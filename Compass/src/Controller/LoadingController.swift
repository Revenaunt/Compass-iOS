//
//  LoadingController.swift
//  Compass
//
//  Created by Ismael Alonso on 6/20/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Just


class LoadingController: UIViewController{
    
    override func viewDidLoad(){
        Just.put(API.getPutUserProfileUrl(SharedData.user), headers: SharedData.user.getHeaderMap(),
                 json: API.getPutUserProfileBody(SharedData.user)){ (response) in
                    
                    if response.ok && CompassUtil.isSuccessStatusCode(response.statusCode!){
                        self.loadData();
                    }
                    else{
                        print(response.statusCode);
                        print(response.description);
                    }
        }
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated);
        navigationController?.setNavigationBarHidden(true, animated: animated);
    }
    
    func loadData(){
        InitialDataLoader.load(SharedData.user){ (success) in
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
            var viewController: UIViewController
            if (success){
                viewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainTabBarController");
            }
            else{
                viewController = mainStoryboard.instantiateViewControllerWithIdentifier("LauncherNavController");
            }
            UIApplication.sharedApplication().keyWindow?.rootViewController = viewController;
        }
    }
}
