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
            
            //Sort them by group and title.
            /*featured.sortInPlace({
                if ($0.getGroup() < $1.getGroup()){
                    if ($0.getGroup() == -1){
                        return false;
                    }
                    return true;
                }
                if ($0.getGroup() > $1.getGroup()){
                    if ($1.getGroup() == -1){
                        return true;
                    }
                    return false;
                }
                return $0.getTitle() < $1.getTitle();
            });*/
            
            //Featured go first
            featured.appendContentsOf(regular);
            return featured;
        }
    }
    
    static var filteredCategoryLists: [[CategoryContent]]{
        get{
            //Stick all the featured categories not selected by default in an array.
            var featured = [CategoryContent]();
            for (_, category) in internalCategoryMap{
                if (category.isFeatured() && !category.isSelectedByDefault()){
                    featured.append(category);
                }
            }
            
            //Sort them by group and title.
            featured.sortInPlace({
                if ($0.getGroup() < $1.getGroup()){
                    return true;
                }
                if ($0.getGroup() > $1.getGroup()){
                    return false;
                }
                return $0.getTitle() < $1.getTitle();
            });
            
            print("Featured: \(featured.count)");
            
            //Stick the categories into individual lists grouped by group.
            var categoryLists = [[CategoryContent]]();
            var categoryList = [CategoryContent]();
            //Set the current group as the first one, we don't want to be appending first
            //  thing because arrays are value types, not reference types.
            var currentGroup = featured[0].getGroup();
            for category in featured{
                if (currentGroup != category.getGroup()){
                    categoryLists.append(categoryList);
                    categoryList = [CategoryContent]();
                    currentGroup = category.getGroup();
                }
                categoryList.append(category);
            }
            categoryLists.append(categoryList);
 
            return categoryLists;
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
