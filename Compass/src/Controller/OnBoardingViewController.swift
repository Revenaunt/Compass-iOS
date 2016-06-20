//
//  OnBoardingViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 6/17/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class OnBoardingViewController: UITableViewController{
    let categoryLists = SharedData.filteredCategoryLists;
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return categoryLists.count;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return categoryLists[section].count;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return categoryLists[section][0].getGroupName();
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("OnBoardingCategoryCell", forIndexPath: indexPath) as! OnBoardingCategoryCell;
        cell.setCategory(categoryLists[indexPath.section][indexPath.row]);
        return cell;
    }
}
