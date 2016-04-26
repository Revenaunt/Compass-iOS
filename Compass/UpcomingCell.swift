//
//  UpcomingCell.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class UpcomingCell: UITableViewCell{
    @IBOutlet weak var action: UILabel!
    @IBOutlet weak var goal: UILabel!
    @IBOutlet weak var time: UILabel!
    
    
    func bind(upcoming: UpcomingAction){
        action.text = upcoming.getTitle();
        goal.text = upcoming.getGoalTitle();
        time.text = upcoming.getTrigger();
    }
}
