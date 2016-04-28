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
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
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
            cell = tableView.dequeueReusableCellWithIdentifier("UpNextCell", forIndexPath: indexPath);
            let upNextCell = cell as! UpNextCell;
            upNextCell.bind(Data.feedData.getUpNextAction()!, progress: Data.feedData.getProgress()!);
        }
        else if (indexPath.section == 1){
            cell = tableView.dequeueReusableCellWithIdentifier("FeedbackCell", forIndexPath: indexPath);
            let feedbackCell = cell as! FeedbackCell;
            //Data.feedData.getFeedback()!.title = "What if the title is ridiculously large? What if the title is ridiculously large? What if the title is ridiculously large?";
            feedbackCell.setFeedback(Data.feedData.getFeedback()!);
            
        }
        else if (indexPath.section == 2){
            cell = tableView.dequeueReusableCellWithIdentifier("UpcomingCell", forIndexPath: indexPath);
            let upcomingCell = cell as! UpcomingCell;
            upcomingCell.bind(Data.feedData.getUpcoming()[indexPath.row]);
        }
        else{
            cell = tableView.dequeueReusableCellWithIdentifier("FeedGoalCell", forIndexPath: indexPath);
            let goalCell = cell as! FeedGoalCell;
            goalCell.bind(Data.feedData.getGoals()[indexPath.row]);
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        print("Height for: \(indexPath.section), \(indexPath.row)");
        if (indexPath.section == 0){
            
        }
        else if (indexPath.section == 1){
            return FeedbackCell.getCellHeight(Data.feedData.getFeedback()!);
        }
        else if (indexPath.section == 2){
            
        }
        else if (indexPath.section == 3){
            return 100;
        }
        return 120;
    }
}

extension String{
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat{
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}