//
//  FeedGoalCell.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class FeedGoalCell: UITableViewCell{
    @IBOutlet weak var iconContainer: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func bind(goal: Goal){
        title.text = goal.getTitle();
    }
}
