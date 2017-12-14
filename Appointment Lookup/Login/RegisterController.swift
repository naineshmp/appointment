//
//  RegisterController.swift
//  Appointment Lookup
//
//  Created by Nainesh Patel on 12/13/17.
//  Copyright © 2017 Nainesh Patel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
//import FirebaseDatabase

class RegisterController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Button Connections
    @IBOutlet weak var emailRegisterField: UITextField!
    @IBOutlet weak var passwordRegisterField: UITextField!
    @IBOutlet weak var passwordRepeatRegisterField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var ref: DatabaseReference!
    var userName: String?
    var passWord: String?
    var passWordRepeat: String?
    
    @IBAction func registerButton(_ sender: UIButton) {
        userName = emailRegisterField.text!
        passWord = passwordRegisterField.text!
        passWordRepeat = passwordRepeatRegisterField.text!
        
        //For debugging
        print(userName!)
        print(passWord!)
        print(passWordRepeat!)
        
        if passWord==passWordRepeat {
            registerUser()
        }
        else {
            let alertController = UIAlertController(title: "Error", message: "Password fields do not match. Please try again.", preferredStyle: UIAlertControllerStyle.actionSheet)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func addUser(){
        ref = Database.database().reference()
        let reference = ref.child("users")
        let key = reference.childByAutoId().key;
        //creating artist with the given values
        let user = ["id":key,
                    "name": self.usernameTextField.text!,
                    "email": self.userName!,
                    "phone":self.phoneTextField.text!,
                    "isBusiness": false
            ] as [String : Any]
        print("Customer added to Database")
        reference.child(key).setValue(user)
    }
    
    //function to add username and password to the database
    func registerUser() {
        
        Auth.auth().createUser(withEmail: userName!,password: passWord!) { user, error in
            if error == nil {
                Auth.auth().signIn(withEmail: self.userName!, password: self.passWord!)
                
                Auth.auth().addStateDidChangeListener() { auth, user in
                    if user != nil {
                        self.addUser()
                        self.performSegue(withIdentifier: "userToHome", sender: nil)
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

