//
//  SignUpViewController.swift
//  Compass
//
//  Created by Ismael Alonso on 4/11/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        navigationController?.setNavigationBarHidden(false, animated: animated);
    }
}