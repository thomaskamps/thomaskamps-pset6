//
//  ContactsFavoritesViewController.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 16-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit
import Firebase
import Siesta

class ContactsFavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ResourceObserver {
    
    // Initial vars
    @IBOutlet weak var tableView: UITableView!
    var data: Array<Dictionary<String, Any>> = []
    var contactFavorites: Array<Any> = []
    var db: FireBaseHelper!
    let api = APIHelper.sharedInstance
    var contactID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Authentication control
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
        }
        
        // Set tableView delegate and dataSource and db
        tableView.delegate = self
        tableView.dataSource = self
        self.db = FireBaseHelper.sharedInstance
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // When view appears load data from selected public favorites
        let ref = FIRDatabase.database().reference().child("publicFavorites/"+self.contactID)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSArray
            
            // If value is not nil, set contactFavorites with the retrieved values 
            // and create a resource for collecting the data
            if value != nil {
                
                self.contactFavorites = value! as! Array<Any>
                let temp = self.contactFavorites.map { String(describing: $0) }
                let idList = temp.joined(separator: ",")
                self.api.createResource().withParam("id", idList).addObserver(self).loadIfNeeded()
                
            } else {
                self.contactFavorites = []
            }
            
        }) { (error) in
            self.alert(title: "An error has occurred", message: error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Determine number of rows for tableView from data, and setting appropriate background
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.data.count == 0 {
            
            let noList: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
            noList.text             = "No favorites for this contact yet"
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
        
        return self.data.count
    }
    
    // Create tableView cell from data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactFavoritesCell", for: indexPath) as! ContactsFavoritesTableViewCell
        cell.label1.text = self.data[indexPath.row]["user"] as? String
        cell.label2.text = String(describing: self.data[indexPath.row]["downloads"]!) + " downloads"
        let temp = self.data[indexPath.row]["previewURL"] as! String
        cell.picture.imageURL = URL(string: temp)
        
        return cell
    }
    
    // Prepare for segue triggered by touching one of the rows
    // Segue will lead to a detailed picture view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowPicture" {
            
            let pictureVC = segue.destination as? PictureViewController
            let pictureData = self.data[(self.tableView.indexPathForSelectedRow?.row)!]
            pictureVC?.data = pictureData
        }
    }
    
    // Resource observer to process change in resource data
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        
        if resource.latestData != nil {
            
            self.data = resource.jsonDict["hits"] as! Array<Dictionary<String, Any>>
        }
        if resource.latestError != nil {
            
            self.alert(title: "An error occurred", message: String(describing: resource.latestError))
        }
        self.tableView.reloadData()
    }

}
