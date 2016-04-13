//
//  LogInViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 4/12/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController{
    
    @IBOutlet weak var logInButton: UIButton!
    
    
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
}