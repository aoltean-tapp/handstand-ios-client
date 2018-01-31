//
//  HSSplashController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/6/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSSplashController: UIViewController {
    //MARK: - iVars
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAppVersion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Private functions
    private func fetchAppVersion() {
        imageView.startShimmering()
        HSSystemNetworkHandler().fetchSystemVersion { [weak self](success, error) in
            if let error = error {
                self?.imageView.stopShimmering()
                if error.code == eErrorType.invalidAppVersion {
                    HSApp().alertUserToForceDownloadNewVersion((error.message!))
                }else{
                    if error.code == eErrorType.updateAppVersion {
                        HSApp().alertUserToDownloadNewVersion((error.message)!)
                    }
                }
            }else {
                if HSUserManager.shared.isUserLoggedIn() {
                    self?.getProfile()
                }else {
                    self?.imageView.stopShimmering()
                    let nc = HSBaseNavigationController.init(rootViewController: HSEntryScreenController())
                    appDelegate.window?.rootViewController = nc
                }
            }
        }
    }
    
    private func showNextController()  {
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
    
    private func getProfile() {
        HSUserNetworkHandler().getUserProfile(completionHandler: { (success, error) in
            if success == true {
                self.checkLoggedInUserOnboardingSteps()
            }else {
                HSUtility.showMessage(string: error?.message)
            }
        })
    }
    
    private func checkLoggedInUserOnboardingSteps() {
        let user = HSUserManager.shared.currentUser
        //User did not purchase anything like(Subscription|Session)
        var controllers:[UIViewController]? = nil
        if user?.newPlan == false {
            let planScreen = HSChoosePlanController()
            controllers = [planScreen]
        }else if(user?.gender == nil) {
            let personInfoScreen = HSPersonalInfoController()
            controllers = [personInfoScreen]
        } else if (user?.quizData?.color == nil) {
            let quizStyleSelectionScreen = HSQuizStyleSelectionController()
            controllers = [quizStyleSelectionScreen]
        }else if (user?.onboarding == false) {
            let whyHandstandScreen = HSWhyHandstandViewController()
            controllers = [whyHandstandScreen]
        }
        if let controllers = controllers {
            self.imageView.stopShimmering()
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.viewControllers = controllers
        }else {
            // Goto Home Screen
            self.showNextController()
        }
    }
}
