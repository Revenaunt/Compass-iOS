//
//  APNsMessage.swift
//  Compass
//
//  Created by Ismael Alonso on 6/1/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class APNsMessage: Mappable{
    private let TYPE_ACTION = "action";
    
    private var objectType: String = "";
    private var objectId: Int = -1;
    private var mappingId: Int = -1;
    
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map){
        objectType <- map["object_type"];
        objectId <- map["object_id"];
        mappingId <- map["user_mapping_id"];
    }
    
    func isAction() -> Bool{
        return objectType == TYPE_ACTION;
    }
    
    func getMappingId() -> Int{
        return mappingId;
    }
}
