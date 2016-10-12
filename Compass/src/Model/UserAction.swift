//
//  UserAction.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class UserAction: Action{
    private var action: ActionContent!
    
    private var primaryGoalId: Int = -1
    private var primaryUserGoalId: Int = -1
    private var goalIconUrl: String = ""
    
    private var primaryCategoryId: Int = -1
    
    //TODO POST parent content. Used anymore in Android??
    
    
    required init?(_ map: Map){
        super.init(map)
    }
    
    override func mapping(map: Map){
        super.mapping(map)
        
        action <- map["action"]
        primaryGoalId <- map["primary_goal"]
        primaryUserGoalId <- map["primary_usergoal"]
        goalIconUrl <- map["goal_icon"]
        primaryCategoryId <- map["primary_category"]
    }
    
    func getPrimaryCategoryId() -> Int{
        return primaryCategoryId
    }
    
    override func getTitle() -> String{
        return action.getTitle()
    }
    
    func getDescription() -> String{
        return action.getDescription()
    }
    
    func getMoreInfo() -> String{
        return action.getMoreInfo()
    }
    
    func getGoalIconUrl() -> String{
        return goalIconUrl
    }
}


class UserActionList: ListResult{
    private(set) internal var results: [UserAction]!
    
    
    override func mapping(map: Map){
        super.mapping(map)
        results <- map["results"]
    }
}
