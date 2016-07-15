//
//  DefaultsManager.swift
//  Compass
//
//  Created by Ismael Alonso on 7/15/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Foundation


class DefaultsManager{
    private let newBadgeIdArrayKey = "new_badges";
    
    
    func addNewAward(badge: Badge){
        let defaults = NSUserDefaults.standardUserDefaults();
        var badgeIds = [Int]();
        if let storedArray = defaults.arrayForKey(newBadgeIdArrayKey) as? [Int]{
            badgeIds = storedArray;
        }
        
        badgeIds.append(badge.getId());
        defaults.setObject(badgeIds, forKey: newBadgeIdArrayKey);
    }
    
    func getNewAwardCount() -> Int{
        let defaults = NSUserDefaults.standardUserDefaults();
        if let badgeIds = defaults.arrayForKey(newBadgeIdArrayKey){
            return badgeIds.count;
        }
        return 0;
    }
    
    func getNewAwardArray() -> [Int]{
        let defaults = NSUserDefaults.standardUserDefaults();
        if let storedArray = defaults.arrayForKey(newBadgeIdArrayKey) as? [Int]{
            return storedArray;
        }
        return [Int]();
    }
}