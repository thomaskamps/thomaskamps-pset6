//
//  FavoritesTableViewCell.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 12-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoritesImg: RemoteImageView!
    @IBOutlet weak var favoritesLabel2: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
