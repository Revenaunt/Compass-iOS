//
//  Badge.swift
//  Compass
//
//  Created by Ismael Alonso on 6/30/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class Badge: TDCBase, CustomStringConvertible{
    private var name: String = "";
    private var text: String = "";
    private var imageUrl: String = "";
    private var userCount: Int = -1;
    
    var isNew: Bool = false;
    
    var description: String{
        return "(Badge) \(name): \(text)"
    }
    
    
    required init?(_ map: Map){
        super.init(map);
    }
    
    override func mapping(map: Map){
        super.mapping(map);
        name <- map["name"];
        text <- map["description"];
        imageUrl <- map["image"];
        userCount <- map["users_count"];
    }
    
    func getName() -> String{
        return name;
    }
    
    func getDescription() -> String{
        return text;
    }
    
    func getImageUrl() -> String{
        return imageUrl;
    }
    
    func getUserCount() -> Int{
        return userCount;
    }

}
    
func ==(lhs: Badge, rhs: Badge) -> Bool{
    return lhs.getId() == rhs.getId();
}
