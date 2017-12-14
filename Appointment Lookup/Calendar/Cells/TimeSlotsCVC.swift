//
//  TimeSlotsCVC.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 8/8/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TimeSlotsCVC: UICollectionViewController {
    
    private let reuseIdentifier = "TimeSlotCell"
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(appointmentDate)
        setupTimeSlotter()
        navBarDropShadow()
        ref = Database.database().reference()
        let timeSlot = TimeSlot()
        timeSlot.time = "8.00"
        timeSlot.slot = 10
        self.TimeSlotList.append(timeSlot)
        print(self.keyString)
         self.getKeyString()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        navBarNoShadow()
    }
   
    
    
    
    public func getKeyString(){
        print("--started;;-")
        ref.child("timeSlots").observeSingleEvent(of: .value, with: { (snapShot) in
            if let snapDict = snapShot.value as? [String:AnyObject]{
                for each in snapDict{
                    let userEmail = each.value["user"] as! String
                    if(userEmail == (Auth.auth().currentUser?.email)!)
                    {
                        self.keyString = each.key
                        print("key selected")
                        self.getAllTimeSlots()
                    }
                }
            }
        })
    }
    
    public func getAllTimeSlots(){
        self.TimeSlotList.removeAll()
        print("started with keystring", self.keyString )
        ref.child("timeSlots").child(self.keyString).child("12-21-2017").observeSingleEvent(of: .value, with: { (snapShot) in
            if let snapDict = snapShot.value as? [String:AnyObject]{
                for each in snapDict{
                    let timeSlot = TimeSlot()
                    timeSlot.time = each.key
                    timeSlot.slot = each.value as! Int
                    self.TimeSlotList.append(timeSlot)
                    self.TimeSlotList.sort { $0.time.compare($1.time, options: .numeric) == .orderedAscending }
                    
                }
                print("count","",self.TimeSlotList.count)
                self.calendarView.reloadData()
//                self.calendarView.reloadSections(<#T##sections: IndexSet##IndexSet#>)
                self.collectionView?.reloadSections(IndexSet(integer : 0))
            }
        })
        
    }
    
    func setupTimeSlotter() {
        timeSlotter.configureTimeSlotter(openTimeHour: 9, openTimeMinutes: 0, closeTimeHour: 17, closeTimeMinutes: 0, appointmentLength: 30, appointmentInterval: 15)
        //    if let appointmentsArray = currentAppointments {
        //     // timeSlotter.currentAppointments = appointmentsArray.map { $0.date }
        //    }
        //    guard let timeSlots = timeSlotter.getTimeSlotsforDate(date: appointmentDate) else {
        //      print("There is no appointments")
        //      return }
        //
        //    self.timeSlots = timeSlots
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TimeSlotCell
        
        if cell.isSelected {
            cell.timeSlotView.backgroundColor = UIColor(red: 205, green: 141, blue: 254, alpha: 1)
            cell.timeLabel.textColor = .white
        }
        
        if(TimeSlotList.count>0)
        {
        //let timeSlot =/ timeSlots[indexPath.row]
        formatter.dateFormat = "H:mm"
        cell.timeLabel.text = TimeSlotList[indexPath.row].time
        print("----" , self.TimeSlotList.count)
        }
        return cell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("this one selected")
        //    if let destinationVC = self.navigationController?.viewControllers[0] as?  NewApptTableViewController {
        //      destinationVC.selectedTimeSlot = timeSlots[indexPath.row]
        //      self.navigationController?.popViewController(animated: true)
        //    } else if let destinationVC = self.navigationController?.viewControllers[0] as? UpdateApptTVC {
        //      destinationVC.selectedTimeSlot = timeSlots[indexPath.row]
        //      self.navigationController?.popViewController(animated: true)
        //    }
    }
    
}




