//
//  CustomAction.swift
//  Compass
//
//  Created by Ismael Alonso on 10/7/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class CustomAction: Action{
    private var title = ""
    private var customGoalId = -1
    private var notificationText = ""
    
    required init?(_ map: Map){
        super.init(map);
    }
    
    override func mapping(map: Map){
        super.mapping(map);
        
        title <- map["title"];
        customGoalId <- map["customgoal"];
        notificationText <- map["notification_text"];
    }
    
    override func getTitle() -> String{
        return title;
    }
}


class CustomActionList: ParserModels.ListResult{
    private(set) internal var results: [CustomAction]!
    
    
    override func mapping(map: Map){
        super.mapping(map)
        results <- map["results"]
    }
}
