//
//  DatePickerController.swift
//  Compass
//
//  Created by Ismael Alonso on 10/18/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class DatePickerController: UIViewController{
    var delegate: DatePickerControllerDelegate?
    var date: NSDate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //TODO: This thing does not work...
        datePicker.minimumDate = NSDate()
        if date != nil{
            datePicker.setDate(date!, animated: false)
        }
    }
    
    override func viewWillDisappear(animated: Bool){
        if delegate != nil{
            delegate!.onDatePicked(datePicker.date)
        }
        super.viewWillDisappear(animated)
    }
}


protocol DatePickerControllerDelegate{
    func onDatePicked(date: NSDate)
}
