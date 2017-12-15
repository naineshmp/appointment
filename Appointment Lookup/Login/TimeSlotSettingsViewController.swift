//
//  TimeSlotSettingsViewController.swift
//  Appointment Lookup
//
//  Created by Nainesh Patel on 12/14/17.
//  Copyright © 2017 Nainesh Patel. All rights reserved.
//

import UIKit

class TimeSlotSettingsViewController: UIViewController, UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string:String) -> Bool {
        return false
    }
    

    @IBOutlet weak var endTimeSettings: UITextField!
    @IBOutlet weak var startTimeSettings: UITextField!
     let startPicker = UIDatePicker()
    let endPicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startPicker.datePickerMode = UIDatePickerMode.time
        endPicker.datePickerMode = UIDatePickerMode.time
       startPicker.minuteInterval = 30
        endPicker.minuteInterval = 30
//        thePicker.delegate = self
//        thePicker.dataSource = self
        startTimeSettings.delegate = self
        
        let startToolBar = UIToolbar()
        startToolBar.barStyle = UIBarStyle.default
        startToolBar.isTranslucent = true
        startToolBar.tintColor = UIColor.black
        startToolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TimeSlotSettingsViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        startToolBar.setItems([ spaceButton, doneButton], animated: false)
        startToolBar.isUserInteractionEnabled = true
        
        let endToolBar = UIToolbar()
        endToolBar.barStyle = UIBarStyle.default
        endToolBar.isTranslucent = true
        endToolBar.tintColor = UIColor.black
        endToolBar.sizeToFit()
        let endDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TimeSlotSettingsViewController.endDonePicker))
        let endSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        endToolBar.setItems([ endSpaceButton, endDoneButton], animated: false)
        endToolBar.isUserInteractionEnabled = true
        
        startTimeSettings.inputView = startPicker
        startTimeSettings.inputAccessoryView = startToolBar

        endTimeSettings.inputView = endPicker
        endTimeSettings.inputAccessoryView = endToolBar
        // Do any additional setup after loading the view.
    }
    
    
    @objc func donePicker() {
        
        let date = startPicker.date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        //print(dateFormat.string(from: date))
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: date)
        let hour = comp.hour
        let minute = comp.minute
        let times = String(hour!) + ":" + String(minute!)
        startTimeSettings.text = times
        view.endEditing(true)
    }
    
    @objc func endDonePicker() {
        let date = endPicker.date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        //print(dateFormat.string(from: date))
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: date)
        let hour = comp.hour
        let minute = comp.minute
        let times = String(hour!) + ":" + String(minute!)
        endTimeSettings.text = times
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
