//
//  HSSubscriptionTermsLinkCell.swift
//  Handstand
//
//  Created by Ranjith Kumar on 8/31/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSSubscriptionTermsLinkCell: UITableViewCell {

    @IBOutlet weak var termsTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func reuseIdentifier()->String {
        return "HSSubscriptionTermsLinkCell"
    }
    
}
