//
//  ActionContent.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class ActionContent: TDCContent{
    private var sequenceOrder: Int = -1;
    private var moreInfo: String = "";
    private var htmlMoreInfo: String = "";
    private var externalResource: String = "";
    private var externalResourceName: String = "";
    private var trigger: Trigger? = nil;
    private var behaviorId: Int = -1;
    
    
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
