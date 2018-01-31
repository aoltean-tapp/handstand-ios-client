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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
                }else if error.code == eErrorType.updateAppVersion {
                    HSApp().alertUserToDownloadNewVersion((error.message)!)
                }else {
                    HSUtility.showMessage(string: error.message)
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
        var controllers:[UIViewController] = []
        let planScreen = HSChoosePlanController()
        let personInfoScreen = HSPersonalInfoController()
        let whyHandstandScreen = HSWhyHandstandViewController()
        let quizStyleSelectionScreen = HSQuizStyleSelectionController()

        if user?.newPlan == true {
            if user?.gender != nil {
                if user?.quizData?.color != nil {
                    if user?.onboarding == true {
                        controllers = []
                    }else {
                        whyHandstandScreen.navType = .type_None
                        controllers = [whyHandstandScreen]
                    }
                }else {
                    quizStyleSelectionScreen.navType = .type_18
                    controllers = [quizStyleSelectionScreen]
                }
            }else {
                personInfoScreen.navType = .type_None
                controllers = [personInfoScreen]
            }
        }else {
            HSAppManager.shared.newPlan = false
            if user?.gender != nil {
                if user?.quizData?.color != nil {
                    if user?.onboarding == true {
                        controllers = []
                    }else {
                        whyHandstandScreen.navType = .type_None
                        controllers = [whyHandstandScreen,planScreen]
                    }
                }else {
                    quizStyleSelectionScreen.navType = .type_18
                    controllers = [quizStyleSelectionScreen,planScreen]
                }
            }else {
                personInfoScreen.navType = .type_None
                controllers = [personInfoScreen,planScreen]
            }
        }
        if controllers.count > 0 {
            self.imageView.stopShimmering()
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.viewControllers = controllers
        }else {
            self.showNextController()
        }
    }
}

