//
//  CategoryCell.swift
//  Compass
//
//  Created by Ismael Alonso on 4/21/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Nuke


class CategoryCell: UITableViewCell{
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
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
