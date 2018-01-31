//
//  HSLoginViewController.swift
//  Handstand
//
//  Created by Fareeth John on 4/4/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSLoginViewController: HSBaseController, HSValidationTextfieldDelegate {

    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var passwordTextfield: HSValidationTextfield!
    @IBOutlet var emailTextfield: HSValidationTextfield!
    var isFromSignUp = true
    
    enum eTextfieldType: Int {
        case email = 1
        case password = 2
    }
    
    private func setPrefilledInputs() {
        //self.emailTextfield.setText("07082017@gmail.com")
        //self.passwordTextfield.setText("11111111")
        self.emailTextfield.setText("k35@h.com")
        self.passwordTextfield.setText("password")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.setPrefilledInputs()
        self.automaticallyAdjustsScrollViewInsets = false
        signUpBtn.isHidden = !isFromSignUp

        self.screenName = HSA.loginScreen
        signUpBtn.isHidden = !isFromSignUp
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Textfield delegate
   
    func textFieldDidEndEditing(_ textField: HSValidationTextfield){
        switch textField.tag {
        case eTextfieldType.email.rawValue:
            _ = textField.validateForEmail()
            break
        case eTextfieldType.password.rawValue:
            _ = textField.validateForPassword()
            break
        default:
            break
        }
    }
    
    func textField(_ textField: HSValidationTextfield, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        textField.clearError()
        clearErrorMessage()
        return true
    }
    
    func textFieldShouldReturn(_ textField: HSValidationTextfield) -> Bool{
        if textField.returnKeyType == "1" {
            let nextTextfield : HSValidationTextfield = self.view.viewWithTag(textField.tag+1) as! HSValidationTextfield
            nextTextfield.setFirstResponder()
        }
        return true
    }
    
    //MARK:- MISC
    
    func isAllFieldValid() -> Bool {
        var status : Bool = false
        if let emailErrMsg = emailTextfield.validateForEmail() {
            showErrorMessage(emailErrMsg)
        }
        else if let passErrMsg = passwordTextfield.validateForPassword(){
            showErrorMessage(passErrMsg)
        }
        else{
            status = true
        }
        return status
    }
    
    func showErrorMessage(_ message : String)  {
        errorMessageLabel.text = "* " + message
        errorMessageLabel.isHidden = false
    }
    
    func clearErrorMessage()  {
        errorMessageLabel.isHidden = true
    }

    // MARK: - Button Action

    @IBAction func showSignUpAction(_ sender: UIButton) {
        if (self.navigationController?.childViewControllers.count)!==2 {
            self.navigationController?.pushViewController(HSSignupController(), animated: true)
        }else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
   override func didTapBackButton() {
        navigationController?.isNavigationBarHidden = true
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onLoginAction(_ sender: HSLoadingButton) {
        self.view.findFirstResonder()?.resignFirstResponder()
        clearErrorMessage()
        if isAllFieldValid() {
            sender.startLoading()
            HSUserNetworkHandler().login(emailTextfield.text()!, password: passwordTextfield.text()!, completionHandler: { (success, error) in
                sender.stopLoading()
                if success {                    
                    HSLoadingView.standardLoading().startLoading()
                    HSOnboardingServiceHandler().startService({ (success, error) in
                        if success {
                            HSAnalytics.setEventForTypes(withLog: HSA.userLogin)
                            HSAnalytics.setMixpanelLoginConfiguration(HSUserManager.shared.currentUser!)
                            HSApp().getAppFirstController({ (viewcontroller) in
                                HSLoadingView.standardLoading().stopLoading()
                                appDelegate.window?.rootViewController = viewcontroller
                            })
//                            let homeCntrl = HSController.defaultController.getMainController()
//                            self.navigationController?.pushViewController(homeCntrl, animated: false)
                        }
                        else{
                            HSLoadingView.standardLoading().stopLoading()
                            if error?.code == eErrorType.invalidAppVersion {
                                HSApp().alertUserToForceDownloadNewVersion((error?.message)!)
                            }
                            else if error?.code == eErrorType.updateAppVersion {
                                HSApp().alertUserToDownloadNewVersion((error?.message)!)
                            }
                            else{
                                HSUtility.showMessage(string: (error?.message)!)
                            }
                        }
                    })
                }
                else{
                    self.showErrorMessage((error?.message)!)
                }
            })
        }
    }
    
    @IBAction func onForgotPasswordAction(_ sender: UIButton) {
        let forgotPassCntrl = HSForgotPasswordEmailController()
        self.navigationController?.pushViewController(forgotPassCntrl, animated: true)
    }
}
