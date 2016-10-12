//
//  Organization.swift
//  Compass
//
//  Created by Ismael Alonso on 8/8/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper;


class Organization: TDCBase, CustomStringConvertible{
    private var name: String = ""
    
    func getName() -> String{
        return name
    }
    
    override func mapping(map: Map){
        super.mapping(map)
        name <- map["name"]
    }
    
    var description: String{
        return "Organization #\(getId()): \(name)"
    }
}


class OrganizationList: ListResult{
    private(set) internal var organizations: [Organization]!
    
    
    override func mapping(map: Map){
        super.mapping(map)
        organizations <- map["results"];
    }
}
