//
//  FeedDataLoader.swift
//  Compass
//
//  Created by Ismael Alonso on 10/7/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Foundation
import Just
import ObjectMapper


/// Handles loading all required data for the feed to display.
/**
 Loads the FeedData bundle, Actions, and goals on demand. The FeedData bundle is accompanied by
 three Actions, one CustomAction, one UserAction, and other of either, and none to five Goals,
 depending on availability. Loaded FeedData is placed in SharedData.feedData, while goals loaded
 on demand are delivered through a closure.
 
 - Author: Ismael Alonso
 */
final class FeedDataLoader{
    //MARK: Singleton and instance retrieval
    
    private static var loader: FeedDataLoader?
    
    /// FeedDataLoader instance getter.
    /**
     Gets the available instance of FeedDataLoader, if there isn't one it creates it.
     
     - Returns: an instance of FeedDataLoader.
     */
    static func getInstance() -> FeedDataLoader{
        if loader == nil{
            loader = FeedDataLoader()
        }
        return loader!
    }
    
    
    //MARK: Attributes
    
    private var feedData: FeedData?
    private var goalBatch = [Goal]()
    
    //¡¡IMPORTANT!!
    //If the URLs are null, the data has been loaded but the result set was empty
    //If the URLs are the empty string, the data has not yet been loaded
    //This is because the API returns NULL as the next URL in the last page of the dataset
    private var getNextUserActionUrl: String? = ""
    private var getNextCustomActionUrl: String? = ""
    //Goal load is not concurrent, so the above comment does not apply to this URL
    private var getNextGoalBatchUrl: String?
    
    //Initial run flags
    private var initialActionLoadRunning = true
    private var initialGoalLoadRunning = true
    
    //Callback stores
    private var dataLoadCallback: ((Bool) -> Void)?
    private var goalLoadCallback: ([Goal]? -> Void)?
    
    
    //MARK: Resetting method
    
    /// Resets the instance of FeedDataLoader.
    private func initialize(){
        feedData = nil
        goalBatch = [Goal]()
        getNextUserActionUrl = ""
        getNextCustomActionUrl = ""
        initialActionLoadRunning = true
        initialGoalLoadRunning = true
    }
    
    //MARK: Internal checking methods
    
    /// Tells whether initial feed data is loaded.
    /**
     Three conditions must be satisified, initial action load is over, initial goal load is over,
     and the FeedData bundle exists. Non-existing FeedData indicates that either the process has
     not yet started, the process has started but the FeedData GET request has not been satisfied,
     or that there was an error along the way that made impossible to load the FeedData.
     
     - Returns: true if the feed data is loaded, false otherwise.
     */
    private func isFeedDataLoaded() -> Bool{
        return !initialActionLoadRunning && !initialGoalLoadRunning && feedData != nil
    }
    
    /// Tells whether initial data load for either UserActions or CustomActions is over.
    /**
     The relevance of this method is that it is able to tell if they are complete individually,
     as opposed to the initialActionLoadRunning flag, which tells whether both of them are
     complete or not. Next action urls have three states: nil, empty, and non-empty. If nil,
     there are no more actions to load; if empty, the initial action load is still in progress;
     and if non-empty, at least an action has been loaded.
     
     - parameter url: the url of the next action to be loaded for either UserActions or
     CustomActions.
     
     - Returns: true if the url is non-empty.
     */
    private func isInitialLoadOver(url: String?) -> Bool{
        return url == nil || !url!.isEmpty;
    }
    
    //MARK: User interaction methods
    
    /// Triggers the initial FeedData load.
    /**
     This methods calls initialize(), which resets the instance to initial state.
     
     - parameter callback: a closure taking a boolean which represents load success or failure.
     */
    func load(callback: (Bool) -> Void){
        dataLoadCallback = callback
        initialize()
        fetchFeedData();
    }
    
    /// Triggers the process that loads the next UserAction.
    /**
     UserActions loaded this way are placed directly in the FeedData buffer.
     */
    func loadNextUserAction(){
        if getNextUserActionUrl != nil{
            fetchUserAction(getNextUserActionUrl!)
        }
    }
    
    /// Triggers the process that loads the next CustomAction.
    /**
     CustomActions loaded this way are placed directly in the FeedData buffer.
     */
    func loadNextCustomAction(){
        if getNextCustomActionUrl != nil{
            fetchCustomAction(getNextCustomActionUrl!)
        }
    }
    
