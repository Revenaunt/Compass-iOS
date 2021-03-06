//
//  AppDelegate.swift
//  Compass
//
//  Created by Ismael Alonso on 4/7/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Locksmith
import CoreData
import ObjectMapper
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{
    
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool{
        NSLog("didFinishLaunchingWithOptions");
        
        #if DEBUG
            print("debug");
        #else
            print("release");
        #endif
        
        let defaults = NSBundle.mainBundle().pathForResource("TourDefaults", ofType: "plist");
        let dict = NSDictionary(contentsOfFile: defaults!);
        NSUserDefaults.standardUserDefaults().registerDefaults(dict as! [String : AnyObject]);
        //TourManager.reset();
        
        //Fire the notification registration process.
        if #available(iOS 10.0, *){
            let center = UNUserNotificationCenter.currentNotificationCenter();
            let options: UNAuthorizationOptions = [.Alert, .Badge, .Sound];
            center.delegate = self;
            center.requestAuthorizationWithOptions(options){ (granted, error) in
                if (granted){
                    print("NotificationCenter, notification authorization granted: \(granted)");
                    UIApplication.sharedApplication().registerForRemoteNotifications();
                }
            };
        }
        else{ //If user is not on iOS 10 use the old methods we've been using
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil);
            application.registerUserNotificationSettings(settings);
            application.registerForRemoteNotifications();
            
        }
        
        //Notification has been tapped being the app completely dead. This appears to be the
        //  procedure by which iOS 10 does it as well
        if let payload = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary{
            let dictionary = Locksmith.loadDataForUserAccount("CompassAccount")
            if dictionary != nil && dictionary!["token"] != nil{
                NSLog("Doin' some evil. With Love, APNs")
                
                let message = Mapper<APNsMessage>().map(payload)!
                if message.isActionMessage(){
                    //Create the navigation controller and set as root
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let navController = storyboard.instantiateViewControllerWithIdentifier("LauncherNavController") as! UINavigationController
                    window?.rootViewController = navController
                    
                    //Create the action controller and immediately push
                    let actionController = storyboard.instantiateViewControllerWithIdentifier("ActionController") as! ActionController
                    actionController.message = message
                    navController.pushViewController(actionController, animated: false)
                }
                else if message.isBadgeMessage(){
                    //Create the navigation controller and set as root
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let navController = storyboard.instantiateViewControllerWithIdentifier("LauncherNavController") as! UINavigationController
                    window?.rootViewController = navController
                    
                    //Create the badge controller and immediately push
                    let badgeController = storyboard.instantiateViewControllerWithIdentifier("BadgeController") as! BadgeController
                    badgeController.badge = message.getBadge()
                    print(message.getBadge())
                    navController.pushViewController(badgeController, animated: false)
                }
            }
        }
        
        //Crashlytics and Answers
        Fabric.with([Crashlytics.self, Answers.self])
        
        return true;
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData){
        //Process the token
        var token = NSString(format: "%@", deviceToken)
        token = token.stringByReplacingOccurrencesOfString("<", withString: "")
        token = token.stringByReplacingOccurrencesOfString(">", withString: "")
        token = token.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        print("APNs token: \(token as String)");
        
        //The method calls to NotificationUtil will handle the specific cases
        NotificationUtil.setApnsToken(token as String);
    }
    
    //If I am not mistaken, this is the method that displays a notification when the message is
    //  received
    @available(iOS 10.0, *)
    func userNotificationCenter(
        center: UNUserNotificationCenter,
        willPresentNotification notification: UNNotification,
        withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void
    ){
        
        print("will present notification");
        let message = Mapper<APNsMessage>().map(notification.request.content.userInfo)!;
        //If this is an action notification, just display the thing
        if (message.isActionMessage()){
            completionHandler([.Alert, .Sound]);
        }
        //If this is a badge notification, something cooler may be done
        else if (message.isBadgeMessage()){
            //Add one to the count of new awards to display a badge
            DefaultsManager.addNewAward(message.getBadge());
            //If the main controller is available
            if let rootController = window?.rootViewController as? MainController{
                print("Controller is available")
                //If the tab bar items are available, update the badge
                if let items = rootController.tabBar.items{
                    print("Tab bar items are available")
                    items[2].badgeValue = "\(DefaultsManager.getNewAwardCount())"
                }
                
                if let navController = rootController.viewControllers?[2] as? UINavigationController{
                    for (controller) in navController.viewControllers{
                        if let awardsController = controller as? AwardsController{
                            message.getBadge().isNew = true
                            awardsController.addBadge(message.getBadge())
                            break;
                        }
                    }
                }
                //At this point, there is no need to display a notification
                completionHandler([]);
            }
            else{
                print("rootController ain't available")
                completionHandler([.Alert, .Sound]);
            }
        }
    }
    
    //This happens when a notification gets tapped in iOS 10
    @available(iOS 10.0, *)
    func userNotificationCenter(
        center: UNUserNotificationCenter,
        didReceiveNotificationResponse response:
        UNNotificationResponse, withCompletionHandler completionHandler: () -> Void
    ){
        print("DidReceiveNotificationResponse")
        switch (response.actionIdentifier){
            case UNNotificationDefaultActionIdentifier:
                handleNotification(response.notification.request.content.userInfo);
                completionHandler();
                break
            
            default:
                completionHandler();
        }
    }
    
    //This happens when a notification is tapped in iOS 9
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject]){
        print("Doin' some evil in didReceiveRemoteNotification. With Love, APNs");
        handleNotification(userInfo);
    }
    
    //Common handler for notification tap events
    func handleNotification(userInfo: [NSObject: AnyObject]){
        let dictionary = Locksmith.loadDataForUserAccount("CompassAccount");
        if (dictionary != nil && dictionary!["token"] != nil){
            let message = Mapper<APNsMessage>().map(userInfo)!;
            print("The message was parsed properly");
            if (message.isActionMessage()){
                let storyboard = UIStoryboard(name: "Main", bundle: nil);
                let actionController = storyboard.instantiateViewControllerWithIdentifier("ActionController") as! ActionController;
                actionController.message = message
                if let rootController = window?.rootViewController as? MainController{
                    rootController.selectedIndex = 1;
                    if let navController = rootController.viewControllers![1] as? UINavigationController{
                        navController.pushViewController(actionController, animated: true);
                    }
                }
            }
            else if (message.isBadgeMessage()){
                //if a root controller exists (and is main)
                if let rootController = window?.rootViewController as? MainController{
                    //Get the storyboard and instantiate the BadgeController
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let badgeController = storyboard.instantiateViewControllerWithIdentifier("BadgeController") as! BadgeController;
                    //Set the badge
                    badgeController.badge = message.getBadge();
                    
                    //If the app is already in the foreground
                    if (UIApplication.sharedApplication().applicationState == UIApplicationState.Active){
                        //Set the badge
                        let newBadges = DefaultsManager.getNewAwardCount();
                        rootController.tabBar.items![2].badgeValue = "\(newBadges)";
                        //If we have access to the navigation controller hosting the awards
                        if let navController = rootController.viewControllers![2] as? UINavigationController{
                            //Find the awards controller and update it
                            for controller in navController.viewControllers{
                                if let awardsController = controller as? AwardsController{
                                    message.getBadge().isNew = true;
                                    awardsController.addBadge(message.getBadge());
                                    break;
                                }
                            }
                        }
                    }
                    else{
                        rootController.selectedIndex = 2;
                        if let navController = rootController.viewControllers![2] as? UINavigationController{
                            navController.pushViewController(badgeController, animated: true);
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //This is all native stuff, mostly core data, which I ain't sure we need. I also don't know what it does. yet.
    //  I am separating it because it is nagging the crap out of me.

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "org.tndata.Compass" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Compass", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

