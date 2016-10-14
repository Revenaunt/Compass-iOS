//
//  UserGoalNewCustomActionCell.swift
//  Compass
//
//  Created by Ismael Alonso on 10/13/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class UserGoalNewCustomActionCell: UITableViewCell{
    @IBOutlet weak var customAction: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var savingIndicator: UIActivityIndicatorView!
    
    var delegate: UserGoalNewCustomActionCellDelegate?
    
    
    func setDelegate(delegate: UserGoalNewCustomActionCellDelegate){
        self.delegate = delegate
    }
    
    @IBAction func add(){
        if customAction.text?.characters.count != 0{
            if delegate != nil{
                customAction.enabled = false
                addButton.enabled = false
                savingIndicator.hidden = false
                delegate!.onAddCustomAction(customAction.text!)
            }
        }
    }
    
    func onActionSaveComplete(success: Bool){
        customAction.enabled = true
        addButton.enabled = true
        savingIndicator.hidden = true
        if success{
            customAction.text = ""
        }
    }
}


protocol UserGoalNewCustomActionCellDelegate{
    func onAddCustomAction(title: String)
}