    /// Tells whether more goals can be loaded.
    /**
     For more goals to be loaded, two conditions must be satisfied; there must be a loaded instance
     of FeedData, and there need to be more goals.
     
     - Returns: true if more goals can be loaded, false otherwise.
     */
    func canLoadMoreGoals() -> Bool{
        return isFeedDataLoaded() && getNextGoalBatchUrl != nil
    }
    
    /// Loads the next goal batch.
    /**
     Goals are only loaded if the conditions in canLoadMoreGoals() are satisfied. If they can't,
     the callback closure will be called with a null parameter.
     
     - parameter callback: a closure taking an optional list of goals as a parameter.
     */
    func loadNextGoalBatch(callback: ([Goal]?) -> Void){
        if canLoadMoreGoals(){
            goalLoadCallback = callback
            //Decide which kind of goals to load
            if getNextGoalBatchUrl!.containsString("custom"){
                fetchCustomGoals(getNextGoalBatchUrl!)
            }
            else{
                fetchUserGoals(getNextGoalBatchUrl!)
            }
        }
        else{
            callback(nil)
        }
    }
    
    //MARK: Internal data retrieval methods
    
    /// Fires the request to the endpoint that exposes FeedData.
    private func fetchFeedData(){
        Just.get(API.getFeedDataUrl(), headers: SharedData.user.getHeaderMap()){ (response) in
            if response.ok{
                self.onFeedDataLoaded(Mapper<FeedDataList>().map(response.contentStr)!.feedData[0])
            }
            else{
                self.dispatchFeedDataLoadFailed()
            }
        }
    }
    
    /// Fires the request to fetch a UserAction.
    private func fetchUserAction(url: String){
        Just.get(url, headers: SharedData.user.getHeaderMap()){ (response) in
            if response.ok{
                self.processUserAction(Mapper<UserActionList>().map(response.contentStr)!)
            }
            else{
                if (!self.isFeedDataLoaded()){
                    self.dispatchFeedDataLoadFailed()
                }
                else{
                    self.feedData?.setNextUserAction(nil)
                }
            }
        }
    }
    
    /// Fires the request to fetch a CustomAction.
    private func fetchCustomAction(url: String){
        Just.get(url, headers: SharedData.user.getHeaderMap()){ (response) in
            if response.ok{
                self.processCustomAction(Mapper<CustomActionList>().map(response.contentStr)!)
            }
            else{
                if (!self.isFeedDataLoaded()){
                    self.dispatchFeedDataLoadFailed()
                }
                else{
                    self.feedData?.setNextCustomAction(nil)
                }
            }
        }
    }
    
    /// Fires the request to fetch a batch of CustomGoals.
    private func fetchCustomGoals(url: String){
        Just.get(url, headers: SharedData.user.getHeaderMap()){ (response) in
            if response.ok{
                self.processCustomGoals(Mapper<CustomGoalList>().map(response.contentStr)!)
            }
            else{
                if (!self.isFeedDataLoaded()){
                    self.dispatchFeedDataLoadFailed()
                }
                else{
                    self.dispatchGoalLoadFailed()
                }
            }
        }
    }
    
    /// Fires the request to fetch a batch of UserGoals.
    private func fetchUserGoals(url: String){
        Just.get(url, headers: SharedData.user.getHeaderMap()){ (response) in
            if response.ok{
                self.processUserGoals(Mapper<UserGoalList>().map(response.contentStr)!)
            }
            else{
                if (!self.isFeedDataLoaded()){
                    self.dispatchFeedDataLoadFailed()
                }
                else{
                    self.dispatchGoalLoadFailed()
                }
            }
        }
    }
    
    //MARK: Data processing methods
    
    /// Triggers the load of a UserAction, a CustomAction, and the first batch of Goals.
    private func onFeedDataLoaded(feedData: FeedData){
        self.feedData = feedData
        fetchUserAction(API.URL.getTodaysUserActions())
        fetchCustomAction(API.URL.getTodaysCustomActions())
        fetchCustomGoals(API.getUserGoalsUrl());
    }
    
