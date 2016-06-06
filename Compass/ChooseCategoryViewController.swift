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
    private let categories = SharedData.filteredCategories;
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        //One section, the list of categories
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //As many rows as categories there are
        return categories.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! CategoryCell;
        cell.setCategory(categories[indexPath.row]);
        return cell;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if (segue.identifier == "ShowGoalLibraryFromCategory"){
            let goalLibraryController = segue.destinationViewController as! GoalLibraryViewController;
            if let selectedCell = sender as? CategoryCell{
                let indexPath = tableView.indexPathForCell(selectedCell);
                goalLibraryController.category = categories[indexPath!.row];
            }
        }
    }
}
