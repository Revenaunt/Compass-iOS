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


final class FeedDataLoader{
    private static var loader: FeedDataLoader?
    
    
    static func getInstance() -> FeedDataLoader{
        if loader == nil{
            loader = FeedDataLoader()
        }
        return loader!
    }
    
    
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
    
    private var initialActionLoadRunning = true
    private var initialGoalLoadRunning = true
    
    //Callback stores
    private var dataLoadCallback: ((FeedData) -> Void)!
    private var goalLoadCallback: ([Goal] -> Void)!
    
    
    private func initialize(){
        feedData = nil
        goalBatch = [Goal]()
        getNextUserActionUrl = ""
        getNextCustomActionUrl = ""
        initialActionLoadRunning = true
        initialGoalLoadRunning = true
    }
    
    func load(callback: (FeedData) -> Void){
        dataLoadCallback = callback;
        
        Just.get(API.getFeedDataUrl(), headers: SharedData.user.getHeaderMap()){ (response) in
            if response.ok{
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding)
                self.feedData = (Mapper<ParserModels.FeedDataArray>().map(result)?.feedData![0])!
                self.onFeedDataLoaded()
            }
        }
    }
    
    func loadNextUserAction(){
        if getNextUserActionUrl != nil{
            fetchUserAction(getNextUserActionUrl!)
        }
    }
    
    func loadNextCustomAction(){
        if getNextCustomActionUrl != nil{
            fetchCustomAction(getNextCustomActionUrl!)
        }
    }
    
    func canLoadMoreGoals() -> Bool{
        return getNextGoalBatchUrl != nil
    }
    
    func loadNextGoalBatch(callback: ([Goal]) -> Void){
        goalLoadCallback = callback
    }
    
    private func onFeedDataLoaded(){
        fetchUserAction(API.URL.getTodaysUserActions())
        fetchCustomAction(API.URL.getTodaysCustomActions())
        fetchUserGoals(API.getUserGoalsUrl());
    }
    
    private func fetchUserAction(url: String){
        Just.get(url, headers: SharedData.user.getHeaderMap()){ (response) in
            if response.ok{
                self.processUserAction(Mapper<UserActionList>().map(response.contentStr)!)
            }
        }
    }
    
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
        
        feedData!.setNextUserAction(userAction)
        if initialActionLoadRunning && isInitialLoadOver(getNextCustomActionUrl){
            feedData!.replaceUpNext()
            
            initialActionLoadRunning = false
            if !initialGoalLoadRunning{
                dataLoadCallback(feedData!)
            }
        }
    }
    
    private func fetchCustomAction(url: String){
        Just.get(url, headers: SharedData.user.getHeaderMap()){ (response) in
            if response.ok{
                self.processCustomAction(Mapper<CustomActionList>().map(response.contentStr)!)
            }
        }
    }
    
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
            feedData!.replaceUpNext()
            
            initialActionLoadRunning = false
            if !initialGoalLoadRunning{
                dataLoadCallback(feedData!)
            }
        }
    }
    
    private func isInitialLoadOver(url: String?) -> Bool{
        return url == nil || !url!.isEmpty;
    }
    
    
    private func fetchUserGoals(url: String){
        Just.get(url, headers: SharedData.user.getHeaderMap()){ (response) in
            if response.ok{
                self.processUserGoals(Mapper<UserGoalList>().map(response.contentStr)!)
            }
        }
    }
    
    private func processUserGoals(goalList: UserGoalList){
        getNextGoalBatchUrl = goalList.next
        if initialGoalLoadRunning{
            feedData!.addGoals(goalList.results)
            dataLoadCallback(feedData!)
            initialGoalLoadRunning = false
        }
        else{
            goalLoadCallback(goalList.results)
        }
    }
}
