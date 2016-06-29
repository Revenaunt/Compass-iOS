//
//  OnBoardingCategoryCell.swift
//  Compass
//
//  Created by Ismael Alonso on 6/17/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Nuke


class OnBoardingCategoryCell: UITableViewCell{
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    
    func setCategory(category: CategoryContent){
        categoryImage.layer.cornerRadius = categoryImage.frame.size.width/2;
        categoryImage.clipsToBounds = true;
        categoryImage.image = UIImage(named: CompassUtil.getCategoryTileAssetName(category));
        if (category.getIconUrl().characters.count != 0){
            Nuke.taskWith(NSURL(string: category.getIconUrl())!){
                let image = $0.image;
                self.categoryImage.image = image;
                }.resume();
        }
        categoryTitle.text = category.getTitle();
    }
}
