//
//  ParserModels.swift
//  Compass
//
//  Created by Ismael Alonso on 4/19/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper;


class ParserModels{
    class CategoryContentArray: Mappable{
        var categories: [CategoryContent]? = nil;
        
        
        required init?(_ map: Map){
            
        }
        
        func mapping(map: Map){
            categories <- map["results"];
        }
    }
}
