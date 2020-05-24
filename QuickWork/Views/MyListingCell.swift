//
//  MyListingCell.swift
//  QuickWork
//
//  Created by Joshua Chan on 5/24/20.
//  Copyright © 2020 Joshua Chan. All rights reserved.
//

import UIKit

class MyListingCell: UITableViewCell {

    @IBOutlet weak var myListingNameLabel: UILabel!
    
    @IBOutlet weak var myDetailsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
