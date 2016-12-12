//
//  PictureViewController.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 12-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit
import Firebase

class PictureViewController: UIViewController {

    @IBOutlet weak var pictureImage: RemoteImageView!
    @IBOutlet weak var pictureButton: UIButton!
    
    var data: Dictionary<String, Any> = [:]
    var ref = FIRDatabase.database().reference()
    var userFavorites: Array<Int> = []
    var userID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.userID = user.uid
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pictureImage.imageURL = URL(string: data["webformatURL"] as! String)
        
        ref.child("users").child(self.userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                self.userFavorites = (value?["favorites"] as? Array)!
            }
            if self.userFavorites.contains(self.data["id"] as! Int) {
                self.pictureButton.setTitle("Remove from favorites", for: .normal)
                self.pictureButton.setTitleColor(UIColor.red, for: .normal)
            } else {
                self.pictureButton.setTitle("Add to favorites", for: .normal)
                self.pictureButton.setTitleColor(UIColor.blue, for: .normal)
            }
        }) { (error) in
            print("opes")
            print(error.localizedDescription)
        }
    }

    @IBAction func pictureButtonAction(_ sender: Any) {
        if self.userFavorites.contains(data["id"] as! Int) {
            pictureButton.setTitle("Add to favorites", for: .normal)
            pictureButton.setTitleColor(UIColor.blue, for: .normal)
            if let index = self.userFavorites.index(of: data["id"] as! Int) {
                self.userFavorites.remove(at: index)
                print(userFavorites)
                self.ref.child("users").child(self.userID).setValue(["favorites": self.userFavorites])
            }
        } else {
            pictureButton.setTitle("Remove from favorites", for: .normal)
            pictureButton.setTitleColor(UIColor.red, for: .normal)
            self.userFavorites.append(data["id"] as! Int)
            print(userFavorites)
            self.ref.child("users").child(self.userID).setValue(["favorites": self.userFavorites])
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
