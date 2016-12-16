//
//  FireBaseHelper.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 12-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import Foundation
import Firebase

class FireBaseHelper {
    
    static let sharedInstance = FireBaseHelper()
    
    private init() {
        userID = FIRAuth.auth()?.currentUser?.uid
    }
    
    var ref = FIRDatabase.database().reference()
    var userID: String?
    
    func createAccount(username: String, email: String, password: String) -> String? {
        var returnVal: String? = nil
        FIRAuth.auth()!.createUser(withEmail: email, password: password) { user, error in
            if error == nil {
                FIRAuth.auth()!.signIn(withEmail: email, password: password)
                var ref = FIRDatabase.database().reference()
                let userID = FIRAuth.auth()?.currentUser?.uid
                ref.child("users").child(userID!).setValue(["favorites": []])
                ref.child("userNames/"+username).setValue(userID)
            } else {
                /*let alert = UIAlertController(title: "Error", message: "Something went wrong while creating your account!", preferredStyle: UIAlertControllerStyle.alert)
                let oke = UIAlertAction(title: "Oke", style: UIAlertActionStyle.default)
                alert.addAction(oke)
                self.present(alert, animated: true, completion: nil)*/
                returnVal = String(describing: error)
            }
        }
        return returnVal
    }
    
    func login(email: String, password: String) throws {
        do {
            try FIRAuth.auth()!.signIn(withEmail: email, password: password)
            self.userID = FIRAuth.auth()?.currentUser?.uid
        } catch {
            throw error
        }
    }
    
    func updateFavorites(userFavorites: Array<Int>) {
        self.ref.child("users/"+self.userID!+"/favorites").setValue(userFavorites)
    }
    
    func addFavorite(data: Dictionary<String, Any>) {
        let dataRef = self.ref.child("users/"+self.userID!+"/favoritesData/"+String(describing: data["id"]!))
        dataRef.setValue(["user": data["user"], "downloads": data["downloads"], "previewURL": data["previewURL"], "webformatURL": data["webformatURL"], "id": data["id"]])
    }
    
    func logOut() throws {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let signOutError as NSError {
            throw signOutError
        }
    }
    /*
    func getUserId(userName: String) -> String {
        var retrievedUserID: String = ""
        
        return retrievedUserID
    }*/
    /*
    func getUserNames() -> Dictionary<String, String>? {
        var retrievedUserNames: Dictionary<String, String>? = nil
        self.ref.child("userNames").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            retrievedUserNames = (value as? Dictionary<String, String> ?? nil)!
        }) { (error) in
            print(error.localizedDescription)
        }
        return retrievedUserNames
    }*/
}
