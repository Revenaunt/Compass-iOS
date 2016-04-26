//
//  Data.swift
//  Compass
//
//  Created by Ismael Alonso on 4/18/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Foundation


class Data{
    //Internal instances
    private static var internalFeedData:FeedData = FeedData();
    
    private static var user: User? = nil;
    private static var publicCategories: [CategoryContent]? = nil;
    
    //Stored pricedures, used to distribute the instances
    static var feedData: FeedData{
        get{
            return self.internalFeedData;
        }
        set (feedData){
            self.internalFeedData = feedData;
            FeedTypes.setDataSource(feedData ?? FeedData());
        }
    };
    
    
    //Deprecate these
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