//
//  HSTrainerClassCell.swift
//  Handstand
//
//  Created by Fareeth John on 4/21/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSTrainerClassCell: UITableViewCell {

    @IBOutlet var backgroundSelectedView: UIView!
    @IBOutlet var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
