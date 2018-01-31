//
//  HSHomeTileBGView.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/29/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSHomeTileBGView: UIView {
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.rgb(0xFCFCFC)
        self.layer.borderColor = UIColor.rgb(0xD7D7D7).cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 4
    }

}

