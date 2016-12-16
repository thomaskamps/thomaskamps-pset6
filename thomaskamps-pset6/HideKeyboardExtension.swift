//
//  HideKeyboardExtension.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 16-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import Foundation
import UIKit

// Extension to hide keyboard on tap
// Found at: http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
