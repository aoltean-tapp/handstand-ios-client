//
//  HSProfileSettingsCell.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/24/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSProfileSettingsCell: UITableViewCell,CellConfigurer {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var rightArrowImageView: UIImageView!
    @IBOutlet private weak var topSeparatorHeightLC: NSLayoutConstraint!
    
    //Lot of code redundant.. Please refactor
    public func populate(with index:Int) {
        switch index {
        case ProfileSettingsRowTypes.changePassword.rawValue:
            titleLabel.text = ProfileSettingsRowTypes.changePassword.desc()
            titleLabel.textColor = UIColor.rgb(0x2A2A2A)
            rightArrowImageView.isHidden = false
            topSeparatorHeightLC.constant = 1.0
            break
        case ProfileSettingsRowTypes.packagesNPayment.rawValue:
            titleLabel.text = ProfileSettingsRowTypes.packagesNPayment.desc()
            titleLabel.textColor = UIColor.rgb(0x2A2A2A)
            rightArrowImageView.isHidden = false
            topSeparatorHeightLC.constant = 0.0
            break
        case ProfileSettingsRowTypes.subscriptionTerms.rawValue:
            titleLabel.text = ProfileSettingsRowTypes.subscriptionTerms.desc()
            titleLabel.textColor = UIColor.rgb(0x2A2A2A)
            rightArrowImageView.isHidden = false
            topSeparatorHeightLC.constant = 0.0
            break
        case ProfileSettingsRowTypes.termsOfService.rawValue:
            titleLabel.text = ProfileSettingsRowTypes.termsOfService.desc()
            titleLabel.textColor = UIColor.rgb(0x2A2A2A)
            rightArrowImageView.isHidden = false
            topSeparatorHeightLC.constant = 0.0
            break
        case ProfileSettingsRowTypes.contactUs.rawValue:
            titleLabel.text = ProfileSettingsRowTypes.contactUs.desc()
            titleLabel.textColor = UIColor.rgb(0x2A2A2A)
            rightArrowImageView.isHidden = true
            topSeparatorHeightLC.constant = 0.0
            break
        case ProfileSettingsRowTypes.rateUs.rawValue:
            titleLabel.text = ProfileSettingsRowTypes.rateUs.desc()
            titleLabel.textColor = UIColor.rgb(0x2A2A2A)
            rightArrowImageView.isHidden = true
            topSeparatorHeightLC.constant = 0.0
            break
        case ProfileSettingsRowTypes.logout.rawValue:
            titleLabel.text = ProfileSettingsRowTypes.logout.desc()
            titleLabel.textColor = UIColor.red
            rightArrowImageView.isHidden = true
            topSeparatorHeightLC.constant = 0.0
            break
        default:
            break
        }
        layoutIfNeeded()
    }
    
}
