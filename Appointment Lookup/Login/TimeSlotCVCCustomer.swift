    //
    //  TimeSlotCVCCustomer.swift
    //  Appointment Lookup
    //
    //  Created by Nainesh Patel on 12/15/17.
    //  Copyright © 2017 Nainesh Patel. All rights reserved.
    //
    
    import UIKit
    import FirebaseDatabase
    import FirebaseAuth
    
    class TimeSlotCVCCustomer: UICollectionViewController {
        private let reuseIdentifier = "TimeSlotCell2"
        var keyDate:String = ""
        var name: String = ""
        var phone: String = ""
        var notes: String = ""
        var selectedTimeSlot: Int = 0
        var businessId: String = ""
        @IBOutlet var calendarView: UICollectionView!
        
        var timeSlotter = TimeSlotter()
        var appointmentDate: Date!
        var formatter = DateFormatter()
        var timeSlots = [Date]()
        let currentDate = Date()
        var currentAppointments: [Appointment]?
        
        var TimeSlotList = Array<TimeSlot>()
        var ref: DatabaseReference!
        var keyString: String = "NULL"
        var selectedTime = ""
        override func viewDidLoad() {
            print(keyDate,"----- date passed")
            super.viewDidLoad()
            print(appointmentDate)
            navBarDropShadow()
            ref = Database.database().reference()
            print(self.keyString)
            self.getKeyString()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            
            navBarNoShadow()
        }
        
        
        @IBAction func SetTime(_ sender: UIButton) {
            selectedTime = (sender.titleLabel?.text!)!
            selectedTimeSlot = getAvailableSlots()
            performSegue(withIdentifier: "toAppointmentsCustomer", sender: sender)
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toAppointmentsCustomer" {
                if let toViewController = segue.destination as? CustomerNewApptTableViewController {
                    
                    toViewController.selectedTime = self.selectedTime
                    toViewController.selectedDate = self.keyDate
                    toViewController.notes = self.notes
                    toViewController.phone = self.phone
                    toViewController.name = self.name
                    toViewController.slots = self.selectedTimeSlot
                    toViewController.businessId = self.businessId
                    print(toViewController.selectedTime)
                }
            }
        }
        
        func getAvailableSlots() -> Int{
            let first =  self.TimeSlotList.first(where: {$0.time == selectedTime})
            return (first?.slot)!
        }
        
        public func getKeyString(){
            print("--started;;-")
            ref.child("timeSlots").observeSingleEvent(of: .value, with: { (snapShot) in
                if let snapDict = snapShot.value as? [String:AnyObject]{
                    for each in snapDict{
                        let userEmail = each.value["user"] as! String
                        if(userEmail == self.businessId)
                        {
                            self.keyString = each.key
                            self.getAllTimeSlots()
                        }
                    }
                }
            })
        }
        
        public func getAllTimeSlots(){
            self.TimeSlotList.removeAll()
            print("started with keystring", self.keyString )
            ref.child("timeSlots").child(self.keyString).child(keyDate).observeSingleEvent(of: .value, with: { (snapShot) in
                let x = snapShot.value
                print(x,"------ this needs to be checked")
                if x is NSNull
                {
                    let alertController = UIAlertController(title: "UNAVAILABLE", message: "SORRY WE ARE BOOKED FOR THE DAY!", preferredStyle: UIAlertControllerStyle.actionSheet)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                if let snapDict = snapShot.value as? [String:AnyObject]{
                   
                    for each in snapDict{
                        let timeSlot = TimeSlot()
                        timeSlot.time = each.key
                        timeSlot.slot = each.value as! Int
                        if(timeSlot.slot>0)
                        {
                            self.TimeSlotList.append(timeSlot)
                        }
                        
                        
                        
                    }
                    self.TimeSlotList.sort { $0.time.compare($1.time, options: .numeric) == .orderedAscending }
                    print("count","",self.TimeSlotList.count)
                    self.calendarView.reloadData()
                   
                    //                self.calendarView.reloadSections()
                    self.collectionView?.reloadSections(IndexSet(integer : 0))
                }
                
            })
            
        }
  
        
        func navBarDropShadow() {
            self.navigationController?.navigationBar.layer.masksToBounds = false
            self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
            self.navigationController?.navigationBar.layer.shadowOpacity = 0.2
            self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
            self.navigationController?.navigationBar.layer.shadowRadius = 4
        }
        
        func navBarNoShadow(){
            self.navigationController?.navigationBar.layer.masksToBounds = true
            self.navigationController?.navigationBar.layer.shadowColor = .none
            self.navigationController?.navigationBar.layer.shadowOpacity = 0
            self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.navigationController?.navigationBar.layer.shadowRadius = 0
        }
        
        
        override func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.TimeSlotList.count
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TimeSlotCell2
            
            if(TimeSlotList.count>0)
            {
                
                //let timeSlot =/ timeSlots[indexPath.row]
                formatter.dateFormat = "H:mm"
                cell.button.setTitle(TimeSlotList[indexPath.row].time, for: UIControlState.normal)
                
                print("----" , TimeSlotList[indexPath.row].time)
            }
            return cell
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
        
        
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            print("this one selected")
            
        }
        
}


