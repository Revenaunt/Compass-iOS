//
//  PickerController.swift
//  Compass
//
//  Created by Ismael Alonso on 8/16/16.
//  Copyright © 2016 Tennessee Data Commons. All rights reserved.
//

import UIKit;


class PickerController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    @IBOutlet weak var picker: UIPickerView!
    
    var delegate: SettingsController!;
    
    
    override func viewDidLoad(){
        picker.selectRow(SharedData.user.getDailyNotificationLimit(), inComponent: 0, animated: false);
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1;
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return 21;
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return "\(row)";
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        delegate.selectedLimit = row;
    }
}
