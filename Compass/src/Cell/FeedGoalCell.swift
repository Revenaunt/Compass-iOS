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
    @IBOutlet weak var userGoalIcon: UIImageView!
    @IBOutlet weak var customGoalIcon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func bind(goal: Goal){
        iconContainer.layoutIfNeeded()
        iconContainer.layer.cornerRadius = iconContainer.frame.size.width/2
        iconContainer.clipsToBounds = true
        if goal is CustomGoal{
            iconContainer.layer.backgroundColor = UIColor.clearColor().CGColor
            userGoalIcon.image = nil
            customGoalIcon.image = UIImage(named: "Guy")
        }
        else{
            let userGoal = goal as! UserGoal
            if let category = SharedData.getCategory(userGoal.getPrimaryCategoryId()){
                iconContainer.layer.backgroundColor = category.getParsedColor().CGColor
            }
            customGoalIcon.image = nil
            if (goal.getIconUrl().characters.count != 0){
                Nuke.taskWith(NSURL(string: goal.getIconUrl())!){
                    self.userGoalIcon.image = $0.image
                }.resume()
             }
        }
        title.text = goal.getTitle()
    }
}
