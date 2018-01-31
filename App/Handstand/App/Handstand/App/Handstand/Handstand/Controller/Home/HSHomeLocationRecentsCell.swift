//
//  HSHomeLocationRecentsCell.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/28/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSHomeLocationRecentsCell: UITableViewCell,CellConfigurer {
    
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    func populate(text:String,image:UIImage) {
        locationImageView.image = image
        locationNameLabel.text = text
    }
    
}
