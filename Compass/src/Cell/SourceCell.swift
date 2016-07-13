//
//  SourceCell.swift
//  Compass
//
//  Created by Ismael Alonso on 7/13/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class SourceCell: UITableViewCell{
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var url: UILabel!
    
    
    func bind(source: SourcesController.Source){
        caption.text = source.getCaption();
        url.text = source.getUrl();
    }
}
