//
//  Action.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class Action: UserContent{
    private var trigger: Trigger? = nil;
    private var nextReminder: String = "";
    
    
    required init?(_ map: Map){
        super.init(map);
    }
    
    override func mapping(map: Map){
        super.mapping(map);
        
        trigger <- map["trigger"];
        nextReminder <- map["next_reminder"];
    }
}
