
//
//  MainViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 4/19/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Locksmith
import Just
import ObjectMapper
import Instructions


class FeedController: UITableViewController, UIActionSheetDelegate, ActionDelegate, CoachMarksControllerDataSource, CoachMarksControllerDelegate{
    
    @IBOutlet weak var addItem: UIBarButtonItem!
    
    var displayedUpcoming = [UpcomingAction]();
    var didIt: Bool = false;
    var selectedActionIndex: Int = -1;
    var selectedGoal: UserGoal? = nil;
    var selectedGoalIndex: Int? = nil;
    
    var upNextCell: UpNextCell? = nil;
    var streaksCell: StreaksCell? = nil;
    var goalsFooterCell: FooterCell? = nil;
    
    private let coachMarksController = CoachMarksController();
    
    
    override func viewDidLoad(){
        if (displayedUpcoming.count == 0){
            displayedUpcoming.appendContentsOf(SharedData.feedData.loadModeUpcoming(0));
        }
        
        //Automatic height calculation
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        //Refresh
        refreshControl!.addTarget(self, action: #selector(FeedController.refresh), forControlEvents: UIControlEvents.ValueChanged);
        
        //Tour
        coachMarksController.dataSource = self;
        coachMarksController.delegate = self;
        coachMarksController.overlayBackgroundColor = UIColor.clearColor();
    }
    
    override func viewDidAppear(animated: Bool){
        if (didIt){
            SharedData.feedData.didIt(selectedActionIndex);
            displayedUpcoming = SharedData.feedData.getUpcoming(displayedUpcoming.count-1);
            if (displayedUpcoming.count == 0){
                displayedUpcoming.appendContentsOf(SharedData.feedData.loadModeUpcoming(0));
            }
            didIt = false;
            selectedActionIndex = -1;
            tableView.reloadData();
        }
        
        if (selectedGoal != nil && selectedGoalIndex != nil){
            let goals = SharedData.feedData.getGoals();
            
            if (goals.count == 0 && goalsFooterCell != nil){
                FeedTypes.setUpdatingGoals(true);
            }
            
            if (selectedGoalIndex! >= goals.count){
                removeGoalFromFeed(selectedGoalIndex!);
            }
            else{
                if (goals[selectedGoalIndex!] != selectedGoal!){
                    removeGoalFromFeed(selectedGoalIndex!);
                }
            }
        }
        selectedGoal = nil;
        selectedGoalIndex = nil;
        
        coachMarksController.startOn(self);
    }
    
    func onDidIt(){
        didIt = true;
    }
    
    func removeGoalFromFeed(index: Int){
        tableView.beginUpdates();
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: selectedGoalIndex!, inSection: FeedTypes.getGoalsSectionPosition())], withRowAnimation: .Automatic);
        tableView.endUpdates();
        
        if (SharedData.feedData.getGoals().count == 0 && goalsFooterCell != nil){
            goalsFooterCell?.seeMore();
        }
    }
    
    func refresh(){
        InitialDataLoader.load(SharedData.user){ (success) in
            self.displayedUpcoming.removeAll();
            self.displayedUpcoming.appendContentsOf(SharedData.feedData.loadModeUpcoming(0));
            self.tableView.reloadData();
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return FeedTypes.getSectionCount();
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (FeedTypes.isUpcomingSection(section)){
            if (SharedData.feedData.canLoadMoreActions(displayedUpcoming.count)){
                return displayedUpcoming.count+1;
            }
            return displayedUpcoming.count;
        }
        return FeedTypes.getSectionItemCount(section);
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return FeedTypes.getSectionHeaderTitle(section);
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: UITableViewCell;
        
        if (FeedTypes.isHeaderSection(indexPath.section)){
            print("Binding header cell");
            cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell", forIndexPath: indexPath);
        }
        else if (FeedTypes.isUpNextSection(indexPath.section)){
            print("Binding up next cell");
            cell = tableView.dequeueReusableCellWithIdentifier("UpNextCell", forIndexPath: indexPath);
            let upNextCell = cell as! UpNextCell;
            self.upNextCell = upNextCell;
            upNextCell.bind(SharedData.feedData.getUpNextAction(), progress: SharedData.feedData.getProgress()!);
        }
        else if (FeedTypes.isStreaksSection(indexPath.section)){
            print("Binding streaks cell");
            cell = tableView.dequeueReusableCellWithIdentifier("StreaksCell", forIndexPath: indexPath);
            let streaksCell = cell as! StreaksCell;
            self.streaksCell = streaksCell;
            streaksCell.setStreaks(SharedData.feedData.getStreaks()!);
            
        }
        else if (FeedTypes.isUpcomingSection(indexPath.section)){
            //The footer
            if (indexPath.row == displayedUpcoming.count && SharedData.feedData.canLoadMoreActions(displayedUpcoming.count)){
                print("Binding footer");
                cell = tableView.dequeueReusableCellWithIdentifier("FooterCell", forIndexPath: indexPath);
                let footerCell = cell as! FooterCell;
                footerCell.bind(self, type: FooterCell.FooterType.Upcoming);
            }
            else{
                print("Binding upcoming cell");
                cell = tableView.dequeueReusableCellWithIdentifier("UpcomingCell", forIndexPath: indexPath);
                let upcomingCell = cell as! UpcomingCell;
                upcomingCell.bind(SharedData.feedData.getUpcoming()[indexPath.row]);
            }
        }
        else{
            //The footer
            if (indexPath.row == SharedData.feedData.getGoals().count){
                print("Binding footer");
                cell = tableView.dequeueReusableCellWithIdentifier("FooterCell", forIndexPath: indexPath);
                goalsFooterCell = cell as? FooterCell;
                goalsFooterCell!.bind(self, type: FooterCell.FooterType.Goals);
            }
            else{
                print("Binding goal cell");
                cell = tableView.dequeueReusableCellWithIdentifier("FeedGoalCell", forIndexPath: indexPath);
                let goalCell = cell as! FeedGoalCell;
                goalCell.bind(SharedData.feedData.getGoals()[indexPath.row]);
            }
        }
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if (FeedTypes.isHeaderSection(indexPath.section)){
            return UIScreen.mainScreen().bounds.width/2;
        }
        else if (FeedTypes.isStreaksSection(indexPath.section)){
            return 100;
        }
        else if (FeedTypes.isGoalsSection(indexPath.section)){
            return 100;
        }
        return 120;
    }
    
    func numberOfCoachMarksForCoachMarksController(coachMarkController: CoachMarksController) -> Int{
        return TourManager.getFeedMarkerCount();
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex: Int) -> CoachMark{
        print("CoackMarksForIndex \(coachMarksForIndex)");
        switch (TourManager.getFirstUnseenFeedMarker()){
        case .General:
            let x = UIScreen.mainScreen().bounds.width/2;
            let y = UIScreen.mainScreen().bounds.height/2-50;
            var mark = coachMarksController.coachMarkForView();
            mark.cutoutPath = UIBezierPath(rect: CGRect(x: x, y: y, width: 0, height: 0));
            mark.maxWidth = UIScreen.mainScreen().bounds.width*0.8;
            coachMarksController.overlayBackgroundColor = UIColor.init(hexString: "#2196F3").colorWithAlphaComponent(0.5);
            return mark;
            
        case .UpNext:
            var mark = coachMarksController.coachMarkForView(upNextCell);
            mark.maxWidth = UIScreen.mainScreen().bounds.width*0.8;
            return mark;
            
        case .Progress:
            var mark = coachMarksController.coachMarkForView(streaksCell);
            mark.maxWidth = UIScreen.mainScreen().bounds.width*0.8;
            return mark;
            
        case .Add:
            var mark = coachMarksController.coachMarkForView(addItem.valueForKey("view") as? UIView);
            mark.maxWidth = UIScreen.mainScreen().bounds.width*0.8;
            return mark;
            
        default:
            break;
        }
        return coachMarksController.coachMarkForView(addItem.valueForKey("view") as? UIView);
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?){
        
        var coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation);
        
        switch (TourManager.getFirstUnseenFeedMarker()){
        case .General:
            coachViews.bodyView.hintLabel.text = "This is your feed. Check in occasionally for tips and to track your progress.";
            coachViews.bodyView.nextLabel.text = "Next";
            coachViews.arrowView = nil;
            
        case .UpNext:
            coachViews.bodyView.hintLabel.text = "This is a tip to help you succeed. Tap and read!";
            coachViews.bodyView.nextLabel.text = "Next";
            
        case .Progress:
            coachViews.bodyView.hintLabel.text = "This is your daily progress. It helps you stay engaged with your success.";
            coachViews.bodyView.nextLabel.text = "Next";
            
        case .Add:
            coachViews.bodyView.hintLabel.text = "Tap the (+) button to browse for more goals.";
            coachViews.bodyView.nextLabel.text = "Finish";
            coachViews.arrowView = nil;
            
        default:
            break;
        }
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView);
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkWillDisappear: CoachMark, forIndex: Int){
        if (TourManager.getFirstUnseenFeedMarker() == TourManager.FeedMarker.UpNext){
            let indexPath = NSIndexPath(forRow: 0, inSection: FeedTypes.getUpNextSectionPosition());
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true);
        }
        TourManager.markFirstUnseenFeedMarker();
    }
    
    func loadMoreUpcoming(){
        let start = displayedUpcoming.count;
        let more = SharedData.feedData.loadModeUpcoming(displayedUpcoming.count);
        displayedUpcoming.appendContentsOf(more);
        
        var paths = [NSIndexPath]();
        for i in 0...more.count-1{
            paths.append(NSIndexPath(forRow: start+i, inSection: FeedTypes.getUpcomingSectionPosition()));
        }
        print("Count: \(displayedUpcoming.count)");
        tableView.beginUpdates();
        if (!SharedData.feedData.canLoadMoreActions(displayedUpcoming.count)){
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: start, inSection: FeedTypes.getUpcomingSectionPosition())],
                                             withRowAnimation: .Automatic)
        }
        tableView.insertRowsAtIndexPaths(paths, withRowAnimation: .Automatic);
        tableView.endUpdates();
    }
    
    func loadMoreGoals(footer: FooterCell){
        Just.get(SharedData.feedData.getNextGoalBatchUrl()!, headers: SharedData.user.getHeaderMap()){ response in
            if (response.ok){
                let start = SharedData.feedData.getGoals().count;
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding);
                let uga = Mapper<ParserModels.UserGoalArray>().map(result)!;
                if (uga.goals!.count > 0){
                    SharedData.feedData.addGoals(uga.goals!, nextGoalBatchUrl: uga.next);
                }
                var paths = [NSIndexPath]();
                for i in 0...uga.goals!.count-1{
                    paths.append(NSIndexPath(forRow: start+i, inSection: FeedTypes.getGoalsSectionPosition()));
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.beginUpdates();
                    if (!SharedData.feedData.canLoadMoreGoals()){
                        self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: start, inSection: FeedTypes.getGoalsSectionPosition())],
                            withRowAnimation: .Automatic);
                        self.goalsFooterCell = nil;
                    }
                    footer.end();
                    self.tableView.insertRowsAtIndexPaths(paths, withRowAnimation: .Automatic);
                    self.tableView.endUpdates();
                    FeedTypes.setUpdatingGoals(false);
                });
            }
        }
    }
    
    @IBAction func addTap(sender: AnyObject){
        self.performSegueWithIdentifier("Library", sender: self);
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        switch (indexPath.section){
        case FeedTypes.getUpNextSectionPosition():
            if (SharedData.feedData.getUpNextAction() != nil){
                performSegueWithIdentifier("ShowActionFromFeed", sender: tableView.cellForRowAtIndexPath(indexPath));
            }
            break;
            
        case FeedTypes.getStreaksSectionPosition():
            tableView.deselectRowAtIndexPath(indexPath, animated: true);
            break;
            
        case FeedTypes.getUpcomingSectionPosition():
            if (SharedData.feedData.getUpcoming()[indexPath.row].isUserAction()){
                performSegueWithIdentifier("ShowActionFromFeed", sender: tableView.cellForRowAtIndexPath(indexPath));
            }
            break;
            
        case FeedTypes.getGoalsSectionPosition():
            let goalCount = SharedData.feedData.getGoals().count
            if goalCount < indexPath.row {
                performSegueWithIdentifier("ShowGoalFromFeed", sender: tableView.cellForRowAtIndexPath(indexPath))
            }
            break;
        default:
            break;
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        segue.destinationViewController.hidesBottomBarWhenPushed = true;
        if (segue.identifier == "ShowActionFromFeed"){
            let actionController = segue.destinationViewController as! ActionViewController;
            actionController.delegate = self;
            if (sender as? UpNextCell) != nil{
                if let upNext = SharedData.feedData.getUpNextAction(){
                    actionController.upcomingAction = upNext;
                    selectedActionIndex = -1;
                }
            }
            else if let selectedCell = sender as? UpcomingCell{
                let indexPath = tableView.indexPathForCell(selectedCell);
                selectedActionIndex = indexPath!.row;
                actionController.upcomingAction = SharedData.feedData.getUpcoming()[indexPath!.row];
            }
        }
        else if (segue.identifier == "ShowGoalFromFeed"){
            if let selectedCell = sender as? FeedGoalCell{
                let indexPath = tableView.indexPathForCell(selectedCell);
                if let userGoal = SharedData.feedData.getGoals()[indexPath!.row] as? UserGoal{
                    let goalController = segue.destinationViewController as! GoalViewController;
                    let goal = userGoal.getGoal();
                    let category = SharedData.getCategory((userGoal.getPrimaryCategoryId()));
                    
                    selectedGoal = userGoal;
                    selectedGoalIndex = indexPath?.row;
                    print(selectedGoalIndex);
                    
                    goalController.goal = goal;
                    goalController.category = category;
                    goalController.userGoal = userGoal;
                    goalController.fromFeed = true
                }
            }
        }
    }
}

extension String{
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat{
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
