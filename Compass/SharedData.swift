//
//  Data.swift
//  Compass
//
//  Created by Ismael Alonso on 4/18/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Foundation


class SharedData{
    //Internal instances
    private static var internalFeedData: FeedData = FeedData();
    private static var internalCategoryMap: [Int: CategoryContent] = [Int: CategoryContent]();
    
    private static var user: User? = nil;
    
    static var publicCategories: [CategoryContent]{
        get{
            var categories = [CategoryContent]();
            for (_, category) in internalCategoryMap{
                categories.append(category);
            }
            return categories;
        }
        
        set (categories){
            for category in categories{
                internalCategoryMap[category.getId()] = category;
            }
        }
    };
    
    //Stored procedures, used to distribute the instances
    static var feedData: FeedData{
        get{
            return self.internalFeedData;
        }
        set (feedData){
            self.internalFeedData = feedData;
            FeedTypes.setDataSource(feedData ?? FeedData());
        }
    };
    
    
    class func hasUser() -> Bool{
        return user != nil;
    }
    
    
    //Deprecate these
    class func setUser(user: User?){
        self.user = user;
    }
    
    class func getUser() -> User?{
        return user;
    }
    
    class func getCategory(categoryId: Int) -> CategoryContent?{
        return internalCategoryMap[categoryId];
    }
}