//
//  API.swift
//  Compass
//
//  Created by Ismael Alonso on 4/15/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

class API{
    
    //#if DEBUG
        static let STAGING = true;
    //#else
    //    static let STAGING = false;
    //#endif
    
    private static let USE_NGROK_TUNNEL = false;
    private static let APP_BASE_URL = "https://app.tndata.org/api/";
    private static let STAGING_BASE_URL = "http://staging.tndata.org/api/";
    private static let NGROK_TUNNEL_URL = "https://tndata.ngrok.io/api/";
    private static let BASE_URL =
            USE_NGROK_TUNNEL ?
                    NGROK_TUNNEL_URL
                    :
                    STAGING ?
                            STAGING_BASE_URL
                            :
                            APP_BASE_URL;
    
    
    class func postProcess(url: String) -> String{
        if url.containsString("?"){
            return url + "&version=2";
        }
        else{
            return url + "?version=2";
        }
    }
    
    
    /*----------------*
     * AUTHENTICATION *
     *----------------*/
    
    static func getLogInUrl() -> String{
        return postProcess(BASE_URL + "auth/token/");
    }
    
    static func getSignUpUrl() -> String{
        return postProcess(BASE_URL + "users/");
    }
    
    static func getSignUpBody(email: String, password: String, firstName: String, lastName: String) -> [String: String]{
        var body = [String: String]();
        body["email"] = email;
        body["password"] = password;
        body["first_name"] = firstName;
        body["last_name"] = lastName;
        return body;
    }
}












