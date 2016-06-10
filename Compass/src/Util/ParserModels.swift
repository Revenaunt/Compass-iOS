//
//  ParserModels.swift
//  Compass
//
//  Created by Ismael Alonso on 4/19/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper;


class ParserModels{
    class CategoryContentArray: Mappable{
        var categories: [CategoryContent]? = nil;
        
        
        required init?(_ map: Map){
            
        }
        
        func mapping(map: Map){
            categories <- map["results"];
        }
    }
    
    class UserCategoryArray: Mappable{
        var categories: [UserCategory]? = nil;
        
        
        required init?(_ map: Map){
            
        }
        
        func mapping(map: Map){
            categories <- map["results"];
        }
    }
    
    class GoalContentArray: Mappable{
        var goals: [GoalContent]? = nil;
        var next: String? = nil;
        
        
        required init?(_ map: Map){
            
        }
        
        func mapping(map: Map){
            goals <- map["results"];
            next <- map["next"];
        }
    }
    
    class CustomGoalArray: Mappable{
        var goals: [CustomGoal]? = nil;
        var next: String? = nil;
        
        
        required init?(_ map: Map){
            
        }
        
        func mapping(map: Map){
            goals <- map["results"];
            next <- map["next"];
        }
    }
    
    class UserGoalArray: Mappable{
        var goals: [UserGoal]? = nil;
        var next: String? = nil;
        
        
        required init?(_ map: Map){
            
        }
        
        func mapping(map: Map){
            goals <- map["results"];
            next <- map["next"];
        }
    }
    
    class FeedDataArray: Mappable{
        var feedData: [FeedData]? = nil;
        
        
        required init?(_ map: Map){
            
        }
        
        func mapping(map: Map){
            feedData <- map["results"];
        }
    }
    
    class RewardArray: Mappable{
        var rewards: [Reward]? = nil;
        
        
        required init?(_ map: Map){
            
        }
        
        func mapping(map: Map){
            rewards <- map["results"];
        }
    }
}
