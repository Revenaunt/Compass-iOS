//
//  OnBoardingCategoryCell.swift
//  Compass
//
//  Created by Ismael Alonso on 6/17/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class OnBoardingCategoryCell: UITableViewCell{
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    
    func setCategory(category: CategoryContent){
        categoryImage.layer.cornerRadius = categoryImage.frame.size.width/2;
        categoryImage.clipsToBounds = true;
        categoryImage.image = UIImage(named: CompassUtil.getCategoryTileAssetName(category));
        categoryTitle.text = category.getTitle();
    }
}
