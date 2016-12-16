//
//  SignUpViewController.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 15-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var passWordField: UITextField!
    
    var db: FireBaseHelper!
    var ref = FIRDatabase.database().reference()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.db.userID = FIRAuth.auth()?.currentUser?.uid
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
        self.db = FireBaseHelper.sharedInstance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUpAction(_ sender: Any) {
        if self.userNameField.text! != "" && self.mailField.text! != "" && self.passWordField.text! != "" {
            self.ref.child("userNames").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let retrievedUserID = (value?[self.userNameField.text!] as? String ?? "")!
                if retrievedUserID == "" {
                    FIRAuth.auth()!.createUser(withEmail: self.mailField.text!, password: self.passWordField.text!) { user, error in
                        if error == nil {
                            FIRAuth.auth()!.signIn(withEmail: self.mailField.text!, password: self.passWordField.text!)
                            var ref = FIRDatabase.database().reference()
                            let userID = FIRAuth.auth()?.currentUser?.uid
                            ref.child("users").child(userID!).setValue(["favorites": []])
                            ref.child("userNames/"+self.userNameField.text!).setValue(userID)
                        } else {
                            self.alert(title: "Something went wrong", message: "Unfortunately something went wrong. Info: \(error)")
                        }
                    }
                } else {
                    self.alert(title: "Username error", message: "The username of your choice was unfortunately already taken. Please try again with a different username.")
                    self.userNameField.text = ""
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            self.alert(title: "Wrong entry", message: "Please enter valid information.")
        }
    }
    

}
