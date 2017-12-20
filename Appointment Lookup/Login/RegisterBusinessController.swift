//
//  RegisterBusinessController.swift
//  Appointment Lookup
//
//  Created by Nainesh Patel on 12/13/17.
//  Copyright © 2017 Nainesh Patel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterBusinessController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource , UITextFieldDelegate{
    
    var categories = ["Health", "Beautician", "Restaurants", "Event Planner", "Legal Services"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let thePicker = UIPickerView()
        thePicker.delegate = self
        thePicker.dataSource = self
        categoryText.delegate = self
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(RegisterBusinessController.donePicker))
        // let cancelButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        categoryText.inputView = thePicker
        categoryText.inputAccessoryView = toolBar
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func donePicker() {
        view.endEditing(true)
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {return 1}
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {return categories.count}
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {return categories[row]}
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {categoryText.text = categories[row]}
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var categoryText: UITextField!
    
    
    //Button Connections@IBOutlet weak var nameRegisterTextField: UITextField!
    @IBOutlet weak var emailRegisterField: UITextField!
    @IBOutlet weak var passwordRegisterField: UITextField!
    @IBOutlet weak var passwordRepeatRegisterField: UITextField!
    @IBOutlet weak var nameRegisterTextField: UITextField!
    @IBOutlet weak var phoneRegisterField: UITextField!
    
    var userName: String?
    var passWord: String?
    var passWordRepeat: String?
    var ref: DatabaseReference!
    var businessUser = BusinessUser()
    
    @IBAction func registerButton(_ sender: UIButton) {
        
        userName = emailRegisterField.text!
        passWord = passwordRegisterField.text!
        passWordRepeat = passwordRepeatRegisterField.text!
        
        //For debugging
        print(userName!)
        print(passWord!)
        print(passWordRepeat!)
        
        if passWord==passWordRepeat {
            if(self.nameRegisterTextField.text != ""  && self.phoneRegisterField.text != "" && self.categoryText.text != ""){
                if(self.validatePhone(value: self.phoneRegisterField.text!)){
                    registerUser()
                }
                else
                {
                    let alertController = UIAlertController(title: "Error", message: "Invalid Phone Number. Example: +16194166883", preferredStyle: UIAlertControllerStyle.actionSheet)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else
            {
                let alertController = UIAlertController(title: "Error", message: "Invalid Data", preferredStyle: UIAlertControllerStyle.actionSheet)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else {
            let alertController = UIAlertController(title: "Error", message: "Password fields do not match. Please try again.", preferredStyle: UIAlertControllerStyle.actionSheet)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func addUser(){
        ref = Database.database().reference()
        let reference = ref.child("businessUsers")
        let key = reference.childByAutoId().key;
        //creating artist with the given values
        let user = ["id":key,
                    "name": self.nameRegisterTextField.text!,
                    "email": self.userName!,
                    "phone":self.phoneRegisterField.text!,
                    "isBusiness": true,
                    "businesstype": categoryText.text!
            ] as [String : Any]
        print("User added to Database")
        reference.child(key).setValue(user)
    }
    
    func validatePhone(value: String) -> Bool {
            let PHONE_REGEX = "^[0-9]{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    //function to add username and password to the database
    func registerUser() {
        
        Auth.auth().createUser(withEmail: userName!,password: passWord!) { user, error in
            if error == nil {
                Auth.auth().signIn(withEmail: self.userName!, password: self.passWord!)
                
                Auth.auth().addStateDidChangeListener() { auth, user in
                    if user != nil {
                        self.performSegue(withIdentifier: "businessUsertoHome", sender: nil)
                        self.addUser()
                    }
                }
                
            }
            else {
                //Prints error message if email has already been registered
                let alertController = UIAlertController(title: "Error", message: "Error with entered information. Check the email address and that the passwords match.", preferredStyle: UIAlertControllerStyle.actionSheet)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}


