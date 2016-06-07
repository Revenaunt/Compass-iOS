//
//  SharedData.swift
//  Compass
//
//  Created by Ismael Alonso on 4/18/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Locksmith


//Contains all the data that needs to be universally accessible or editable.
class SharedData{
    /*-----------------------------------*
     * Category attributes and functions *
     *-----------------------------------*/
    
    //Internal map, contains the map of categories indexed by ID.
    private static var internalCategoryMap: [Int: CategoryContent] = [Int: CategoryContent]();
    
    //List handler.
    static var publicCategories: [CategoryContent]{
        //Returns an unordered, unfiltered list of categories.
        get{
            var categories = [CategoryContent]();
            for (_, category) in internalCategoryMap{
                categories.append(category);
            }
            return categories;
        }
        
        //Generates the internal map from the list of categories this is set to.
        set (categories){
            internalCategoryMap.removeAll();
            for category in categories{
                internalCategoryMap[category.getId()] = category;
            }
        }
    };
    
    //Returns a list of non-default categories, starting with all the featured ones.
    static var filteredCategories: [CategoryContent]{
        get{
            var featured = [CategoryContent]();
            var regular = [CategoryContent]();
            //Classify featured and non-default others
            for (_, category) in internalCategoryMap{
                if (category.isFeatured()){
                    featured.append(category);
                }
                else if (!category.isSelectedByDefault()){
                    regular.append(category);
                }
            }
            //Featured go first
            featured.appendContentsOf(regular);
            return featured;
        }
    }
    
    //Gets a single category given its ID in O(1) or nil if the id isn't mapped
    static func getCategory(categoryId: Int) -> CategoryContent?{
        return internalCategoryMap[categoryId];
    }
    
    
    /*-------------------------------*
     * User attributes and functions *
     *-------------------------------*/
    
    //Internal instance of the user object.
    private static var internalUser: User?;
    
    //Creates a User instance containing a token.
    private static func readUserWithToken() -> User{
        return User(token: Locksmith.loadDataForUserAccount("CompassAccount")!["token"] as! String);
    }
    
    //Manages access to the User instance.
    static var user: User{
        //Returns the user instance if it exists, otherwise, it creates one with the token.
        get{
            return internalUser ?? readUserWithToken();
        }
        
        //Sets a user instance.
        set (user){
            internalUser = user;
        }
    }
    
    //Tells whether user data exists and, therefore, a user is logged in.
    static func isUserLoggedIn() -> Bool{
        return Locksmith.loadDataForUserAccount("CompassAccount") != nil;
    }
    
    
    /*------------------------------------*
     * Feed data attributes and functions *
     *------------------------------------*/
    
    //Internal instance for FeedData
    private static var internalFeedData: FeedData = FeedData();
    
    static var feedData: FeedData{
        get{
            return self.internalFeedData;
        }
        set (feedData){
            self.internalFeedData = feedData;
            FeedTypes.setDataSource(feedData ?? FeedData());
        }
    };
}
