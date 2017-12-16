//
//  AppointmentDetailCustomer.swift
//  Appointment Lookup
//
//  Created by Nainesh Patel on 12/15/17.
//  Copyright © 2017 Nainesh Patel. All rights reserved.
//


import UIKit
import FirebaseAuth
import FirebaseDatabase

class AppointmentDetailCustomer: UIViewController {
    
    var ref: DatabaseReference!
    var keyString: String = ""
    var keyDate: String = ""
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var chargeLabel: UILabel!
    @IBOutlet weak var notesLabel: UITextView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var customerName: UILabel!
    var appointmentId:String  = ""
    
    func getData() {
        ref.child("timeSlots").observeSingleEvent(of: .value, with: { (snapShot) in
            //print(snapShot)
            if let snapDict = snapShot.value as? [String:AnyObject]{
                for each in snapDict{
                    let userEmail = each.value["user"] as! String
                    if(userEmail == (Auth.auth().currentUser?.email)!)
                    {
                        self.keyString = each.key
                        print(self.keyString, "-- init")
                    }
                }
                self.getAppointment()
            }
            
        })
        return;
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        reloadInputViews()
    }
    
    public func getAppointment(){
        print("started with keystring", self.keyString )
        ref.child("appointments").child(self.keyString).child(self.keyDate).child(self.appointmentId).observeSingleEvent(of: .value, with: { (snapShot) in
            
            print(snapShot)
            if let snapDict = snapShot.value as? [String:AnyObject]{
                for each in snapDict{
                    print(each)
                    switch(each.key)
                    {
                    case "name":
                        self.customerName.text = each.value as? String
                    case "notes":
                        self.notesLabel.text = each.value as? String
                    case "phone":
                        self.phoneLabel.text = each.value as? String
                    case "charge":
                        self.chargeLabel.text = "\(each.value as! Double)"
                    case "time":
                        self.timeLabel.text = each.value as? String
                    default:
                        print("")
                    }
                    self.date.text = self.keyDate
                    
                    self.reloadInputViews()
                    
                }
                
            }
        })
        
    }
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
        
        self.notesLabel.isEditable = false
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
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

