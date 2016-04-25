//
//  UpcomingAction.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class UpcomingAction: Mappable{
    private var id: Int = -1;
    private var title: String = "";
    private var goalId: Int = -1;
    private var goalTitle: String = "";
    private var trigger: String = "";
    private var type: String = "";
    
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map){
        id <- map["action_id"];
        title <- map["action"];
        goalId <- map["goal_id"];
        goalTitle <- map["goal"];
        trigger <- map["trigger"];
        type <- map["type"];
    }
    
    func getId() -> Int{
        return id;
    }
    
    func getTitle() -> String{
        return title;
    }
    
    func getGoalId() -> Int{
        return goalId;
    }
    
    func getGoalTitle() -> String{
        return goalTitle;
    }
    
    //TODO trigger (unimportant now)
    
    func getTrigger() -> String{
        return trigger;
    }
}
