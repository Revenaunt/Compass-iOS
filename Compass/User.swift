//
//  User.swift
//  Compass
//
//  Created by Ismael Alonso on 4/18/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class User: TDCBase{
    //Profile information
    private var profileId: Int = 0;
    private var email: String = "";
    private var password: String = "";
    private var firstName: String = "";
    private var lastName: String = "";
    private var fullName: String = "";
    private var token: String = "";
    private var dateJoined: String = "";
    private var needsOnBoarding: Bool = true;
    
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
    
    func setPassword(password: String){
        self.password = password;
    }
    
    func getEmail() -> String{
        return email;
    }
    
    func getPassword() -> String{
        return password;
    }
    
    func getToken() -> String{
        return token;
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
        needsOnBoarding <- map["needs_onboarding"];
        
        zipCode <- map["zipcode"];
        birthday <- map["birthday"];
        sex <- map["sex"];
        employed <- map["employed"];
        parent <- map["is_parent"];
        relationship <- map["in_relationship"];
        degree <- map["has_degree"];
    }
    
    func toString() -> String{
        return fullName + "(uid: \(getId()), pid: \(profileId)), \(email), " + (needsOnBoarding ? "needs on-boarding" : "doesn't need onboarding");
    }
}
