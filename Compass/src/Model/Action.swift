//
//  Action.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Foundation
import ObjectMapper


class Action: UserContent{
    private var trigger: Trigger? = nil
    private var nextReminder: String = ""
    private var goalTitle: String = ""
    
    
    required init?(_ map: Map){
        super.init(map)
    }
    
    override func mapping(map: Map){
        super.mapping(map)
        
        trigger <- map["trigger"]
        nextReminder <- map["next_reminder"]
        goalTitle <- map["goal_title"]
    }
    
    func getNextReminderDate() -> NSDate?{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ssZ"
        return formatter.dateFromString(nextReminder)
    }
    
    func getTitle() -> String{
        return ""
    }
}


extension Action: Comparable{ }

func < (lhs: Action, rhs: Action) -> Bool{
    let lhDate = lhs.getNextReminderDate()
    let rhDate = rhs.getNextReminderDate()
    if lhDate != nil && rhDate == nil{
        return true
    }
    else if lhDate == nil && rhDate != nil{
        return false
    }
    else if lhDate != nil{ // && rhDate != nil (implied)
        return lhDate! < rhDate!
    }
    else{ //lhDate == nil && rhDate == nil (implied)
        return lhs.getTitle() < rhs.getTitle()
    }
}
    
func == (lhs: Action, rhs: Action) -> Bool{
    let lhDate = lhs.getNextReminderDate()
    let rhDate = rhs.getNextReminderDate()
    if lhDate != nil && rhDate == nil{
        return false
    }
    else if lhDate == nil && rhDate != nil{
        return false
    }
    else if lhDate != nil{ // && rhDate != nil (implied)
        return lhDate! == rhDate!
    }
    else{ //lhDate == nil && rhDate == nil (implied)
        return lhs.getTitle() == rhs.getTitle()
    }
}
