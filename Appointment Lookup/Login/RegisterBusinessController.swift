
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterBusinessController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
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
        let reference = ref.child("businessUsers")
        let key = reference.childByAutoId().key;
        //creating artist with the given values
        let user = ["id":key,
                    "name": self.nameRegisterTextField.text!,
                    "email": self.userName!,
                    "phone":self.phoneRegisterField.text!,
        ]
        print("User added to Database")
        reference.child(key).setValue(user)
        
    }
    
    
    //function to add username and password to the database
    func registerUser() {
        
        Auth.auth().createUser(withEmail: userName!,password: passWord!) { user, error in
            if error == nil {
                Auth.auth().signIn(withEmail: self.userName!, password: self.passWord!)
                
                Auth.auth().addStateDidChangeListener() { auth, user in
                    if user != nil {
                
                        print("Success-------")
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


