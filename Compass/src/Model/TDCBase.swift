//
//  TDCBase.swift
//  Compass
//
//  Created by Ismael Alonso on 4/19/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class TDCBase: Mappable{
    private var id: Int = -1;
    
    
    init(id: Int){
        self.id = id;
    }
    
    func getId() -> Int{
        return id;
    }
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map){
        id <- map["id"];
    }
}