//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD


class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        
        //TODO: Set up a new user on our Firbase database
        
        if emailTextfield.text == "" || passwordTextfield.text == ""  {
            let alert = UIAlertController(title: "Error Message", message:"Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!, completion: { (user, error) in
                if (error != nil) {
                    
                    if let errCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                        
                        var alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            (result: UIAlertAction) -> Void in
                            print("Error transmitted")
                        }

                        switch errCode {
                        case .errorCodeInvalidEmail:
                            print("Invalid email")
                            alertController = UIAlertController(title: "Error", message: "Email syntax is not correct", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(okButton)
                            self.present(alertController, animated: true, completion: nil)
                        case .errorCodeEmailAlreadyInUse:
                            print("Email already in use")
                            alertController = UIAlertController(title: "Error", message: "This email is already in use", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(okButton)
                            self.present(alertController, animated: true, completion: nil)
                        case .errorCodeWeakPassword:
                            print("Password weak")
                            alertController = UIAlertController(title: "Error", message: "Password is too weak. Please choose a password which contains at least 6 characters.", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(okButton)
                            self.present(alertController, animated: true, completion: nil)
                        default:
                            // ALWAYS GET HERE.
                            print(error as Any)
                            alertController = UIAlertController(title: "Error", message: "An unknown error occured.", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(okButton)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    }
                    
                } else {
                    print("User created")
                    
                    SVProgressHUD.dismiss()
                    
                    self.performSegue(withIdentifier: "goToChat", sender: self)
                    
                    self.emailTextfield.text = ""
                    
                    self.passwordTextfield.text = ""
                }
            })
        }
        
    }
    
}
