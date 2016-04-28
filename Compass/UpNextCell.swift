//
//  UpNextCellTableViewCell.swift
//  Compass
//
//  Created by Ismael Alonso on 4/20/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit

class UpNextCell: UITableViewCell {
    @IBOutlet weak var progressIndicator: CircleProgressView!
    @IBOutlet weak var action: UILabel!
    @IBOutlet weak var goal: UILabel!
    @IBOutlet weak var time: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(upNext: UpcomingAction, progress: FeedData.Progress){
        progressIndicator.setProgress(Double(progress.getProgressPercentage())/100, animated: true);
        action.text = upNext.getTitle();
        goal.text = upNext.getGoalTitle();
        time.text = upNext.getTriggerDisplay();
    }
}
