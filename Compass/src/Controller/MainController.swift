//
//  MainController.swift
//  Compass
//
//  Created by Ismael Alonso on 7/14/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class MainController: UITabBarController{
    override func viewDidLoad(){
        super.viewDidLoad()
        NotificationUtil.sendRegistrationToken();
        selectedIndex = 1;
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        let newAwardCount = DefaultsManager.getNewAwardCount()
        if newAwardCount == 0{
            tabBar.items?[2].badgeValue = nil
        }
        else{
            tabBar.items?[2].badgeValue = "\(newAwardCount)"
        }
    }
}
