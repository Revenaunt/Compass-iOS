//
//  AwardCell.swift
//  Compass
//
//  Created by Ismael Alonso on 7/14/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Nuke


class AwardCell: UITableViewCell{
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var badgeName: UILabel!
    @IBOutlet weak var badgeDescription: UILabel!
    
    
    func bind(badge: Badge){
        if (badge.getImageUrl().characters.count != 0){
            Nuke.taskWith(NSURL(string: badge.getImageUrl())!){
                let image = $0.image;
                self.badgeImage.image = image;
            }.resume();
        }
        badgeName.text = badge.getName();
        badgeDescription.text = badge.getDescription();
    }
}
