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
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = self.tableView.dequeueReusableCellWithIdentifier("UpNextCell", forIndexPath: indexPath) as! UpNextCell;
        
        if (indexPath.item == 0){
            cell.setProgress(0.44);
        }
        else{
            cell.setProgress(0.28);
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