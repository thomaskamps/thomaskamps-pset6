//
//  RemoteImageView.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 12-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit
import Siesta

/// Extension for remote images. Adapted from the Siesta framework documentation.
class RemoteImageView: UIImageView {
    static var imageCache: Service = Service()
    
    // Set placeholder for network failures / not found pictures
    var placeholderImage = UIImage(named: "placeholder")
    
    // Property to be set with URL of your image, creates a Siesta resource when set
    var imageURL: URL? {
        get { return imageResource?.url }
        set { imageResource = RemoteImageView.imageCache.resource(absoluteURL: newValue) }
    }
    
    // Image resource, when set loads the image if possible, otherwise displays placeholder
    var imageResource: Resource? {
        willSet {
            imageResource?.removeObservers(ownedBy: self)
            imageResource?.cancelLoadIfUnobserved(afterDelay: 0.05)
        }
        
        didSet {
            imageResource?.loadIfNeeded()
            imageResource?.addObserver(owner: self) { [weak self] _ in
                self?.image = self?.imageResource?.typedContent(
                    ifNone: self?.placeholderImage)
            }
        }
    }
}
