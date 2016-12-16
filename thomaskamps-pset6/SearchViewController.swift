//
//  SearchViewController.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 12-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit
import Firebase
import Siesta

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, ResourceObserver {
    
    // Inital vars
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchData: Array<Dictionary<String, Any>> = []
    let api = APIHelper.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Authentication control
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
        }
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Calculate number of rows for tableView and adjust background accordingly
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchData.count == 0 {
            
            let noList: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
            noList.text             = "No search results"
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
        
        return self.searchData.count
    }
    
    // Create tableView cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchTableViewCell
        cell.searchLabel.text = self.searchData[indexPath.row]["user"] as? String
        cell.searchLabel2.text = String(describing: self.searchData[indexPath.row]["downloads"]!) + " downloads"
        let temp = self.searchData[indexPath.row]["previewURL"] as! String
        cell.searchImg.imageURL = URL(string: temp)
        
        return cell
    }
    
    // Resource listener to monitor searchData results
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        
        if resource.latestData != nil {
            
            self.searchData = resource.jsonDict["hits"] as! Array<Dictionary<String, Any>>
        }
        if resource.latestError != nil {
            
            self.alert(title: "An error occurred", message: String(describing: resource.latestError))
        }
        
        self.tableView.reloadData()
    }
    
    // Function for performing a search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text! != "" {
            
            // Hide keyboard
            view.endEditing(true)
            
            // Create resource for search results
            self.api.createResource().withParam("orientation", "vertical").withParam("q", searchBar.text!.replacingOccurrences(of: " ", with: "+")).addObserver(self).loadIfNeeded()
        }
    }
    
    // Cancel search
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        view.endEditing(true)
        searchData = []
        self.tableView.reloadData()
    }
    
    // Prepare for segue to detailed picture
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowPicture" {
            
            let pictureVC = segue.destination as? PictureViewController
            let pictureIndex = tableView.indexPathForSelectedRow?.row
            pictureVC?.data = searchData[pictureIndex!]
        }
    }

}
