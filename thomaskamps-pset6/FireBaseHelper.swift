//
//  FireBaseHelper.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 12-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import Foundation
import Firebase

class FireBaseHelper {
    
    static let sharedInstance = FireBaseHelper()
    
    private init() { }
    
    func createAccount(email: String, password: String) {
        FIRAuth.auth()!.createUser(withEmail: email, password: password) { user, error in
            if error == nil {
                FIRAuth.auth()!.signIn(withEmail: email, password: password)
                var ref = FIRDatabase.database().reference()
                let userID = FIRAuth.auth()?.currentUser?.uid
                ref.child("users").child(userID!).setValue(["favorites": []])
            } else {
                /*let alert = UIAlertController(title: "Error", message: "Something went wrong while creating your account!", preferredStyle: UIAlertControllerStyle.alert)
                let oke = UIAlertAction(title: "Oke", style: UIAlertActionStyle.default)
                alert.addAction(oke)
                self.present(alert, animated: true, completion: nil)*/
                print(error)
            }
        }
    }
    
    func login(email: String, password: String) {
        FIRAuth.auth()!.signIn(withEmail: email, password: password)
    }
}
