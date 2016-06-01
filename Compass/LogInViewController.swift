//
//  LogInViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 4/12/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Just
import ObjectMapper
import Locksmith


class LogInViewController: UIViewController{
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
        logInButton.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1);
        //The button is white to make it visible in the storyboard, the color is changed to default here
        logInButton.setTitleColor(UIColor.init(red: 0.1, green: 0.46, blue: 0.82, alpha: 1), forState: UIControlState.Normal);
        logInButton.layer.cornerRadius = 18;
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated);
        navigationController?.setNavigationBarHidden(false, animated: animated);
    }
    
    
    @IBAction func onLogInTap(){
        toggleMenu(false);
        
        let email = emailField.text!;
        let pass = passwordField.text!;
        
        Just.post(API.getLogInUrl(), data: API.getLogInBody(email, password: pass)){ (response) in
            print(response.ok);
            print(response.statusCode ?? -1);
            if response.ok && CompassUtil.isSuccessStatusCode(response.statusCode!){
                let user = Mapper<User>().map(String(data: response.content!, encoding:NSUTF8StringEncoding))!;
                SharedData.setUser(user);
                print(SharedData.getUser()!.toString());
                
                //This right here is probably not necessary except for testing purposes
                do{
                    try Locksmith.deleteDataForUserAccount("CompassAccount");
                }
                catch{
                    print("There is no account to delete");
                }
                
                do{
                    var accountInfo = [String: String]();
                    accountInfo["email"] = email;
                    accountInfo["password"] = pass;
                    accountInfo["token"] = user.getToken();
                    try Locksmith.saveData(accountInfo, forUserAccount: "CompassAccount");
                }
                catch{
                    print("Error writing to keychain");
                    print(error);
                }
                
                InitialDataLoader.load(SharedData.getUser()!){ (success) in
                    if (success){
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                        let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainNavigationController");
                        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController;
                    }
                    else{
                        self.toggleMenu(true);
                    }
                }
            }
            else{
                print(response.error);
                self.toggleMenu(true);
            }
        }
    }
    
    private func toggleMenu(showButton: Bool){
        logInButton.hidden = !showButton;
        indicator.hidden = showButton;
    }
}