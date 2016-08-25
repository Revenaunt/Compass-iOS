//
//  TourManager.swift
//  Compass
//
//  Created by Ismael Alonso on 8/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Foundation


class TourManager{
    
    
    /*----------------------*
     * ORGANIZATION MARKERS *
     *----------------------*/
    
    private static let organizationMarkerKeys = ["organization_general", "organization_skip"];
    enum OrganizationMarker: Int{
        case General = 0
        case Skip = 1
        case None
    }
    
    static func getOrganizationMarkerCount() -> Int{
        var count = 0;
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(organizationMarkerKeys[OrganizationMarker.General.rawValue])){
            count += 1;
        }
        if (!defaults.boolForKey(organizationMarkerKeys[OrganizationMarker.Skip.rawValue])){
            count += 1;
        }
        return count;
    }
    
    static func getFirstUnseenOrganizationMarker() -> OrganizationMarker{
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(organizationMarkerKeys[OrganizationMarker.General.rawValue])){
            return .General;
        }
        if (!defaults.boolForKey(organizationMarkerKeys[OrganizationMarker.Skip.rawValue])){
            return .Skip;
        }
        return .None;
    }
    
    static func markFirstUnseenOrganizationMarker(){
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(organizationMarkerKeys[OrganizationMarker.General.rawValue])){
            defaults.setObject(true, forKey: organizationMarkerKeys[OrganizationMarker.General.rawValue]);
        }
        else if (!defaults.boolForKey(organizationMarkerKeys[OrganizationMarker.Skip.rawValue])){
            defaults.setObject(true, forKey: organizationMarkerKeys[OrganizationMarker.Skip.rawValue]);
        }
    }
    
    
    /*------------------*
     * CATEGORY MARKERS *
     *------------------*/
    
    private static let categoryMarkerKeys = ["category_general", "category_skip"];
    enum CategoryMarker: Int{
        case General = 0
        case Skip = 1
        case None
    }
    
    static func getCategoryMarkerCount() -> Int{
        var count = 0;
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(categoryMarkerKeys[CategoryMarker.General.rawValue])){
            count += 1;
        }
        if (!defaults.boolForKey(categoryMarkerKeys[CategoryMarker.Skip.rawValue])){
            count += 1;
        }
        return count;
    }
    
    static func getFirstUnseenCategoryMarker() -> CategoryMarker{
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(categoryMarkerKeys[CategoryMarker.General.rawValue])){
            return .General;
        }
        if (!defaults.boolForKey(categoryMarkerKeys[CategoryMarker.Skip.rawValue])){
            return .Skip;
        }
        return .None;
    }
    
    static func markFirstUnseenCategoryMarker(){
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(categoryMarkerKeys[CategoryMarker.General.rawValue])){
            defaults.setObject(true, forKey: categoryMarkerKeys[CategoryMarker.General.rawValue]);
        }
        else if (!defaults.boolForKey(categoryMarkerKeys[CategoryMarker.Skip.rawValue])){
            defaults.setObject(true, forKey: categoryMarkerKeys[CategoryMarker.Skip.rawValue]);
        }
    }
    
    
    /*----------------------*
     * GOAL LIBRARY MARKERS *
     *----------------------*/
    
    private static let goalLibraryMarkerKeys = ["goal_library_general"];
    enum GoalLibraryMarker: Int{
        case General = 0
        case None
    }
    
    static func getGoalLibraryMarkerCount() -> Int{
        var count = 0;
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(goalLibraryMarkerKeys[GoalLibraryMarker.General.rawValue])){
            count += 1;
        }
        return count;
    }
    
    static func getFirstUnseenGoalLibraryMarker() -> GoalLibraryMarker{
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(goalLibraryMarkerKeys[GoalLibraryMarker.General.rawValue])){
            return .General;
        }
        return .None;
    }
    
    static func markFirstUnseenGoalLibraryMarker(){
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(goalLibraryMarkerKeys[GoalLibraryMarker.General.rawValue])){
            defaults.setObject(true, forKey: goalLibraryMarkerKeys[GoalLibraryMarker.General.rawValue]);
        }
    }
    
    
    /*--------------*
     * FEED MARKERS *
     *--------------*/
    
    private static let feedMarkerKeys = ["feed_general", "feed_up_next", "feed_progress", "feed_add"];
    enum FeedMarker: Int{
        case General = 0
        case UpNext = 1
        case Progress = 2
        case Add = 3
        case None
    }
    
    static func getFeedMarkerCount() -> Int{
        var count = 0;
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(feedMarkerKeys[FeedMarker.General.rawValue])){
            count += 1;
        }
        if (!defaults.boolForKey(feedMarkerKeys[FeedMarker.UpNext.rawValue])){
            count += 1;
        }
        if (!defaults.boolForKey(feedMarkerKeys[FeedMarker.Progress.rawValue])){
            count += 1;
        }
        if (!defaults.boolForKey(feedMarkerKeys[FeedMarker.Add.rawValue])){
            count += 1;
        }
        return count;
    }
    
    static func getFirstUnseenFeedMarker() -> FeedMarker{
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(feedMarkerKeys[FeedMarker.General.rawValue])){
            return .General;
        }
        if (!defaults.boolForKey(feedMarkerKeys[FeedMarker.UpNext.rawValue])){
            return .UpNext;
        }
        if (!defaults.boolForKey(feedMarkerKeys[FeedMarker.Progress.rawValue])){
            return .Progress;
        }
        if (!defaults.boolForKey(feedMarkerKeys[FeedMarker.Add.rawValue])){
            return .Add;
        }
        return .None;
    }
    
    static func markFirstUnseenFeedMarker(){
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(feedMarkerKeys[FeedMarker.General.rawValue])){
            defaults.setObject(true, forKey: feedMarkerKeys[FeedMarker.General.rawValue]);
        }
        else if (!defaults.boolForKey(feedMarkerKeys[FeedMarker.UpNext.rawValue])){
            defaults.setObject(true, forKey: feedMarkerKeys[FeedMarker.UpNext.rawValue]);
        }
        else if (!defaults.boolForKey(feedMarkerKeys[FeedMarker.Progress.rawValue])){
            defaults.setObject(true, forKey: feedMarkerKeys[FeedMarker.Progress.rawValue]);
        }
        else if (!defaults.boolForKey(feedMarkerKeys[FeedMarker.Add.rawValue])){
            defaults.setObject(true, forKey: feedMarkerKeys[FeedMarker.Add.rawValue]);
        }
    }
    
    
    /*----------------*
     * ACTION MARKERS *
     *----------------*/
    
    private static let actionMarkerKeys = ["action_general", "action_got_it"];
    enum ActionMarker: Int{
        case General = 0
        case GotIt = 1
        case None
    }
    
    static func getActionMarkerCount() -> Int{
        var count = 0;
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(actionMarkerKeys[ActionMarker.General.rawValue])){
            count += 1;
        }
        if (!defaults.boolForKey(actionMarkerKeys[ActionMarker.GotIt.rawValue])){
            count += 1;
        }
        return count;
    }
    
    static func getFirstUnseenActionMarker() -> ActionMarker{
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(actionMarkerKeys[ActionMarker.General.rawValue])){
            return .General;
        }
        if (!defaults.boolForKey(actionMarkerKeys[ActionMarker.GotIt.rawValue])){
            return .GotIt;
        }
        return .None;
    }
    
    static func markFirstUnseenActionMarker(){
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(actionMarkerKeys[ActionMarker.General.rawValue])){
            defaults.setObject(true, forKey: actionMarkerKeys[ActionMarker.General.rawValue]);
        }
        else if (!defaults.boolForKey(actionMarkerKeys[ActionMarker.GotIt.rawValue])){
            defaults.setObject(true, forKey: actionMarkerKeys[ActionMarker.GotIt.rawValue]);
        }
    }
    
    
    /*----------------*
     * RESET FUNCTION *
     *----------------*/
    
    static func reset(){
        let defaults = NSUserDefaults.standardUserDefaults();
        defaults.setObject(false, forKey: organizationMarkerKeys[OrganizationMarker.General.rawValue]);
        defaults.setObject(false, forKey: organizationMarkerKeys[OrganizationMarker.Skip.rawValue]);
        
        defaults.setObject(false, forKey: categoryMarkerKeys[CategoryMarker.General.rawValue]);
        defaults.setObject(false, forKey: categoryMarkerKeys[CategoryMarker.Skip.rawValue]);
        
        defaults.setObject(false, forKey: goalLibraryMarkerKeys[GoalLibraryMarker.General.rawValue]);
        
        defaults.setObject(false, forKey: feedMarkerKeys[FeedMarker.General.rawValue]);
        defaults.setObject(false, forKey: feedMarkerKeys[FeedMarker.UpNext.rawValue]);
        defaults.setObject(false, forKey: feedMarkerKeys[FeedMarker.Progress.rawValue]);
        defaults.setObject(false, forKey: feedMarkerKeys[FeedMarker.Add.rawValue]);
        
        defaults.setObject(false, forKey: actionMarkerKeys[ActionMarker.General.rawValue]);
        defaults.setObject(false, forKey: actionMarkerKeys[ActionMarker.GotIt.rawValue]);
    }
}
