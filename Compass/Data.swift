//
//  Data.swift
//  Compass
//
//  Created by Ismael Alonso on 4/18/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Foundation


class Data{
    private static var user: User? = nil;
    private static var publicCategories: [CategoryContent]? = nil;
    
    
    class func setUser(user: User?){
        self.user = user;
    }
    
    class func getUser() -> User?{
        return user;
    }
    
    class func setPublicCategories(publicCategories: [CategoryContent]?){
        self.publicCategories = publicCategories;
    }
    
    class func getPublicCategories() -> [CategoryContent]?{
        return publicCategories;
    }
}