//
//  OnBoardingCategoryController.swift
//  Compass
//
//  Created by Ismael Alonso on 6/20/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Instructions


class OnBoardingCategoryController: UIViewController, UITableViewDelegate, UITableViewDataSource, GoalAddedDelegate, CoachMarksControllerDataSource, CoachMarksControllerDelegate{
    @IBOutlet weak var explanation: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    let categoryLists = SharedData.filteredCategoryLists;
    
    private let coachMarksController = CoachMarksController();
    
    
    override func viewDidLoad(){
        if (TourManager.getOnBoardingCategoryMarkerCount() != 0){
            UIApplication.sharedApplication().beginIgnoringInteractionEvents();
        }
        
        explanation.textContainerInset = UIEdgeInsetsMake(14, 20, 14, 20);
        
        //Tour
        coachMarksController.dataSource = self;
        coachMarksController.delegate = self;
        coachMarksController.overlay.color = UIColor.clearColor();
    }
    
    override func viewDidAppear(animated: Bool){
        coachMarksController.startOn(self);
    }
    
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
        let cell = tableView.cellForRowAtIndexPath(indexPath);
        performSegueWithIdentifier("GoalLibraryFromOnBoarding", sender: cell);
    }
    
    func numberOfCoachMarksForCoachMarksController(coachMarkController: CoachMarksController) -> Int{
        return TourManager.getOnBoardingCategoryMarkerCount();
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkForIndex coachMarksForIndex: Int) -> CoachMark{
        switch (TourManager.getFirstUnseenOnBoardingCategoryMarker()){
        case .General:
            let x = UIScreen.mainScreen().bounds.width/2;
            let y = UIScreen.mainScreen().bounds.height/2-50;
            var mark = coachMarksController.helper.coachMarkForView();
            mark.cutoutPath = UIBezierPath(rect: CGRect(x: x, y: y, width: 0, height: 0));
            mark.maxWidth = UIScreen.mainScreen().bounds.width*0.8;
            coachMarksController.overlay.color = UIColor.init(hexString: "#2196F3").colorWithAlphaComponent(0.5);
            return mark;
            
        case .Skip:
            var mark = coachMarksController.helper.coachMarkForView(nextButton);
            mark.maxWidth = UIScreen.mainScreen().bounds.width*0.8;
            return mark;
            
        default:
            break;
        }
        return coachMarksController.helper.coachMarkForView();
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?){
        
        var coachViews = coachMarksController.helper.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation);
        
        switch (TourManager.getFirstUnseenOnBoardingCategoryMarker()){
        case .General:
            coachViews.bodyView.hintLabel.text = "Tap the item that describes what you want to do";
            coachViews.bodyView.nextLabel.text = "Next";
            coachViews.arrowView = nil;
            
        case .Skip:
            coachViews.bodyView.hintLabel.text = "Tap here if you want to skip";
            coachViews.bodyView.nextLabel.text = "OK";
            
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
        TourManager.markFirstUnseenOnBoardingCategoryMarker();
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "GoalLibraryFromOnBoarding"){
            let goalLibraryController = segue.destinationViewController as! GoalLibraryViewController;
            if let selectedCell = sender as? OnBoardingCategoryCell{
                let indexPath = tableView.indexPathForCell(selectedCell)!;
                goalLibraryController.category = categoryLists[indexPath.section][indexPath.row];
                goalLibraryController.goalAddedDelegate = self;
                goalLibraryController.fromOnBoarding = true;
            }
        }
    }
    
    func goalAdded(){
        nextButton.setTitle("Finish", forState: .Normal);
    }
    
    @IBAction func onNextTapped(){
        SharedData.user.onBoardingComplete();
        performSegueWithIdentifier("LoadingFromOnBoarding", sender: nil);
    }
}
