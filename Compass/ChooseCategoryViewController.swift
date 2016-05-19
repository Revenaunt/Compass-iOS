//
//  ChooseCategoryViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 4/21/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class ChooseCategoryViewController: UITableViewController{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return SharedData.publicCategories.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! CategoryCell;
        cell.setCategory(SharedData.publicCategories[indexPath.row]);
        return cell;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if (segue.identifier == "ShowGoalLibraryFromCategory"){
            let goalLibraryController = segue.destinationViewController as! GoalLibraryViewController;
            if let selectedCell = sender as? CategoryCell{
                let indexPath = tableView.indexPathForCell(selectedCell);
                goalLibraryController.category = SharedData.publicCategories[indexPath!.row];
            }
        }
    }
}