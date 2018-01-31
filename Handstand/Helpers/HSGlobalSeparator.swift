//
//  HSGlobalSeparator.swift
//  Handstand
//
//  Created by Ranjith Kumar on 1/5/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import UIKit

class HSGlobalSeparator: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = HSColorUtility.globalSeparatorColor()
    }
}
