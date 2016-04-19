//
//  CategoryContent.swift
//  Compass
//
//  Created by Ismael Alonso on 4/19/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class CategoryContent: TDCContent{
    private var order: Int = -1;
    
    private var imageUrl: String = "";
    private var color: String = "";
    private var secondaryColor: String = "";
    
    private var packagedContent: Bool = false;
    
    
    required init?(_ map: Map){
        super.init(map);
    }
    
    override func mapping(map: Map){
        super.mapping(map);
        order <- map["order"];
        imageUrl <- map["image_url"];
        color <- map["color"];
        secondaryColor <- map["secondary_color"];
        packagedContent <- map["packaged_content"];
    }
    
    
    //TODO getters
    
    
    func toString() -> String{
        return "Category #\(getId()): \(getTitle())";
    }
}