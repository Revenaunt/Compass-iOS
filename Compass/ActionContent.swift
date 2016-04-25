//
//  ActionContent.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class ActionContent: TDCContent{
    var sequenceOrder: Int = -1;
    var moreInfo: String = "";
    var htmlMoreInfo: String = "";
    var externalResource: String = "";
    var externalResourceName: String = "";
    var trigger: Trigger? = nil;
    var behaviorId: Int = -1;
    
    
    required init?(_ map: Map){
        super.init(map)
    }
    
    override func mapping(map: Map){
        super.mapping(map);
        
        sequenceOrder <- map["sequence_order"];
        moreInfo <- map["more_info"];
        htmlMoreInfo <- map["html_more_info"];
        externalResource <- map["external_resource"];
        externalResourceName <- map["external_resource_name"];
        trigger <- map["default_trigger"];
        behaviorId <- map["behavior"];
    }
}
