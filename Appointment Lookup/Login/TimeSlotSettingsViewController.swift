//
//  TimeSlotSettingsViewController.swift
//  Appointment Lookup
//
//  Created by Nainesh Patel on 12/14/17.
//  Copyright © 2017 Nainesh Patel. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class TimeSlotSettingsViewController: UIViewController, UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string:String) -> Bool {
        return false
    }
    
    @IBOutlet weak var selectedDateTextField: UITextField!
    
    @IBOutlet weak var endTimeSettings: UITextField!
    @IBOutlet weak var startTimeSettings: UITextField!
    let startPicker = UIDatePicker()
    let endPicker = UIDatePicker()
    let datePicker = UIDatePicker()
    var endTime = ""
    @IBOutlet weak var NumOfSlots: UITextField!
    var ref: DatabaseReference!
    var keyString:String = ""
    var dateString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        startPicker.datePickerMode = UIDatePickerMode.time
        endPicker.datePickerMode = UIDatePickerMode.time
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.date = Date()
        startPicker.minuteInterval = 30
        endPicker.minuteInterval = 30
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0
        var userCalendar = Calendar.current
        var someDateTime = userCalendar.date(from: dateComponents)
        startPicker.date = someDateTime!
        
        dateComponents.hour = 16
        dateComponents.minute = 0
        userCalendar = Calendar.current
        someDateTime = userCalendar.date(from: dateComponents)
        endPicker.date = someDateTime!
        
        startTimeSettings.delegate = self
        selectedDateTextField.delegate = self
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
        
        let date = startPicker.date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        self.dateString = dateFormat.string(from: Date())
        selectedDateTextField.text = self.dateString
        getToolBarForDate()
        startTimeSettings.inputView = startPicker
        startTimeSettings.inputAccessoryView = startToolBar
        endTimeSettings.inputView = endPicker
        endTimeSettings.inputAccessoryView = endToolBar
        getKeyString()
        // Do any additional setup after loading the view.
    }
    
    func getToolBarForDate()
    {
        let endToolBar = UIToolbar()
        endToolBar.barStyle = UIBarStyle.default
        endToolBar.isTranslucent = true
        endToolBar.tintColor = UIColor.black
        endToolBar.sizeToFit()
        let endDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TimeSlotSettingsViewController.selectedDatePickerDone))
        let endSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        endToolBar.setItems([ endSpaceButton, endDoneButton], animated: false)
        endToolBar.isUserInteractionEnabled = true
        selectedDateTextField.inputView = datePicker
        selectedDateTextField.inputAccessoryView = endToolBar
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
    
    @IBAction func SaveToDB(_ sender: UIButton) {
        
        var time = offsetFrom(startDate: startPicker.date, endDate: endPicker.date)
        setTimeSlots(time: time)
        
        
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
    
    @objc func selectedDatePickerDone() {
        let date = datePicker.date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        //print(dateFormat.string(from: date))
        self.dateString = dateFormat.string(from: date)
        print("-- DATE SELECTED", dateString)
        selectedDateTextField.text = self.dateString
        view.endEditing(true)
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
    
    public func getKeyString(){
        ref.child("timeSlots").observeSingleEvent(of: .value, with: { (snapShot) in
            if let snapDict = snapShot.value as? [String:AnyObject]{
                for each in snapDict{
                    let userEmail = each.value["user"] as! String
                    if(userEmail == (Auth.auth().currentUser?.email)!)
                    {
                        self.keyString = each.key
                        return
                    }
                }
            }
        })
    }
    
    
    
    func setTimeSlots(time :String){
        print(dateString, "in time slot")
        var timeString = time.components(separatedBy: " ")
        var minutes = Int(timeString[0])
        var noOfSlots = minutes!/30
        print(noOfSlots," == no of slots")
        var Slots = [TimeSlot]()
        var val = 2
        if NumOfSlots.text != ""{
            val = Int(NumOfSlots.text!)!
        }
        var currentTime = dateToString(date: self.startPicker.date)
        var date = self.startPicker.date
        
        if(noOfSlots>0){
            for i in 0...noOfSlots-1{
                var newSlot = TimeSlot()
                let newTime = date.addingTimeInterval(30 * 60 * Double(i))
                //print(newTime)
                newSlot.time = dateToString(date: newTime)
                newSlot.slot = val
                print("-key-", keyString, "dat", self.dateString, newSlot.time, newSlot.slot)
                self.ref.child("timeSlots").child(self.keyString).child(self.selectedDateTextField.text!).child(newSlot.time).setValue(newSlot.slot)
                print(newSlot.time,"+",newSlot.slot)
            }
            print("Slots")
        }
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

