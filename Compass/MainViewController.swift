//
//  MainViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 4/19/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Locksmith


class MainViewController: UITableViewController, UIActionSheetDelegate{
    override func viewDidLoad(){
        NotificationUtil.sendRegistrationToken();
        
        print(SharedData.getUser()?.getToken());
        
        //Automatic height calculation
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        //tableView.backgroundView!.layer.zPosition -= 1;
        
        /*refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.backgroundView = refreshControl;*/
        refreshControl!.addTarget(self, action: #selector(MainViewController.refresh), forControlEvents: UIControlEvents.ValueChanged);
    }
    
    func refresh(){
        InitialDataLoader.load(SharedData.getUser()!){ (success) in
            self.tableView.reloadData();
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 4;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
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
            //Data.feedData.getFeedback()!.title = "What if the title is ridiculously large? What if the title is ridiculously large? What if the title is ridiculously large?";
            feedbackCell.setFeedback(SharedData.feedData.getFeedback()!);
            
        }
        else if (indexPath.section == 2){
            print("Binding upcoming cell");
            cell = tableView.dequeueReusableCellWithIdentifier("UpcomingCell", forIndexPath: indexPath);
            let upcomingCell = cell as! UpcomingCell;
            upcomingCell.bind(SharedData.feedData.getUpcoming()[indexPath.row]);
        }
        else{
            print("Binding goal cell");
            cell = tableView.dequeueReusableCellWithIdentifier("FeedGoalCell", forIndexPath: indexPath);
            let goalCell = cell as! FeedGoalCell;
            goalCell.bind(SharedData.feedData.getGoals()[indexPath.row]);
        }
        
        return cell;
    }
    
    @IBAction func addTap(sender: AnyObject){
        let addSheet = UIAlertController(title: "Choose an option", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet);
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
        presentViewController(addSheet, animated: true, completion: nil);
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        print("Height for: \(indexPath.section), \(indexPath.row)");
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
        switch (indexPath.section){
            case 0, 2:
                performSegueWithIdentifier("ShowActionFromFeed", sender: self);
                break;
            
            default:
                break;
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