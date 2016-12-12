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
    
    var placeholderImage = UIImage(named: "placeholder")
    
    var imageURL: URL? {
        get { return imageResource?.url }
        set { imageResource = RemoteImageView.imageCache.resource(absoluteURL: newValue) }
    }
    
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
