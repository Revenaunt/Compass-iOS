//
//  Award.swift
//  Compass
//
//  Created by Ismael Alonso on 7/14/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class Award: Mappable{
    private var badge: Badge!
    
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map){
        badge <- map["badge"]
    }
    
    func getBadge() -> Badge{
        return badge
    }
}


class AwardList: ListResult{
    private(set) internal var awards: [Award]!
    
    
    override func mapping(map: Map){
        super.mapping(map)
        awards <- map["results"]
    }
}
