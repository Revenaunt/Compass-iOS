//
//  ResetController.swift
//  Compass
//
//  Created by Ismael Alonso on 8/19/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Just


class ResetController: UIViewController{
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var check: UIImageView!
    
    
    override func viewDidLoad(){
        address.layer.borderColor = UIColor.redColor().CGColor;
        address.layer.cornerRadius = 4;
        
        indicator.hidden = true;
    }
    
    @IBAction func addressEditing(){
        address.layer.borderWidth = 0;
    }
    
    @IBAction func reset(){
        if (isValidEmail(address.text!)){
            resetButton.hidden = true;
            indicator.hidden = false;
            indicator.startAnimating();
            check.hidden = true;
            
            Just.post(API.URL.resetPassword(), json: API.BODY.resetPassword(address.text!)){ response in
                print(response.ok);
                print(response.statusCode ?? -1);
                print(String(data: response.content!, encoding:NSUTF8StringEncoding));
                if (response.ok){
                    dispatch_async(dispatch_get_main_queue(), {
                        self.requestFinished(true);
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.requestFinished(false);
                    });
                }
            }
        }
        else{
            address.layer.borderWidth = 1;
        }
    }
    
    private func isValidEmail(email: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx);
        return emailTest.evaluateWithObject(email);
    }
    
    private func requestFinished(ok: Bool){
        if (ok){
            resetButton.hidden = true;
            indicator.hidden = true;
            check.hidden = false;
        }
        else{
            resetButton.hidden = false;
            indicator.hidden = true;
            check.hidden = true;
        }
    }
}
