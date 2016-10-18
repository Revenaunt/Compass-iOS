//
//  Trigger.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class Trigger: TDCBase{
    private var name: String = ""
    
    private var time: String?
    private var date: String?
    private var recurrences: String?
    
    private var recurrencesDisplay: String = ""
    
    private var disabled: Bool = false
    
    
    init(){
        super.init(id: -1)
    }
    
    required init?(_ map: Map){
        super.init(map)
    }
    
    override func mapping(map: Map){
        super.mapping(map)
        
        name <- map["name"]
        time <- map["time"]
        date <- map["date"]
        recurrences <- map["recurrences"]
        recurrencesDisplay <- map["recurrences_display"]
        disabled <- map["disabled"]
    }
    
    func isEnabled() -> Bool{
        return !disabled
    }
    
    func hasTime() -> Bool{
        return !(time ?? "").isEmpty
    }
    
    func getTime() -> NSDate{
        if hasTime(){
            let formatter = NSDateFormatter()
            formatter.dateFormat = "H:mm:ss"
            return formatter.dateFromString(time!)!
        }
        return NSDate()
    }
    
    func getFormattedTime(format: NSDateFormatter) -> String{
        return format.stringFromDate(getTime())
    }
    
    func hasDate() -> Bool{
        return !(date ?? "").isEmpty
    }
    
    func getDate() -> NSDate{
        if !(date ?? "").isEmpty{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-d"
            return formatter.dateFromString(date!)!
        }
        return NSDate()
    }
    
    func getFormattedDate(format: NSDateFormatter) -> String{
        return format.stringFromDate(getDate())
    }
    
    func hasRecurrence() -> Bool{
        return !(recurrences ?? "").isEmpty
    }
    
    func getRecurrenceDisplay() -> String{
        return recurrencesDisplay
    }
    
    func setTime(time: NSDate){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "H:mm:ss"
        self.time = formatter.stringFromDate(time)
    }
    
    func setDate(date: NSDate){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-d"
        self.date = formatter.stringFromDate(date)
    }
}
