//
//  HSTrainerListFooterView.swift
//  Handstand
//
//  Created by Fareeth John on 5/25/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSTrainerListFooterView: UIView {
    var loadingIndictor  = NVActivityIndicatorView(frame:  CGRect(x: 0, y: 0, width: 27.5, height: 27.5))
    
    override func awakeFromNib() {
        self.addSubview(loadingIndictor)
        loadingIndictor.isHidden = true
        loadingIndictor.color = .lightGray
        loadingIndictor.type = .ballRotateChase
        loadingIndictor.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        loadingIndictor.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
    }

    func startLoading()  {
        loadingIndictor.isHidden = false
        loadingIndictor.startAnimating()
    }
    
    func stopLoading()  {
        loadingIndictor.stopAnimating()
        loadingIndictor.isHidden = true
    }

}
