//
//  User.swift
//  Compass
//
//  Created by Ismael Alonso on 4/18/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class User: TDCBase, CustomStringConvertible{
    //Profile information
    private var profileId: Int = 0;
    private var email: String = "";
    private var password: String = "";
    private var firstName: String = "";
    private var lastName: String = "";
    private var fullName: String = "";
    private var token: String = "";
    private var dateJoined: String = "";
    private var needsOnBoardingVar: Bool = true;
    private var dailyNotificationLimit = 0;
    
    //Profile answers
    private var zipCode: String = "";
    private var birthday: String = "";
    private var sex: String = "";
    private var employed: Bool = false;
    private var parent: Bool = false;
    private var relationship: Bool = false;
    private var degree: Bool = false;
    
    
    init(email: String, password: String){
        self.email = email;
        self.password = password;
        super.init(id: -1);
    }
    
    init(token: String){
        super.init(id: -1);
        self.token = token;
    }
    
    func setPassword(password: String){
        self.password = password;
    }
    
    func setDailyNotificationLimit(dailyNotificationLimit: Int){
        self.dailyNotificationLimit = dailyNotificationLimit;
    }
    
    func onBoardingComplete(){
        needsOnBoardingVar = false;
    }
    
    func getProfileId() -> Int{
        return profileId;
    }
    
    func getEmail() -> String{
        return email;
    }
    
    func getPassword() -> String{
        return password;
    }
    
    func getFullName() -> String{
        return fullName;
    }
    
    func getToken() -> String{
        return token;
    }
    
    func needsOnBoarding() -> Bool{
        return needsOnBoardingVar;
    }
    
    func getDailyNotificationLimit() -> Int{
        return dailyNotificationLimit;
    }
    
    required init?(_ map: Map){
        super.init(map);
    }
    
    override func mapping(map: Map){
        super.mapping(map);
        
        profileId <- map["userprofile_id"];
        email <- map["email"];
        firstName <- map["first_name"];
        lastName <- map["last_name"];
        fullName <- map["full_name"];
        token <- map["token"];
        dateJoined <- map["dateJoined"];
        needsOnBoardingVar <- map["needs_onboarding"];
        dailyNotificationLimit <- map["maximum_daily_notifications"];
        
        zipCode <- map["zipcode"];
        birthday <- map["birthday"];
        sex <- map["sex"];
        employed <- map["employed"];
        parent <- map["is_parent"];
        relationship <- map["in_relationship"];
        degree <- map["has_degree"];
    }
    
    func getHeaderMap() -> [String: String]{
        return ["Authorization": "Token \(token)"];
    }
    
    var description: String{
        let idSec = "(uid: \(getId()), pid: \(profileId))";
        let onBoardingSec = "\(needsOnBoardingVar ? "needs" : "doesn't need") on-boarding";
        return "\(fullName) \(idSec), \(email), \(onBoardingSec)";
    }
}
