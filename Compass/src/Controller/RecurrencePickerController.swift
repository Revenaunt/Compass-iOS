//
//  RecurrencePickerController.swift
//  Compass
//
//  Created by Ismael Alonso on 10/18/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit


class RecurrencePickerController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    var delegate: RecurrencePickerControllerDelegate?
    
    @IBOutlet weak var monthdayPicker: UIPickerView!
    @IBOutlet weak var weekdayPicker: UIPickerView!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        var rrule = ""
        var display = ""
        if indexPath.row == 1{
            rrule = "RRULE:FREQ=DAILY;INTERVAL=1"
            display = "Daily"
        }
        else if indexPath.row == 2{
            let row = weekdayPicker.selectedRowInComponent(0)
            rrule = "RRULE:FREQ=WEEKLY;INTERVAL=1;\(getRRuleWeekday(row))"
            display = "Weekly, \(getRRuleWeekdayDisplay(row))"
        }
        else if indexPath.row == 3{
            let row = weekdayPicker.selectedRowInComponent(0)
            rrule = "RRULE:FREQ=WEEKLY;INTERVAL=2;\(getRRuleWeekday(row))"
            display = "Biweekly, \(getRRuleWeekdayDisplay(row))"
        }
        else if indexPath.row == 4{
            let row = monthdayPicker.selectedRowInComponent(0)
            rrule = "RRULE:FREQ=MONTHLY;BYMONTHDAY=\(row+1);INTERVAL=1"
            display = "Monthly, \(getRRuleMonthDayDisplay(row+1))"
        }
        
        if delegate != nil{
            delegate!.onRecurrencePicked(rrule, display: display)
        }
        navigationController!.popViewControllerAnimated(true)
    }
    
    private func getRRuleWeekday(index: Int) -> String{
        if index == 0{
            return "MO"
        }
        if index == 1{
            return "TU"
        }
        if index == 2{
            return "WE"
        }
        if index == 3{
            return "TH"
        }
        if index == 4{
            return "FR"
        }
        if index == 5{
            return "SA"
        }
        return "SU"
    }
    
    private func getRRuleWeekdayDisplay(index: Int) -> String{
        if index == 0{
            return "Monday"
        }
        if index == 1{
            return "Tuesday"
        }
        if index == 2{
            return "Wednesday"
        }
        if index == 3{
            return "Thursday"
        }
        if index == 4{
            return "Friday"
        }
        if index == 5{
            return "Saturday"
        }
        return "Sunday"
    }
    
    private func getRRuleMonthDayDisplay(day: Int) -> String{
        var tail = "th"
        if (day/10 != 1){
            if day%10 == 1{
                tail = "st"
            }
            if day%10 == 2{
                tail = "nd"
            }
            if day%10 == 3{
                tail = "rd"
            }
        }
        return "\(day)\(tail)"
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == weekdayPicker{
            return 7
        }
        if pickerView == monthdayPicker{
            return 31
        }
        return 0
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if pickerView == weekdayPicker{
            return getRRuleWeekdayDisplay(row)
        }
        else if pickerView == monthdayPicker{
            return "\(row+1)"
        }
        return ""
    }
}


protocol RecurrencePickerControllerDelegate{
    func onRecurrencePicked(rrule: String, display: String)
}
