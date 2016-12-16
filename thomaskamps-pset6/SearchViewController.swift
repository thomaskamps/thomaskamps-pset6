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

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var searchData: Array<Dictionary<String, Any>> = []
    
    let api = APIHelper.sharedInstance.pixabayAPI
    let apiKey = APIHelper.sharedInstance.key
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchTableViewCell
        cell.searchLabel.text = self.searchData[indexPath.row]["user"] as! String
        cell.searchLabel2.text = String(describing: self.searchData[indexPath.row]["downloads"]!) + " downloads"
        let temp = self.searchData[indexPath.row]["previewURL"] as! String
        cell.searchImg.imageURL = URL(string: temp)
        
        return cell
    }
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        if resource.latestData != nil {
            self.searchData = resource.jsonDict["hits"] as! Array<Dictionary<String, Any>>
        }
        if resource.latestError != nil {
            print(resource.latestError)
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text! != "" {
            view.endEditing(true)
            self.api.resource("/").withParam("orientation", "vertical").withParam("key", self.apiKey).withParam("q", searchBar.text!.replacingOccurrences(of: " ", with: "+")).addObserver(self).loadIfNeeded()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
        searchData = []
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPicture" {
            let pictureVC = segue.destination as? PictureViewController
            let pictureIndex = tableView.indexPathForSelectedRow?.row
            pictureVC?.data = searchData[pictureIndex!]
        }
    }

}
