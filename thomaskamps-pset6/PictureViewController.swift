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
    
    // Initial vars
    @IBOutlet weak var pictureImage: RemoteImageView!
    @IBOutlet weak var pictureButton: UIButton!
    
    var data: Dictionary<String, Any> = [:]
    var db: FireBaseHelper!
    var userFavorites: Array<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Authentication control
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
        }
        
        self.db = FireBaseHelper.sharedInstance
        self.pictureButton.setTitle("Add to favorites", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // When view appears load image from URL
        pictureImage.imageURL = URL(string: data["webformatURL"] as! String)
        
        // Load users favorites from Firebase to check if current picture is in there
        let ref = FIRDatabase.database().reference().child("users/"+self.db.userID!+"/favorites")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSArray
            
            if value != nil {
                
                self.userFavorites = value! as! Array<Int>
                
                // If favorites already contain the picture set removal button, else an add-button
                if self.userFavorites.contains(self.data["id"] as! Int) {
                    
                    self.pictureButton.setTitle("Remove from favorites", for: .normal)
                    self.pictureButton.setTitleColor(UIColor.red, for: .normal)
                    
                } else {
                    
                    self.pictureButton.setTitle("Add to favorites", for: .normal)
                    self.pictureButton.setTitleColor(UIColor.white, for: .normal)
                }
            }
        }) { (error) in
            
            self.alert(title: "An error occurred", message: String(describing: error.localizedDescription))
        }
    }
    
    // Button action for saving picture to your phones album
    @IBAction func saveButtonAction(_ sender: Any) {
        
        UIImageWriteToSavedPhotosAlbum(pictureImage.image!, saveImageHandler(_:didFinishSavingWithError:contextInfo:), nil, nil)
    }
    
    // Handler for saving picture to your phones album
    func saveImageHandler(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if error == nil {
            
            self.alert(title: "Succes!", message: "The image was saved to your photos.")
            
        } else {
            
            self.alert(title: "Failed...", message: (error?.localizedDescription)!)
        }
    }
    
    // Function to add or delete picture to/from favorites
    @IBAction func pictureButtonAction(_ sender: Any) {
        
        // Check if picture already is in favorites
        if self.userFavorites.contains(data["id"] as! Int) {
            
            pictureButton.setTitle("Add to favorites", for: .normal)
            pictureButton.setTitleColor(UIColor.white, for: .normal)
            
            if let index = self.userFavorites.index(of: data["id"] as! Int) {
                
                let item = String(describing: self.userFavorites[index])
                self.db.deleteFavorite(id: item)
                self.userFavorites.remove(at: index)
            }
        } else {
            
            pictureButton.setTitle("Remove from favorites", for: .normal)
            pictureButton.setTitleColor(UIColor.red, for: .normal)
            self.userFavorites.append(data["id"] as! Int)
            db.addFavorite(data: data)
        }
        db.updateFavorites(userFavorites: self.userFavorites)
        
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "privacySetting") == nil {
            if defaults.bool(forKey: "privacySetting") {
                self.db.updatePublicFavorites(userFavorites: self.userFavorites)
            }
        } else {
            self.db.updatePublicFavorites(userFavorites: self.userFavorites)
        }
    }
}
