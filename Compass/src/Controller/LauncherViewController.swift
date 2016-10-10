//
//  ViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 4/7/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Locksmith
import Just
import ObjectMapper


class LauncherViewController: UIViewController{
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var logIn: UIButton!

    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        print(API.STAGING);
        
        let dictionary = Locksmith.loadDataForUserAccount("CompassAccount");
        if (dictionary != nil && dictionary!["email"] != nil){
            let email = dictionary!["email"] as! String;
            let password = dictionary!["password"] as! String;
            print("User account: \(email)");
            
            Just.post(API.getLogInUrl(), json: API.getLogInBody(email, password: password)){ (response) in
                if response.ok && CompassUtil.isSuccessStatusCode(response.statusCode!){
                    SharedData.user = Mapper<User>().map(response.contentStr)!;
                    print(SharedData.user);
                    if (SharedData.user.needsOnBoarding()){
                        self.fetchCategories();
                    }
                    else{
                        InitialDataLoader.load(SharedData.user){ (success) in
                            if (success){
                                if SharedData.user.needsOnBoarding(){
                                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("OnBoardingNavigationController")
                                    UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
                                }
                                else{
                                    self.loadFeedData();
                                }
                            }
                            else{
                                self.showMenu()
                            }
                        }
                    }
                }
                else{
                    print(response.error);
                    self.showMenu();
                }
            }
        }
        else{
            showMenu();
        }
    }
    
    private func loadFeedData(){
        FeedDataLoader.getInstance().load(){ (feedData) in
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainTabBarController")
            UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        navigationController?.setNavigationBarHidden(true, animated: animated);
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showMenu(){
        dispatch_async(dispatch_get_main_queue(), {
            self.activityIndicator.hidden = true;
            self.signUp.hidden = false;
            self.logIn.hidden = false;
        });
    }
    
    private func fetchCategories(){
        Just.get(API.getCategoriesUrl()){ (response) in
            if response.ok && CompassUtil.isSuccessStatusCode(response.statusCode!){
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding)
                SharedData.publicCategories = (Mapper<ParserModels.CategoryContentArray>().map(result)?.categories)!
                for category in SharedData.publicCategories{
                    print(category.toString())
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("OnBoardingNavController")
                    UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
                })
            }
            else{
                self.showMenu()
            }
        }
    }
}