    /// Decides what to do with a recently fetched UserAction
    /**
     If there aren't actions to load, which will happen if the user has no actions on the first
     call to the endpoint the next UserAction set to the feed data must be nil. Additionally,
     if the CustomAction has already loaded, replaceUpNext needs to be called, which will trigger
     the load of the action that got bumped, if any. If the goals have finished loading as well
     the FeedData is dispatched.
     
     - parameter actionList: the result of parsing the data delivered by the API
     */
    private func processUserAction(actionList: UserActionList){
        getNextUserActionUrl = actionList.next
        var userAction: UserAction?
        //The first call to the endpoint may yield no results, in this case the next url will
        //  be null and the results array will be empty
        if actionList.results.isEmpty{
            userAction = nil
        }
        else{
            userAction = actionList.results[0]
        }
        
        feedData?.setNextUserAction(userAction)
        if initialActionLoadRunning && isInitialLoadOver(getNextCustomActionUrl){
            //CustomAction has already loaded
            feedData?.replaceUpNext()
            
            initialActionLoadRunning = false
            if !initialGoalLoadRunning{
                dispatchFeedData()
            }
        }
    }
    
    /// Decides what to do with a recently fetched CustomAction
    /**
     If there aren't actions to load, which will happen if the user has no actions on the first
     call to the endpoint the next CustomAction set to the feed data must be nil. Additionally,
     if the UserAction has already loaded, replaceUpNext needs to be called, which will trigger
     the load of the action that got bumped, if any. If the goals have finished loading as well
     the FeedData is dispatched.
     
     - parameter actionList: the result of parsing the data delivered by the API.
     */
    private func processCustomAction(actionList: CustomActionList){
        getNextCustomActionUrl = actionList.next
        var customAction: CustomAction?
        //The first call to the endpoint may yield no results, in this case the next url will
        //  be null and the results array will be empty
        if actionList.results.isEmpty{
            customAction = nil
        }
        else{
            customAction = actionList.results[0]
        }
        
        feedData!.setNextCustomAction(customAction)
        if initialActionLoadRunning && isInitialLoadOver(getNextUserActionUrl){
            //UserAction has already loaded
            feedData!.replaceUpNext()
            
            initialActionLoadRunning = false
            if !initialGoalLoadRunning{
                dispatchFeedData()
            }
        }
    }
    
    /// Decides what to do with a recently loaded CustomGoal batch.
    /**
     Sets the next batch url and populates the goal batch list. Loads the first batch of UserGoals
     if less than three CustomGoals were delivered, otherwise it dispatches the batch.
     
     - parameter goalList: the result of parsing the data delivered by the API.
     */
    private func processCustomGoals(goalList: CustomGoalList){
        getNextGoalBatchUrl = goalList.next
        for goal in goalList.results{
            goalBatch.append(goal)
        }
        if getNextGoalBatchUrl == nil{
            getNextGoalBatchUrl = API.getUserGoalsUrl()
            if goalBatch.count < 3{
                fetchUserGoals(getNextGoalBatchUrl!)
            }
            else{
                dispatchGoals()
            }
        }
        else{
            dispatchGoals()
        }
    }
    
    /// Decides what to do with a recently loaded UserGoal batch.
    /**
     Sets the next batch url and dispatches the loaded batch.
     
     - parameter goalList: the result of parsing the data delivered by the API.
     */
    private func processUserGoals(goalList: UserGoalList){
        getNextGoalBatchUrl = goalList.next
        for goal in goalList.results{
            goalBatch.append(goal)
        }
        dispatchGoals();
    }
    
    //MARK: Dispatching methods
    
    /// Dispatches the loaded FeedData. If for some reason there ain't no FeedData, dispatches the
    /// failed event. Either is done in the UI thread.
    private func dispatchFeedData(){
        if feedData != nil{
            SharedData.feedData = feedData!
            dispatch_async(dispatch_get_main_queue(), {
                self.dataLoadCallback!(true)
            })
        }
        else{
            dispatchFeedDataLoadFailed()
        }
    }
    
    /// Dispatches a failed load event in the UI thread.
    private func dispatchFeedDataLoadFailed(){
        feedData = nil
        dispatch_async(dispatch_get_main_queue(), {
            self.dataLoadCallback?(false)
        })
    }
    
    /// Dispatches a goal batch in the UI thread if this ain't an initial load.
    private func dispatchGoals(){
        if initialGoalLoadRunning{
            feedData!.addGoals(goalBatch)
            if !initialActionLoadRunning{
                dispatchFeedData()
            }
            initialGoalLoadRunning = false
        }
        else{
            dispatch_async(dispatch_get_main_queue(), {
                self.goalLoadCallback?(self.goalBatch)
                self.goalBatch.removeAll()
            })
        }
    }
    
    /// Dispatches a failed load event in the UI thread.
    private func dispatchGoalLoadFailed(){
        dispatch_async(dispatch_get_main_queue(), {
            self.goalLoadCallback?(nil)
            self.goalBatch.removeAll()
        })
    }
}
