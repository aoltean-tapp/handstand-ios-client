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
//        setPrefilledInputs()
        UINavigationBar.appearance().barStyle = .blackOpaque
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UINavigationBar.appearance().barStyle = .default
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
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
                if success {
                    self.getProfile()
                }
                else{
                    sender.stopLoading()
                    HSUtility.showMessage(string: (error?.message)!)
                }
            })
        }
    }
    
    private func getProfile() {
        HSUserNetworkHandler().getUserProfile(completionHandler: { (success, error) in
            if success == true {
                self.checkLoggedInUserOnboardingSteps()
            }else {
                self.loginButton.stopLoading()
                HSUtility.showMessage(string: error?.message)
            }
        })
    }

    private func showNextController()  {
        HSApp().getAppFirstController { (firstCntrl) in
            self.loginButton.stopLoading()
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
            self.loginButton.stopLoading()
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.viewControllers = controllers
        }else {
            self.showNextController()
        }
    }
    
    @IBAction func didTapForgotPassword(_ sender: Any) {
        let forgotPassCntrl = HSForgotPasswordEmailController()
        navigationController?.pushViewController(forgotPassCntrl, animated: true)
    } 
    
    //MARK: - Private functions
    private func setPrefilledInputs() {
        self.emailTextField.text = "ranjith@handstandapp.com"
        self.passwordTextField.text = "password"
//        self.emailTextField.text = "0323@gmail.com"
//                self.passwordTextField.text = "11111111"
//        self.emailTextField.text = "07082017@gmail.com"
//        self.passwordTextField.text = "11111111"
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
