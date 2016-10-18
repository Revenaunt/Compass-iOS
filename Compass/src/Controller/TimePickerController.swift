//
//  TimePickerController.swift
//  Compass
//
//  Created by Ismael Alonso on 10/18/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class TimePickerController: UIViewController{
    var delegate: TimePickerControllerDelegate?
    var date: NSDate?
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if date != nil{
            timePicker.setDate(date!, animated: false)
        }
    }
    
    override func viewWillDisappear(animated: Bool){
        if delegate != nil{
            delegate!.onTimePicked(timePicker.date)
        }
        super.viewWillDisappear(animated)
    }
}


protocol TimePickerControllerDelegate{
    func onTimePicked(time: NSDate)
}
