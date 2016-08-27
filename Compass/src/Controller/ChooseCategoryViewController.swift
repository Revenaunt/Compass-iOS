//
//  ChooseCategoryViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 4/21/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Instructions


class ChooseCategoryViewController: UITableViewController, CoachMarksControllerDataSource, CoachMarksControllerDelegate{
    //Retrieve the list of filtered categories just once
    private let categoryLists = SharedData.nonDefaultCategoryLists;
    
    private let coachMarksController = CoachMarksController();
    
    
    override func viewDidLoad(){
        if (TourManager.getCategoryMarkerCount() != 0){
            UIApplication.sharedApplication().beginIgnoringInteractionEvents();
        }
        
        //Tour
        coachMarksController.dataSource = self;
        coachMarksController.delegate = self;
        coachMarksController.overlayBackgroundColor = UIColor.clearColor();
    }
    
    override func viewDidAppear(animated: Bool){
        coachMarksController.startOn(self);
    }
    
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
    
    func numberOfCoachMarksForCoachMarksController(coachMarkController: CoachMarksController) -> Int{
        return TourManager.getCategoryMarkerCount();
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex: Int) -> CoachMark{
        switch (TourManager.getFirstUnseenCategoryMarker()){
        case .General:
            let x = UIScreen.mainScreen().bounds.width/2;
            let y = UIScreen.mainScreen().bounds.height/2-50;
            var mark = coachMarksController.coachMarkForView();
            mark.cutoutPath = UIBezierPath(rect: CGRect(x: x, y: y, width: 0, height: 0));
            mark.maxWidth = UIScreen.mainScreen().bounds.width*0.8;
            coachMarksController.overlayBackgroundColor = UIColor.init(hexString: "#2196F3").colorWithAlphaComponent(0.5);
            return mark;
            
        default:
            break;
        }
        return coachMarksController.coachMarkForView();
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?){
        
        var coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation);
        
        switch (TourManager.getFirstUnseenCategoryMarker()){
        case .General:
            coachViews.bodyView.hintLabel.text = "Tap the item that describes what you want to do";
            coachViews.bodyView.nextLabel.text = "Next";
            coachViews.arrowView = nil;
            
        default:
            break;
        }
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 1);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            UIApplication.sharedApplication().endIgnoringInteractionEvents();
        });
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView);
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkWillDisappear: CoachMark, forIndex: Int){
        TourManager.markFirstUnseenCategoryMarker();
    }
}
