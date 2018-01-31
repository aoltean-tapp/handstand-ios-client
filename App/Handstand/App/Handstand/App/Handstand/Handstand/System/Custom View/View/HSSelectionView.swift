//
//  HSSelectionView.swift
//  Handstand
//
//  Created by Fareeth John on 4/26/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

protocol HSSelectionViewDelegate {
    func didChangeInHeight(_ height : CGFloat, onView view : HSSelectionView)
}

class HSSelectionView: UIView {

    @IBOutlet var selectionView: UIView!
    @IBOutlet var detailView: UIView!
    var isDetailVisible : Bool = false
    var delegate : HSSelectionViewDelegate? = nil

    func showDetailScreen()  {
        isDetailVisible = true
        let selectionViewFrame = selectionView.frame
        var detailScreenFrame = self.detailView.frame
        detailScreenFrame.origin.y = selectionViewFrame.size.height
        var theFrame = self.frame
        theFrame.size.height = selectionViewFrame.size.height + detailScreenFrame.size.height
        delegate?.didChangeInHeight(theFrame.size.height, onView: self)
        UIView.animate(withDuration: 0.5, animations: {
            self.detailView.frame = detailScreenFrame
            self.frame = theFrame
        }, completion: {success in
            
        })
    }
    
    func hideDetailScreen() {
        isDetailVisible = false
        let selectionViewFrame = selectionView.frame
        var theFrame = self.frame
        theFrame.size.height = selectionViewFrame.size.height
        delegate?.didChangeInHeight(theFrame.size.height, onView: self)
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = theFrame
        }, completion: {success in
            
        })
    }
    
}
