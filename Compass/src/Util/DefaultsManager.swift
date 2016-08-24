//
//  DefaultsManager.swift
//  Compass
//
//  Created by Ismael Alonso on 7/15/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Foundation


class DefaultsManager{
    
    
    /*------------------------*
     * AWARD RELATED DEFAULTS *
     *------------------------*/
    
    private static let newBadgeIdArrayKey = "new_badges";
    
    
    static func addNewAward(badge: Badge){
        let defaults = NSUserDefaults.standardUserDefaults();
        var badgeIds = [Int]();
        if let storedArray = defaults.arrayForKey(newBadgeIdArrayKey) as? [Int]{
            badgeIds = storedArray;
        }
        
        badgeIds.append(badge.getId());
        defaults.setObject(badgeIds, forKey: newBadgeIdArrayKey);
    }
    
    static func removeNewAward(badge: Badge){
        let defaults = NSUserDefaults.standardUserDefaults();
        if let storedArray = defaults.arrayForKey(newBadgeIdArrayKey) as? [Int]{
            let newArray = storedArray.filter{ $0 != badge.getId() };
            defaults.setObject(newArray, forKey: newBadgeIdArrayKey);
        }
    }
    
    static func emptyNewAwardsRecords(){
        NSUserDefaults.standardUserDefaults().setObject([Int](), forKey: newBadgeIdArrayKey);
    }
    
    static func getNewAwardCount() -> Int{
        let defaults = NSUserDefaults.standardUserDefaults();
        if let badgeIds = defaults.arrayForKey(newBadgeIdArrayKey){
            return badgeIds.count;
        }
        return 0;
    }
    
    static func getNewAwardArray() -> [Int]{
        let defaults = NSUserDefaults.standardUserDefaults();
        if let storedArray = defaults.arrayForKey(newBadgeIdArrayKey) as? [Int]{
            return storedArray;
        }
        return [Int]();
    }
    
    
    /*-----------------------*
     * TOUR RELATED DEFAULTS *
     *-----------------------*/
    
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
        if (defaults.boolForKey(feedMarkerKeys[FeedMarker.General.rawValue])){
            count += 1;
        }
        if (defaults.boolForKey(feedMarkerKeys[FeedMarker.UpNext.rawValue])){
            count += 1;
        }
        if (defaults.boolForKey(feedMarkerKeys[FeedMarker.Progress.rawValue])){
            count += 1;
        }
        if (defaults.boolForKey(feedMarkerKeys[FeedMarker.Add.rawValue])){
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
    
    private static let actionMarkerKeys = ["action_general", "action_got_it"];
    enum ActionMarker: Int{
        case General = 0
        case GotIt = 1
        case None
    }
    
    static func getActionMarkerCount() -> Int{
        var count = 0;
        let defaults = NSUserDefaults.standardUserDefaults();
        if (defaults.boolForKey(feedMarkerKeys[ActionMarker.General.rawValue])){
            count += 1;
        }
        if (defaults.boolForKey(feedMarkerKeys[ActionMarker.GotIt.rawValue])){
            count += 1;
        }
        return count;
    }
    
    static func getFirstUnseenActionMarker() -> ActionMarker{
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(feedMarkerKeys[ActionMarker.General.rawValue])){
            return .General;
        }
        if (!defaults.boolForKey(feedMarkerKeys[ActionMarker.GotIt.rawValue])){
            return .GotIt;
        }
        return .None;
    }
    
    static func markFirstUnseenActionMarker(){
        let defaults = NSUserDefaults.standardUserDefaults();
        if (!defaults.boolForKey(feedMarkerKeys[ActionMarker.General.rawValue])){
            defaults.setObject(true, forKey: feedMarkerKeys[ActionMarker.General.rawValue]);
        }
        else if (!defaults.boolForKey(feedMarkerKeys[ActionMarker.GotIt.rawValue])){
            defaults.setObject(true, forKey: feedMarkerKeys[ActionMarker.GotIt.rawValue]);
        }
    }
}
