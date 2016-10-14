//
//  UserGoalCustomActionCell.swift
//  Compass
//
//  Created by Ismael Alonso on 10/13/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class UserGoalCustomActionCell: UITableViewCell{
    @IBOutlet weak var customAction: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    func setActionTitle(title: String){
        customAction.text = title
    }
    
    @IBAction func save(){
        
    }
}


protocol UserGoalCustomActionCellDelegate{
    func onSaveCustomAction(source: UITableViewCell, newTitle: String);
}
