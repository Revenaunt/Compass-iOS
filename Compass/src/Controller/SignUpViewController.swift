//
//  SignUpViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 4/11/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Just
import ObjectMapper;
import Locksmith;


class SignUpViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordCheck: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var termsOfServiceButton: UIButton!
    
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
        address.layer.borderColor = UIColor.redColor().CGColor;
        address.layer.cornerRadius = 4;
        
        password.layer.borderColor = UIColor.redColor().CGColor;
        password.layer.cornerRadius = 4;
        
        passwordCheck.layer.borderColor = UIColor.redColor().CGColor;
        passwordCheck.layer.cornerRadius = 4;
        
        firstName.layer.borderColor = UIColor.redColor().CGColor;
        firstName.layer.cornerRadius = 4;
        
        lastName.layer.borderColor = UIColor.redColor().CGColor;
        lastName.layer.cornerRadius = 4;
        
        signUpButton.backgroundColor = UIColor.init(red: 0.1, green: 0.46, blue: 0.82, alpha: 1);
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
        signUpButton.layer.cornerRadius = 18;
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated);
        navigationController?.setNavigationBarHidden(false, animated: animated);
    }
    
    @IBAction func addressEditingBegun(){
        address.layer.borderWidth = 0;
    }
    
    @IBAction func passwordEditingBegun(){
        password.layer.borderWidth = 0;
        passwordCheck.layer.borderWidth = 0;
    }
    
    @IBAction func passwordCheckEditingBegun(){
        password.layer.borderWidth = 0;
        passwordCheck.layer.borderWidth = 0;
    }
    
    @IBAction func firstNameEditingBegun(){
        firstName.layer.borderWidth = 0;
    }
    
    @IBAction func lastNameEditingBegun(){
        lastName.layer.borderWidth = 0;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if textField == address{
            password.becomeFirstResponder();
        }
        else if textField == password{
            passwordCheck.becomeFirstResponder();
        }
        else if textField == passwordCheck{
            firstName.becomeFirstResponder();
        }
        else if textField == firstName{
            lastName.becomeFirstResponder();
        }
        else if (textField == lastName){
            lastName.resignFirstResponder();
            signUpTapped();
        }
        return true;
    }
    
    @IBAction func signUpTapped(){
        let email = address.text!;
        let pass = password.text!;
        let passCheck = passwordCheck.text!;
        let first = firstName.text!;
        let last = lastName.text!;
        
        if !isValidEmail(email){
            address.layer.borderWidth = 1;
            return;
        }
        if pass.characters.count < 5{
            password.layer.borderWidth = 1;
            return;
        }
        if !passCheck.isEqual(pass){
            passwordCheck.layer.borderWidth = 1;
            return;
        }
        if first.isEmpty{
            firstName.layer.borderWidth = 1;
            return;
        }
        if last.isEmpty{
            lastName.layer.borderWidth = 1;
            return;
        }
        signUp(email, password: pass, firstName: first, lastName: last);
    }
    
    private func isValidEmail(email: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx);
        return emailTest.evaluateWithObject(email);
    }
    
    @IBAction func onTap(sender: AnyObject){
        address.resignFirstResponder();
        password.resignFirstResponder();
        passwordCheck.resignFirstResponder();
        firstName.resignFirstResponder();
        lastName.resignFirstResponder();
    }
    
    private func signUp(email: String, password: String, firstName: String, lastName: String){
        toggleMenu(false);
        
        Just.post(API.getSignUpUrl(), json: API.getSignUpBody(email, password: password, firstName: firstName, lastName: lastName)){ (response) in
            if response.ok{
                let user = Mapper<User>().map(String(data: response.content!, encoding:NSUTF8StringEncoding))!;
                user.setPassword(password);
                SharedData.user = user;
                print(user);
                
                //This right here is probably not necessary except for testing purposes
                do{
                    try Locksmith.deleteDataForUserAccount("CompassAccount");
                }
                catch{
                    print("There is no account to delete");
                }
                
                do{
                    var accountInfo = [String: String]();
                    accountInfo["email"] = user.getEmail();
                    accountInfo["password"] = user.getPassword();
                    accountInfo["token"] = user.getToken();
                    try Locksmith.saveData(accountInfo, forUserAccount: "CompassAccount");
                }
                catch{
                    print("Error writing to keychain");
                    print(error);
                }
                
                self.fetchCategories();
            }
            else{
                self.toggleMenu(true);
            }
        }
    }
    
    @IBAction func privacyPolicy(){
        UIApplication.sharedApplication().openURL(NSURL(string: "https://app.tndata.org/privacy/")!);
    }
    
    @IBAction func termsOfService(){
        UIApplication.sharedApplication().openURL(NSURL(string: "https://app.tndata.org/terms/")!);
    }
    
    private func toggleMenu(showButtons: Bool){
        dispatch_async(dispatch_get_main_queue(), {
            self.signUpButton.hidden = !showButtons;
            self.activity.hidden = showButtons;
            self.privacyPolicyButton.hidden = !showButtons;
            self.termsOfServiceButton.hidden = !showButtons;
        });
    }
    
    private func fetchCategories(){
        Just.get(API.getCategoriesUrl()){ (response) in
            if (response.ok && CompassUtil.isSuccessStatusCode(response.statusCode!)){
                let result = String(data: response.content!, encoding:NSUTF8StringEncoding);
                SharedData.publicCategories = (Mapper<ParserModels.CategoryContentArray>().map(result)?.categories)!;
                for category in SharedData.publicCategories{
                    print(category.toString());
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil);
                    let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("OnBoardingNavController");
                    UIApplication.sharedApplication().keyWindow?.rootViewController = viewController;
                });
            }
            else{
                self.toggleMenu(true);
            }
        }
    }
}
