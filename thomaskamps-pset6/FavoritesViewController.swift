//
//  FavoritesViewController.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 12-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit
import Firebase

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Initial vars
    @IBOutlet weak var tableView: UITableView!
    
    var data: Dictionary<String, Dictionary<String, Any>> = [:]
    var userFavorites: Array<Int> = []
    var db: FireBaseHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Authentication control
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        self.db = FireBaseHelper.sharedInstance
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // When view appears fetch users favorites from Firebase
        let ref = FIRDatabase.database().reference().child("users/"+self.db.userID!)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            if value?["favorites"] != nil {
                
                self.userFavorites = value!["favorites"] as! Array<Int>
                self.data = value!["favoritesData"] as! Dictionary<String, Dictionary<String, Any>>
                
            } else {
                
                self.userFavorites = []
            }
            self.tableView.reloadData()
            
        }) { (error) in
            
            self.alert(title: "An error occurred", message: String(describing: error.localizedDescription))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Calculate the amount of rows needed for tableView and set background accordingly
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.userFavorites.count == 0 {
            
            let noList: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
            noList.text             = "No favorites yet"
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
        
        return self.userFavorites.count
    }
    
    // Fill tableView cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesTableViewCell
        let picID = String(describing: self.userFavorites[indexPath.row])
        cell.favoritesLabel.text = self.data[picID]?["user"] as? String
        cell.favoritesLabel2.text = String(describing: self.data[picID]?["downloads"]!) + " downloads"
        let temp = self.data[picID]?["previewURL"] as! String
        cell.favoritesImg.imageURL = URL(string: temp)
        
        return cell
    }
    
    // Prepare for segue to detailed pictureview
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowPicture" {
            
            let pictureVC = segue.destination as? PictureViewController
            let pictureID = String(describing: self.userFavorites[(self.tableView.indexPathForSelectedRow?.row)!])
            pictureVC?.data = data[pictureID]!
        }
    }
    
    // Enable deletion from tableView and process those
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let index = indexPath.row
            let item = String(describing: self.userFavorites[index])
            self.db.deleteFavorite(id: item)
            self.userFavorites.remove(at: index)
            self.db.updateFavorites(userFavorites: self.userFavorites)
            
            let defaults = UserDefaults.standard
            if defaults.object(forKey: "privacySetting") == nil {
                if defaults.bool(forKey: "privacySetting") {
                    self.db.updatePublicFavorites(userFavorites: self.userFavorites)
                }
            } else {
                self.db.updatePublicFavorites(userFavorites: self.userFavorites)
            }
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }

}
