//
//  ActionContent.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class ActionContent: TDCContent{
    private var sequenceOrder: Int = -1
    private var moreInfo: String = ""
    private var externalResource: String = ""
    private var externalResourceName: String = ""
    
    required init?(_ map: Map){
        super.init(map)
    }
    
    override func mapping(map: Map){
        super.mapping(map)
        
        sequenceOrder <- map["sequence_order"]
        moreInfo <- map["more_info"]
        externalResource <- map["external_resource"]
        externalResourceName <- map["external_resource_name"]
    }
    
    func getMoreInfo() -> String{
        return moreInfo
    }
}


class ActionContentList: ListResult{
    private(set) internal var results: [ActionContent]!
    
    
    override func mapping(map: Map){
        super.mapping(map)
        results <- map["results"]
    }
}
