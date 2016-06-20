
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


class MainViewController: UITableViewController, UIActionSheetDelegate{
    var displayedUpcoming = [UpcomingAction]();
    
    
    override func viewDidLoad(){
        NotificationUtil.sendRegistrationToken();
        
        print(SharedData.user.getToken());
        
        if (displayedUpcoming.count == 0){
            displayedUpcoming.appendContentsOf(SharedData.feedData.loadModeUpcoming(0));
        }
        
        //Automatic height calculation
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        //Refresh
        refreshControl!.addTarget(self, action: #selector(MainViewController.refresh), forControlEvents: UIControlEvents.ValueChanged);
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
        return 4;
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
            print("Binding up next cell");
            cell = tableView.dequeueReusableCellWithIdentifier("UpNextCell", forIndexPath: indexPath);
            let upNextCell = cell as! UpNextCell;
            upNextCell.bind(SharedData.feedData.getUpNextAction(), progress: SharedData.feedData.getProgress()!);
        }
        else if (indexPath.section == 1){
            print("Binding feedback cell");
            cell = tableView.dequeueReusableCellWithIdentifier("FeedbackCell", forIndexPath: indexPath);
            let feedbackCell = cell as! FeedbackCell;
            feedbackCell.setFeedback(SharedData.feedData.getFeedback()!);
            
        }
        else if (indexPath.section == 2){
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
                let footerCell = cell as! FooterCell;
                footerCell.bind(self, type: FooterCell.FooterType.Goals);
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
                                                        withRowAnimation: .Automatic)
                    }
                    else{
                        footer.end();
                    }
                    self.tableView.insertRowsAtIndexPaths(paths, withRowAnimation: .Automatic);
                    self.tableView.endUpdates();
                });
            }
        }
    }
    
    @IBAction func addTap(sender: AnyObject){
        self.performSegueWithIdentifier("Library", sender: self);
        /*let addSheet = UIAlertController(title: "Choose an option", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet);
        addSheet.addAction(UIAlertAction(title: "Search goals", style: .Default){ action in
            do{
                try Locksmith.deleteDataForUserAccount("CompassAccount");
            }
            catch{
                
            }
        });
        addSheet.addAction(UIAlertAction(title: "Browse goals", style: .Default){ action in
            self.performSegueWithIdentifier("Library", sender: self);
        });
        presentViewController(addSheet, animated: true, completion: nil);*/
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if (indexPath.section == 0){
            
        }
        else if (indexPath.section == 1){
            return FeedbackCell.getCellHeight(SharedData.feedData.getFeedback()!);
        }
        else if (indexPath.section == 2){
            
        }
        else if (indexPath.section == 3){
            return 100;
        }
        return 120;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print(indexPath);
        switch (indexPath.section){
            case 0:
                if (SharedData.feedData.getUpNextAction() != nil){
                    performSegueWithIdentifier("ShowActionFromFeed", sender: tableView.cellForRowAtIndexPath(indexPath));
                }
                break;
            
            case 2:
                if (SharedData.feedData.getUpcoming()[indexPath.row].isUserAction()){
                    performSegueWithIdentifier("ShowActionFromFeed", sender: tableView.cellForRowAtIndexPath(indexPath));
                }
                break;
            
            default:
                break;
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if (segue.identifier == "ShowActionFromFeed"){
            let actionController = segue.destinationViewController as! ActionViewController;
            if (sender as? UpNextCell) != nil{
                if let upNext = SharedData.feedData.getUpNextAction(){
                    actionController.upcomingAction = upNext;
                }
            }
            else if let selectedCell = sender as? UpcomingCell{
                let indexPath = tableView.indexPathForCell(selectedCell);
                actionController.upcomingAction = SharedData.feedData.getUpcoming()[indexPath!.row];
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
