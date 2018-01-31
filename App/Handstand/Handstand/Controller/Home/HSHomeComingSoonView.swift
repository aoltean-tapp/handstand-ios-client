//
//  HSHomeComingSoonView.swift
//  Handstand
//
//  Created by Fareeth John on 4/19/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
import ReachabilitySwift

protocol HSHomeComingSoonViewProtocol:class {
    func didTapCloseComingSoonView()
    func didTapToShowNewSubscriptionScreen()
}

class HSHomeComingSoonView: UIView,HSSubcriptionControllerDelegate,SubscriptionRegisterProtocol {
    
    public weak var delegate:HSHomeComingSoonViewProtocol?
    lazy var subscriptionController:HSSubcriptionController = HSSubcriptionController()
    lazy var subscribeToRegisterController:HSSubscriptionRegisterController = HSSubscriptionRegisterController()

    @IBOutlet var videoButton: UIButton!
    @IBOutlet var messageLabel: UILabel!
    var cityName : String! = ""
    override func awakeFromNib() {
    }
    
    func setCity(_ city : String)  {
        cityName = city
        messageLabel.text = NSLocalizedString("City_ComingSoon", comment: "").replacingOccurrences(of: "(City)", with: city)
    }

    //MARK:- Button Action
    
    @IBAction func onCloseAction(_ sender: UIButton) {
        self.delegate?.didTapCloseComingSoonView()
        UIView.animate(withDuration: 0.5, animations: {
        }, completion: {success in
            self.removeFromSuperview()
        })
    }
    
    @IBAction func onWatchVideoAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
//            self.superview?.alpha = 0
        }, completion: {success in
            let reachability = Reachability()!
            reachability.whenReachable = { reachability in
                DispatchQueue.main.async {
                    self.videoClicked()
                }
            }
            reachability.whenUnreachable = { reachability in
                DispatchQueue.main.async {
                    HSUtility.showMessage(string: NSLocalizedString("network_error", comment: ""), title: "Handstand")
                }
            }
            do {
                try reachability.startNotifier()
            } catch {
                debugPrint("Unable to start notifier")
            }
        })
    }
    func videoClicked() {
        if HSUserManager.shared.hasValidMembership == false {
//            if HSUserManager.shared.currentUser?.subscribeBefore == false {
//                self.showSubscriptionRegisterScene()
//            }else {
//                self.showSubscriptionScene()
//            }
            self.delegate?.didTapToShowNewSubscriptionScreen()
        }else {
            if let _ = HSAppManager.shared.videoSession?.dailyVideo {
                self.showVideoViewController()
            }else {
                HSUtility.showMessage(string: "Sorry! Video is not Available!", title: "Handstand")
            }
        }
    }
    func showVideo()  {
        if HSAppManager.shared.videoSession != nil {
            showVideoViewController()
        }
        else{
            HSLoadingView.standardLoading().startLoading()
            HSUserNetworkHandler().getMyHomeInfo({ (video, error) in
                HSLoadingView.standardLoading().stopLoading()
                if error != nil{
                    HSUtility.showMessage(string: (error?.message)!)
                }
                else{
                    if HSAppManager.shared.videoSession != nil {
                        self.showVideo()
                    }
                }
            })
        }
    }
    func showVideoViewController(){
        let videoVwCntrl = HSVideoViewController()
        let topController = HSUtility.getTopController()
        topController.present(videoVwCntrl, animated: true, completion: nil)
    }
    
    //MARK: - Private functions
    
    func showSubscriptionScene() {
        self.subscriptionController.view.frame = CGRect(x:0,
                                                        y:self.frame.height,
                                                        width:ScreenCons.SCREEN_WIDTH,
                                                        height:self.frame.height)
        self.addSubview(self.subscriptionController.view)
        self.subscriptionController.view.alpha = 0.0
        self.subscriptionController.delegate = self
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
            self.subscriptionController.view.frame = CGRect(x:0,
                                                            y:0,
                                                            width:ScreenCons.SCREEN_WIDTH,
                                                            height:self.frame.height)
            self.subscriptionController.view.alpha = 1.0
        }) { (finished) in
            HSAnalytics.setEventForTypes(withLog: HSA.subscriptionsScreen)
        }
    }
    func closeSubscriptionScene() {
        self.subscriptionController.view.frame = CGRect(x:0,y:self.frame.height,width:ScreenCons.SCREEN_WIDTH,height:self.frame.height)
        self.subscriptionController.willMove(toParentViewController: nil)
        self.subscriptionController.view.alpha = 1.0
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
            self.subscriptionController.view.frame = CGRect(x:0,y:self.frame.height,width:ScreenCons.SCREEN_WIDTH,height:self.frame.height)
            self.subscriptionController.view.alpha = 0.0
        }) { (finished) in
            self.subscriptionController.view.removeFromSuperview()
            self.subscriptionController.removeFromParentViewController()
        }
    }
    
    func removeSubscriptionView() {
        self.subscriptionController.view.removeFromSuperview()
        self.subscriptionController.removeFromParentViewController()
        self.subscribeToRegisterController.view.removeFromSuperview()
        self.subscribeToRegisterController.removeFromParentViewController()
    }
    
    func showSubscriptionRegisterScene() {
        self.subscribeToRegisterController.view.frame = CGRect(x:0,
                                                               y:ScreenCons.SCREEN_HEIGHT,
                                                               width:ScreenCons.SCREEN_WIDTH,
                                                               height:ScreenCons.SCREEN_HEIGHT)
        self.addSubview(self.self.subscribeToRegisterController.view)
        self.subscribeToRegisterController.view.alpha = 0.0
        self.subscribeToRegisterController.delegate = self
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
            self.subscribeToRegisterController.view.frame = CGRect(x:0,
                                                                   y:0,
                                                                   width:ScreenCons.SCREEN_WIDTH,
                                                                   height:ScreenCons.SCREEN_HEIGHT)
            self.subscribeToRegisterController.view.alpha = 1.0
        }) { (finished) in
            HSAnalytics.setEventForTypes(withLog: HSA.subFreeTrailScreen) }
    }
    
    func closeSubscriptionRegisterScene() {
        self.subscribeToRegisterController.view.frame = CGRect(x:0,y:self.frame.height,width:ScreenCons.SCREEN_WIDTH,height:self.frame.height)
        self.subscribeToRegisterController.willMove(toParentViewController: nil)
        self.subscribeToRegisterController.view.alpha = 1.0
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
            self.subscribeToRegisterController.view.frame = CGRect(x:0,y:self.frame.height,width:ScreenCons.SCREEN_WIDTH,height:self.frame.height)
            self.subscribeToRegisterController.view.alpha = 0.0
        }) { (finished) in
            self.subscribeToRegisterController.view.removeFromSuperview()
            self.subscribeToRegisterController.removeFromParentViewController()
        }
    }

}
