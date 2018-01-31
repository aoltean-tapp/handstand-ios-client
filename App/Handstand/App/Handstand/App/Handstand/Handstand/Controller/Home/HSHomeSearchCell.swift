//
//  HSHomeSearchCell.swift
//  Handstand
//
//  Created by Fareeth John on 4/12/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSHomeSearchCell: UITableViewCell,CellConfigurer {

    @IBOutlet var addressDetailLabel: UILabel!
    @IBOutlet var addressTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
