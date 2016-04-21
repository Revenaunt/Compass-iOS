//
//  CategoryCell.swift
//  Compass
//
//  Created by Ismael Alonso on 4/21/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


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
        categoryImage.image = UIImage(named: "Tile - Community");
        categoryTitle.text = category.getTitle();
    }
}
