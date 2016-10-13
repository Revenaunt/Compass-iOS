//
//  UserGoal.swift
//  Compass
//
//  Created by Ismael Alonso on 4/26/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class UserGoal: Goal{
    let Type: String = "UserGoal"
    
    var goal: GoalContent!
    var primaryCategoryId: Int = -1
    var progress: FeedData.Progress? = nil
    
    
    override func mapping(map: Map){
        super.mapping(map)
        goal <- map["goal"]
        primaryCategoryId <- map["primary_category"]
        progress <- map ["progress"]
    }
    
    override func getType() -> String{
        return Type
    }
    
    func getGoal() -> GoalContent{
        return goal
    }
    
    override func getContentId() -> Int{
        return goal.getId()
    }
    
    func getDescription() -> String{
        return goal.getDescription()
    }
    
    func getPrimaryCategoryId() -> Int{
        return primaryCategoryId
    }
    
    func getProgress() -> FeedData.Progress{
        return progress!
    }
    
    override func getTitle() -> String{
        return goal.getTitle()
    }
    
    override func getIconUrl() -> String {
        return goal.getIconUrl()
    }
    
    override func getColor() -> String{
        return ""
    }
}


class UserGoalList: ListResult{
    private(set) internal var results: [UserGoal]!
    
    
    override func mapping(map: Map){
        super.mapping(map)
        results <- map["results"]
    }
}
