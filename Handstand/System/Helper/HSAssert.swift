//
//  HSAssert.swift
//  Handstand
//
//  Created by Fareeth John on 4/5/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: M_PI * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = FLT_MAX
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
}

extension Collection where Iterator.Element == String {
    var initials: [String] {
        return map{String($0.characters.prefix(1))}
    }
}

extension UIColor {
    
    class func handstandGreen() -> UIColor {
        return UIColor(red:0.33, green:0.8, blue:0.59, alpha:1)
    }
    
    class func handstandGray() -> UIColor {
        return UIColor(red:0.28, green:0.28, blue:0.28, alpha:1)
    }

}
