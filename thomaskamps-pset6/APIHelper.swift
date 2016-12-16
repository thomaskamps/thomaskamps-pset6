//
//  APIHelper.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 09-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import Foundation
import Siesta

// Helper for creating a singleton containing a Siesta Service
// This is needed for optimal benefits from the Siesta framework
class APIHelper {
    
    // Make this a singleton
    static let sharedInstance = APIHelper()
    private init() { }
    
    // Create initial Service and key var
    let pixabayAPI = Service(baseURL: "https://pixabay.com/api")
    private let key = "3987140-123363b3a4777b57ef5875d82"
    
    // Function for creating a resource, initialized with the API-key
    func createResource() -> Resource {
        return pixabayAPI.resource("/").withParam("key", self.key)
    }
    
}
