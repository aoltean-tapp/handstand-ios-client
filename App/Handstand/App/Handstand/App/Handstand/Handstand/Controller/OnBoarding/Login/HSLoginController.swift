//
//  HSLoginController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/20/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
import TextFieldEffects

struct HSTextFieldEffectConstants {
    static let didEndEditingConstant:CGFloat = 60.0
    static let didEndTextFieldConstant:CGFloat = 45.0
}

class HSLoginController: HSBaseController {
    
    //MARK: - iVars
    @IBOutlet weak var emailTextField: HoshiTextField! {
        didSet { emailTextField.delegate = self }
    }
    @IBOutlet weak var passwordTextField: HoshiTextField! {
        didSet { passwordTextField.delegate = self }
    }
    @IBOutlet weak var emailTxtFieldHeightLC: NSLayoutConstraint!
    @IBOutlet weak var passwordTxtFieldHeightLC: NSLayoutConstraint!
    @IBOutlet weak var loginButton: HSLoadingButton! {
        didSet { loginButton.btnType = .typeB }
    }
    @IBOutlet weak var logoViewTopspaceLC: NSLayoutConstraint!
    
    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        HSNavigationBarManager.shared.applyProperties(key: .type_4, viewController: self)
        hideKeyboardWhenTappedAround()
        setPrefilledInputs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func dismissCurrentKeyboard() {
        view.endEditing(true)
        adjustInputTextFields()
    }
    
    //MARK: - Button Actions
    @IBAction func didTapLogin(_ sender: HSLoadingButton) {
        dismissCurrentKeyboard()
        if userCanLogin() == true {
            sender.startLoading()
            HSUserNetworkHandler().login(emailTextField.text!, password: passwordTextField.text!, completionHandler: { (success, error) in
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
                    HSUtility.showMessage(string: (error?.message)!)
                }
            })
        }
    }
    @IBAction func didTapForgotPassword(_ sender: Any) {
        let forgotPassCntrl = HSForgotPasswordEmailController()
        navigationController?.pushViewController(forgotPassCntrl, animated: true)
    } 
    
    //MARK: - Private functions
    private func setPrefilledInputs() {
        self.emailTextField.text = "07082017@gmail.com"
        self.passwordTextField.text = "11111111"
//        self.emailTextField.text="k35@h.com"
//        self.passwordTextField.text="password"
        adjustInputTextFields()
    }
    private func userCanLogin() -> Bool {
        var status : Bool = false
        if let msg = emailTextField.isEmail() {
            HSUtility.showMessage(string: msg, title: AppCons.APPNAME)
        }else if let msg = passwordTextField.isPassword() {
            HSUtility.showMessage(string: msg, title: AppCons.APPNAME)
        }else{
            status = true
        }
        return status
    }
    //MARK: - Internal functions
    internal func adjustInputTextFields() {
        logoViewTopspaceLC.constant = 50
        emailTxtFieldHeightLC.constant = getInputFieldHeight(emailTextField)
        passwordTxtFieldHeightLC.constant = getInputFieldHeight(passwordTextField)
        view.layoutIfNeeded()
    }
    internal func getInputFieldHeight(_ textField:UITextField)->CGFloat {
        if let length = textField.text?.length() {
            return length>0 ? HSTextFieldEffectConstants.didEndEditingConstant : HSTextFieldEffectConstants.didEndTextFieldConstant
        }
        return HSTextFieldEffectConstants.didEndTextFieldConstant
    }
}

extension HSLoginController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailTxtFieldHeightLC.constant = HSTextFieldEffectConstants.didEndEditingConstant
        }else if textField == passwordTextField {
            passwordTxtFieldHeightLC.constant = HSTextFieldEffectConstants.didEndEditingConstant
        }
        if ScreenCons.SCREEN_HEIGHT < 600 {
            logoViewTopspaceLC.constant = 10
        }
        view.layoutIfNeeded()
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            emailTxtFieldHeightLC.constant = getInputFieldHeight(emailTextField)
        }else if textField == passwordTextField {
            passwordTxtFieldHeightLC.constant = getInputFieldHeight(passwordTextField)
        }
        if ScreenCons.SCREEN_HEIGHT < 600 {
            logoViewTopspaceLC.constant = 50
        }
        view.layoutIfNeeded()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField {
            adjustInputTextFields()
            didTapLogin(loginButton)
        }
        return true
    }
}
