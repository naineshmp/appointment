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
        var time = offsetFrom(startDate: startPicker.date, endDate: endPicker.date)
        setTimeSlots(time: time)
        
        
    }
    func dateToString(date : Date) -> String{
        let date = date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        //print(dateFormat.string(from: date))
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: date)
        let hour = comp.hour
        let minute = comp.minute
        let times = String(hour!) + ":" + String(minute!)
        return times
    }
    
    func setTimeSlots(time :String){
        var timeString = time.components(separatedBy: " ")
        var minutes = Int(timeString[0])
        var noOfSlots = minutes!/30
        print(noOfSlots," == no of slots")
        var Slots = [TimeSlot]()
        
        var currentTime = dateToString(date: self.startPicker.date)
        var date = self.startPicker.date
        for i in 0...noOfSlots-1{
            var newSlot = TimeSlot()
            let newTime = date.addingTimeInterval(30 * 60 * Double(i))
            //print(newTime)
            newSlot.time = dateToString(date: newTime)
            newSlot.slot = 2
            Slots.append(newSlot)
            print(newSlot.time,"+",newSlot.slot)
        }
        print("Slots")
    }
    func offsetFrom(startDate: Date, endDate : Date) -> String {
        
        let previousDate = startDate
        let now = endDate
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.minute, .second]
        formatter.maximumUnitCount = 2
        
        let string = formatter.string(from: previousDate, to: now)
        print(string,"Difference")
        return string!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

