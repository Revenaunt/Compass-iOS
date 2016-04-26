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
    private static var feedData: FeedData?{
        get{
            return self.feedData;
        }
        set{
            self.feedData = newValue;
            FeedTypes.setDataSource(newValue ?? FeedData());
        }
    };
    
    
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
    
    class func setFeedData(feedData: FeedData){
        self.feedData = feedData;
    }
    
    class func getFeedData() -> FeedData?{
        return feedData;
    }
}