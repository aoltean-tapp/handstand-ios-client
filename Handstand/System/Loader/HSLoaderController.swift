//
//  HSLoaderController.swift
//  Handstand
//
//  Created by Fareeth John on 3/28/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSLoaderController: HSBaseController {
    
    @IBOutlet var hIconImage: UIImageView!
    var isStopAnimation : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = HSA.splashScreen
        navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startAnimation()
        self.showNextController()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - MISC
    func showNextController()  {
        HSApp().getAppFirstController { (firstCntrl) in
            self.stopAnimation()
            if let firstCntrl = firstCntrl {
                if firstCntrl is HSBaseTabBarController {
                    appDelegate.window?.rootViewController = firstCntrl
                }else {
                    self.navigationController?.pushViewController(firstCntrl, animated: false)
                }
            }
        }
    }
    
    
    func startAnimation()  {
        if isStopAnimation == true {
            return
        }
        UIView.animate(withDuration: 0.6,
                       animations: {
                        self.hIconImage.alpha = 0.3
                        self.hIconImage.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6,
                                       animations: {
                                        self.hIconImage.alpha = 1.0
                                        self.hIconImage.transform = CGAffineTransform.identity
                        },
                                       completion: { _ in
                                        self.startAnimation()
                        })
        })
    }
    
    func stopAnimation()  {
        isStopAnimation = true
    }
    
}
