//
//  FireBaseHelper.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 12-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import Foundation
import Firebase

// Helper for interacting with the Firebase database
class FireBaseHelper {
    
    // Make this become a singleton
    static let sharedInstance = FireBaseHelper()
    private init() {
        userID = FIRAuth.auth()?.currentUser?.uid
    }
    
    // Init vars
    var ref = FIRDatabase.database().reference()
    var userID: String?
    
    // Log in and automatically set userID
    func login(email: String, password: String) throws {
        FIRAuth.auth()!.signIn(withEmail: email, password: password)
        self.userID = FIRAuth.auth()?.currentUser?.uid
    }
    
    // Update regular (private) favorites, replaces entire array
    func updateFavorites(userFavorites: Array<Int>) {
        self.ref.child("users/"+self.userID!+"/favorites").setValue(userFavorites)
    }
    
    // Update publicly visible favorites, replaces entire array
    func updatePublicFavorites(userFavorites: Array<Int>) {
        self.ref.child("publicFavorites/"+self.userID!).setValue(userFavorites)
    }
    
    // Adds favoritesData item containing data of a specific favorite picture
    func addFavorite(data: Dictionary<String, Any>) {
        let dataRef = self.ref.child("users/"+self.userID!+"/favoritesData/"+String(describing: data["id"]!))
        dataRef.setValue(["user": data["user"], "downloads": data["downloads"], "previewURL": data["previewURL"], "webformatURL": data["webformatURL"], "id": data["id"]])
    }
    
    // Log current user out
    func logOut() throws {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let signOutError as NSError {
            throw signOutError
        }
    }
    
    // Delete favoritesData item containing data of a specific favorite picture
    func deleteFavorite(id: String) {
        let dataRef = self.ref.child("users/"+self.userID!+"/favoritesData/"+id)
        dataRef.removeValue()
    }
}
