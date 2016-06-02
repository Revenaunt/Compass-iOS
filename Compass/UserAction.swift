//
//  UserAction.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class UserAction: Action{
    private var action: ActionContent? = nil;
    private var primaryGoalId: Int = -1;
    private var primaryCategoryId: Int = -1;
    
    //TODO POST parent content. Used anymore in Android??
    
    
    required init?(_ map: Map){
        super.init(map);
    }
    
    override func mapping(map: Map){
        super.mapping(map);
        
        action <- map["action"];
        primaryGoalId <- map["primary_goal"];
        primaryCategoryId <- map["primary_category"];
    }
    
    func getPrimaryCategoryId() -> Int{
        return primaryCategoryId;
    }
    
    func getTitle() -> String{
        return action!.getTitle();
    }
    
    func getDescription() -> String{
        return action!.getDescription();
    }
    
    func getBehaviorTitle() -> String{
        return action!.getBehaviorTitle();
    }
}