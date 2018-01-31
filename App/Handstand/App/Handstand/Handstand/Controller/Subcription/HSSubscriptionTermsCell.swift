//
//  HSSubscriptionTermsCell.swift
//  Handstand
//
//  Created by Ranjith Kumar on 8/31/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSSubscriptionTermsCell: UITableViewCell {

    @IBOutlet weak var termsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    class func reuseIdentifier()->String {
        return "HSSubscriptionTermsCell"
    }
    
}
