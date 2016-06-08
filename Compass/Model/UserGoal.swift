//
//  UserGoal.swift
//  Compass
//
//  Created by Ismael Alonso on 4/26/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class UserGoal: Goal{
    var goal: GoalContent? = nil;
    var primaryCategoryId: Int = -1;
    var progress: FeedData.Progress? = nil;
    
    
    override func mapping(map: Map){
        goal <- map["goal"];
        primaryCategoryId <- map["primary_category"];
        progress <- map ["progress"];
    }
    
    func getGoal() -> GoalContent{
        return goal!;
    }
    
    func getPrimaryCategoryId() -> Int{
        return primaryCategoryId;
    }
    
    func getProgress() -> FeedData.Progress{
        return progress!;
    }
    
    override func getTitle() -> String{
        return goal!.getTitle();
    }
    
    override func getIconUrl() -> String {
        return goal!.getIconUrl();
    }
    
    override func getColor() -> String{
        return "";
    }
}
