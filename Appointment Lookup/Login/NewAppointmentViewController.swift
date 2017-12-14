//
//  NewAppointmentViewController.swift
//  Appointment Lookup
//
//  Created by Nainesh Patel on 12/13/17.
//  Copyright © 2017 Nainesh Patel. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class NewAppointmentViewController: UIViewController {
    
    @IBOutlet weak var NameTextField: UITextField!
    var ref: DatabaseReference! = Database.database().reference()
    var keyString: String = "NULL"
    @IBOutlet weak var ChargeTextField: UITextField!
    @IBOutlet weak var timeAndDateSelector: UIDatePicker!
    @IBOutlet weak var NotesTextArea: UITextView!
    @IBOutlet weak var PhoneTextField: UITextField!
    
    var timeSelected = ""
    @IBAction func addAppointment(_ sender: Any) {
        let name = NameTextField.text!
        let charge: Double? = Double(ChargeTextField.text!) ?? 0.0
        let timeAndDate = self.timeAndDateSelector.date
        let notes = NotesTextArea.text!
        bookAppointment(name,charge!,timeAndDate,notes)
        
        print("----------",name,150,timeAndDate,notes)
    }
    
    func setKeyString() {
        ref.child("timeSlots").observeSingleEvent(of: .value, with: { (snapShot) in
            //print(snapShot)
            if let snapDict = snapShot.value as? [String:AnyObject]{
                for each in snapDict{
                    let userEmail = each.value["user"] as! String
                    if(userEmail == (Auth.auth().currentUser?.email)!)
                    {
                        self.keyString = each.key
                        print(self.keyString, "-- init")
                        return;
                    }
                }
                //self.setTimeSlot()
            }
            
        })
        return;
    }
    
    func bookAppointment(_ name: String,_ charge: Double, _ timeAndDate: Date, _ notes: String){
        print("----------",name,150,timeAndDate,notes)
        print(timeAndDate)
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: timeAndDate)
        let hour = comp.hour
        let minute = comp.minute
        let times = String(hour!) + ":" + String(minute!)
        print(times)
        let date:String = dateFormat.string(from: timeAndDate)
        print(date);
        ref.child("timeSlots").child(self.keyString).child(date).observeSingleEvent(of: .value, with: { (snapShot) in
            print(snapShot)
            if let snapDict = snapShot.value as? [String:AnyObject]{
                for each in snapDict{
                    if(each.key == times)
                    {
                        let appointment = each.value as! Int
                        if(appointment > 0)
                        {
                            self.updateTimeSlot(date,times,appointment - 1)
                            //let appointmentKey = self.ref.childByAutoId().key;
                            let appointment = [ "name": name,
                                                "notes": notes,
                                                "charge": charge,
                                                "time": times,
                                                "phone": self.PhoneTextField.text!
                                                ] as [String : Any]
                            
                            self.ref.child("appointments").child(self.keyString).child(date).childByAutoId().setValue(appointment)
                            print("APPOINTMENT BOOKED")
                        }
                    }
                }
            }
        })
    }
    
    func updateTimeSlot(_ date: String,_ time: String,_ slot: Int){
        print("-- time slot changed --")
        self.ref.child("timeSlots").child(keyString).child(date).child(time).setValue(slot)
    }
    
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setKeyString()
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
