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

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var userContacts: Dictionary<String, String> = [:]
    var userContactsKeys: Array<String> = []
    let db = FireBaseHelper.sharedInstance
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if let contactsFromDefaults = UserDefaults.standard.value(forKey: "userContacts") {
            self.userContacts = contactsFromDefaults as! Dictionary<String, String>
            self.userContactsKeys = Array(self.userContacts.keys)
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
            tableView.separatorStyle = .none
        }
        return self.userContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactsTableViewCell
        let userName = self.userContactsKeys[indexPath.row]
        cell.contactLabel.text = userName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let index = indexPath.row
            let indexUserName = self.userContactsKeys[index]
            self.userContacts[indexUserName] = nil
            self.userContactsKeys.remove(at: index)
            UserDefaults.standard.setValue(self.userContacts, forKey: "userContacts")
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }

    @IBAction func searchButtonAction(_ sender: Any) {
        if self.searchField.text! != "" {
            self.ref.child("userNames").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                //let retrievedUserNames = (value as? Dictionary<String, String> ?? nil)!
                if let foundUserID = value?[self.searchField.text!] as? String {
                    self.userContacts[self.searchField.text!] = foundUserID
                    self.userContactsKeys.append(self.searchField.text!)
                    UserDefaults.standard.setValue(self.userContacts, forKey: "userContacts")
                    self.tableView.reloadData()
                    self.alert(title: "Contact succesfully added.", message: "\(self.searchField.text!) was succesfully added to your contacts. Let's see what pictures he/she likes!")
                } else {
                    self.alert(title: "Incorrect username", message: "Unfortunaltely the user you specified was not found")
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            self.alert(title: "Please enter a value", message: "")
        }
    }
}
