//
//  HSPaymentCardCell.swift
//  Handstand
//
//  Created by Fareeth John on 5/19/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSPaymentCardCell: UITableViewCell {

    @IBOutlet var cardNumberLabel: UILabel!
    @IBOutlet var brandLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
