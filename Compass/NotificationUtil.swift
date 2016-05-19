//
//  NotificationUtil.swift
//  Compass
//
//  Created by Ismael Alonso on 5/12/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Just


class NotificationUtil{
    private static var registrationToken: String?;
    
    
    class func setRegistrationToken(token: String){
        registrationToken = token;
    }
    
    class func sendRegistrationToken(){
        print("NotificationUtil: trying to send the registration token to the api...");
        //The only case in which we'd need to send the token to the API would be when the
        //  token has been set and the user has already logged in.
        if (registrationToken != nil && SharedData.hasUser()){
            print("NotificationUtil: sending the token.");
            Just.post(API.getPostRegistrationUrl(), headers: SharedData.getUser()!.getHeaderMap(),
                      json: API.getPostRegistrationBody(registrationToken!)){ (response) in
                        if (response.ok){
                            print("NotificationUtil: token delivered");
                        }
                        else{
                            print("NotificationUtil: token not delivered(\(response.statusCode))");
                        }
            };
            
            //To prevent unnecessary network traffic set the token reference to nil once
            //  it has been sent.
            registrationToken = nil;
        }
        else{
            print("NotificationUtil: token not sent, either already sent or user isn't logged in");
        }
    }
}