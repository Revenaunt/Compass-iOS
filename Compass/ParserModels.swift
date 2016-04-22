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
    
    class GoalContentArray: Mappable{
        var goals: [GoalContent]? = nil;
        var next: String? = nil;
        
        required init?(_ map: Map){
            
        }
        
        func mapping(map: Map){
            goals <- map["results"];
            next <- map["next"];
        }
    }
}
