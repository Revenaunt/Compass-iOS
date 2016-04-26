//
//  FeedbackCell.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class FeedbackCell: UITableViewCell{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    
    func setFeedback(feedback: FeedData.ActionFeedback){
        title.text = feedback.getTitle();
        subtitle.text = feedback.getSubtitle();
    }
}
