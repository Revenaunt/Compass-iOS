//
//  UserCategory.swift
//  Compass
//
//  Created by Ismael Alonso on 5/31/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class UserCategory: UserContent{
    var category: CategoryContent? = nil;
    
    
    required init?(_ map: Map){
        super.init(map);
    }
    
    override func mapping(map: Map){
        super.mapping(map);
        
        category <- map["category"];
    }
    
    func getCategory() -> CategoryContent?{
        return category;
    }
    
    func getIconUrl() -> String{
        return category!.getIconUrl();
    }
    
    func getImageUrl() -> String{
        return category!.getImageUrl();
    }
}
