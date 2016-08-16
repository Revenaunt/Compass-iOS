//
//  FeedTyper.swift
//  Compass
//
//  Created by Ismael Alonso on 4/26/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//


class FeedTypes{
    private static var feedData: FeedData = FeedData();
    private static var updatingGoals: Bool = false;
    
    
    static func setDataSource(feedData: FeedData){
        self.feedData = feedData;
    }
    
    static func hasUpNextAction() -> Bool{
        return feedData.getUpNextAction() != nil;
    }
    
    static func getUpNextSectionPosition() -> Int{
        return 0;
    }
    
    static func isUpNextSection(section: Int) -> Bool{
        return getUpNextSectionPosition() == section;
    }
    
    static func getStreaksSectionPosition() -> Int{
        return getUpNextSectionPosition() + 1;
    }
    
    static func isStreaksSection(section: Int) -> Bool{
        return getStreaksSectionPosition() == section;
    }
    
    static func hasUpcoming() -> Bool{
        return feedData.getUpcoming().count != 0;
    }
    
    static func getUpcomingSectionPosition() -> Int{
        return getStreaksSectionPosition() + 1;
    }
    
    static func isUpcomingSection(section: Int) -> Bool{
        return getUpcomingSectionPosition() == section;
    }
    
    static func hasGoals() -> Bool{
        return feedData.getGoals().count != 0;
    }
    
    static func getGoalsSectionPosition() -> Int{
        return getUpcomingSectionPosition() + 1;
    }
    
    static func isGoalsSectionPosition(section: Int) -> Bool{
        return getGoalsSectionPosition() == section;
    }
    
    static func getSectionCount() -> Int{
        return getGoalsSectionPosition() + 1;
    }
    
    static func getSectionItemCount(section: Int) -> Int{
        switch (section){
            case getUpNextSectionPosition():
                return 1;
            
            case getStreaksSectionPosition():
                return 1;
            
            case getUpcomingSectionPosition():
                return SharedData.feedData.getUpcoming().count;
            
            case getGoalsSectionPosition():
                if (SharedData.feedData.canLoadMoreGoals()){
                    return SharedData.feedData.getGoals().count+1;
                }
                return SharedData.feedData.getGoals().count;
            
            default:
                return 0;
        }
    }
    
    static func getSectionHeaderTitle(section: Int) -> String{
        switch (section){
            case getUpNextSectionPosition():
                return "Up next";
            
            case getStreaksSectionPosition():
                return "Weekly progress";
            
            case getUpcomingSectionPosition():
                return hasUpcoming() ? "Upcoming" : "";
            
            case getGoalsSectionPosition():
                return (hasGoals() || updatingGoals) ? "Your goals" : "";
            
            default:
                return "";
        }
    }
    
    static func setUpdatingGoals(updating: Bool){
        updatingGoals = updating;
    }
}
