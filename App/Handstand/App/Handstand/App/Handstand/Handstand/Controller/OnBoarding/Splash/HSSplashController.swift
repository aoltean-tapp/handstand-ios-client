//
//  HSSplashController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/6/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSSplashController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.startShimmering()
        if HSUserManager.shared.isUserLoggedIn() {
            showNextController()
        }else {
            fetchClassTypesWithAppVersion()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchClassTypesWithAppVersion() {
        HSSystemNetworkHandler().fetchClassTypes { [weak self](success, error) in
            self?.imageView.stopShimmering()
            let nc = HSBaseNavigationController.init(rootViewController: HSEntryScreenController())
            appDelegate.window?.rootViewController = nc
            if error?.code == eErrorType.invalidAppVersion {
                HSApp().alertUserToForceDownloadNewVersion((error?.message!)!)
            }
            else{
                if error?.code == eErrorType.updateAppVersion {
                    HSApp().alertUserToDownloadNewVersion((error?.message)!)
                }
            }
        }
    }
    
    func showNextController()  {
        HSApp().getAppFirstController { (firstCntrl) in
            self.imageView.stopShimmering()
            if let firstCntrl = firstCntrl {
                if firstCntrl is HSBaseTabBarController {
                    appDelegate.window?.rootViewController = firstCntrl
                }else {
                    self.navigationController?.pushViewController(firstCntrl, animated: false)
                }
            }
        }
    }

}
