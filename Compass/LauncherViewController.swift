//
//  ViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 4/7/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit

class LauncherViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var logIn: UIButton!

    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults();
        if !defaults.boolForKey("hasLoggedIn"){
            activityIndicator.hidden = true;
            signUp.hidden = false;
            logIn.hidden = false;
        }
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

