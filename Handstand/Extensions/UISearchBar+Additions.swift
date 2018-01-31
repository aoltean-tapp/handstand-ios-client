//
//  UISearchBar+Additions.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/28/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import Foundation

extension UISearchBar {
    public func setCustomAppearance() {
        let _subviews = subviews.flatMap { $0.subviews }
        guard let txtField = (_subviews.filter { $0 is UITextField }).first as? UITextField else { return }
        txtField.textColor = UIColor.rgb(0x989899)
        txtField.font = HSFontUtilities.avenirNextRegular(size: 17)
    }
}
