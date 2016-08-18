//
//  UpcomingAction.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper

//IMPORTANT NOTE: The reason why this class does not extend TDCBase is because it
//  ain't got an id. This model is special in the sense that it is an abstraction
//  bundling information about several models. The id comes in a field named
//  `action_id` as opposed to the regular `id` that TDCBase parses. It also means
//  different things depending on the value of `type`
class UpcomingAction: Mappable{
    private let USER_ACTION_TYPE = "useraction";
    private let CUSTOM_ACTION_TYPE = "customaction";
    
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
    
    func getTrigger() -> String{
        return trigger;
    }
    
    func getTriggerDisplay() -> String{
        let parser = NSDateFormatter();
        parser.locale = NSLocale(localeIdentifier: "us");
        parser.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ";
        let date = parser.dateFromString(trigger);
        
        if (date == nil){
            return "";
        }
        let formatter = NSDateFormatter();
        formatter.dateFormat = "h:mm a";
        return formatter.stringFromDate(date!);
    }
    
    func isUserAction() -> Bool{
        return type == USER_ACTION_TYPE;
    }
    
    func isCustomAction() -> Bool{
        return type == CUSTOM_ACTION_TYPE;
    }
}
