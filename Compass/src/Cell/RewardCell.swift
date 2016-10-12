//
//  RewardCell.swift
//  Compass
//
//  Created by Ismael Alonso on 10/11/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class RewardCell: UITableViewCell{
    @IBOutlet weak var rewardImage: UIImageView!
    @IBOutlet weak var rewardHeader: UILabel!
    @IBOutlet weak var rewardPreview: UILabel!
    
    
    func bind(reward: Reward){
        rewardImage.image = reward.getImageAsset()
        rewardHeader.text = reward.getHeaderTitle()
        var message = reward.getMessage()
        if message.characters.count > 30{
            message = "\(message.chopAt(30))..."
        }
        rewardPreview.text = message
    }
}
