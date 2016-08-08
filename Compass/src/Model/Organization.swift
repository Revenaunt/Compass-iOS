//
//  Organization.swift
//  Compass
//
//  Created by Ismael Alonso on 8/8/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper;


class Organization: TDCBase{
    private var name: String = "";
    
    func getName() -> String{
        return name;
    }
    
    override func mapping(map: Map){
        super.mapping(map);
        name <- map["name"];
    }
}
