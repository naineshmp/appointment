//
//  NewApptTableViewController.swift
//  Appointment Lookup
//
//  Created by Nainesh Patel on 12/15/17.
//  Copyright © 2017 Nainesh Patel. All rights reserved.
//

import UIKit
import CoreData
import JTAppleCalendar
import FirebaseDatabase
import FirebaseAuth

class NewApptTableViewController: UITableViewController {
    let formatter = DateFormatter()
    var calendarViewHidden = true
    var appointmentScrolled = false
    var keyDate: Date = Date()
    var keyString: String = ""
    var name: String = ""
    var phone: String = ""
    var notes: String = ""
    var email: String = ""
    var slots: Int = 0
    var ref: DatabaseReference! = Database.database().reference()
    // Calendar Color
    let outsideMonthColor = UIColor.lightGray
    let monthColor = UIColor.darkGray
    let selectedMonthColor = UIColor.white
    let currentDateSelectedViewColor = UIColor.black
    var selectedTime = ""
    var selectedDate = ""
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet weak var timeSlotLabel: UILabel!
    
    @IBOutlet weak var CustomerName: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var dateDetailLabel: UILabel!
    @IBOutlet weak var CustomerEmail: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    
    
    func showAlert(_ title1: String,_ message : String,_ title2: String ){
        let alertController = UIAlertController(title: title1, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.addAction(UIAlertAction(title: title2, style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func validatePhone(value: String) -> Bool {
        let PHONE_REGEX = "^[0-9]{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    @IBAction func confirmAppointment(_ sender: UIBarButtonItem) {       
        if CustomerName.text != "" && selectedTime != "" && phoneNumber.text != "" && CustomerEmail.text != "" {
            if self.validatePhone(value: phoneNumber.text!){
                if self.isValidEmail(testStr: self.CustomerEmail.text!){
                    saveAppointment()
                    showAlert("Success", "Appointment Successfully Added", "Dismiss")
                }
                else
                {
                    showAlert("Error", "Invalid Email Example", "Dismiss")
                }
            }
                
            else{
                showAlert("Error", "Invalid Phone Number Example : 6194166883", "Dismiss")
            }
        }
        else{
            showAlert("Error", "Please enter all data.", "Dismiss")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTimeSlots" {
            let controller = (segue.destination as! TimeSlotsCVC)
            controller.keyDate =  self.selectedDate
            controller.name = self.CustomerName.text!
            controller.notes = self.noteTextView.text
            controller.phone = self.phoneNumber.text!
            controller.email = self.CustomerEmail.text!
        }
    }
    
    
    func saveAppointment(){
        print("______________Apoointment______________")
        print(CustomerName.text!)
        print(phoneNumber.text!)
        print(selectedTime)
        print(selectedDate)
        print(noteTextView.text!)
        print(CustomerEmail.text!)
        addAppointment()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        noLargeTitles()
        setKeyString()
        setupKeyboardNotification()
        
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates( [Date()] )
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomerNewApptTableViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
        self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, -20, 0);
    }
    
    @objc func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setKeyString()
        self.timeSlotLabel.text = "Time of Appointment                  " + self.selectedTime
    }
    
    func clearData(){
        self.CustomerName.text = ""
        self.phoneNumber.text = ""
        self.noteTextView.text = ""
        self.timeSlotLabel.text = "Time of Appointment"
        self.CustomerEmail.text = ""
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
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
    
    func addAppointment()
    {
        let appointment = [ "name": self.CustomerName.text ?? "Default Name",
                            "notes": self.noteTextView.text,
                            "time": self.selectedTime,
                            "phone": self.phoneNumber.text!,
                            "email": self.CustomerEmail.text!
            ] as [String : Any]
        self.updateTimeSlot(selectedDate, selectedTime, slots-1)
        self.ref.child("appointments").child(self.keyString).child(self.selectedDate).childByAutoId().setValue(appointment)
        let appointmentCustomerSide = [
            "businessId": self.keyString,
            "customerEmail": self.CustomerEmail.text!
            ] as [String : Any]
        self.ref.child("appointmentCustomerSide").child(self.keyString).setValue(appointmentCustomerSide)
        clearData()
    }
    
    func updateTimeSlot(_ date: String,_ time: String,_ slot: Int){
        print("-- time slot changed --")
        self.ref.child("timeSlots").child(keyString).child(date).child(time).setValue(slot)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.CustomerName.text = self.name
        self.phoneNumber.text = self.phone
        self.noteTextView.text = self.notes
        self.CustomerEmail.text = self.email
        
        let dateFormat = DateFormatter()
        if selectedDate != ""{
            dateFormat.dateFormat = "MM-dd-yyyy"
            dateFormat.date(from: selectedDate)
            print(selectedDate,"this date returned")
            calendarView.scrollToDate(dateFormat.date(from: selectedDate)!, animateScroll: false)
            calendarView.selectDates( [dateFormat.date(from: selectedDate)!] )
        }
    }
    
    func noLargeTitles(){
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
            tableView.dragDelegate = self as? UITableViewDragDelegate
        }
    }
    
    func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(NewApptTableViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewApptTableViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight + 20, 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
    }
    
}

extension NewApptTableViewController {
    func toggleCalendarView() {
        calendarViewHidden = !calendarViewHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        appointmentScrolled = true
    }
    
    func updateDateDetailLabel(date: Date){
        formatter.dateFormat = "MMMM dd, yyyy"
        dateDetailLabel.text = formatter.string(from: date)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            toggleCalendarView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if calendarViewHidden && indexPath.section == 0 && indexPath.row == 1 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerView.isOpaque = false
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.isOpaque = false
        return footerView
    }
    
    //  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //    if calendarViewHidden && section == 0 {
    //      return 40
    //    } else {
    //      return 1
    //    }
    //  }
}



extension NewApptTableViewController {
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarDayCell else { return }
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarDayCell else {
            return
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
        
        // Setup Labels
        calendarView.visibleDates{ (visibleDates) in
            self.setupViewsFromCalendar(from: visibleDates)
        }
    }
    
    func setupViewsFromCalendar(from visibleDates: DateSegmentInfo ) {
        guard let date = visibleDates.monthDates.first?.date else { return }
        
        formatter.dateFormat = "MMMM dd, yyyy"
        dateDetailLabel.text = formatter.string(from: date)
        
        calendarView.selectDates( [date] )
        
        updateDateDetailLabel(date: date)
        
    }
    
    
}


extension NewApptTableViewController {
    func loadAppointmentsForDate(date: Date){
        
    }
    
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
    
    func fetchAppointmentsForDay() {
        
    }
}

extension NewApptTableViewController: JTAppleCalendarViewDataSource {
    
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
        parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}


extension NewApptTableViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    // Display Cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        updateDateDetailLabel(date: date)
        loadAppointmentsForDate(date: date)
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM-dd-yyyy"
        self.selectedDate = dateFormat.string(from: date)
        //self.selectedDate = "\(date)"
        
        //    calendarViewDateChanged()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        if appointmentScrolled {
            setupViewsFromCalendar(from: visibleDates)
        }
    }
}

extension NewApptTableViewController: NSFetchedResultsControllerDelegate {
    
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
            print("Appt Deleted")
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



