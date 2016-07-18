//
//  BadgeController.swift
//  Compass
//
//  Created by Ismael Alonso on 6/30/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Nuke


class BadgeController: UIViewController{
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    //Apparently, description is a superclass variable
    @IBOutlet weak var badgeDescription: UILabel!
    
    var badge: Badge!;
    
    
    override func viewDidLoad(){
        Nuke.taskWith(NSURL(string: badge.getImageUrl())!){
            self.image.image = $0.image;
        }.resume();
        
        name.text = badge.getName();
        badgeDescription.text = badge.getDescription();
    }
    
    override func viewDidAppear(animated: Bool){
        imageContainer.layer.cornerRadius = imageContainer.frame.size.width/2;
        imageContainer.hidden = false;
    }
}
