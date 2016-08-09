//
//  TDCBase.swift
//  Compass
//
//  Created by Ismael Alonso on 4/19/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class TDCBase: Mappable, Equatable{
    private var id: Int = -1;
    
    
    init(id: Int){
        self.id = id;
    }
    
    func getId() -> Int{
        return id;
    }
    
    func getType() -> String{
        return "";
    }
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map){
        id <- map["id"];
    }
}

//For equatable, checks types and ids for equality
func ==(lhs: TDCBase, rhs: TDCBase) -> Bool{
    return lhs.getType() == rhs.getType() && lhs.getId() == rhs.getId();
}
