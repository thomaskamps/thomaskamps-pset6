//
//  ContactsTableViewCell.swift
//  thomaskamps-pset6
//
//  Created by Thomas Kamps on 15-12-16.
//  Copyright © 2016 Thomas Kamps. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var contactLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
