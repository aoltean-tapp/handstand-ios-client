//
//  HSNewSubscriptionHeaderCell.swift
//  Handstand
//
//  Created by Ranjith Kumar on 1/10/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import UIKit

class HSNewSubscriptionHeaderCell: UICollectionViewCell,CellConfigurer {

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 2.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        dropShadow()
    }

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    public func populate(data:HSNewSubscriptionPlans) {
        self.contentLabel.text = data.text1! + "\n" + data.text2!
        self.priceLabel.text = data.price! + "\n" + data.duration!
    }
    
    internal override func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowRadius = 4.0
        layer.cornerRadius = 5.0
    }
    
}
