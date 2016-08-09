//
//  CustomGoal.swift
//  Compass
//
//  Created by Ismael Alonso on 4/26/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class CustomGoal: Goal{
    let Type = "CustomGoal";
    
    var title: String = "";
    
    
    override func getType() -> String{
        return Type;
    }
    
    override func mapping(map: Map){
        super.mapping(map);
        title <- map["title"];
    }
    
    func setTitle(title: String){
        self.title = title;
    }
    
    override func getTitle() -> String{
        return title;
    }
}
