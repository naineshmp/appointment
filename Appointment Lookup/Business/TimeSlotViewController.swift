//
//  TimeSlotViewController.swift
//  Appointment Lookup
//
//  Created by Nainesh Patel on 12/11/17.
//  Copyright © 2017 Nainesh Patel. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TimeSlotViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.TimeSlotList.count
    }
    

    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBAction func changeDate(_ sender: UIDatePicker) {
        print("date changed..", sender.date)
        self.TimeSlotList.removeAll()
        self.tableView.reloadData()
        keyDate = self.getDateString(date: sender.date)
        print(keyDate)
        self.getAllTimeSlots(self.getDateString(date: sender.date))
    }
    
    
    @IBOutlet weak var datePicker: UINavigationItem!
    @IBOutlet weak var numberOfSlots: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var queue = DispatchQueue(label: "Main ", qos: .utility)
    var keyDate:String = "NULL"
    
    var TimeSlotList = Array<TimeSlot>()
    var ref: DatabaseReference!
    var keyString: String = "NULL"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeSlotCell", for: indexPath) as! TimeSlotTabelViewCell
        if(TimeSlotList.count>0)
        {
            cell.Time.text = TimeSlotList[indexPath.row].time
            cell.Slot.text = "\(TimeSlotList[indexPath.row].slot)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    
    @IBAction func updateClicked(_ sender: Any) {
        let date = timePicker.date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        //print(dateFormat.string(from: date))
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: date)
        let hour = comp.hour
        let minute = comp.minute
        let times = String(hour!) + ":" + String(minute!)
        let numberSlot = Int(numberOfSlots.text!)

        addTimeToFirebase(id: keyString, time: times, slot: numberSlot!)
        getAllTimeSlots(keyDate)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        keyDate = getDateString(date: Date())
        print("--", keyDate)
        // Do any additional setup after loading the view.
    }
    
    func getDateString(date: Date) -> String{
     let dateFormat = DateFormatter()
    dateFormat.dateFormat = "MM-dd-yyyy"
    return dateFormat.string(from: date)
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0
        let userCalendar = Calendar.current // user calendar
        let someDateTime = userCalendar.date(from: dateComponents)
        timePicker.date = someDateTime!
        numberOfSlots.text = "0"
        ref = Database.database().reference()
        checkExisting()
        print(self.keyString)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkExisting() {
        ref.child("timeSlots").observeSingleEvent(of: .value, with: { (snapShot) in
            print(snapShot)
            if let snapDict = snapShot.value as? [String:AnyObject]{
                for each in snapDict{
                    let userEmail = each.value["user"] as! String
                    if(userEmail == (Auth.auth().currentUser?.email)!)
                    {
                        self.keyString = each.key
                        self.getAllTimeSlots(self.keyDate)
                        print(self.keyString, "-- init")
                        return;
                    }
                }
                self.setTimeSlot()
            }
            else{
                self.setTimeSlot()
            }
        })
        return;
    }
    
    func setTimeSlot(){
        ref = Database.database().reference()
        let reference = ref.child("timeSlots")
        let key = reference.childByAutoId().key;
        keyString = key
        getAllTimeSlots(keyDate)
        self.ref.child("timeSlots").child(key).child("user").setValue((Auth.auth().currentUser?.email)!)
    }
    
    func addTimeToFirebase(id: String, time: String, slot: Int){
        self.ref.child("timeSlots").child(id).child(keyDate).child(time).setValue(slot)
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
    
    public func getAllTimeSlots(_ date: String){
        getKeyString()
        self.TimeSlotList.removeAll()
        print("started with keystring", date )
        ref.child("timeSlots").child(self.keyString).child(date).observeSingleEvent(of: .value, with: { (snapShot) in
            if let snapDict = snapShot.value as? [String:AnyObject]{
                for each in snapDict{
                    let timeSlot = TimeSlot()
                    timeSlot.time = each.key
                    timeSlot.slot = each.value as! Int
                    self.TimeSlotList.append(timeSlot)
                    self.TimeSlotList.sort { $0.time.compare($1.time, options: .numeric) == .orderedAscending }
                }
                self.tableView.reloadData()
            }
        })
        
    }
    
}



