//
//  API.swift
//  Compass
//
//  Created by Ismael Alonso on 4/15/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import Foundation


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
    
    static func getLogInBody(email: String, password: String) -> [String: String]{
        var logInBody = [String: String]();
        logInBody["email"] = email;
        logInBody["password"] = password;
        return logInBody;
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
    
    static func getPostRegistrationUrl() -> String{
        return postProcess(BASE_URL + "notifications/devices/");
    }
    
    static func getPostRegistrationBody(token: String) -> [String: String]{
        var body = [String: String]();
        body["device_type"] = "ios";
        body["registration_id"] = token;
        return body;
    }
    
    static func getLogOutUrl() -> String{
        return postProcess(BASE_URL + "auth/logout/");
    }
    
    static func getLogOutBody(regId: String) -> [String: String]{
        var body = [String: String]();
        body["registration_id"] = regId;
        return body;
    }
    
    
    /*------------------------------*
     * APPLICATION DATA AND LIBRARY *
     *------------------------------*/
    
    static func getFeedDataUrl() -> String{
        return postProcess(BASE_URL + "users/feed/");
    }
    
    //Categories
    static func getCategoriesUrl() -> String{
        return postProcess(BASE_URL + "categories/?page_size=999999");
    }
    
    static func getCategoryUrl(categoryId: Int) -> String{
        return postProcess(BASE_URL + "categories/\(categoryId)/");
    }
    
    static func getUserCategoryUrl(categoryId: Int) -> String{
        return postProcess(BASE_URL + "users/categories/?category=\(categoryId)");
    }
    
    /*static func getDeleteCategoryUrl(userCategory: UserCategory) -> String{
        return BASE_URL + "users/categories/" + userCategory.getId() + "/";
    }*/
    
    static func getUserCategoriesUrl() -> String{
        return postProcess(BASE_URL + "users/categories/?page_size=999999");
    }
    
    /*static func getPostCategoryBody(category: CategoryContent) -> [String: String]{
        JSONObject postCategoriesBody = new JSONObject();
        try{
            postCategoriesBody.put("category", category.getId());
        }
        catch (JSONException jsonx){
            jsonx.printStackTrace();
        }
        return postCategoriesBody;
    }*/
    
    //Goals
    static func getGoalsUrl(category: CategoryContent) -> String{
        return postProcess(BASE_URL + "goals/?category=\(category.getId())");
    }
    
    static func getUserGoalsUrl() -> String{
        return postProcess(BASE_URL + "users/goals/?page_size=3");
    }
    
    static func getCustomGoalsUrl() -> String{
        return postProcess(BASE_URL + "users/customgoals/?page_size=3");
    }
    
    static func getPostGoalUrl(goal: GoalContent) -> String{
        return postProcess("\(BASE_URL)goals/\(goal.getId())/enroll/");
    }
    
    static func getPostGoalBody(category: CategoryContent) -> [String: String]{
        var body = [String: String]();
        body["category"] = "\(category.getId())";
        return body;
    }
    
    //Actions
    static func getActionUrl(actionMappingId: Int) -> String{
        return postProcess("\(BASE_URL)users/actions/\(actionMappingId)/");
    }
    
    
    /*--------------*
     * USER PROFILE *
     *--------------*/
    
    static func getPutUserProfileUrl(user: User) -> String{
        return "\(BASE_URL)users/profile/\(user.getProfileId())/";
    }
    
    static func getPutUserProfileBody(user: User) -> [String: String]{
        var body = [String: String]();
        body["timezone"] = NSTimeZone.defaultTimeZone().name;
        body["needs_onboarding"] = "\(user.needsOnBoarding())";
        body["maximum_daily_notifications"] = "\(user.getDailyNotificationLimit())";
        return body;
    }
    
    
    /*---------------*
     * MISCELLANEOUS *
     *---------------*/
    
    static func getRandomRewardUrl() -> String{
        return postProcess(BASE_URL + "rewards/?random=1");
    }
    
    static func getPostActionReportUrl(actionId: Int) -> String{
        return postProcess("\(BASE_URL)users/actions/\(actionId)/complete/");
    }
    
    static func getPostActionReportBody(state: String) -> [String: String]{
        var body = [String: String]();
        body["state"] = state;
        return body;
    }
    
    static func getPutSnoozeUrl(notificationId: Int) -> String{
        return postProcess("\(BASE_URL)notifications/\(notificationId)/");
    }
    
    static func getPutSnoozeBody(date: String, time: String) -> [String: String]{
        var body = [String: String]();
        body["date"] = date;
        body["time"] = time;
        return body;
    }
    
    static func getAwardsUrl() -> String{
        return postProcess(BASE_URL + "awards/");
    }
    
    class URL{
        static func resetPassword() -> String{
            return "\(BASE_URL)reset-password/"
        }
        
        static func userAccount() -> String{
            return "\(BASE_URL)users/accounts/";
        }
        
        static func getCategory(id: Int) -> String{
            return "\(BASE_URL)categories/\(id)/"
        }
        
        static func getUserGoal(id: Int) -> String{
            return "\(BASE_URL)users/goals/\(id)/"
        }
        
        static func deleteGoal(goal: Goal) -> String{
            if (goal is UserGoal){
                return "\(BASE_URL)users/goals/\(goal.getId())/";
            }
            else{
                return "\(BASE_URL)users/customgoals/\(goal.getId())/";
            }
        }
        
        static func getTodaysUserActions() -> String{
            return "\(BASE_URL)users/actions/?today=1&exclude_completed=1&page_size=1";
        }
        
        static func getCustomAction(id: Int) -> String{
            return "\(BASE_URL)users/customactions/\(id)/"
        }
        
        static func getTodaysCustomActions() -> String{
            return "\(BASE_URL)users/customactions/?today=1&exclude_completed=1&page_size=1";
        }
        
        static func getCustomActions(goal: Goal) -> String{
            if goal is UserGoal{
                return "\(BASE_URL)users/customactions/?goal=\(goal.getContentId())"
            }
            if goal is CustomGoal{
                return "\(BASE_URL)users/customactions/?customgoal=\(goal.getId())"
            }
            return ""
        }
        
        static func postCustomAction() -> String{
            return "\(BASE_URL)users/customactions/"
        }
        
        static func getOrganizations() -> String{
            return "\(BASE_URL)organizations/";
        }
        
        static func postOrganization() -> String{
            return "\(BASE_URL)organizations/members/";
        }
        
        static func postRemoveOrganization(organization: Organization) -> String{
            return "\(BASE_URL)organizations/\(organization.getId())/remove-member/"
        }
    }
    
    class BODY{
        static func postPutCustomAction(title: String, goal: Goal) -> [String: AnyObject]{
            var body = [String: AnyObject]()
            body["title"] = title
            body["notification_text"] = title
            if goal is UserGoal{
                body["goal"] = goal.getContentId()
            }
            else if goal is CustomGoal{
                body["customgoal"] = goal.getId()
            }
            return body
        }
        
        static func resetPassword(email: String) -> [String: String]{
            var body = [String: String]();
            body["email"] = email;
            return body;
        }
        
        static func postOrganization(organization: Organization) -> [String: AnyObject]{
            var body = [String: AnyObject]();
            body["organization"] = organization.getId();
            return body;
        }
        
        static func postRemoveOrganization(organization: Organization) -> [String: AnyObject]{
            var body = [String: AnyObject]();
            body["organization"] = organization.getId();
            return body;
        }
    }
}












