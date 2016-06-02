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
    private var actionFeedback: ActionFeedback? = nil;
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
        actionFeedback <- map["action_feedback"];
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
    
    func getFeedback() -> ActionFeedback?{
        return actionFeedback;
    }
    
    func getUpcoming() -> [UpcomingAction]{
        return upcomingActions;
    }
    
    func getGoals() -> [Goal]{
        return goals;
    }
    
    func addGoals(goals: [Goal]){
        self.goals.appendContentsOf(goals);
    }
    
    func setNextGoalBatchUrl(url: String?){
        nextGoalBatchUrl = url;
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
    
    var description: String{
        return "Feed Data: \(upNextAction != nil ? "has" : "doesn't have") up next, \(actionFeedback != nil ? "has" : "doesn't have") feedback, \(upcomingActions.count) actions, \(goals.count) goals";
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
    
    class ActionFeedback: Mappable{
        private var title: String = "";
        private var subtitle: String = "";
        private var iconId: Int = -1;
        
        private var goalId: Int = -1;
        private var goalType: String = "";
        
        
        required init?(_ map: Map){
            
        }
        
        internal func mapping(map: Map){
            title <- map["title"];
            subtitle <- map["subtitle"];
            iconId <- map["icon"];
        }
        
        func getTitle() -> String{
            return title;
        }
        
        func getSubtitle() -> String{
            return subtitle;
        }
        
        func getIconResourceName() -> String{
            return "Feedback \(iconId)";
        }
        
        func setGoal(/* UpcomingAction */){
            //TODO
        }
        
        func getGoalId() -> Int{
            return goalId;
        }
        
        func hasUserGoal() -> Bool{
            return goalType == "usergoal";
        }
        
        func hasCustomGoal() -> Bool{
            return goalType == "customgoal";
        }
    }
}
