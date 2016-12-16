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
    var db: FireBaseHelper!
    var userFavorites: Array<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        pictureImage.imageURL = URL(string: data["webformatURL"] as! String)
        print(data)
        var ref = FIRDatabase.database().reference()
        ref.child("users/"+self.db.userID!+"/favorites").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSArray
            if value != nil {
                self.userFavorites = value! as! Array<Int>
                if self.userFavorites.contains(self.data["id"] as! Int) {
                    self.pictureButton.setTitle("Remove from favorites", for: .normal)
                    self.pictureButton.setTitleColor(UIColor.red, for: .normal)
                } else {
                    self.pictureButton.setTitle("Add to favorites", for: .normal)
                    self.pictureButton.setTitleColor(UIColor.white, for: .normal)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    @IBAction func saveButtonAction(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(pictureImage.image!, saveImageHandler(_:didFinishSavingWithError:contextInfo:), nil, nil)
    }
    
    func saveImageHandler(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if error == nil {
            let alert = UIAlertController(title: "Succes!", message: "The image was saved to your photos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Failed...", message: error?.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func pictureButtonAction(_ sender: Any) {
        if self.userFavorites.contains(data["id"] as! Int) {
            pictureButton.setTitle("Add to favorites", for: .normal)
            pictureButton.setTitleColor(UIColor.white, for: .normal)
            if let index = self.userFavorites.index(of: data["id"] as! Int) {
                self.userFavorites.remove(at: index)
                db.updateFavorites(userFavorites: self.userFavorites)
            }
        } else {
            pictureButton.setTitle("Remove from favorites", for: .normal)
            pictureButton.setTitleColor(UIColor.red, for: .normal)
            self.userFavorites.append(data["id"] as! Int)
            db.updateFavorites(userFavorites: self.userFavorites)
            db.addFavorite(data: data)
        }
    }
}
