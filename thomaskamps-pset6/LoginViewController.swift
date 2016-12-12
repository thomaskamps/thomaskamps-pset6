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

    @IBOutlet weak var mailLoginField: UITextField!
    @IBOutlet weak var passwordLoginField: UITextField!
    
    let db = FireBaseHelper.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAction(_ sender: Any) {
        self.db.login(email: mailLoginField.text!, password: passwordLoginField.text!)
    }

    @IBAction func signUpAction(_ sender: Any) {
        let alert = UIAlertController(title: "Sign Up", message: "Sign Up", preferredStyle: .alert)

        alert.addTextField { mailField in
            mailField.placeholder = "E-mail"
        }
        
        alert.addTextField { passwordField in
            passwordField.isSecureTextEntry = true
            passwordField.placeholder = "Password"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        let save = UIAlertAction(title: "Sign Up", style: .default) { action in
            let mailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            self.db.createAccount(email: mailField.text!, password: passwordField.text!)
        }
        
        alert.addAction(save)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }

}

