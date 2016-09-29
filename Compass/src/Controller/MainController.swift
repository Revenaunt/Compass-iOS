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
        NotificationUtil.sendRegistrationToken();
        selectedIndex = 1;
    }
}
