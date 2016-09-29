//
//  GoalLibraryViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 4/21/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Just
import ObjectMapper
import Nuke
import Instructions


class GoalLibraryViewController: UITableViewController, GoalAddedDelegate, CoachMarksControllerDataSource, CoachMarksControllerDelegate{
    var category: CategoryContent!;
    var goalAddedDelegate: GoalAddedDelegate?;
    var fromOnBoarding = false;
    
    private var goals = [GoalContent]();
    private var activityCell: LibraryLoadingCell? = nil;
    
    private var loading: Bool = false;
    private var next: String? = nil;
    
    private var selectedGoalIndex: Int = -1;
    private var selectedGoal: GoalContent? = nil;
    private var goalWasAdded = false;
    
    private var coachMarksController = CoachMarksController();
    
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
        if (TourManager.getGoalLibraryMarkerCount(false) != 0){
            UIApplication.sharedApplication().beginIgnoringInteractionEvents();
        }
        
        //Load first batch of goals
        next = API.getGoalsUrl(category);
        loadMore();
        
        //Automatic height calculation
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        //Tour
        coachMarksController.dataSource = self;
        coachMarksController.delegate = self;
        coachMarksController.overlay.color = UIColor.clearColor();
    }
    
    override func viewDidAppear(animated: Bool){
        //if we come from a child view controller (as opposed to the parent)
        if (selectedGoal != nil){
            if (goalWasAdded){
                //Add the goal
                Just.post(API.getPostGoalUrl(selectedGoal!), headers: SharedData.user.getHeaderMap(),
                          json: API.getPostGoalBody(category)){ (response) in
                            if (response.ok){
                                print("Goal posted successfully");
                            }
                            else{
                                print("Goal not posted successfully: \(response.statusCode)");
                            }
                };
                
                //User feedback
                let description = "Compass will check back in occasionally with activities that can help you reach your goal.";
                let alert = UIAlertController(title: "You're awesome", message: description, preferredStyle: UIAlertControllerStyle.Alert);
                alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.Default, handler: { action in
                    self.goals.removeAtIndex(self.selectedGoalIndex);
                    if (self.goals.isEmpty){
                        self.navigationController?.popViewControllerAnimated(true);
                    }
                    else{
                        let indexPath = NSIndexPath(forRow: self.selectedGoalIndex, inSection: 2);
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade);
                        
                        self.coachMarksController = CoachMarksController();
                        self.coachMarksController.dataSource = self;
                        self.coachMarksController.delegate = self;
                        self.coachMarksController.overlay.color = UIColor.clearColor();
                        
                        self.coachMarksController.startOn(self);
                    }
                }));
                presentViewController(alert, animated: true, completion: nil);
            }
        }
    }
    
    private func loadMore(){
        loading = true;
        Just.get(next!, headers: SharedData.user.getHeaderMap()){ (response) in
            if (response.ok){
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding)!;
                let gca = Mapper<ParserModels.GoalContentArray>().map(result)!;
                if (gca.goals?.count == 0){
                    self.activityCell?.displayMessage();
                }
                else{
                    let start = self.goals.count;
                    self.goals.appendContentsOf(gca.goals!);
                    self.next = gca.next;
                    if (API.STAGING && self.next != nil && (self.next?.hasPrefix("https"))!){
                        self.next = "http" + (self.next?.substringFromIndex((self.next?.startIndex.advancedBy(5))!))!;
                    }
                    var paths = [NSIndexPath]();
                    for i in 0...gca.goals!.count-1{
                        paths.append(NSIndexPath(forRow: start+i, inSection: 2));
                    }
                    print("Next url: \(self.next)");
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.beginUpdates()
                        if (self.next == nil){
                            self.tableView.deleteSections(NSIndexSet(index: 3), withRowAnimation: .Automatic);
                        }
                        self.tableView.insertRowsAtIndexPaths(paths, withRowAnimation: .Automatic);
                        self.tableView.endUpdates();
                        
                        self.coachMarksController.startOn(self);
                    });
                }
            }
            self.loading = false;
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        if (next == nil){
            return 3;
        }
        return 4;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (section == 2){
            return goals.count;
        }
        return 1;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: UITableViewCell;
        if (indexPath.section == 0){
            cell = tableView.dequeueReusableCellWithIdentifier("HeaderHeroCell", forIndexPath: indexPath);
            let instance = cell as! CategoryHeaderCell;
            instance.setHeader(category);
        }
        else if (indexPath.section == 1){
            cell = tableView.dequeueReusableCellWithIdentifier("CategoryDescriptionCell", forIndexPath: indexPath);
            let instance = cell as! CategoryDescriptionCell;
            instance.setCategory(category);
        }
        else if (indexPath.section == 2){
            cell = tableView.dequeueReusableCellWithIdentifier("GoalCell", forIndexPath: indexPath);
            let instance = cell as! GoalCell;
            instance.setContent(goals[indexPath.row], category: category);
            
        }
        else{
            if (activityCell == nil){
                cell = tableView.dequeueReusableCellWithIdentifier("ProgressCell", forIndexPath: indexPath);
                activityCell = cell as? LibraryLoadingCell;
            }
            else{
                cell = activityCell!;
            }
            if (!loading && next != nil){
                loadMore();
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        return cell;
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if (indexPath.section == 0){
            return UIScreen.mainScreen().bounds.width*2/3;
        }
        else if (indexPath.section == 1){
            let width = UIScreen.mainScreen().bounds.width-56;
            let title = category!.getTitle().heightWithConstrainedWidth(width, font: UIFont.systemFontOfSize(20));
            let description = category!.getDescription().heightWithConstrainedWidth(width, font: UIFont.systemFontOfSize(17));
            return title+description+62;
        }
        else if (indexPath.section == 2){
            return 100;
        }
        else{
            return 50;
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if let selectedCell = sender as? GoalCell{
            if (segue.identifier == "ShowGoalFromLibrary"){
                let goalController = segue.destinationViewController as! GoalViewController;
                let indexPath = tableView.indexPathForCell(selectedCell);
                selectedGoalIndex = indexPath!.row;
                selectedGoal = goals[selectedGoalIndex];
                goalWasAdded = false;
                goalController.delegate = self;
                goalController.category = category;
                goalController.goal = selectedGoal;
            }
        }
    }
    
    func goalAdded(){
        goalWasAdded = true;
        goalAddedDelegate?.goalAdded();
    }
    
    func numberOfCoachMarksForCoachMarksController(coachMarkController: CoachMarksController) -> Int{
        return TourManager.getGoalLibraryMarkerCount(goalWasAdded);
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkForIndex coachMarksForIndex: Int) -> CoachMark{
        switch (TourManager.getFirstUnseenGoalLibraryMarker()){
        case .General:
            let x = UIScreen.mainScreen().bounds.width/2;
            let y = UIScreen.mainScreen().bounds.height/2-50;
            var mark = coachMarksController.helper.coachMarkForView();
            mark.cutoutPath = UIBezierPath(rect: CGRect(x: x, y: y, width: 0, height: 0));
            mark.maxWidth = UIScreen.mainScreen().bounds.width*0.8;
            coachMarksController.overlay.color = UIColor.init(hexString: "#2196F3").colorWithAlphaComponent(0.5);
            return mark;
            
        case .Added:
            let x = UIScreen.mainScreen().bounds.width/2;
            let y = UIScreen.mainScreen().bounds.height/2-50;
            var mark = coachMarksController.helper.coachMarkForView();
            mark.cutoutPath = UIBezierPath(rect: CGRect(x: x, y: y, width: 0, height: 0));
            mark.maxWidth = UIScreen.mainScreen().bounds.width*0.8;
            coachMarksController.overlay.color = UIColor.init(hexString: "#2196F3").colorWithAlphaComponent(0.5);
            return mark;
            
        default:
            break;
        }
        return coachMarksController.helper.coachMarkForView();
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?){
        
        var coachViews = coachMarksController.helper.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation);
        
        switch (TourManager.getFirstUnseenGoalLibraryMarker()){
        case .General:
            coachViews.bodyView.hintLabel.text = "Tap the item that describes what you want to do";
            coachViews.bodyView.nextLabel.text = "OK";
            coachViews.arrowView = nil;
            
        case .Added:
            if (fromOnBoarding){
                coachViews.bodyView.hintLabel.text = "You can choose more content or hit back to go to onboarding and finish the process";
            }
            else{
                coachViews.bodyView.hintLabel.text = "You can choose more content or hit back to go to Compass";
            }
            coachViews.bodyView.nextLabel.text = "OK";
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
        TourManager.markFirstUnseenGoalLibraryMarker();
    }
}

