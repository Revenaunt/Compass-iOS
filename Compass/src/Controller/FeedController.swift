
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


class FeedController: UITableViewController, UIActionSheetDelegate, ActionDelegate{
    var displayedUpcoming = [UpcomingAction]();
    var didIt: Bool = false;
    var selectedActionIndex: Int = -1;
    var selectedGoal: UserGoal? = nil;
    var selectedGoalIndex: Int? = nil;
    
    var goalsFooterCell: FooterCell? = nil;
    
    
    override func viewDidLoad(){
        if (displayedUpcoming.count == 0){
            displayedUpcoming.appendContentsOf(SharedData.feedData.loadModeUpcoming(0));
        }
        
        //Automatic height calculation
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        //Refresh
        refreshControl!.addTarget(self, action: #selector(FeedController.refresh), forControlEvents: UIControlEvents.ValueChanged);
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
    }
    
    func onDidIt(){
        didIt = true;
    }
    
    func removeGoalFromFeed(index: Int){
        tableView.beginUpdates();
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: selectedGoalIndex!, inSection:3)], withRowAnimation: .Automatic);
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
        
        if (indexPath.section == 0){
            print("Binding header cell");
            cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell", forIndexPath: indexPath);
        }
        else if (indexPath.section == 1){
            print("Binding up next cell");
            cell = tableView.dequeueReusableCellWithIdentifier("UpNextCell", forIndexPath: indexPath);
            let upNextCell = cell as! UpNextCell;
            upNextCell.bind(SharedData.feedData.getUpNextAction(), progress: SharedData.feedData.getProgress()!);
        }
        else if (indexPath.section == 2){
            print("Binding feedback cell");
            cell = tableView.dequeueReusableCellWithIdentifier("StreaksCell", forIndexPath: indexPath);
            let streaksCell = cell as! StreaksCell;
            streaksCell.setStreaks(SharedData.feedData.getStreaks()!);
            
        }
        else if (indexPath.section == 3){
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
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if (indexPath.section == 0){
            return UIScreen.mainScreen().bounds.width*2/3;
        }
        else if (indexPath.section == 2){
            return  200;
            //return FeedbackCell.getCellHeight(SharedData.feedData.getFeedback()!);
        }
        else if (indexPath.section == 4){
            return 100;
        }
        return 120;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        switch (indexPath.section){
            case 1:
                if (SharedData.feedData.getUpNextAction() != nil){
                    performSegueWithIdentifier("ShowActionFromFeed", sender: tableView.cellForRowAtIndexPath(indexPath));
                }
                break;
            
            case 2:
                tableView.deselectRowAtIndexPath(indexPath, animated: true);
                break;
            
            case 3:
                if (SharedData.feedData.getUpcoming()[indexPath.row].isUserAction()){
                    performSegueWithIdentifier("ShowActionFromFeed", sender: tableView.cellForRowAtIndexPath(indexPath));
                }
                break;
            
            case 4:
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
