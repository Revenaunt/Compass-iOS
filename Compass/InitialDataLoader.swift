//
//  InitialDataLoader.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Just
import ObjectMapper



class InitialDataLoader{
    private static var user: User? = nil;
    private static var callback: ((Bool)) -> Void = { success in };
    
    static func load(user: User, callback: ((Bool)) -> Void){
        self.user = user;
        self.callback = callback;
        fetchCategories();
    }
    
    private static func fetchCategories(){
        Just.get(API.getCategoriesUrl()){ (response) in
            if (response.ok && CompassUtil.isSuccessStatusCode(response.statusCode!)){
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding);
                Data.publicCategories = (Mapper<ParserModels.CategoryContentArray>().map(result)?.categories)!;
                for category in Data.publicCategories{
                    print(category.toString());
                }
                fetchFeedData();
            }
            else{
                failure();
            }
        }
    }
    
    private static func fetchFeedData(){
        Just.get(API.getFeedDataUrl(), headers: CompassUtil.getHeaderMap(user!)){ (response) in
            if (response.ok){
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding);
                Data.feedData = (Mapper<ParserModels.FeedDataArray>().map(result)?.feedData![0])!;
                fetchCustomGoals();
            }
            else{
                failure();
            }
        }
    }
    
    private static func fetchCustomGoals(){
        Just.get(API.getCustomGoalsUrl(), headers: CompassUtil.getHeaderMap(user!)){ response in
            if (response.ok){
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding);
                let goals = (Mapper<ParserModels.CustomGoalArray>().map(result)?.goals)!
                if (goals.count > 0){
                    Data.feedData.addGoals(goals);
                    success();
                }
                else{
                    fetchUserGoals();
                }
            }
            else{
                failure();
            }
        }
    }
    
    private static func fetchUserGoals(){
        Just.get(API.getUserGoalsUrl(), headers: CompassUtil.getHeaderMap(user!)){ response in
            if (response.ok){
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding);
                let goals = (Mapper<ParserModels.UserGoalArray>().map(result)?.goals)!
                if (goals.count > 0){
                    Data.feedData.addGoals(goals);
                    success();
                }
                else{
                    fetchUserGoals();
                }
            }
            else{
                failure();
            }
        }
    }
    
    private static func success(){
        dispatch_async(dispatch_get_main_queue(), {
            callback(true);
        });
    }
    
    private static func failure(){
        dispatch_async(dispatch_get_main_queue(), {
            callback(false);
        });
    }
}


