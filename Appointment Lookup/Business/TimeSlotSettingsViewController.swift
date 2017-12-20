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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string:String) -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        startPicker.datePickerMode = UIDatePickerMode.time
        endPicker.datePickerMode = UIDatePickerMode.time
        datePicker.datePickerMode = UIDatePickerMode.date
        startTimeSettings.text = "8:0"
        endTimeSettings.text = "16:0"
        self.NumOfSlots.text = "2"
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
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        self.dateString = dateFormat.string(from: Date())
        selectedDateTextField.text = self.dateString
        getToolBarForDate()
        startTimeSettings.inputView = startPicker
        startTimeSettings.inputAccessoryView = startToolBar
        endTimeSettings.inputView = endPicker
        endTimeSettings.inputAccessoryView = endToolBar
        NumOfSlots.keyboardType = UIKeyboardType.numberPad
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
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: date)
        let hour = comp.hour
        let minute = comp.minute
        let times = String(hour!) + ":" + String(minute!)
        startTimeSettings.text = times
        view.endEditing(true)
    }
    
    @IBAction func SaveToDB(_ sender: UIButton) {
        let time = offsetFrom(startDate: startPicker.date, endDate: endPicker.date)
        getKeyString(time: time)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func endDonePicker() {
        let date = endPicker.date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: date)
        let hour = comp.hour
        let minute = comp.minute
        let times = String(hour!) + ":" + String(minute!)
        endTimeSettings.text = times
        view.endEditing(true)
    }
    
    func showAlert(_ title1: String,_ message : String,_ title2: String ){
        let alertController = UIAlertController(title: title1, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.addAction(UIAlertAction(title: title2, style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func selectedDatePickerDone() {
        let date = datePicker.date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        self.dateString = dateFormat.string(from: date)
        selectedDateTextField.text = self.dateString
        view.endEditing(true)
    }
    
    func dateToString(date : Date) -> String{
        let date = date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: date)
        let hour = comp.hour
        let minute = comp.minute
        let times = String(hour!) + ":" + String(minute!)
        return times
    }

    public func getKeyString(time: String){
        ref.child("timeSlots").observeSingleEvent(of: .value, with: { (snapShot) in
            if let snapDict = snapShot.value as? [String:AnyObject]{
                for each in snapDict{
                    let userEmail = each.value["user"] as! String
                    if(userEmail == (Auth.auth().currentUser?.email)!)
                    {
                        self.keyString = each.key
                        self.setTimeSlots(time: time)
                    }
                }
            }
        })
    }
    
//    public func getKeyString(time: String){
//        ref.child("timeSlots").observeSingleEvent(of: .value, with: { (snapShot) in
//            print(snapShot)
//            if let snapDict = snapShot.value as? [String:AnyObject]{
//                for each in snapDict{
//                    let userEmail = each.value["user"] as! String
//                    if(userEmail == (Auth.auth().currentUser?.email)!)
//                    {
//                        self.keyString = each.key
//                        self.setTimeSlots(time: time)
//                    }
//                }
//                self.setTimeSlot()
//            }
//            else{
//                self.setTimeSlot()
//            }
//        })
//        return;
//    }
//
//    func setTimeSlot(){
//        ref = Database.database().reference()
//        let reference = ref.child("timeSlots")
//        let key = reference.childByAutoId().key;
//        keyString = key
//        self.ref.child("timeSlots").child(key).child("user").setValue((Auth.auth().currentUser?.email)!)
//    }
    
    
    func setTimeSlots(time :String){
        var timeString = time.components(separatedBy: " ")
        let minutes = Int(timeString[0])
        let noOfSlots = minutes!/30
        var val = 2
        if NumOfSlots.text != ""{
            val = Int(NumOfSlots.text!)!
        }
        let date = self.startPicker.date
        
        if(noOfSlots>0){
            for i in 0...noOfSlots-1{
                let newTime = date.addingTimeInterval(30 * 60 * Double(i))
                self.ref.child("timeSlots").child(self.keyString).child(self.selectedDateTextField.text!).child(dateToString(date: newTime)).setValue(val)
            }
            self.showAlert("Success","Time Slots Added for day " + "\(dateString)" , "Dismiss")
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
        return string!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

