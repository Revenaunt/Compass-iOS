//
//  ChooseCategoryViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 4/21/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class ChooseCategoryViewController: UITableViewController{
    //Retrieve the list of filtered categories just once
    private let categoryLists = SharedData.nonDefaultCategoryLists;
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        //One section, the list of categories
        return categoryLists.count;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //As many rows as categories there are
        return categoryLists[section].count;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return categoryLists[section][0].getGroupName();
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! CategoryCell;
        cell.setCategory(categoryLists[indexPath.section][indexPath.row]);
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        //navigationController!.popViewControllerAnimated(false);
        let cell = tableView.cellForRowAtIndexPath(indexPath);
        performSegueWithIdentifier("ShowGoalLibraryFromCategory", sender: cell);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if (segue.identifier == "ShowGoalLibraryFromCategory"){
            let goalLibraryController = segue.destinationViewController as! GoalLibraryViewController;
            if let selectedCell = sender as? CategoryCell{
                let indexPath = tableView.indexPathForCell(selectedCell)!;
                goalLibraryController.category = categoryLists[indexPath.section][indexPath.row];
            }
        }
    }
}
