//
//  HSPlansHeaderTitleReusableView.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/17/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSPlansHeaderTitleReusableView: UICollectionReusableView,CellConfigurer {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    public func getHeight()->CGFloat {
        let calculatedSize = self.titleLabel.sizeThatFits(CGSize(width:self.titleLabel.frame.width,height:999))
        return calculatedSize.height + 30
    }
    
    public func populatePlansTitle(title:String) {
        titleLabel.text = title
    }
    
}

