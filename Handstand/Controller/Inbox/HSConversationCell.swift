//
//  HSConversationCell.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/9/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import UIKit

class HSConversationCell: UICollectionViewCell {

    @IBOutlet weak var trainerNameLabel: UILabel!
    @IBOutlet weak var lastContactedTimeLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var sessionDateLabel: UILabel!
    @IBOutlet weak var trainerImageView: UIImageView!
    @IBOutlet weak var sessionStatusImageView: UIImageView!
    
    @IBOutlet weak var pendingApprovalView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
