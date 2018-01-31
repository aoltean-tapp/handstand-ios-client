//
//  HSChoosePlanCVCell.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/17/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSChoosePlanCVCell: UICollectionViewCell,CellConfigurer {

    @IBOutlet weak var _imageView: UIImageView!

    class public func getHeight()->CGFloat {
        return 40
    }
}
