//
//  SettingsController.swift
//  Compass
//
//  Created by Ismael Alonso on 7/13/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Just
import Locksmith


class SettingsController: UITableViewController{
    @IBOutlet weak var versionName: UILabel!
    
    
    override func viewDidLoad(){
        let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String;
        versionName.text = version;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if (indexPath.section == 0){
            print("General");
            if (indexPath.row == 0){
                
                tableView.deselectRowAtIndexPath(indexPath, animated: true);
            }
            else if (indexPath.row == 1){
                do{
                    //Send the logout request
                    let defaults = NSUserDefaults.standardUserDefaults();
                    let token = defaults.objectForKey("APNsToken") as? String;
                    if (token != nil){
                        Just.post(API.getLogOutUrl(), headers: SharedData.user.getHeaderMap(),
                                  json: API.getLogOutBody(token!));
                    }
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
                tableView.deselectRowAtIndexPath(indexPath, animated: true);
            }
            else if (indexPath.row == 1){
                UIApplication.sharedApplication().openURL(NSURL(string: "https://app.tndata.org/privacy/")!);
                tableView.deselectRowAtIndexPath(indexPath, animated: true);
            }
            else if (indexPath.row == 2){
                performSegueWithIdentifier("ShowSources", sender: self);
            }
        }
    }
}
