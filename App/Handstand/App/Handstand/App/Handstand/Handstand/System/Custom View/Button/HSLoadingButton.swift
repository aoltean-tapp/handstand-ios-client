//
//  HSLoadingButton.swift
//  Handstand
//
//  Created by Fareeth John on 4/6/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit


class HSLoadingButton: HSButton {

    var givenTitle : String?
    var isOnAnimation : Bool = false
    var isCloseAnimated : Bool = false
    var scale : CGFloat = 0.9
    var animationTime = 0.2
    var loadingIndictor  = NVActivityIndicatorView(frame:  CGRect(x: 0, y: 0, width: 27.5, height: 27.5))
    var kViewTag = 15150

    override func awakeFromNib() {
        self.addSubview(loadingIndictor)
        loadingIndictor.isHidden = true
        loadingIndictor.color = .white
        loadingIndictor.type = .ballSpinFadeLoader
        loadingIndictor.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        loadingIndictor.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        loadingIndictor.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
    }
    
    private func retainState()   {
        UIView.animate(withDuration: animationTime,
                       animations: {
                        self.transform = CGAffineTransform.identity
        },
                       completion: { _ in
                        self.isOnAnimation = false
        })
    }
    
    func startLoading()  {
        givenTitle = self.titleLabel?.text
        self.setTitle("", for: .normal)
        loadingIndictor.isHidden = false
        loadingIndictor.startAnimating()
        
        let theView = UIView()
        theView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        theView.backgroundColor = UIColor.clear
        theView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        theView.tag = kViewTag
        UIApplication.shared.delegate?.window??.addSubview(theView)
    }
    
    func stopLoading()  {
        self.setTitle(givenTitle, for: .normal)
        loadingIndictor.stopAnimating()
        loadingIndictor.isHidden = true
        
        let theView = UIApplication.shared.delegate?.window??.viewWithTag(kViewTag)
        theView?.removeFromSuperview()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesBegan(touches, with: event)
        if isOnAnimation == false {
            isOnAnimation = true
            isCloseAnimated = false
            UIView.animate(withDuration: animationTime,
                           animations: {
                            self.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
            },
                           completion: { _ in
                            if self.isCloseAnimated == false{
                                self.isCloseAnimated = true
                            }
                            else{
                                self.retainState()
                            }
            })
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesEnded(touches, with: event)
        if self.isCloseAnimated == false{
            self.isCloseAnimated = true
        }
        else{
            self.retainState()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesCancelled(touches, with: event)
    }

}
