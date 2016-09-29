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
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var badgeName: UILabel!
    @IBOutlet weak var badgeDescription: UILabel!
    
    
    func bind(badge: Badge){
        badgeImage.layoutIfNeeded();
        if (badge.getImageUrl().characters.count != 0){
            Nuke.taskWith(NSURL(string: badge.getImageUrl())!){
                let image = $0.image;
                self.badgeImage.image = image;
            }.resume();
        }
        badgeName.text = badge.getName();
        badgeDescription.text = badge.getDescription();
        if (badge.isNew){
            container.backgroundColor = UIColor(colorLiteralRed: 0.9, green: 0.9, blue: 0.9, alpha: 1);
        }
        else{
            container.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1);
        }
    }
}
