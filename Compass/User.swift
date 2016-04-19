//
//  User.swift
//  Compass
//
//  Created by Ismael Alonso on 4/18/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import ObjectMapper


class User: Mappable{
    //Profile information
    private var id: Int = 0;
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
    }
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map){
        id <- map["id"];
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
        return fullName + "(uid: " + String(id) + ", pid: " + String(profileId) + "), " + email + ", "
            + (needsOnBoarding ? "needs on-boarding" : "doesn't need onboarding");
    }
}
