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
    
    static func getHeaderSectionPosition() -> Int{
        return 0;
    }
    
    static func isHeaderSection(section: Int) -> Bool{
        return section == getHeaderSectionPosition();
    }
    
    static func hasUpNextAction() -> Bool{
        return feedData.getUpNext() != nil;
    }
    
    static func getUpNextSectionPosition() -> Int{
        return getHeaderSectionPosition() + 1;
    }
    
    static func isUpNextSection(section: Int) -> Bool{
        return getUpNextSectionPosition() == section;
    }
    
    static func hasStreaks() -> Bool{
        return feedData.getStreaks() != nil && feedData.getStreaks()!.count != 0;
    }
    
    static func getStreaksSectionPosition() -> Int{
        return getUpNextSectionPosition() + 1;
    }
    
    static func isStreaksSection(section: Int) -> Bool{
        return getStreaksSectionPosition() == section;
    }
    
    static func getRewardSectionPosition() -> Int{
        return getStreaksSectionPosition() + 1
    }
    
    static func isRewardSection(section: Int) -> Bool{
        return getRewardSectionPosition() == section
    }
    
    static func hasGoals() -> Bool{
        return feedData.getGoals().count != 0;
    }
    
    static func getGoalsSectionPosition() -> Int{
        return getRewardSectionPosition() + 1;
    }
    
    static func isGoalsSection(section: Int) -> Bool{
        return getGoalsSectionPosition() == section;
    }
    
    static func getSectionCount() -> Int{
        return getGoalsSectionPosition() + 1;
    }
    
    static func getSectionItemCount(section: Int) -> Int{
        switch (section){
            case getHeaderSectionPosition():
                return 1;
            
            case getUpNextSectionPosition():
                return 1;
            
            case getStreaksSectionPosition():
                return hasStreaks() ? 1 : 0;
            
            case getRewardSectionPosition():
                return 1
            
            case getGoalsSectionPosition():
                if (FeedDataLoader.getInstance().canLoadMoreGoals()){
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
                return "";
            
            case getStreaksSectionPosition():
                return hasStreaks() ? "Weekly progress" : "";
            
            case getRewardSectionPosition():
                return " "
            
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
