//
//  ViewController.swift
//  Appointment Lookup
//
//  Created by Nainesh Patel on 12/13/17.
//  Copyright © 2017 Nainesh Patel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var ref: DatabaseReference!
    var userName: String?
    var passWord: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)    }
    
    //Functions to hide navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enterButton(_ sender: UIButton) {
        userName = usernameField.text!
        passWord = passwordField.text!
        logUserIn(userName!, passWord!)
    }
    
    //function to check username and password against database
    func logUserIn(_ username: String?, _ password: String?) {
        Auth.auth().signIn(withEmail: username!, password: password!) { user, error in
            if error == nil {
                Auth.auth().addStateDidChangeListener() { auth, user in
                    if user != nil {
                        // removed admin@test.com account... date DECEMBER 20
                        if Auth.auth().currentUser?.email == "admin@test.com" {
                            //self.authenticationCheck()
                        } else {
                            self.ref = Database.database().reference()
                            self.ref.child("businessUsers").observeSingleEvent(of: .value, with: { (snapShot) in
                                if let snapDict = snapShot.value as? [String:AnyObject]{
                                    for each in snapDict{
                                        let userEmail = each.value["email"] as! String
                                        let isBusiness:Bool = each.value["isBusiness"] as! Bool
                                        if(userEmail == self.userName)
                                        {
                                            
                                            if(isBusiness)
                                            {
                                                self.performSegue(withIdentifier: "loginToBusiness", sender: nil)
                                            }
                                            else
                                            {
                                                self.performSegue(withIdentifier: "signInToHome", sender: nil)
                                            }
                                        }
                                    }
                                }
                            })
                            
                            self.ref.child("users").observeSingleEvent(of: .value, with: { (snapShot) in
                                if let snapDict = snapShot.value as? [String:AnyObject]{
                                    for each in snapDict{
                                        let userEmail = each.value["email"] as! String
                                        let isBusiness:Bool = each.value["isBusiness"] as! Bool
                                        if(userEmail == self.userName)
                                        {
                                            
                                            if(isBusiness)
                                            {
                                                self.performSegue(withIdentifier: "loginToBusiness", sender: nil)
                                            }
                                            else
                                            {
                                                self.performSegue(withIdentifier: "signInToHome", sender: nil)
                                            }
                                        }
                                    }
                                }
                            })
                            
                            print("success")
                            
                        }
                    }
                }
            }
            else {
                //.alert gives center screen error -- .actionSheet is near bottom of screen
                let alertController = UIAlertController(title: "Error", message: "No user account found for that email and password combination. Please try again", preferredStyle: UIAlertControllerStyle.actionSheet)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        //
        
        //
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toRegisterController", sender: nil)
    }
    
    @IBAction func registerProviderClick(_ sender: Any) {
        self.performSegue(withIdentifier: "toRegisterBusinessController", sender: nil)
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toForgotPassword", sender: nil)
    }
    
    func showAlertWithTitle(_ title: String, _ message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        DispatchQueue.main.async() { () -> Void in
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func errorMessageForLAErrorCode(_ errorCode: Int) -> String {
        var message = ""
        
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            print("Authentication was cancelled by application")
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            print("The user failed to provide valid credentials")
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            print("The context is invalid")
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            print("Passcode is not set on the device")
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            print("Authentication was cancelled by the system")
        case Int(kLAErrorBiometryLockout):
            message = "Too many failed attempts."
            print("Too many failed attempts")
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            print("The user did cancel")
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            print("The user chose to use the fallback")
        default:
            message = "Did not find error code on LAError object"
            print("Did not find error code on LAError object")
        }
        return message
    }
    
    
}
