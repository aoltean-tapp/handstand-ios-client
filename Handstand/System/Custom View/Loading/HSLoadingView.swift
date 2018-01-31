//
//  HSLoadingView.swift
//  Handstand
//
//  Created by Fareeth John on 4/6/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSLoadingView: UIView {

    @IBOutlet var hIconImageView: UIImageView!
    private var isStopAnimation : Bool = false
    private let viewTag = 19081
    
    class func standardLoading() -> HSLoadingView{
        return HSLoadingView.fromNib()
    }
    
    override func awakeFromNib() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
    
    func startLoading()  {
        self.tag = viewTag
        UIApplication.shared.keyWindow?.addSubview(self)
        startAnimation()
    }
    
    func stopLoading()  {
        stopAnimation()
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
        }, completion: {success in
            UIApplication.shared.keyWindow?.viewWithTag(self.viewTag)?.removeFromSuperview()
        })
    }
    
    private func startAnimation()  {
        if isStopAnimation == true {
            return
        }
        UIView.animate(withDuration: 0.6,
                       animations: {
                        self.hIconImageView.alpha = 0.3
                        self.hIconImageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6,
                                       animations: {
                                        DispatchQueue.main.async {
                                            self.hIconImageView.alpha = 1.0
                                            self.hIconImageView.transform = CGAffineTransform.identity
                                        }
                        },
                                       completion: { _ in
                                        self.startAnimation()
                        })
        })
    }
    
    private func stopAnimation()  {
        isStopAnimation = true
    }


}
