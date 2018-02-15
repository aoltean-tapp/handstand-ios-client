//
//  HSTrainerChatBubbleCell.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/12/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import UIKit

class HSTrainerChatBubbleCell: UICollectionViewCell {

    @IBOutlet weak var trainerImageView: UIImageView!
    @IBOutlet weak var trainerMessageLabel: UILabel!
    @IBOutlet weak var chatBubbleView: UIView!
    @IBOutlet weak var messageWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func resizeChatBubble() {
        let properSize = trainerMessageLabel.sizeThatFits(CGSize(width: 246.0, height: 36.0))
        let properWidth = properSize.width + 34.0
        messageWidthConstraint.constant = properWidth <= 38.0 ? 38.0 : properWidth
    }
}
