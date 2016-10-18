//
//  TriggerController.swift
//  Compass
//
//  Created by Ismael Alonso on 10/17/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class TriggerController: UIViewController, UIGestureRecognizerDelegate{
    
    //MARK: Data
    
    var action: Action!
    
    //MARK: UI components
    
    @IBOutlet weak var actionTitle: UILabel!
    @IBOutlet weak var triggerSwitch: UISwitch!
    @IBOutlet weak var timeContainer: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateContainer: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var recurrenceContainer: UIView!
    @IBOutlet weak var recurrenceLabel: UILabel!
    
    //MARK: Formatters
    
    private let timeFormat = NSDateFormatter()
    private let dateFormat = NSDateFormatter()
    
    
    //MARK: Lifecycle methods
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //Set up the clickables
        let timeTap = UITapGestureRecognizer(target: self, action: #selector(ActionController.handleTap(_:)))
        timeTap.delegate = self
        timeContainer.addGestureRecognizer(timeTap)
        
        let dateTap = UITapGestureRecognizer(target: self, action: #selector(ActionController.handleTap(_:)))
        dateTap.delegate = self
        dateContainer.addGestureRecognizer(dateTap)
        
        let recurrenceTap = UITapGestureRecognizer(target: self, action: #selector(ActionController.handleTap(_:)))
        recurrenceTap.delegate = self
        recurrenceContainer.addGestureRecognizer(recurrenceTap)
        
        //Set the formatters' formats
        timeFormat.dateFormat = "h:mm a"
        dateFormat.dateFormat = "MMM d yyyy"
        
        var trigger = action.getTrigger()
        if trigger == nil{
            trigger = Trigger()
        }
        action.setTrigger(trigger!)
        
        //Set the state of the form
        title = action.getGoalTitle()
        actionTitle.text = action.getTitle()
        triggerSwitch.setOn(trigger!.isEnabled(), animated: false)
        if trigger!.hasTime(){
            timeLabel.text = trigger!.getFormattedTime(timeFormat)
        }
        if trigger!.hasDate(){
            dateLabel.text = trigger!.getFormattedDate(dateFormat)
        }
        if trigger!.hasRecurrence(){
            recurrenceLabel.text = trigger!.getRecurrenceDisplay()
        }
    }
    
    
    //MARK: Tap detection
    
    func handleTap(sender: UITapGestureRecognizer?){
        if sender?.view == timeContainer{
            
        }
        else if sender?.view == dateContainer{
            
        }
        else if sender?.view == recurrenceContainer{
            
        }
    }
    
    
    //MARK: UI actions
    
    @IBAction func onStateChange(){
        if !triggerSwitch.on{
            //disable, save, pop
        }
    }
    
    @IBAction func done(){
        save()
    }
    
    
    //MARK: Saving a trigger
    
    private func save(){
        
    }
}
