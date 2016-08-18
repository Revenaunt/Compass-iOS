//
//  FeedData.swift
//  Compass
//
//  Created by Ismael Alonso on 4/25/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


//No need to extend TDCBase
class FeedData: Mappable, CustomStringConvertible{
    private let LOAD_MORE_COUNT = 3;
    
    private var progress: Progress? = nil;
    private var streaks: [Streak]? = nil;
    private var upNextAction: UpcomingAction? = nil;
    private var upcomingActions: [UpcomingAction] = [UpcomingAction]();
    private var goals: [Goal] = [Goal]();
    private var nextGoalBatchUrl: String? = nil;
    
    
    init(){
        
    }
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map){
        progress <- map["progress"];
        streaks <- map["streaks"];
        upcomingActions <- map["upcoming"];
        var upcoming = [UpcomingAction]();
        for action in upcomingActions{
            if (action.isUserAction()){
                upcoming.append(action);
            }
        }
        upcomingActions = upcoming;
        
        if (upcomingActions.count > 0){
            upNextAction = upcomingActions.removeAtIndex(0) as UpcomingAction;
        }
    }
    
    func getProgress() -> Progress?{
        return progress;
    }
    
    func getUpNextAction() -> UpcomingAction?{
        return upNextAction;
    }
    
    func getStreaks() -> [Streak]?{
        return streaks;
    }
    
    func getUpcoming() -> [UpcomingAction]{
        return upcomingActions;
    }
    
    func getUpcoming(size: Int) -> [UpcomingAction]{
        var size = size;
        if (size > upcomingActions.count){
            size = upcomingActions.count;
        }
        else if (size < 0){
            size = 0;
        }
        var list = [UpcomingAction]();
        var i = 0;
        while (i < size){
            list.append(upcomingActions[i]);
            i += 1;
        }
        return list;
    }
    
    func getGoals() -> [Goal]{
        return goals;
    }
    
    func addGoals(goals: [Goal], nextGoalBatchUrl: String?){
        self.goals.appendContentsOf(goals);
        self.nextGoalBatchUrl = nextGoalBatchUrl;
    }
    
    func didIt(index: Int){
        if (index == -1){
            if (upcomingActions.count == 0){
                upNextAction = nil;
            }
            else{
                upNextAction = upcomingActions.removeAtIndex(0) as UpcomingAction;
            }
        }
        else{
            upcomingActions.removeAtIndex(index);
        }
        streaks![streaks!.count-1].count += 1;
    }
    
    func removeGoal(goal: Goal){
        let index = goals.indexOf{
            $0 == goal;
        };
        if (index != nil){
            goals.removeAtIndex(index!);
        }
    }
    
    func getNextGoalBatchUrl() -> String?{
        return nextGoalBatchUrl;
    }
    
    func canLoadMoreActions(displayedUpcoming: Int) -> Bool{
        return displayedUpcoming < upcomingActions.count;
    }
    
    func loadModeUpcoming(displayedUpcoming: Int) -> [UpcomingAction]{
        var batch = [UpcomingAction]();
        while (batch.count < LOAD_MORE_COUNT && canLoadMoreActions(displayedUpcoming + batch.count)){
            batch.append(upcomingActions[displayedUpcoming+batch.count]);
        }
        return batch;
    }
    
    func canLoadMoreGoals() -> Bool{
        return nextGoalBatchUrl != nil;
    }
    
    var description: String{
        return "Feed Data: \(upNextAction != nil ? "has" : "doesn't have") up next, \(upcomingActions.count) actions, \(goals.count) goals";
    }
    
    
    class Progress: Mappable{
        private var totalActions: Int = 0;
        private var completedActions: Int = 0;
        private var progressPercentage: Int = 0;
        
        
        required init?(_ map: Map){
            
        }
        
        internal func mapping(map: Map){
            totalActions <- map["total"];
            completedActions <- map["completed"];
            progressPercentage <- map["progress"];
        }
        
        func complete(){
            completedActions += 1;
            progressPercentage = completedActions * 100 / totalActions;
        }
        
        func remove(){
            totalActions -= 1;
            progressPercentage = completedActions * 100 / totalActions;
        }
        
        func getTotalActions() -> Int{
            return totalActions;
        }
        
        func getCompletedActions() -> Int{
            return completedActions;
        }
        
        func getProgressPercentage() -> Int{
            return progressPercentage;
        }
        
        func getProgressFraction() -> String{
            return "\(completedActions)/\(totalActions)";
        }
    }
    
    
    class Streak: Mappable{
        private var count: Int = 0;
        private var day: String = "";
        
        
        required init?(_ map: Map){
            
        }
        
        internal func mapping(map: Map){
            count <- map["count"];
            day <- map["day"];
        }
        
        func getCount() -> Int{
            return count;
        }
        
        func getDay() -> String{
            return day[0];
        }
    }
}
