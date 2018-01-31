//
//  HSProfilePictureCell.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/23/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSProfilePictureCell:UITableViewCell,CellConfigurer {
    
    //Caption:Change Profile Picture
    @IBOutlet weak var changeProfilePictureHeightLC: NSLayoutConstraint!
    @IBOutlet weak var changeProfilePictureTopspaceLC: NSLayoutConstraint!
    
    @IBOutlet weak var roundRectView: HSRoundedView!
    public var isProfileEditing:Bool = false {
        didSet {
            if isProfileEditing == false {
                changeProfilePictureHeightLC.constant = 0
                changeProfilePictureTopspaceLC.constant = 0
            }else {
                changeProfilePictureHeightLC.constant = 21
                changeProfilePictureTopspaceLC.constant = 10
            }
            self.layoutIfNeeded()
        }
    }
    
    public func populateData(with userModel:HSUser) {
        if let avatar = userModel.avatar {
            if avatar.count == 0 {
                roundRectView.imageView.image = #imageLiteral(resourceName: "icAvatarPlaceholder")
                roundRectView.backgroundColor = HSColorUtility.roundedRedColor()
            }else {
                roundRectView.imageView.sd_setImage(with: URL.init(string: avatar))
                if let code = HSUserManager.shared.currentUser?.quizData?.color {
                    roundRectView.backgroundColor = HSColorUtility.getMarkerTagColor(with: code)
                }
            }
        }else {
            roundRectView.imageView.image = #imageLiteral(resourceName: "icAvatarPlaceholder")
            roundRectView.backgroundColor = HSColorUtility.roundedRedColor()
        }
    }
    
}
