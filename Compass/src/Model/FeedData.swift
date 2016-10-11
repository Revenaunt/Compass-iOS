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
    private let LOAD_MORE_COUNT = 3
    
    private var progress: Progress? = nil
    private var streaks: [Streak]? = nil
    private var reward: Reward!
    private var goals: [Goal] = [Goal]()
    
    
    //New stuff
    private var upNext: Action? = nil
    private var nextUserAction: UserAction? = nil
    private var nextCustomAction: CustomAction? = nil
    
    
    init(){
        
    }
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map){
        progress <- map["progress"]
        streaks <- map["streaks"]
        reward <- map["funcontent"]
    }
    
    
    //New stuff
    func setNextUserAction(action: UserAction?){
        nextUserAction = action
    }
    
    func setNextCustomAction(action: CustomAction?){
        nextCustomAction = action
    }
    
    func replaceUpNext(){
        let action = getNextAction()
        if action != nil{
            if action is UserAction{
                FeedDataLoader.getInstance().loadNextUserAction()
                nextUserAction = nil
            }
            else{
                FeedDataLoader.getInstance().loadNextCustomAction()
                nextCustomAction = nil
            }
        }
        upNext = action;
    }
    
    func getNextAction() -> Action?{
        if nextUserAction != nil && nextCustomAction == nil{
            return nextUserAction
        }
        else if nextUserAction == nil && nextCustomAction != nil{
            return nextCustomAction
        }
        else if nextUserAction != nil{ // && nextCustomAction != nil{ (implied)
            if nextUserAction! < nextCustomAction!{
                return nextUserAction
            }
            else{
                return nextCustomAction
            }
        }
        else{
            return nil;
        }
    }
    
    func addGoals(goals: [Goal]){
        self.goals.appendContentsOf(goals);
    }
    
    func getReward() -> Reward{
        return reward
    }
    
    
    
    func getProgress() -> Progress?{
        return progress;
    }
    
    func getUpNext() -> Action?{
        return upNext;
    }
    
    func getStreaks() -> [Streak]?{
        return streaks;
    }
    
    func getGoals() -> [Goal]{
        return goals;
    }
    
    func didIt(){
        streaks![streaks!.count-1].count += 1
        replaceUpNext()
    }
    
    func removeGoal(goal: Goal){
        let index = goals.indexOf{
            $0 == goal;
        };
        if (index != nil){
            goals.removeAtIndex(index!);
        }
    }
    
    var description: String{
        return "Feed Data: \(upNext != nil ? "has" : "doesn't have") up next, \(nextUserAction != nil ? "has" : "doesn't have") nextUA, \(nextCustomAction != nil ? "has" : "doesn't have") nextCA, \(goals.count) goals";
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


class FeedDataList: ParserModels.ListResult{
    var feedData: [FeedData]!
    
    
    override func mapping(map: Map){
        feedData <- map["results"]
    }
}
