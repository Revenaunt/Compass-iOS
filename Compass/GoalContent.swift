//
//  GoalContent.swift
//  Compass
//
//  Created by Ismael Alonso on 4/21/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class GoalContent: TDCContent{
    private var outcome: String{
        get{
            return self.outcome;
        }
        
        set (outcome){
            self.outcome = outcome;
        }
    };
    
    private var categoryIdSet: Set<Int>{
        get{
            return self.categoryIdSet;
        }
        
        set (categoryIdSet){
            self.categoryIdSet = categoryIdSet;
        }
    };
    
    private var behaviorCount: Int{
        get{
            return self.behaviorCount;
        }
        
        set (behaviorCount){
            self.behaviorCount = behaviorCount;
        }
    };
    
    
    required init?(_ map: Map){
        super.init(map);
    }
    
    override func mapping(map: Map){
        super.mapping(map);
        
        outcome <- map["outcome"];
        categoryIdSet <- map["categories"];
        behaviorCount <- map["behaviors_count"];
    }
}
