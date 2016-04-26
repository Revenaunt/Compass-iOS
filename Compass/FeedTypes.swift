//
//  FeedTyper.swift
//  Compass
//
//  Created by Ismael Alonso on 4/26/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//


class FeedTypes{
    private static var feedData: FeedData = FeedData();
    
    
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
    
    static func hasFeedback() -> Bool{
        return hasUpNextAction() && Data.getFeedData()?.getFeedback() != nil;
    }
    
    static func getFeedbackSectionPosition() -> Int{
        return getUpNextSectionPosition() + 1;
    }
    
    static func isFeedbackSection(section: Int) -> Bool{
        return hasFeedback() && getFeedbackSectionPosition() == section;
    }
    
    static func hasUpcoming() -> Bool{
        return feedData.getUpcoming().count != 0;
    }
    
    static func getUpcomingSectionPosition() -> Int{
        if (hasFeedback()){
            return getFeedbackSectionPosition() + 1;
        }
        return getUpNextSectionPosition() + 1;
    }
    
    static func isUpcomingSection(section: Int) -> Bool{
        return getUpcomingSectionPosition() == section;
    }
    
    static func hasGoals() -> Bool{
        return feedData.getGoals().count != 0;
    }
    
    static func getGoalsSectionPosition() -> Int{
        return getUpcomingSectionPosition() + (hasUpcoming() ? 1 : 0);
    }
    
    static func isGoalsSectionPosition(section: Int) -> Bool{
        return getGoalsSectionPosition() == section;
    }
}
