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
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var dailyNotificationLimit: UILabel!
    @IBOutlet weak var versionName: UILabel!
    
    
    var selectedLimit: Int = SharedData.user.getDailyNotificationLimit();
    
    
    override func viewDidLoad(){
        userName.text = SharedData.user.getFullName();
        dailyNotificationLimit.text = "\(SharedData.user.getDailyNotificationLimit())";
        let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String;
        versionName.text = version;
    }
    
    override func viewDidAppear(animated: Bool){
        if (selectedLimit != SharedData.user.getDailyNotificationLimit()){
            SharedData.user.setDailyNotificationLimit(selectedLimit);
            dailyNotificationLimit.text = "\(selectedLimit)";
            Just.put(API.getPutUserProfileUrl(SharedData.user), headers: SharedData.user.getHeaderMap(),
                     json: API.getPutUserProfileBody(SharedData.user)){ (response) in
                        
                        print(response.statusCode);
                        
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if (indexPath.section == 0){
            print("General");
            if (indexPath.row == 0){
                if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString){
                    CompassUtil.openUrl(appSettings);
                }
                tableView.deselectRowAtIndexPath(indexPath, animated: true);
            }
            else if (indexPath.row == 1){
                let recipient = "feedback@tndata.org";
                let subject = "Compass Feedback";
                let string = "mailto:?to=\(recipient)&subject=\(subject)";
                let set = NSCharacterSet.URLQueryAllowedCharacterSet();
                let encodedString = string.stringByAddingPercentEncodingWithAllowedCharacters(set)!;
                print("before");
                let url = NSURL(string: encodedString)!;
                print("after");
                CompassUtil.openUrl(url);
                tableView.deselectRowAtIndexPath(indexPath, animated: true);
            }
            else if (indexPath.row == 2){
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
                    DefaultsManager.emptyNewAwardsRecords();
                    TourManager.reset();
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
            print("Notifications");
            if (indexPath.row == 0){
                performSegueWithIdentifier("PickerFromSettings", sender: self);
            }
        }
        else if (indexPath.section == 2){
            print("About");
            if (indexPath.row == 0){
                CompassUtil.openUrl(NSURL(string: "https://app.tndata.org/terms/")!);
                tableView.deselectRowAtIndexPath(indexPath, animated: true);
            }
            else if (indexPath.row == 1){
                CompassUtil.openUrl(NSURL(string: "https://app.tndata.org/privacy/")!);
                tableView.deselectRowAtIndexPath(indexPath, animated: true);
            }
            else if (indexPath.row == 2){
                performSegueWithIdentifier("ShowSources", sender: self);
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        segue.destinationViewController.hidesBottomBarWhenPushed = true;
        if (segue.identifier == "PickerFromSettings"){
            let pickerController = segue.destinationViewController as! PickerController;
            pickerController.delegate = self;
        }
    }
}
