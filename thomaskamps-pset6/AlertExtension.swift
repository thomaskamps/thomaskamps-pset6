//
//  AlertExtension.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 15-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let oke = UIAlertAction(title: "Oke", style: .default, handler: nil)
        alert.addAction(oke)
        self.present(alert, animated: true, completion: nil)
    }
    
}
