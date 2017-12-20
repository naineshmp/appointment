//
//  PasswordController.swift
//  Appointment Lookup
//
//  Created by Nainesh Patel on 12/13/17.
//  Copyright © 2017 Nainesh Patel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class PasswordController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var usernameField: UITextField!
  
    @IBAction func recoverPressed(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: usernameField.text!) { error in
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: "No account was found for the entered email address. Please try again.", preferredStyle: UIAlertControllerStyle.actionSheet)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                
                 self.present(alertController, animated: true, completion: nil)
            }
            else {
                let alertController = UIAlertController(title: "Forgotten Password", message:
                    "A recovery email has been sent to the entered email address", preferredStyle: UIAlertControllerStyle.actionSheet)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: { (action) in
                    self.performSegue(withIdentifier: "passwordReset", sender: nil)
                }))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    
}
