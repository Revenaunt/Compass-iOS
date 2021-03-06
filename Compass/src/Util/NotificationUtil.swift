//
//  NotificationUtil.swift
//  Compass
//
//  Created by Ismael Alonso on 5/12/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Foundation
import Just


class NotificationUtil{
    private static var apnsToken: String?;
    private static var sendToken: Bool = false;
    
    
    class func setApnsToken(token: String){
        apnsToken = token;
        
        let defaults = NSUserDefaults.standardUserDefaults();
        defaults.setObject(apnsToken, forKey: "APNsToken");
        
        sendToken = true;
        sendRegistrationToken();
    }
    
    class func sendRegistrationToken(){
        print("NotificationUtil: trying to send the registration token to the api...");
        //The only case in which we'd need to send the token to the API would be when the
        //  token has been set and the user has already logged in.
        if (apnsToken != nil && SharedData.isUserLoggedIn() && sendToken){
            Just.post(API.getPostRegistrationUrl(), headers: SharedData.user.getHeaderMap(),
                      json: API.getPostRegistrationBody(apnsToken!)){ (response) in
                        if (response.ok){
                            print("NotificationUtil: token delivered");
                        }
                        else{
                            print("NotificationUtil: token not delivered(\(response.statusCode))");
                        }
            };
            sendToken = false;
        }
        else{
            print("NotificationUtil: token not sent, either already sent or user isn't logged in");
        }
    }
    
    class func logOut(){
        sendToken = true;
    }
}
