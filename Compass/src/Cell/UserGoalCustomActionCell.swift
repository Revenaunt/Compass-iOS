//
//  UserGoalCustomActionCell.swift
//  Compass
//
//  Created by Ismael Alonso on 10/13/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class UserGoalCustomActionCell: UITableViewCell{
    private var delegate: UserGoalCustomActionCellDelegate!
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var bullet: UIView!
    @IBOutlet weak var customAction: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    private var saveButtonConstraints = [NSLayoutConstraint]()
    
    
    func setAction(delegate: UserGoalCustomActionCellDelegate, title: String){
        self.delegate = delegate
        customAction.text = title
        
        bullet.layoutIfNeeded()
        bullet.layer.cornerRadius = bullet.bounds.width/2
        
        removeSaveButton()
    }
    
    func edit(){
        customAction.enabled = true
        customAction.borderStyle = UITextBorderStyle.RoundedRect
        customAction.becomeFirstResponder()
        selectionStyle = .None
        content.addSubview(saveButton)
        for constraint in saveButtonConstraints{
            content.addConstraint(constraint)
        }
    }
    
    @IBAction func save(){
        if customAction.text!.characters.count != 0{
            customAction.enabled = false
            customAction.borderStyle = UITextBorderStyle.None
            customAction.resignFirstResponder()
            selectionStyle = .Default
            removeSaveButton()
            delegate.onSaveCustomAction(self, newTitle: customAction.text!)
        }
    }
    
    private func removeSaveButton(){
        //TODO: put this in an extension?
        for constraint in content.constraints{
            if constraint.belongsTo(saveButton){
                saveButtonConstraints.append(constraint)
            }
        }
        saveButton.removeFromSuperview()
    }
}


protocol UserGoalCustomActionCellDelegate{
    func onSaveCustomAction(cell: UserGoalCustomActionCell, newTitle: String)
}
