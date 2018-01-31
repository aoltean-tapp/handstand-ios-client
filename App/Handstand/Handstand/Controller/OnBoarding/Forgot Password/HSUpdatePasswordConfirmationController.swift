//
//  HSUpdatePasswordConfirmationController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 09/08/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSUpdatePasswordConfirmationController: UIViewController {
    
    var emailID : String! = nil
    var password: String! = nil
    
    @IBOutlet weak var tickImageview: UIImageView! {
        didSet {
            let image = #imageLiteral(resourceName: "ic_confirmPwd_set_tick").withRenderingMode(.alwaysTemplate)
            tickImageview.tintColor = UIColor.rgb(0x51CC97)
            tickImageview.image = image
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        HSNavigationBarManager.shared.applyProperties(key: .type_4, viewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.perform(#selector(HSUpdatePasswordConfirmationController.presentHomeScene), with: nil, afterDelay: 0.4)
    }
    
    func presentHomeScene() {
        appDelegate.window?.rootViewController = HSBaseTabBarController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
