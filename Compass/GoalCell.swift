//
//  GoalCell.swift
//  Compass
//
//  Created by Ismael Alonso on 4/22/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class GoalCell: UITableViewCell{
    @IBOutlet weak var iconContainer: UIView!
    @IBOutlet weak var goalIcon: UIImageView!
    @IBOutlet weak var goalTitle: UILabel!
    
    
    func setContent(goal: GoalContent?, category: CategoryContent){
        print("Color: \(category.getColor())");
        iconContainer.layer.cornerRadius = iconContainer.frame.size.width/2;
        iconContainer.clipsToBounds = true;
        iconContainer.layer.backgroundColor = category.getParsedColor().CGColor;
    }
}
