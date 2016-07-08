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
            //For some reason, in the second run, the frame object reports a wrong height,
            //  to fix that, header image is forced to layout to calculate the actual
            //  height respecting its constraints, and only then we set the corner radius
            self.image.setNeedsLayout();
            self.image.layoutIfNeeded();
            self.image.layer.cornerRadius = self.image.frame.height/2;
            self.image.clipsToBounds = true;
            self.image.image = $0.image;
            
            self.imageContainer.layer.cornerRadius = self.imageContainer.frame.size.width/2;
            self.imageContainer.hidden = false;
        }.resume();
        
        name.text = badge.getName();
        badgeDescription.text = badge.getDescription();
    }
}
