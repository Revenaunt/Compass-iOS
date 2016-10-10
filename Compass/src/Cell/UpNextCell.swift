//
//  UpNextCellTableViewCell.swift
//  Compass
//
//  Created by Ismael Alonso on 4/20/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit

class UpNextCell: UITableViewCell {
    @IBOutlet weak var action: UILabel!
    @IBOutlet weak var goal: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(upNext: Action?, progress: FeedData.Progress){
        if (upNext == nil){
            if (progress.getTotalActions() == 0){
                action.text = "No activities selected for today";
                goal.text = "Select a goal to get started";
            }
            else{
                action.text = "No activities remaining today";
                goal.text = "See you tomorrow";
            }
        }
        else{
            action.text = upNext!.getTitle();
            if (upNext is UserAction){
                var description = (upNext as! UserAction).getDescription()
                if description.characters.count > 30{
                    description = "\(description.chopAt(30))..."
                }
                goal.text = description;
            }
        }
    }
}
