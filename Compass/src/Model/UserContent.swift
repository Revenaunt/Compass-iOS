//
//  UserContent.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class UserContent: TDCBase{
    private var editable: Bool = false;
    
    
    required init?(_ map: Map){
        super.init(map);
    }
    
    override func mapping(map: Map){
        super.mapping(map);
        
        editable <- map["editable"];
    }
    
    func setEditable(editable: Bool){
        self.editable = editable;
    }
    
    func isEditable() -> Bool{
        return editable;
    }
    
    func getContentId() -> Int{
        return -1
    }
}
