//
//  Award.swift
//  Compass
//
//  Created by Ismael Alonso on 7/14/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class Award: Mappable{
    var badge: Badge?;
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map){
        badge <- map["badge"];
    }
}
