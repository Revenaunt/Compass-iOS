//
//  Trigger.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class Trigger: TDCBase{
    private var name: String = "";
    
    private var time: String = "";
    private var date: String = "";
    private var recurrences: String = "";
    
    private var recurrencesDisplay: String = "";
    
    private var disabled: Bool = false;
    
    
    required init?(_ map: Map){
        super.init(map);
    }
    
    override func mapping(map: Map){
        super.mapping(map);
        
        name <- map["name"];
        time <- map["time"];
        date <- map["date"];
        recurrences <- map["recurrences"];
        recurrencesDisplay <- map["recurrences_display"];
        disabled <- map["disabled"];
    }
}
