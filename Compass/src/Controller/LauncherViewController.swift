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
            
            print(email);
            print(password);
            
            Just.post(API.getLogInUrl(), data: API.getLogInBody(email, password: password)){ (response) in
                print(response.ok);
                print(response.statusCode ?? -1);
                if response.ok && CompassUtil.isSuccessStatusCode(response.statusCode!){
                    SharedData.user = Mapper<User>().map(String(data: response.content!, encoding:NSUTF8StringEncoding))!;
                    print(SharedData.user);
                    InitialDataLoader.load(SharedData.user){ (success) in
                        if (success){
                            print(SharedData.feedData);
                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                            let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainNavigationController");
                            UIApplication.sharedApplication().keyWindow?.rootViewController = viewController;
                        }
                        else{
                            self.showMenu()
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
}

