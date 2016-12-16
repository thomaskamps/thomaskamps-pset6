//
//  ContactsViewController.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 12-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit
import Firebase

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Initial vars
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var userContacts: Dictionary<String, String> = [:]
    var userContactsKeys: Array<String> = []
    let db = FireBaseHelper.sharedInstance
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Authentication control
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Check if user already has contacts in UserDefaults
        if let contactsFromDefaults = UserDefaults.standard.value(forKey: "userContacts") {
            
            self.userContacts = contactsFromDefaults as! Dictionary<String, String>
            self.userContactsKeys = Array(self.userContacts.keys)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Calculate number of rows for tableView and adjust background accordingly
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.userContacts.count == 0 {
            
            let noList: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
            noList.text             = "No contacts yet.."
            noList.textColor        = UIColor.black
            noList.textAlignment    = .center
            tableView.backgroundView = noList
            tableView.separatorStyle = .none
            
        } else {
            
            let noList: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
            noList.text             = ""
            noList.textColor        = UIColor.black
            noList.textAlignment    = .center
            tableView.backgroundView = noList
            tableView.separatorStyle = .singleLine
        }
        
        return self.userContacts.count
    }
    
    // Create tableView cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactsTableViewCell
        let userName = self.userContactsKeys[indexPath.row]
        cell.contactLabel.text = userName
        
        return cell
    }
    
    // Enable deletion editing style for tableView and process deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let index = indexPath.row
            let indexUserName = self.userContactsKeys[index]
            
            // Remove from own variables
            self.userContacts[indexUserName] = nil
            self.userContactsKeys.remove(at: index)
            
            // Update UserDefaults
            UserDefaults.standard.setValue(self.userContacts, forKey: "userContacts")
            
            // Update tableView
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }
    
    // Search function to find users
    @IBAction func searchButtonAction(_ sender: Any) {
        
        // Close keyboard
        view.endEditing(true)
        
        if self.searchField.text! != "" {
            
            // Get all usernames from Firebase
            self.ref.child("userNames").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                // Check if given username can be found
                if let foundUserID = value?[self.searchField.text!] as? String {
                    
                    // Update vars, UserDefaults and tableView
                    self.userContacts[self.searchField.text!] = foundUserID
                    self.userContactsKeys.append(self.searchField.text!)
                    UserDefaults.standard.setValue(self.userContacts, forKey: "userContacts")
                    self.tableView.reloadData()
                    self.alert(title: "Contact succesfully added.", message: "\(self.searchField.text!) was succesfully added to your contacts. Let's see what pictures he/she likes!")
                    
                } else {
                    
                    self.alert(title: "Incorrect username", message: "Unfortunaltely the user you specified was not found")
                }
            }) { (error) in
                
                self.alert(title: "An error occurred", message: String(describing: error.localizedDescription))
            }
        } else {
            
            self.alert(title: "Please enter a value", message: "")
        }
    }
    
    // Prepare for segue to a contacts favorites
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowContact" {
            
            let nextVC = segue.destination as? ContactsFavoritesViewController
            let index = tableView.indexPathForSelectedRow?.row
            nextVC?.contactID = self.userContacts[self.userContactsKeys[index!]]!
        }
    }
    
}
