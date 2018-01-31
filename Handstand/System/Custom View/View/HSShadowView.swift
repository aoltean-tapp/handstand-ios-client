//
//  HSShadowView.swift
//  Handstand
//
//  Created by Fareeth John on 5/5/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSShadowView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.lightGray
    @IBInspectable var isOutlined: Bool = false

    override func awakeFromNib() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        
        if isOutlined {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = 0.5
        }

    }

    override func layoutSubviews() {
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
}
