//
//  HSButton.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/20/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

fileprivate struct ButtonLayerConstants {
    static let cornerRadius:CGFloat = 4.0
    static let borderWidth:CGFloat = 1.0
}

public enum BtnType {
    case typeA
    case typeB
    case typeC
    case typeD
}

class HSButton: UIButton {
    public var btnType: BtnType = .typeA {
        didSet {
            layer.cornerRadius = ButtonLayerConstants.cornerRadius
            switch btnType {
            case .typeA:
                applyPropertiesOnTypeA()
                break
            case .typeB:
                applyPropertiesOnTypeB()
                break
            case .typeC:
                applyPropertiesOnTypeC()
                break
            case .typeD:
                applyPropertiesOnTypeD()
                break
            }
        }
    }
    
    private func applyPropertiesOnTypeA() {
        setTitleColor(.white, for: .normal)
        backgroundColor = UIColor.handstandGreen()
        titleLabel?.font = HSFontUtilities.avenirNextRegular(size: 17)
    }
    
    private func applyPropertiesOnTypeB() {
        setTitleColor(.white, for: .normal)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = ButtonLayerConstants.borderWidth
        backgroundColor = UIColor.clear
        titleLabel?.font = HSFontUtilities.avenirNextDemiBold(size: 17)
    }
    private func applyPropertiesOnTypeC() {
        setTitleColor(UIColor.handstandGreen(), for: .normal)
        backgroundColor = UIColor.white
        titleLabel?.font = HSFontUtilities.avenirNextDemiBold(size: 17)
        layer.borderWidth = ButtonLayerConstants.borderWidth
        layer.borderColor = UIColor.handstandGreen().cgColor
    }
    private func applyPropertiesOnTypeD() {
        setTitleColor(UIColor.white, for: .normal)
        backgroundColor = UIColor.handstandGreen()
        titleLabel?.font = HSFontUtilities.avenirNextDemiBold(size: 17)
    }
    
}
