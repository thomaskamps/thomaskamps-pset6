//
//  ContactsFavoritesTableViewCell.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 16-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit

class ContactsFavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var picture: RemoteImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
