//
//  SettingsController.swift
//  Compass
//
//  Created by Ismael Alonso on 7/13/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Locksmith


class SettingsController: UITableViewController{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if (indexPath.section == 0){
            print("General");
            if (indexPath.row == 0){
                
            }
            else if (indexPath.row == 1){
                do{
                    //Remove the user info
                    try Locksmith.deleteDataForUserAccount("CompassAccount");
                    //Back to the login screen
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                    let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("LauncherNavController");
                    UIApplication.sharedApplication().keyWindow?.rootViewController = viewController;
                }
                catch{
                    
                }
            }
        }
        else if (indexPath.section == 1){
            print("About");
            if (indexPath.row == 0){
                UIApplication.sharedApplication().openURL(NSURL(string: "https://app.tndata.org/terms/")!);
            }
            else if (indexPath.row == 1){
                UIApplication.sharedApplication().openURL(NSURL(string: "https://app.tndata.org/privacy/")!);
            }
            else if (indexPath.row == 2){
                performSegueWithIdentifier("ShowSources", sender: self);
            }
        }
    }
}
