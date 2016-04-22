//
//  CategoryDescriptionCell.swift
//  Compass
//
//  Created by Ismael Alonso on 4/21/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class CategoryDescriptionCell: UITableViewCell{
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryDescription: UILabel!
    
    
    func setCategory(category: CategoryContent){
        categoryTitle.text = category.getTitle();
        categoryDescription.text = category.getDescription();
    }
}
