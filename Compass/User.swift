//
//  User.swift
//  Compass
//
//  Created by Ismael Alonso on 4/18/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//


class User{
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
    
    func toString() -> String{
        return fullName + "(uid: " + String(id) + ", pid: " + String(profileId) + "), " + email + ", "
            + (needsOnBoarding ? "needs on-boarding" : "doesn't need onboarding");
    }
}
