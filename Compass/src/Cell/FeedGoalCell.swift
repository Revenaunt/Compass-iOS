//
//  FeedGoalCell.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Nuke


class FeedGoalCell: UITableViewCell{
    @IBOutlet weak var iconContainer: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func bind(goal: Goal){
        iconContainer.layer.cornerRadius = iconContainer.frame.size.width/2;
        iconContainer.clipsToBounds = true;
        if (goal is CustomGoal){
            iconContainer.layer.backgroundColor = UIColor.clearColor().CGColor;
            icon.image = UIImage(named: "Guy");
        }
        else{
            let userGoal = goal as! UserGoal;
            let category = SharedData.getCategory(userGoal.getPrimaryCategoryId());
            if (category != nil){
                iconContainer.layer.backgroundColor = category?.getParsedColor().CGColor;
            }
            else{
                //reset/primary
            }
            if (goal.getIconUrl().characters.count != 0){
                Nuke.taskWith(NSURL(string: goal.getIconUrl())!){
                    let image = $0.image;
                    self.icon.image = image;
                }.resume();
             }
        }
        title.text = goal.getTitle();
    }
}
