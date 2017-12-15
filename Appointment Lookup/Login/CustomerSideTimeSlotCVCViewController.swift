//
//  CustomerSideTimeSlotCVCViewController.swift
//  Appointment Lookup
//
//  Created by Nainesh Patel on 12/15/17.
//  Copyright © 2017 Nainesh Patel. All rights reserved.
//
import UIKit
import FirebaseDatabase
import FirebaseAuth

class CustomerSideTimeSlotCVCViewController: UIViewController {
//
//    private let reuseIdentifier = "TimeSlotCell"
//    var keyDate:String = ""
//    var name: String = ""
//    var phone: String = ""
//    var notes: String = ""
//    var selectedTimeSlot: Int = 0
//
//
//    var timeSlotter = TimeSlotter()
//    var appointmentDate: Date!
//    var formatter = DateFormatter()
//    var timeSlots = [Date]()
//    let currentDate = Date()
//    var currentAppointments: [Appointment]?
//
//    var TimeSlotList = Array<TimeSlot>()
//    var ref: DatabaseReference!
//    var keyString: String = "NULL"
//    var selectedTime = ""
//    override func viewDidLoad() {
//        print(keyDate,"----- date passed")
//        super.viewDidLoad()
//        print(appointmentDate)
//        setupTimeSlotter()
//        navBarDropShadow()
//        ref = Database.database().reference()
//        print(self.keyString)
//        self.getKeyString()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//
//        navBarNoShadow()
//    }
//
//
//    @IBAction func SetTime(_ sender: UIButton) {
//        selectedTime = (sender.titleLabel?.text!)!
//        selectedTimeSlot = getAvailableSlots()
//        performSegue(withIdentifier: "toNewAppointment", sender: sender)
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toNewAppointment" {
//            if let toViewController = segue.destination as? NewApptTableViewController {
//
//                toViewController.selectedTime = self.selectedTime
//                toViewController.selectedDate = self.keyDate
//                toViewController.notes = self.notes
//                toViewController.phone = self.phone
//                toViewController.name = self.name
//                toViewController.slots = self.selectedTimeSlot
//                print(toViewController.selectedTime)
//            }
//        }
//    }
//
//    func getAvailableSlots() -> Int{
//        let first =  self.TimeSlotList.first(where: {$0.time == selectedTime})
//        return (first?.slot)!
//    }
//
//    public func getKeyString(){
//        print("--started;;-")
//        ref.child("timeSlots").observeSingleEvent(of: .value, with: { (snapShot) in
//            if let snapDict = snapShot.value as? [String:AnyObject]{
//                for each in snapDict{
//                    let userEmail = each.value["user"] as! String
//                    if(userEmail == (Auth.auth().currentUser?.email)!)
//                    {
//                        self.keyString = each.key
//                        print("key selected")
//                        self.getAllTimeSlots()
//                    }
//                }
//            }
//        })
//    }
//
//    public func getAllTimeSlots(){
//        self.TimeSlotList.removeAll()
//        print("started with keystring", self.keyString )
//        ref.child("timeSlots").child(self.keyString).child(keyDate).observeSingleEvent(of: .value, with: { (snapShot) in
//            if let snapDict = snapShot.value as? [String:AnyObject]{
//                for each in snapDict{
//                    let timeSlot = TimeSlot()
//                    timeSlot.time = each.key
//                    timeSlot.slot = each.value as! Int
//                    if(timeSlot.slot>0)
//                    {
//                        self.TimeSlotList.append(timeSlot)
//                    }
//
//
//
//                }
//                self.TimeSlotList.sort { $0.time.compare($1.time, options: .numeric) == .orderedAscending }
//                print("count","",self.TimeSlotList.count)
//                self.calendarView.reloadData()
//                //                self.calendarView.reloadSections()
//                self.collectionView?.reloadSections(IndexSet(integer : 0))
//            }
//        })
//
//    }
//
//    func setupTimeSlotter() {
//        timeSlotter.configureTimeSlotter(openTimeHour: 9, openTimeMinutes: 0, closeTimeHour: 17, closeTimeMinutes: 0, appointmentLength: 30, appointmentInterval: 15)
//        //    if let appointmentsArray = currentAppointments {
//        //     // timeSlotter.currentAppointments = appointmentsArray.map { $0.date }
//        //    }
//        //    guard let timeSlots = timeSlotter.getTimeSlotsforDate(date: appointmentDate) else {
//        //      print("There is no appointments")
//        //      return }
//        //
//        //    self.timeSlots = timeSlots
//    }
//
//    func navBarDropShadow() {
//        self.navigationController?.navigationBar.layer.masksToBounds = false
//        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
//        self.navigationController?.navigationBar.layer.shadowOpacity = 0.2
//        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
//        self.navigationController?.navigationBar.layer.shadowRadius = 4
//    }
//
//    func navBarNoShadow(){
//        self.navigationController?.navigationBar.layer.masksToBounds = true
//        self.navigationController?.navigationBar.layer.shadowColor = .none
//        self.navigationController?.navigationBar.layer.shadowOpacity = 0
//        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.navigationController?.navigationBar.layer.shadowRadius = 0
//    }
//
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.TimeSlotList.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TimeSlotCell
//
//        if(TimeSlotList.count>0)
//        {
//
//            //let timeSlot =/ timeSlots[indexPath.row]
//            formatter.dateFormat = "H:mm"
//            cell.timeSlotButton.setTitle(TimeSlotList[indexPath.row].time, for: UIControlState.normal)
//
//            print("----" , TimeSlotList[indexPath.row].time)
//        }
//        return cell
//    }
//
//
//
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        print("this one selected")
//
//    }
    
}





