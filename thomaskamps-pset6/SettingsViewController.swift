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
    
    let db = FireBaseHelper.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func logOutAction(_ sender: Any) {
        do {
            try self.db.logOut()
            self.performSegue(withIdentifier: "logOutSegue", sender: nil)
            
        } catch {
            self.alert(title: "Can't log out", message: "Unfortunately something went wrong. Info: \(error)")
        }
    }
    

}
