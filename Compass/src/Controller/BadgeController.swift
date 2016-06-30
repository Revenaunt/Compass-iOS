//
//  BadgeController.swift
//  Compass
//
//  Created by Ismael Alonso on 6/30/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class BadgeController: UIViewController{
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    //Apparently, description is a superclass variable
    @IBOutlet weak var badgeDescription: UILabel!
    
    var badge: Badge!;
}
