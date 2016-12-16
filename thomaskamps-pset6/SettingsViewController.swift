//
//  SettingsViewController.swift
//  
//
//  Created by Thomas Kamps on 16-12-16.
//
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    // Initial vars
    let db = FireBaseHelper.sharedInstance
    @IBOutlet weak var privacyButton: UISwitch!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Authentication control
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
        }
        
        // Set switch to current value
        if self.defaults.object(forKey: "privacySetting") != nil {
            let currentVal = defaults.bool(forKey: "privacySetting")
            self.privacyButton.setOn(currentVal, animated:true)
        } else {
            self.privacyButton.setOn(true, animated:true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Logout function
    @IBAction func logOutAction(_ sender: Any) {
        do {
            try self.db.logOut()
            
            // Perform segue to login screen
            self.performSegue(withIdentifier: "logOutSegue", sender: nil)
            
        } catch {
            self.alert(title: "Can't log out", message: "Unfortunately something went wrong. Info: \(error)")
        }
    }
    
    // Set public favorites privacy on/off
    @IBAction func privacyAction(_ sender: Any) {
        
        if self.privacyButton.isOn {
            
            // Fetch users favorites from Firebase
            let ref = FIRDatabase.database().reference().child("users/"+self.db.userID!)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                if value?["favorites"] != nil {
                    
                    let userFavorites = value!["favorites"] as! Array<Int>
                    self.db.updatePublicFavorites(userFavorites: userFavorites)
                    
                }
            }) { (error) in
                
                self.alert(title: "An error occurred", message: String(describing: error.localizedDescription))
            }
        }
        if !self.privacyButton.isOn {
            
            self.db.updatePublicFavorites(userFavorites: [])
        }

        self.defaults.set(self.privacyButton.isOn, forKey: "privacySetting")
    }

}
