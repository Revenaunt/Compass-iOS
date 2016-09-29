//
//  CategoryHeaderCell.swift
//  Compass
//
//  Created by Ismael Alonso on 4/22/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Nuke


class CategoryHeaderCell: UITableViewCell{
    @IBOutlet weak var categoryImage: UIImageView!
    
    
    func setHeader(category: CategoryContent){
        categoryImage.layoutIfNeeded();
        if (category.getImageUrl().characters.count != 0){
            Nuke.taskWith(NSURL(string: category.getImageUrl())!){
                let image = $0.image;
                self.categoryImage.image = image;
            }.resume();
        }
    }
}
