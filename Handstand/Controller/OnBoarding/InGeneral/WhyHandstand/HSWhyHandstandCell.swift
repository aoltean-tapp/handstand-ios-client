//
//  HSWhyHandstandCell.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/19/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSWhyHandstandCell: UITableViewCell,CellConfigurer {
    
    @IBOutlet weak var borderView: UIView! {
        didSet {
            borderView.layer.borderWidth = 0.5
            borderView.layer.borderColor = UIColor.lightGray.cgColor
            borderView.layer.cornerRadius = 3.0
        }
    }

    @IBOutlet weak var queryLabel: UILabel!
    @IBOutlet weak var querySelectedImageView: UIImageView!
    
    public func populate(query:HSWhyHandstandDataMeta) {
        queryLabel.text = query.text
        querySelectedImageView.image = query.isSelected ? #imageLiteral(resourceName: "icWhyHandstandBtnCheck") : #imageLiteral(resourceName: "icWhyHandstandBtnUnCheck")
    }
}

