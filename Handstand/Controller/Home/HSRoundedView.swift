//
//  HSRoundedView.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/4/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSRoundedView:UIView {
    var ivHeight:CGFloat = 68
    var ivWidth:CGFloat = 68

    let imageView:UIImageView = {
        let iv = UIImageView()
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.white.cgColor
        iv.clipsToBounds = true
        return iv
    }()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = true
//        backgroundColor = HSColorUtility.markerTagColor()
        addSubview(imageView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.commonAttributions()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        commonAttributions()
        addSubview(imageView)
    }
    private func commonAttributions() {
        layer.cornerRadius = frame.height/2
        imageView.frame = CGRect(x:1,y:1,width:ivWidth,height:ivHeight)
        imageView.layer.cornerRadius = imageView.frame.height/2
    }
}
