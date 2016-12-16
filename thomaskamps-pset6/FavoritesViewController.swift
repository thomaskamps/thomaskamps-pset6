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

    @IBOutlet weak var tableView: UITableView!
    var data: Dictionary<String, Dictionary<String, Any>> = [:]
    var userFavorites: Array<Int> = []
    var db: FireBaseHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
        }
        tableView.delegate = self
        tableView.dataSource = self
        self.db = FireBaseHelper.sharedInstance
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var ref = FIRDatabase.database().reference()
        ref.child("users/"+self.db.userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value?["favorites"] != nil {
                self.userFavorites = value!["favorites"] as! Array<Int>
                //print(value!["favoritesData"] as! Dictionary<String, Dictionary<String, Any>>)
                self.data = value!["favoritesData"] as! Dictionary<String, Dictionary<String, Any>>
                
                self.tableView.reloadData()
            } else {
                self.userFavorites = []
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
            tableView.separatorStyle = .none
        }
        return self.userFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesTableViewCell
        let picID = String(describing: self.userFavorites[indexPath.row])
        cell.favoritesLabel.text = self.data[picID]?["user"] as! String
        cell.favoritesLabel2.text = String(describing: self.data[picID]?["downloads"]!) + " downloads"
        let temp = self.data[picID]?["previewURL"] as! String
        cell.favoritesImg.imageURL = URL(string: temp)
        
        return cell
    }
    
    /*func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        if resource.latestData != nil {
            let temp = resource.jsonDict["hits"] as! Array<Dictionary<String, Any>>
            let temp1 = temp[0]
            self.data[temp1["id"] as! Int] = temp1
        }
        if resource.latestError != nil {
            print(resource.latestError)
        }
        self.tableView.reloadData()
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPicture" {
            let pictureVC = segue.destination as? PictureViewController
            let pictureID = String(describing: self.userFavorites[(self.tableView.indexPathForSelectedRow?.row)!])
            pictureVC?.data = data[pictureID]!
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let index = indexPath.row
            self.userFavorites.remove(at: index)
            self.db.updateFavorites(userFavorites: self.userFavorites)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }

}
