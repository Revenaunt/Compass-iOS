//
//  FeedbackCell.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class FeedbackCell: UITableViewCell{
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    
    func setFeedback(feedback: FeedData.ActionFeedback){
        icon.image = UIImage(named: feedback.getIconResourceName());
        title.text = feedback.getTitle();
        subtitle.text = feedback.getSubtitle();
    }
    
    static func getCellHeight(feedback: FeedData.ActionFeedback) -> CGFloat{
        print(UIScreen.mainScreen().bounds.width);
        let width = UIScreen.mainScreen().bounds.width-80-24;
        print(width);
        
        
        let label = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max));
        label.numberOfLines = 0;
        label.lineBreakMode = .ByWordWrapping;
        
        label.font = UIFont.systemFontOfSize(16);
        label.text = feedback.getTitle();
        label.sizeToFit();
        let titleHgt = label.bounds.height;
        
        label.font = UIFont.systemFontOfSize(15);
        label.text = feedback.getSubtitle();
        label.sizeToFit();
        let subtitleHgt = label.bounds.height;
        
        let totalHgt = (titleHgt + subtitleHgt + 16)*1.3;
        print(totalHgt);
        
        return totalHgt < 80 ? CGFloat(80) : totalHgt;
    }
}
