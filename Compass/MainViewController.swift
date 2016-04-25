//
//  MainViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 4/19/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class MainViewController: UITableViewController, UIActionSheetDelegate{
    override func viewDidLoad(){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 4;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (section == 2){
            return 3
        }
        return 1;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0){
            return "Up Next";
        }
        else if (section == 1){
            //Feedback is a complete different section layout-wise, but it is part of the original up next.
            //  Returning an empty string as the section header will make it seem like they are part of the same thing.
            return "";
        }
        else if (section == 2){
            return "Upcoming";
        }
        else{
            return "My Goals";
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell: UITableViewCell;
        
        if (indexPath.section == 0){
            cell = tableView.dequeueReusableCellWithIdentifier("UpNextCell", forIndexPath: indexPath);
            let upNextCell = cell as! UpNextCell;
            upNextCell.setProgress(0.44);
        }
        else if (indexPath.section == 1){
            cell = tableView.dequeueReusableCellWithIdentifier("FeedbackCell", forIndexPath: indexPath);
        }
        else if (indexPath.section == 2){
            cell = tableView.dequeueReusableCellWithIdentifier("UpcomingCell", forIndexPath: indexPath);
        }
        else{
            cell = tableView.dequeueReusableCellWithIdentifier("UpNextCell", forIndexPath: indexPath);
            let upNextCell = cell as! UpNextCell;
            upNextCell.setProgress(0.28);
        }
        
        return cell;
    }
    
    @IBAction func addTap(sender: AnyObject){
        let addSheet = UIAlertController(title: "Choose an option", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet);
        addSheet.addAction(UIAlertAction(title: "Search goals", style: .Default){ action in
            
        });
        addSheet.addAction(UIAlertAction(title: "Browse goals", style: .Default){ action in
            self.performSegueWithIdentifier("Library", sender: self);
        });
        presentViewController(addSheet, animated: true, completion: nil);
    }
}