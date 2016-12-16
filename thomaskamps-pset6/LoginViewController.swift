//
//  LoginViewController.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 09-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    // Initial vars
    @IBOutlet weak var mailLoginField: UITextField!
    @IBOutlet weak var passwordLoginField: UITextField!
    
    var db: FireBaseHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Authentication check
        if FIRAuth.auth() != nil {
            FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
                
                // If user is authenticated, perform segue to main app screen
                if user != nil {
                    self.db.userID = FIRAuth.auth()?.currentUser?.uid
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            }
        }
        
        self.db = FireBaseHelper.sharedInstance
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Button action to log in
    @IBAction func loginAction(_ sender: Any) {
        if mailLoginField.text! != "" && passwordLoginField.text! != "" {
            FIRAuth.auth()!.signIn(withEmail: mailLoginField.text!, password: passwordLoginField.text!) {(user, error) in
                
                if error == nil {
                    
                    self.db.userID = FIRAuth.auth()?.currentUser?.uid
                    
                } else {
                    
                    self.alert(title: "Something went wrong", message: "Unfortunately something went wrong. Info: \(error)")
                }
            }
        } else {
            
            self.alert(title: "Please enter your credentials", message: "")
        }
    }

}

