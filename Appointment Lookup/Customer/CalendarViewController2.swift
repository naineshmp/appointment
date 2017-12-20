//
//  CalendarViewController2.swift
//  Appointment Lookup
//
//  Created by Nainesh Patel on 12/15/17.
//  Copyright © 2017 Nainesh Patel. All rights reserved.
//

//FOR HOME PAGE ON CUSTOMER SIDE....

import UIKit
import CoreData
import JTAppleCalendar
import FirebaseDatabase
import FirebaseAuth

class CalendarViewController2: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    var ref: DatabaseReference!
    @IBOutlet weak var tableView: UITableView!
    var keyString: String = "NULL"
    var keydate: String = "NULL"
    var AppointmentList = Array<Appointment>()
    private let segueApptDetail = "toAppointmentDetailCustomer"
    private var selectedAppointmentId: String = "null"
    let formatter = DateFormatter()
    // Calendar Color
    let outsideMonthColor = UIColor.lightGray
    let monthColor = UIColor.darkGray
    let selectedMonthColor = UIColor.white
    let currentDateSelectedViewColor = UIColor.black
    
    func setKeyString() {
        ref.child("timeSlots").observeSingleEvent(of: .value, with: { (snapShot) in
            print("-- shot per shot")
            if let snapDict = snapShot.value as? [String:AnyObject]{
                print(snapShot, "-------")
                for each in snapDict{
                    let userEmail = each.value["user"] as! String
                    if(userEmail == (Auth.auth().currentUser?.email)!)
                    {
                        self.keyString = each.key
                        print(self.keyString, "-- init")
                        self.getAllBookedProviders(dateEntered: Date()) // 123
                        return;
                    }
                }
                //self.setTimeSlot()
            }
            
        })
        return;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueApptDetail {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let cell = tableView.cellForRow(at: indexPath) as! AppointmentCell2
                let controller = (segue.destination as! AppointmentDetailCustomer)
                controller.appointmentId =  cell.uiLabel.text!
                controller.keyDate = self.keydate
                controller.keyString = cell.businessId.text!
                print("id--",cell.uiLabel.text!)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func getAllBookedProviders(dateEntered: Date)
    {
        self.AppointmentList.removeAll()
        ref.child("appointmentCustomerSide").observeSingleEvent(of: .value, with: { (snapShot) in
            print(snapShot)
            if let snapDict = snapShot.value as? [String:AnyObject]{
                for each in snapDict{
                    let cemail = each.value["customerEmail"] as! String
                    let businessId = each.value["businessId"] as! String
                    self.getAppointmentForDay(dateEntered,businessId,cemail)
                }
                self.tableView.reloadData()
            }
        })
    }
    
    func getAppointmentForDay(_ dateEntered: Date, _ keyString: String, _ email: String ){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        let date:String = dateFormat.string(from: dateEntered)
        ref.child("appointments").child(keyString).child(date).observeSingleEvent(of: .value, with: { (snapShot) in
            print(snapShot)
            if let snapDict = snapShot.value as? [String:AnyObject]{
                for each in snapDict{
                    let user = (Auth.auth().currentUser?.email)!
                    if(each.value["email"] as! String == user){
                    let appointment = Appointment()
                    appointment.appointmentId = each.key
                    appointment.name = each.value["name"] as! String
                    appointment.phone = each.value["phone"] as! String
                    appointment.time = each.value["time"] as! String
                    appointment.notes = each.value["notes"] as! String
                        appointment.businessId = keyString
                    self.AppointmentList.append(appointment)
                    print("Added", self.AppointmentList.count)
                    }
                }
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.setKeyString()
        self.tableView.reloadData()
        print("---view did appear called-")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupCalendarView()
        ref = Database.database().reference()
        setKeyString()
        //calendarView.dropShadowBottom()
        
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates( [Date()] )
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Calendar", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    
    
    
    
    func applicationDidEnterBackground(_ notification: Notification) {
        
    }
    
    
    func noLargeTitles(){
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
            tableView.dragDelegate = self as? UITableViewDragDelegate
        }
    }
}

extension CalendarViewController2: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.AppointmentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell2", for: indexPath) as! AppointmentCell2
        if(AppointmentList.count>0)
        {
            var time = AppointmentList[indexPath.row].time
            if time.range(of:":0") != nil {
                time = time + "0"
                cell.dateLabel.text = time
            }
            else{
                cell.dateLabel.text = AppointmentList[indexPath.row].time
            }
            cell.nameLabel.text = AppointmentList[indexPath.row].name
            cell.noteLabel.text = AppointmentList[indexPath.row].notes
            cell.uiLabel.text = AppointmentList[indexPath.row].appointmentId
            cell.businessId.text = AppointmentList[indexPath.row].businessId
            cell.uiLabel.isHidden = true
            cell.businessId.isHidden = true
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Fetch Appointment
            
        }
    }
    
}



extension CalendarViewController2: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                print("Appt Added")
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                print("Appt Changed and updated")
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            print("...")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
    }
    
}

extension CalendarViewController2 {
    
    
    func fullDayPredicate(for date: Date) -> NSPredicate {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateFrom = calendar.startOfDay(for: date)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dateFrom)
        components.day! += 1
        let dateTo = calendar.date(from: components)
        let datePredicate = NSPredicate(format: "(%@ <= date) AND (date < %@)", argumentArray: [dateFrom, dateTo as Any])
        
        return datePredicate
    }
    
}



extension CalendarViewController2 {
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarDayCell2 else { return }
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarDayCell2 else {
            return
        }
        
        let todaysDate = Date()
        if todaysDate.day() == cellState.date.day() {
            validCell.dateLabel.textColor = UIColor.purple
        } else {
            validCell.dateLabel.textColor = cellState.isSelected ? UIColor.purple : UIColor.darkGray
        }
        
        
        if validCell.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    func setupCalendarView() {
        // Setup Calendar Spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
    }
    
    
    
    func setupViewsFromCalendar(from visibleDates: DateSegmentInfo ) {
        guard let date = visibleDates.monthDates.first?.date else { return }
        
        formatter.dateFormat = "MMMM"
        title = formatter.string(from: date).uppercased()
    }
    
}



extension CalendarViewController2: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        var parameters: ConfigurationParameters
        var startDate = Date()
        var endDate = Date()
        if let calendarStartDate = formatter.date(from: "2017 01 01"),
            let calendarEndndDate = formatter.date(from: "2017 12 31") {
            startDate = calendarStartDate
            endDate = calendarEndndDate
        }
        parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 1)
        return parameters
    }
    
    
}


extension CalendarViewController2: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarDayCell2", for: indexPath) as! CalendarDayCell2
        
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        self.keydate = dateFormat.string(from: date)
        self.getAllBookedProviders(dateEntered: date)  //123
        self.tableView.reloadData()
        //  loadAppointmentsForDate(date: date)
        //    calendarViewDateChanged()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        print("---- selected------")
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsFromCalendar(from: visibleDates)
    }
    
    
    
}



