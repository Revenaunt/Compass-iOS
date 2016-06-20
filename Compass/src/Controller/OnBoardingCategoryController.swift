//
//  OnBoardingCategoryController.swift
//  Compass
//
//  Created by Ismael Alonso on 6/20/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class OnBoardingCategoryController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var nextButton: UIButton!
    
    let categoryLists = SharedData.filteredCategoryLists;
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return categoryLists.count;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return categoryLists[section].count;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return categoryLists[section][0].getGroupName();
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("OnBoardingCategoryCell", forIndexPath: indexPath) as! OnBoardingCategoryCell;
        cell.setCategory(categoryLists[indexPath.section][indexPath.row]);
        return cell;
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 100;
    }
    
    @IBAction func onNextTapped(){
        
    }
}
