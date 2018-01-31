//
//  HSUpdatePasswordController.swift
//  Handstand
//
//  Created by Fareeth John on 5/12/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSUpdatePasswordController: HSBaseController, HSValidationTextfieldDelegate {
    
    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var reEnterTextfield: HSValidationTextfield!
    @IBOutlet var newPasswordTextfield: HSValidationTextfield!
    @IBOutlet weak var updateBtn: HSLoadingButton!

    var emailID : String! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = HSA.passwordResetScreen
        self.title = "Change Password"
        HSNavigationBarManager.shared.applyProperties(key: .type_0, viewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- MISC
    
    func isAllFieldValid() -> Bool {
        if (newPasswordTextfield.text()?.count)! > 0 {
            if (reEnterTextfield.text()?.count)! > 0 {
                if newPasswordTextfield.text() == reEnterTextfield.text() {
                    return true
                }
                else{
                    showErrorMessage(NSLocalizedString("password_not_matching", comment: ""))
                }
            }
            else{
                showErrorMessage(NSLocalizedString("invalid_new_password_error", comment: ""))
            }
        }
        else{
            showErrorMessage(NSLocalizedString("invalid_password_error", comment: ""))
        }
        return false
    }
    
    func showErrorMessage(_ message : String)  {
        errorMessageLabel.text = "* " + message
        errorMessageLabel.isHidden = false
    }
    
    func clearErrorMessage()  {
        errorMessageLabel.isHidden = true
    }
    
    //MARK:- Textfield delagate
    
    func textFieldDidBeginEditing(_ textField: HSValidationTextfield){
        
    }
    func textFieldDidEndEditing(_ textField: HSValidationTextfield){
        
    }
    
    func textField(_ textField: HSValidationTextfield, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        textField.clearError()
        clearErrorMessage()
        return true
    }
    
    func textFieldShouldReturn(_ textField: HSValidationTextfield) -> Bool{
        return true
    }
    
    // MARK: - Button Action
    @IBAction func onSaveAction(_ sender: HSLoadingButton) {
        self.view.findFirstResonder()?.resignFirstResponder()
        if isAllFieldValid() {
            sender.startLoading()
            HSUserManager.shared.password = self.newPasswordTextfield.text()
            HSUserNetworkHandler().saveProfileInfo(profileData: ["password":newPasswordTextfield.text()!], completionHandler: { (isSuccess, error) in
                if isSuccess {
                    HSUserManager.shared.accessToken = HSUserManager.shared.tempAccessToken
                    HSUserManager.shared.tempAccessToken = nil
                    HSAnalytics.setEventForTypes(withLog: HSA.passwordReset)
                    self.doAutoLogin()
                }else {
                    sender.stopLoading()
                    self.showErrorMessage((error?.message)!)
                }
            })
        }
    }
    
    private func doAutoLogin() {
        HSUserNetworkHandler().login(emailID, password: self.reEnterTextfield.text()!) { (success, error) in
            if success {
                self.getProfile()
            }else{
                self.updateBtn.stopLoading()
                HSUtility.showMessage(string: (error?.message)!)
            }
        }
    }

    private func getProfile() {
        HSUserNetworkHandler().getUserProfile(completionHandler: { (success, error) in
            if success == true {
                self.checkLoggedInUserOnboardingSteps()
            }else {
                self.updateBtn.stopLoading()
                HSUtility.showMessage(string: error?.message)
            }
        })
    }

    private func showNextController()  {
        HSApp().getAppFirstController { (firstCntrl) in
            self.updateBtn.stopLoading()
            if let firstCntrl = firstCntrl {
                if firstCntrl is HSBaseTabBarController {
                    appDelegate.window?.rootViewController = firstCntrl
                }else {
                    self.navigationController?.pushViewController(firstCntrl, animated: false)
                }
            }
        }
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
                        controllers = [personInfoScreen,quizStyleSelectionScreen,whyHandstandScreen]
                    }
                }else {
                    controllers = [personInfoScreen,quizStyleSelectionScreen]
                }
            }else {
                controllers = [personInfoScreen]
            }
        }else {
            HSAppManager.shared.newPlan = false
            if user?.gender != nil {
                if user?.quizData?.color != nil {
                    if user?.onboarding == true {
                        controllers = []
                    }else {
                        controllers = [personInfoScreen,quizStyleSelectionScreen,whyHandstandScreen,planScreen]
                    }
                }else {
                    controllers = [personInfoScreen,quizStyleSelectionScreen,planScreen]
                }
            }else {
                controllers = [personInfoScreen,planScreen]
            }
        }
        if controllers.count > 0 {
            self.updateBtn.stopLoading()
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.viewControllers = controllers
        }else {
            self.showNextController()
        }
    }
}
