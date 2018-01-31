//
//  HSCommon.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/22/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import Foundation
import UIKit

protocol CellConfigurer:class {
    static func nib()->UINib
    static func reuseIdentifier()->String
}

extension CellConfigurer {
    static func nib() -> UINib {
        return UINib.init(nibName: self.reuseIdentifier(), bundle: nil)
    }
    
    static func reuseIdentifier()->String{
        return String(describing: self)
    }
}

class HSBaseTableViewCell:UITableViewCell,CellConfigurer{
    func populateData(){}
}

extension UINib {
    class func nib(with name:String)->UINib {
        return UINib.init(nibName: name, bundle: nil)
    }
}
