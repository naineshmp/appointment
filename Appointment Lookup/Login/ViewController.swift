//
//  ViewController.swift
//  test
//
//  Created by Dominic Heaton on 03/10/2017.
//  Copyright © 2017 Dominic Heaton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var userName: String?
    var passWord: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
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
                        if Auth.auth().currentUser?.email == "admin@test.com" {
                            self.authenticationCheck()
                        } else {
                            self.performSegue(withIdentifier: "toMenu", sender: nil)
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
//self.performSegue(withIdentifier: "toRegisterController", sender: nil)
    }

    @IBAction func forgotPassword(_ sender: UIButton) {
     //   self.performSegue(withIdentifier: "toForgotPassword", sender: nil)
    }
    
    func authenticationCheck() {
        let authenticationContext = LAContext()
        var error: NSError?
        
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            
            //alert if no biometric sensors found
            showAlertWithTitle("Error", "This device does not have FaceID/TouchID Sensor.")
            return
        }
        
        authenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Confirm you are the Administrator", reply: { [unowned self] (success, error) -> Void in
            
            if success {
                DispatchQueue.main.async() { () -> Void in
                    self.performSegue(withIdentifier: "toAdmin", sender: nil)
                }
            }
            else {
                if let error = error {
                    let message = self.errorMessageForLAErrorCode((error as NSError).code)
                    self.showAlertWithTitle("Error", message)
                }
            }
            
        })
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
            case Int(kLAErrorBiometryNotAvailable):
                message = "FaceID/TouchID is not available on the device"
                print("FaceID/TouchID is not available on the device")
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
