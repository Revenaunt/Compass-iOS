//
//  UpNextCellTableViewCell.swift
//  Compass
//
//  Created by Ismael Alonso on 4/20/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


/// Up Next Action cell.
/**
 Displays the requested action data. This action should be FeedData.upNext
 
 - Author: Ismael Alonso
 */
class UpNextCell: UITableViewCell{
    //MARK: UI components
    
    @IBOutlet weak var actionContainer: UIView!
    @IBOutlet weak var actionTitle: UILabel!
    @IBOutlet var actionDescription: UILabel!
    
    private var descriptionConstraints = [NSLayoutConstraint]()
    
    
    //MARK: Binding method
    
    /// Sets the cell's dataset.
    /**
     Binds an action to this cell.
     
     - parameter upNext: the action to be displayed, nil if one isn't available.
     - parameter progress: the progress object, for being able to tell if the lack of action is
    due to the user not having actions in his dataset or having completed them all.
     */
    func bind(upNext: Action?, progress: FeedData.Progress?){
        if upNext == nil{
            addDescription()
            if progress == nil ||  progress!.getTotalActions() == 0{
                actionTitle.text = "No activities selected for today"
                actionDescription.text = "Select a goal to get started"
            }
            else{
                actionTitle.text = "No activities remaining today"
                actionDescription.text = "See you tomorrow"
            }
        }
        else{
            actionTitle.text = upNext!.getTitle()
            if upNext is UserAction{
                addDescription()
                var description = (upNext as! UserAction).getDescription()
                if description.characters.count > 30{
                    description = "\(description.chopAt(30))..."
                }
                actionDescription.text = description
            }
            else{
                removeDescription()
            }
        }
    }
    
    private func addDescription(){
        if !descriptionConstraints.isEmpty{
            actionContainer.addSubview(actionDescription)
            for constraint in descriptionConstraints{
                actionContainer.addConstraint(constraint)
            }
            descriptionConstraints.removeAll()
        }
    }
    
    private func removeDescription(){
        if descriptionConstraints.isEmpty{
            for constraint in actionContainer.constraints{
                if constraint.belongsTo(actionDescription){
                    descriptionConstraints.append(constraint)
                }
            }
            actionDescription.removeFromSuperview()
        }
    }
}
