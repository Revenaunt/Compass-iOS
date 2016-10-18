//
//  TriggerController.swift
//  Compass
//
//  Created by Ismael Alonso on 10/17/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class TriggerController: UIViewController, UIGestureRecognizerDelegate, TimePickerControllerDelegate, DatePickerControllerDelegate, RecurrencePickerControllerDelegate{
    
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
    
    
    //MARK: Tap detection, segues, and delegate callbacks
    
    func handleTap(sender: UITapGestureRecognizer?){
        if sender?.view == timeContainer{
            performSegueWithIdentifier("TimePickerFromTrigger", sender: self)
        }
        else if sender?.view == dateContainer{
            performSegueWithIdentifier("DatePickerFromTrigger", sender: self)
        }
        else if sender?.view == recurrenceContainer{
            performSegueWithIdentifier("RecurrencePickerFromTrigger", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "TimePickerFromTrigger"{
            let timePickerController = segue.destinationViewController as! TimePickerController
            timePickerController.delegate = self
            timePickerController.date = action.getTrigger()!.getTime()
        }
        else if segue.identifier == "DatePickerFromTrigger"{
            let datePickerController = segue.destinationViewController as! DatePickerController
            datePickerController.delegate = self
            datePickerController.date = action.getTrigger()!.getDate()
        }
        else if segue.identifier == "RecurrencePickerFromTrigger"{
            let recurrencePicker = segue.destinationViewController as! RecurrencePickerController
            recurrencePicker.delegate = self
        }
    }
    
    func onTimePicked(time: NSDate){
        timeLabel.text = timeFormat.stringFromDate(time)
        action.getTrigger()!.setTime(time)
    }
    
    func onDatePicked(date: NSDate){
        dateLabel.text = dateFormat.stringFromDate(date)
        action.getTrigger()!.setDate(date)
    }
    
    func onRecurrencePicked(rrule: String, display: String){
        recurrenceLabel.text = display
        action.getTrigger()!.setRRule(rrule, display: display)
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
