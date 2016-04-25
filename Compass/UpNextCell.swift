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

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setProgress(progress: Double){
        progressIndicator.setProgress(progress, animated: true);
        //progressCaption.text = "\(progress) complete";
    }
}
