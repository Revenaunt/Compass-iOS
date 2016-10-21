
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


class FeedController: UITableViewController, UIActionSheetDelegate, ActionDelegate{
    
    @IBOutlet weak var addItem: UIBarButtonItem!
    
    var didIt = false
    var goalRemoved = false
    var selectedGoal: UserGoal? = nil
    var selectedGoalIndex: Int? = nil
    
    var upNextCell: UpNextCell? = nil
    var streaksCell: StreaksCell? = nil
    var goalsFooterCell: FooterCell? = nil
    
    private let coachMarksController = CoachMarksController()
    
    
    override func viewDidLoad(){
        if TourManager.getFeedMarkerCount() != 0{
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        }
        
        //Automatic height calculation
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Refresh
        refreshControl!.addTarget(self, action: #selector(FeedController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        
        //Tour
        coachMarksController.dataSource = self
        coachMarksController.delegate = self
        coachMarksController.overlay.color = UIColor.clearColor()
    }
    
    override func viewDidAppear(animated: Bool){
        if didIt{
            SharedData.feedData.didIt()
            didIt = false
            tableView.reloadData()
        }
        if goalRemoved{
            SharedData.feedData.replaceUpNext()
            goalRemoved = false
            tableView.reloadData()
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
        didIt = true
    }
    
    func onGoalRemoved(){
        goalRemoved = true
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
        FeedDataLoader.getInstance().load(){ (success) in
            if (success){
                self.tableView.reloadData();
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return FeedTypes.getSectionCount();
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
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
            upNextCell.bind(SharedData.feedData.getUpNext(), progress: SharedData.feedData.getProgress());
        }
        else if (FeedTypes.isStreaksSection(indexPath.section)){
            print("Binding streaks cell");
            cell = tableView.dequeueReusableCellWithIdentifier("StreaksCell", forIndexPath: indexPath);
            let streaksCell = cell as! StreaksCell;
            self.streaksCell = streaksCell;
            streaksCell.setStreaks(SharedData.feedData.getStreaks()!);
            
        }
        else if (FeedTypes.isRewardSection(indexPath.section)){
            print("Binding reward cell");
            cell = tableView.dequeueReusableCellWithIdentifier("RewardCell", forIndexPath: indexPath);
            let rewardCell = cell as! RewardCell;
            rewardCell.bind(SharedData.feedData.getReward());
        }
        else{
            //The footer
            if indexPath.row == SharedData.feedData.getGoals().count{
                print("Binding footer")
                cell = tableView.dequeueReusableCellWithIdentifier("FooterCell", forIndexPath: indexPath)
                goalsFooterCell = cell as? FooterCell
                goalsFooterCell!.bind(self)
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
    
    func loadMoreGoals(footer: FooterCell){
        FeedDataLoader.getInstance().loadNextGoalBatch(){ (goals) in
            if goals != nil{
                //Count the current amount of goals and add the new ones
                let preCount = SharedData.feedData.getGoals().count
                SharedData.feedData.addGoals(goals!)
                
                //Create the path objects to update the table
                var addPaths = [NSIndexPath]()
                let section = FeedTypes.getGoalsSectionPosition()
                for i in 0...goals!.count-1{
                    addPaths.append(NSIndexPath(forRow: preCount+i, inSection: section))
                }
                
                //Update the table
                self.tableView.beginUpdates();
                if (!FeedDataLoader.getInstance().canLoadMoreGoals()){
                    let deletePaths = [NSIndexPath(forRow: preCount, inSection: section)]
                    self.tableView.deleteRowsAtIndexPaths(deletePaths, withRowAnimation: .Automatic)
                    self.goalsFooterCell = nil;
                }
                self.tableView.insertRowsAtIndexPaths(addPaths, withRowAnimation: .Automatic)
                self.tableView.endUpdates()
            }
            
            //Update the footer
            FeedTypes.setUpdatingGoals(false);
            footer.end()
        }
    }
    
    @IBAction func addTap(sender: AnyObject){
        self.performSegueWithIdentifier("Library", sender: self);
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        switch (indexPath.section){
        case FeedTypes.getUpNextSectionPosition():
            if (SharedData.feedData.getUpNext() != nil){
                performSegueWithIdentifier("ShowActionFromFeed", sender: tableView.cellForRowAtIndexPath(indexPath))
            }
            break;
            
        case FeedTypes.getStreaksSectionPosition():
            tableView.deselectRowAtIndexPath(indexPath, animated: true);
            break;
            
        case FeedTypes.getRewardSectionPosition():
            performSegueWithIdentifier("ShowRewardFromFeed", sender: tableView.cellForRowAtIndexPath(indexPath))
            break
            
        case FeedTypes.getGoalsSectionPosition():
            if indexPath.row < SharedData.feedData.getGoals().count && SharedData.feedData.getGoals()[indexPath.row] is UserGoal{
                performSegueWithIdentifier("ShowMyGoalFromFeed", sender: tableView.cellForRowAtIndexPath(indexPath))
            }
            break;
            
        default:
            print("Falling back to default")
            break;
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        //segue.destinationViewController.hidesBottomBarWhenPushed = true;
        if (segue.identifier == "ShowActionFromFeed"){
            let actionController = segue.destinationViewController as! ActionController;
            actionController.delegate = self;
            if (sender as? UpNextCell) != nil{
                if let upNext = SharedData.feedData.getUpNext(){
                    actionController.action = upNext;
                }
            }
        }
        if (segue.identifier == "ShowRewardFromFeed"){
            let rewardController = segue.destinationViewController as! RewardController;
            rewardController.reward = SharedData.feedData.getReward()
        }
        else if segue.identifier == "ShowMyGoalFromFeed"{
            if let selectedCell = sender as? FeedGoalCell{
                let indexPath = tableView.indexPathForCell(selectedCell);
                if let userGoal = SharedData.feedData.getGoals()[indexPath!.row] as? UserGoal{
                    selectedGoal = userGoal;
                    selectedGoalIndex = indexPath?.row;
                    print(selectedGoalIndex);
                    
                    let goalController = segue.destinationViewController as! MyGoalController
                    goalController.userGoal = userGoal
                }
            }
        }
    }
}


//Tour Extension for the FeedController
extension FeedController: CoachMarksControllerDataSource, CoachMarksControllerDelegate{
    func numberOfCoachMarksForCoachMarksController(coachMarkController: CoachMarksController) -> Int{
        //print(TourManager.getFeedMarkerCount());
        return TourManager.getFeedMarkerCount();
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkForIndex coachMarksForIndex: Int) -> CoachMark{
        print("CoackMarksForIndex \(coachMarksForIndex)");
        switch (TourManager.getFirstUnseenFeedMarker()){
        case .General:
            let x = UIScreen.mainScreen().bounds.width/2;
            let y = UIScreen.mainScreen().bounds.height/2-50;
            var mark = coachMarksController.helper.coachMarkForView();
            mark.cutoutPath = UIBezierPath(rect: CGRect(x: x, y: y, width: 0, height: 0));
            mark.maxWidth = UIScreen.mainScreen().bounds.width*0.8;
            coachMarksController.overlay.color = UIColor.init(hexString: "#2196F3").colorWithAlphaComponent(0.5);
            return mark;
            
        case .UpNext:
            var mark = coachMarksController.helper.coachMarkForView(upNextCell);
            mark.maxWidth = UIScreen.mainScreen().bounds.width*0.8;
            return mark;
            
        case .Progress:
            var mark = coachMarksController.helper.coachMarkForView(streaksCell);
            mark.maxWidth = UIScreen.mainScreen().bounds.width*0.8;
            return mark;
            
        case .Add:
            var mark = coachMarksController.helper.coachMarkForView(addItem.valueForKey("view") as? UIView);
            mark.maxWidth = UIScreen.mainScreen().bounds.width*0.8;
            return mark;
            
        default:
            break;
        }
        return coachMarksController.helper.coachMarkForView(addItem.valueForKey("view") as? UIView);
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?){
        
        var coachViews = coachMarksController.helper.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation);
        
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
        
        let triggerTime = (Int64(NSEC_PER_SEC) * 1);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            UIApplication.sharedApplication().endIgnoringInteractionEvents();
        });
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView);
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkWillDisappear: CoachMark, forIndex: Int){
        print("disappear code");
        if (TourManager.getFirstUnseenFeedMarker() == TourManager.FeedMarker.UpNext){
            let indexPath = NSIndexPath(forRow: 0, inSection: FeedTypes.getUpNextSectionPosition());
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true);
        }
        TourManager.markFirstUnseenFeedMarker();
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, didFinishShowingAndWasSkipped skipped: Bool){
        print("finish/skipped code");
    }
}


extension String{
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat{
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
