//
//  String+Additions.swift
//  Handstand
//
//  Created by Ranjith Kumar on 8/31/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    func addKernAttribute(){
        self.attributedText = self.text?.manageKerning(font, attributedText: attributedText, text: text!)
    }
}

extension UITextField {
    func addKernAttribute(){
        self.attributedText = self.text?.manageKerning(font!, text: text!)
    }
}

extension String {
    func manageKerning(_ font:UIFont,attributedText:NSAttributedString? = nil,text:String)->NSMutableAttributedString {
        let attrs = [
            NSFontAttributeName: font
        ]
        
        var attrStr:NSMutableAttributedString?
        
        if attributedText != nil {
            attrStr = attributedText as! NSMutableAttributedString?
        }else {
            attrStr = NSMutableAttributedString(string: text, attributes: attrs)
        }
        attrStr?.addAttribute(NSKernAttributeName, value: NSNumber.init(value: 2.0), range: NSRange.init(location: 0, length: (text.characters.count)))
        return attrStr!
    }
    func length()->Int {
        return self.count
    }
}
