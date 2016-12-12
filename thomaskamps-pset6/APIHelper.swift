//
//  APIHelper.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 09-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import Foundation
import Siesta
import SwiftyJSON

class APIHelper {
    
    static let sharedInstance = APIHelper()
    
    let pixabayAPI = Service(baseURL: "https://pixabay.com/api")
    let key = "3987140-123363b3a4777b57ef5875d82"
    
    private init() { }
    
    
    

    /*
    func getJSON(givenID: String){
        let reqURL = URL(string: "https://www.omdbapi.com/?plot=full&r=json&i="+givenID)
        URLSession.shared.dataTask(with: reqURL! as URL, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Geen error")
                return
            }
            
            do {
                let parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let parsedDataDict = parsedData as Dictionary
                DispatchQueue.main.async {
                    self.movieData[givenID] = [:] as Dictionary <String, String>
                    self.movieData[givenID]?["title"] = parsedDataDict["Title"] as! String?
                    self.movieData[givenID]?["year"] = parsedDataDict["Year"] String?
                    self.movieData[givenID]?["posterUrl"] = parsedDataDict["Poster"] as! String?
                    self.tableView.reloadData()
                    self.getIMG(givenID: givenID)
                }
                
            } catch {
                print("Error")
            }
        }).resume()
    }
    
    func getIMG(givenID: String){
        let posterUrlTemp = self.movieData[givenID]?["posterUrl"]
        let posterUrl = posterUrlTemp?.replacingOccurrences(of: "http://", with: "https://")
        let posterUrlnew = URL(string: posterUrl!)
        
        URLSession.shared.dataTask(with: posterUrlnew! as URL, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "Geen error")
                return
            }
            DispatchQueue.main.async {
                self.moviePoster[givenID] = data
                self.tableView.reloadData()
            }
            
        }).resume()
    }
    */
    
}
