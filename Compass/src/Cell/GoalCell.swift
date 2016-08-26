//
//  GoalCell.swift
//  Compass
//
//  Created by Ismael Alonso on 4/22/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Nuke


class GoalCell: UITableViewCell{
    @IBOutlet weak var iconContainer: UIView!
    @IBOutlet weak var goalIcon: UIImageView!
    @IBOutlet weak var goalTitle: UILabel!
    
    
    func setContent(goal: GoalContent, category: CategoryContent){
        iconContainer.layer.cornerRadius = iconContainer.frame.size.width/2;
        iconContainer.clipsToBounds = true;
        iconContainer.layer.backgroundColor = category.getParsedColor().CGColor;
        if (goal.getIconUrl().characters.count != 0){
            Nuke.taskWith(NSURL(string: goal.getIconUrl())!){
                let image = $0.image;
                self.goalIcon.image = image;
            }.resume();
        }
        goalTitle.text = goal.getTitle();
    }
}
