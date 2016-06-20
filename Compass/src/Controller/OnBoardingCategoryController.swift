//
//  OnBoardingCategoryController.swift
//  Compass
//
//  Created by Ismael Alonso on 6/20/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class OnBoardingCategoryController: UIViewController, UITableViewDelegate, UITableViewDataSource, GoalAddedDelegate{
    @IBOutlet weak var tableView: UITableView!
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        //navigationController!.popViewControllerAnimated(false);
        let cell = tableView.cellForRowAtIndexPath(indexPath);
        performSegueWithIdentifier("GoalLibraryFromOnBoarding", sender: cell);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "GoalLibraryFromOnBoarding"){
            let goalLibraryController = segue.destinationViewController as! GoalLibraryViewController;
            if let selectedCell = sender as? OnBoardingCategoryCell{
                let indexPath = tableView.indexPathForCell(selectedCell)!;
                goalLibraryController.category = categoryLists[indexPath.section][indexPath.row];
                goalLibraryController.goalAddedDelegate = self;
            }
        }
    }
    
    func goalAdded(){
        nextButton.setTitle("Finish", forState: .Normal);
    }
    
    @IBAction func onNextTapped(){
        
    }
}
