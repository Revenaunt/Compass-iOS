//
//  APNsMessage.swift
//  Compass
//
//  Created by Ismael Alonso on 6/1/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class APNsMessage: Mappable{
    //Notification message types
    private let TYPE_USER_ACTION = "action"
    private let TYPE_CUSTOM_ACTION = "customaction"
    private let TYPE_BADGE = "award"
    
    //Common fields
    private var notificationId: Int = -1;
    private var objectType: String = "";
    
    private var badge: Badge? = nil;
    
    private var objectId: Int = -1;
    private var mappingId: Int = -1;
    
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map){
        notificationId <- map["id"]
        objectType <- map["object_type"]
        badge <- map["badge"]
        objectId <- map["object_id"]
        mappingId <- map["user_mapping_id"]
    }
    
    func isUserActionMessage() -> Bool{
        return objectType == TYPE_USER_ACTION
    }
    
    func isCustomActionMessage() -> Bool{
        return objectType == TYPE_CUSTOM_ACTION
    }
    
    func isActionMessage() -> Bool{
        return isUserActionMessage() || isCustomActionMessage()
    }
    
    func isBadgeMessage() -> Bool{
        return objectType == TYPE_BADGE
    }
    
    func getBadge() -> Badge{
        return badge!
    }
    
    func getNotificationId() -> Int{
        return notificationId
    }
    
    func getObjectId() -> Int{
        return objectId
    }
    
    func getMappingId() -> Int{
        return mappingId
    }
}
