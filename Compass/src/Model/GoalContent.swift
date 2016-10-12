//
//  GoalContent.swift
//  Compass
//
//  Created by Ismael Alonso on 4/21/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class GoalContent: TDCContent{
    private var outcome: String = "";
    private var categoryIdSet: Set<Int> = Set<Int>();
    
    func getOutcome() -> String{
        return outcome;
    }
    
    func getCategoryIdSet() -> Set<Int>{
        return categoryIdSet;
    }
    
    required init?(_ map: Map){
        super.init(map);
    }
    
    override func mapping(map: Map){
        super.mapping(map);
        
        outcome <- map["outcome"];
        categoryIdSet <- map["categories"];
    }
    
    func toString() -> String{
        return "Goal #\(getId()): \(getTitle())";
    }
}
