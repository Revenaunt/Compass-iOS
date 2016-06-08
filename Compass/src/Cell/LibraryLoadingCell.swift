//
//  LibraryLoadingCell.swift
//  Compass
//
//  Created by Ismael Alonso on 6/6/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class LibraryLoadingCell: UITableViewCell{
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var message: UILabel!
    
    
    func displayMessage(){
        activityIndicator.hidden = true;
        message.hidden = false;
    }
}
