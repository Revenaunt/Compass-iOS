//
//  SignUpViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 4/11/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController{
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
        signUpButton.backgroundColor = UIColor.init(red: 0.1, green: 0.46, blue: 0.82, alpha: 1);
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal);
        signUpButton.layer.cornerRadius = 18;
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated);
        navigationController?.setNavigationBarHidden(false, animated: animated);
    }
}