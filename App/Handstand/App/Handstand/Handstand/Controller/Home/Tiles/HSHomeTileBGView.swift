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
        self.layer.borderColor = UIColor.rgba(0xD4D4D4, alpha: 0.5).cgColor
        self.layer.borderWidth = 0.7
        self.layer.cornerRadius = 3
    }

}

