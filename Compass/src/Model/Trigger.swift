//
//  Trigger.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class Trigger: TDCBase, CustomStringConvertible{
    private var time: String?
    private var date: String?
    private var recurrence: String?
    
    private var recurrenceDisplay: String?
    
    private var disabled: Bool = false
    
    var description: String{
        return "\(time ?? "no time"), \(date ?? "no date"), \(recurrence ?? "no recurrence"), enabled: \(!disabled)"
    }
    
    
    init(){
        super.init(id: -1)
    }
    
    required init?(_ map: Map){
        super.init(map)
    }
    
    override func mapping(map: Map){
        super.mapping(map)
        
        time <- map["time"]
        date <- map["trigger_date"]
        recurrence <- map["recurrences"]
        recurrenceDisplay <- map["recurrences_display"]
        disabled <- map["disabled"]
    }
    
    func isEnabled() -> Bool{
        return !disabled
    }
    
    func isDisabled() -> Bool{
        return disabled
    }
    
    func hasTime() -> Bool{
        return !(time ?? "").isEmpty
    }
    
    func getRawTime() -> String{
        return time ?? ""
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
    
    func getRawDate() -> String{
        return date ?? ""
    }
    
    func getDate() -> NSDate{
        if hasDate(){
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
        return !(recurrence ?? "").isEmpty
    }
    
    func getRecurrence() -> String{
        return recurrence ?? ""
    }
    
    func getRecurrenceDisplay() -> String{
        return recurrenceDisplay ?? ""
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
        print(self.date)
    }
    
    func setRRule(rrule: String, display: String){
        recurrence = rrule
        recurrenceDisplay = display
    }
    
    func setEnabled(enabled: Bool){
        self.disabled = !enabled
    }
    
    func copy() -> Trigger{
        let trigger = Trigger()
        
        trigger.time = self.time
        trigger.date = self.date
        trigger.recurrence = self.recurrence
        trigger.recurrenceDisplay = self.recurrenceDisplay
        trigger.disabled = self.disabled
        
        return trigger
    }
}
