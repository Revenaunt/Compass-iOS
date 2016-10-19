//
//  TriggerController.swift
//  Compass
//
//  Created by Ismael Alonso on 10/17/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit
import Just
import ObjectMapper


/// Controller for the Trigger editor
/**
 Displays current Trigger information and allows the user to modify it.
 
 - Author: Ismael Alonso
 */
class TriggerController: UIViewController, UIGestureRecognizerDelegate{
    
    //MARK: Data
    
    var delegate: TriggerControllerDelegate!
    var action: Action!
    private var trigger = Trigger()
    private var saving = false
    
    //MARK: UI components
    
    @IBOutlet weak var actionTitle: UILabel!
    @IBOutlet weak var triggerSwitch: UISwitch!
    @IBOutlet weak var timeContainer: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateContainer: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var recurrenceContainer: UIView!
    @IBOutlet weak var recurrenceLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var savingIndicator: UIActivityIndicatorView!
    
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
        
        //If the action has a trigger, set it
        if let actionTrigger = action.getTrigger(){
            trigger = actionTrigger
        }
        
        //Set the state of the form
        title = action.getGoalTitle()
        actionTitle.text = action.getTitle()
        triggerSwitch.setOn(trigger.isEnabled(), animated: false)
        if trigger.hasTime(){
            timeLabel.text = trigger.getFormattedTime(timeFormat)
        }
        if trigger.hasDate(){
            dateLabel.text = trigger.getFormattedDate(dateFormat)
        }
        if trigger.hasRecurrence(){
            recurrenceLabel.text = trigger.getRecurrenceDisplay()
        }
    }
    
    
    //MARK: Tap detection and segues
    
    func handleTap(sender: UITapGestureRecognizer?){
        if !saving{
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
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "TimePickerFromTrigger"{
            let timePickerController = segue.destinationViewController as! TimePickerController
            timePickerController.delegate = self
            timePickerController.date = trigger.getTime()
        }
        else if segue.identifier == "DatePickerFromTrigger"{
            let datePickerController = segue.destinationViewController as! DatePickerController
            datePickerController.delegate = self
            datePickerController.date = trigger.getDate()
        }
        else if segue.identifier == "RecurrencePickerFromTrigger"{
            let recurrencePicker = segue.destinationViewController as! RecurrencePickerController
            recurrencePicker.delegate = self
        }
    }
    
    
    //MARK: UI actions
    
    @IBAction func onStateChange(){
        trigger.setEnabled(triggerSwitch.on)
        if !triggerSwitch.on{
            save()
        }
    }
    
    @IBAction func done(){
        save()
    }
    
    
    //MARK: Saving a trigger
    
    /// Saves the state of a Trigger.
    /**
     Disables the form and sends a PUT request to the API with the updated Trigger information
     and decides what to do based on the response. If the request was completed successfully,
     the delegate is called and the controller popped from the stack. If the request failed the
     form is enabled again.
     */
    private func save(){
        //Disable the form
        triggerSwitch.enabled = false
        doneButton.enabled = false
        savingIndicator.hidden = false
        saving = true
        //Send the request
        Just.put(
            API.URL.putTrigger(action),
            json: API.BODY.putTrigger(trigger),
            headers: SharedData.user.getHeaderMap()
        ){ (response) in
            if response.ok{
                //If it worked, deliver
                if self.action is CustomAction{
                    let action = Mapper<CustomAction>().map(response.contentStr)!
                    self.delegate.onTriggerSavedForAction(action)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }
            }
            else{
                //If it didn't work, enable the form
                self.saving = false;
                dispatch_async(dispatch_get_main_queue(), {
                    self.triggerSwitch.enabled = true
                    self.doneButton.enabled = true
                    self.savingIndicator.hidden = true
                    self.saving = false
                })
            }
        }
    }
}


//MARK: Picker delegates

extension TriggerController: TimePickerControllerDelegate{
    func onTimePicked(time: NSDate){
        timeLabel.text = timeFormat.stringFromDate(time)
        trigger.setTime(time)
    }
}

extension TriggerController: DatePickerControllerDelegate{
    func onDatePicked(date: NSDate){
        dateLabel.text = dateFormat.stringFromDate(date)
        trigger.setDate(date)
    }
}

extension TriggerController: RecurrencePickerControllerDelegate{
    func onRecurrencePicked(rrule: String, display: String){
        recurrenceLabel.text = display
        trigger.setRRule(rrule, display: display)
    }
}


/// Delegate for the TriggerController.
/**
 Contains a Trigger delivery function.
 
 - Author: Ismael Alonso.
 */
protocol TriggerControllerDelegate{
    ///Delivers the Trigger inside an Action created from the API response.
    func onTriggerSavedForAction(action: Action)
}
