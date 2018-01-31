//
//  HSBorderView.swift
//  Handstand
//
//  Created by Fareeth John on 4/26/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSBorderView: UIView {
    
    enum eBorderType: Int {
        case normal = 1
        case selected = 2
        case error = 3
    }


    @IBInspectable var borderColor: UIColor = UIColor.lightGray
    @IBInspectable var selectedColor: UIColor = UIColor.lightGray
    @IBInspectable var errorColor: UIColor = UIColor.lightGray
    @IBInspectable var isCircle: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    /*
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }*/
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isCircle {
            self.layer.cornerRadius = self.frame.size.width/2
            var theFrame = self.frame
            if theFrame.size.height != theFrame.size.width {
                theFrame.size.height = theFrame.size.width
                self.frame = theFrame
            }
        }
    }
    
    func setupUI()  {
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        if isCircle {
            self.layer.cornerRadius = self.frame.size.width/2
        }
    }
    
    func setBorderColor(forType type : eBorderType){
        switch type {
        case .normal:
            self.layer.borderColor = borderColor.cgColor
            break
        case .selected:
            self.layer.borderColor = selectedColor.cgColor
            break
        case .error:
            self.layer.borderColor = errorColor.cgColor
            break
        }
    }

}
