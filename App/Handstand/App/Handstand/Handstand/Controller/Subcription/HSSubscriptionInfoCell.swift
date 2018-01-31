//
//  HSSubscriptionInfoCell.swift
//  Handstand
//
//  Created by Ranjith Kumar on 1/10/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import UIKit

class HSSubscriptionInfoCell: UITableViewCell,CellConfigurer {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 2.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        contentView.dropShadow()
    }
    
    public func populateInfo(data:HSDescriptionValue) {
        self.headerLabel.text = data.header
        self.bodyLabel.text = data.body
    }
    
}
