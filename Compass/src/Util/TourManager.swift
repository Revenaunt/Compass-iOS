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
        return 0;
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
    
    
    /*------------------------------*
     * ON BOARDING CATEGORY MARKERS *
     *------------------------------*/
    
    private static let onBoardingCategoryMarkerKeys = ["ob_category_general", "ob_category_skip"];
    enum OnBoardingCategoryMarker: Int{
        case General = 0
        case Skip = 1
        case None
    }
    
    static func getOnBoardingCategoryMarkerCount() -> Int{
        var count = 0;
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(onBoardingCategoryMarkerKeys[OnBoardingCategoryMarker.General.rawValue])){
            count += 1;
        }
        if (!defaults.boolForKey(onBoardingCategoryMarkerKeys[OnBoardingCategoryMarker.Skip.rawValue])){
            count += 1;
        }
        return 0;
    }
    
    static func getFirstUnseenOnBoardingCategoryMarker() -> OnBoardingCategoryMarker{
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(onBoardingCategoryMarkerKeys[OnBoardingCategoryMarker.General.rawValue])){
            return .General;
        }
        if (!defaults.boolForKey(onBoardingCategoryMarkerKeys[OnBoardingCategoryMarker.Skip.rawValue])){
            return .Skip;
        }
        return .None;
    }
    
    static func markFirstUnseenOnBoardingCategoryMarker(){
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(onBoardingCategoryMarkerKeys[OnBoardingCategoryMarker.General.rawValue])){
            defaults.setObject(true, forKey: onBoardingCategoryMarkerKeys[OnBoardingCategoryMarker.General.rawValue]);
        }
        else if (!defaults.boolForKey(onBoardingCategoryMarkerKeys[OnBoardingCategoryMarker.Skip.rawValue])){
            defaults.setObject(true, forKey: onBoardingCategoryMarkerKeys[OnBoardingCategoryMarker.Skip.rawValue]);
        }
    }
    
    
    /*------------------*
     * CATEGORY MARKERS *
     *------------------*/
    
    private static let categoryMarkerKeys = ["category_general"];
    enum CategoryMarker: Int{
        case General = 0
        case None
    }
    
    static func getCategoryMarkerCount() -> Int{
        var count = 0;
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(categoryMarkerKeys[CategoryMarker.General.rawValue])){
            count += 1;
        }
        return 0;
    }
    
    static func getFirstUnseenCategoryMarker() -> CategoryMarker{
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(categoryMarkerKeys[CategoryMarker.General.rawValue])){
            return .General;
        }
        return .None;
    }
    
    static func markFirstUnseenCategoryMarker(){
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(categoryMarkerKeys[CategoryMarker.General.rawValue])){
            defaults.setObject(true, forKey: categoryMarkerKeys[CategoryMarker.General.rawValue]);
        }
    }
    
    
    /*----------------------*
     * GOAL LIBRARY MARKERS *
     *----------------------*/
    
    private static let goalLibraryMarkerKeys = ["goal_library_general", "goal_library_added"];
    enum GoalLibraryMarker: Int{
        case General = 0
        case Added = 1
        case None
    }
    
    //This markers are delivered in two distinct stages, one by one
    static func getGoalLibraryMarkerCount(added: Bool) -> Int{
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(goalLibraryMarkerKeys[GoalLibraryMarker.General.rawValue])){
            return 0;
        }
        if (added && !defaults.boolForKey(goalLibraryMarkerKeys[GoalLibraryMarker.Added.rawValue])){
            return 0;
        }
        return 0;
    }
    
    static func getFirstUnseenGoalLibraryMarker() -> GoalLibraryMarker{
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(goalLibraryMarkerKeys[GoalLibraryMarker.General.rawValue])){
            return .General;
        }
        if (!defaults.boolForKey(goalLibraryMarkerKeys[GoalLibraryMarker.Added.rawValue])){
            return .Added;
        }
        return .None;
    }
    
    static func markFirstUnseenGoalLibraryMarker(){
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(goalLibraryMarkerKeys[GoalLibraryMarker.General.rawValue])){
            defaults.setObject(true, forKey: goalLibraryMarkerKeys[GoalLibraryMarker.General.rawValue]);
        }
        else if (!defaults.boolForKey(goalLibraryMarkerKeys[GoalLibraryMarker.Added.rawValue])){
            defaults.setObject(true, forKey: goalLibraryMarkerKeys[GoalLibraryMarker.Added.rawValue]);
        }
    }
    
    
    /*--------------*
     * GOAL MARKERS *
     *--------------*/
    
    private static let goalMarkerKeys = ["goal_add"];
    enum GoalMarker: Int{
        case Add = 0
        case None
    }
    
    static func getGoalMarkerCount() -> Int{
        var count = 0;
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(goalMarkerKeys[GoalMarker.Add.rawValue])){
            count += 1;
        }
        return 0;
    }
    
    static func getFirstUnseenGoalMarker() -> GoalMarker{
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(goalMarkerKeys[GoalMarker.Add.rawValue])){
            return .Add;
        }
        return .None;
    }
    
    static func markFirstUnseenGoalMarker(){
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(goalMarkerKeys[GoalMarker.Add.rawValue])){
            defaults.setObject(true, forKey: goalMarkerKeys[GoalMarker.Add.rawValue]);
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
        return 0;
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
    
    private static let actionMarkerKeys = ["action_got_it"];
    enum ActionMarker: Int{
        case GotIt = 0
        case None
    }
    
    static func getActionMarkerCount() -> Int{
        var count = 0;
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(actionMarkerKeys[ActionMarker.GotIt.rawValue])){
            count += 1;
        }
        return 0;
    }
    
    static func getFirstUnseenActionMarker() -> ActionMarker{
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(actionMarkerKeys[ActionMarker.GotIt.rawValue])){
            return .GotIt;
        }
        return .None;
    }
    
    static func markFirstUnseenActionMarker(){
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(actionMarkerKeys[ActionMarker.GotIt.rawValue])){
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
        
        defaults.setObject(false, forKey: onBoardingCategoryMarkerKeys[OnBoardingCategoryMarker.General.rawValue]);
        defaults.setObject(false, forKey: onBoardingCategoryMarkerKeys[OnBoardingCategoryMarker.Skip.rawValue]);
        
        defaults.setObject(false, forKey: categoryMarkerKeys[CategoryMarker.General.rawValue]);
        
        defaults.setObject(false, forKey: goalLibraryMarkerKeys[GoalLibraryMarker.General.rawValue]);
        defaults.setObject(false, forKey: goalLibraryMarkerKeys[GoalLibraryMarker.Added.rawValue]);
        
        defaults.setObject(false, forKey: goalMarkerKeys[GoalMarker.Add.rawValue]);
        
        defaults.setObject(false, forKey: feedMarkerKeys[FeedMarker.General.rawValue]);
        defaults.setObject(false, forKey: feedMarkerKeys[FeedMarker.UpNext.rawValue]);
        defaults.setObject(false, forKey: feedMarkerKeys[FeedMarker.Progress.rawValue]);
        defaults.setObject(false, forKey: feedMarkerKeys[FeedMarker.Add.rawValue]);
        
        defaults.setObject(false, forKey: actionMarkerKeys[ActionMarker.GotIt.rawValue]);
    }
}
