//
//  HSSignupController.swift
//  Handstand
//
//  Created by Fareeth John on 4/4/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import SafariServices

let phoneVerificationIdentifier: String = "notification.verifyPhone.identifier"

class HSSignupController: HSBaseController, HSValidationTextfieldDelegate, UGLinkLabelDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var termsCheck: UIImageView!
    @IBOutlet var policyCheck: UIImageView!
    @IBOutlet var policyLabel: UGLinkLabel!
    @IBOutlet var termsLabel: UGLinkLabel!
    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var passwordTextfield: HSValidationTextfield!
    @IBOutlet var phoneNumberTextfield: HSValidationTextfield!
    @IBOutlet var emailTextfield: HSValidationTextfield!
    @IBOutlet var lastNameTextfield: HSValidationTextfield!
    @IBOutlet var firstNameTextfield: HSValidationTextfield!
    
    enum eTextfieldType: Int {
        case firstName = 1
        case lastName = 2
        case email = 3
        case phone = 4
        case password = 5
    }
    func setPrefilledInputs() {
        self.firstNameTextfield.setText("Test")
        self.lastNameTextfield.setText("Email")
        self.emailTextfield.setText("K40@h.com")
        self.phoneNumberTextfield.setText("9704963170")
        self.passwordTextfield.setText("password")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.screenName = HSA.createAccountScreen
//        self.setPrefilledInputs()
        
        scrollView.contentSize = CGSize(width: UIScreen.main.applicationFrame.size.width, height: (policyLabel.superview?.frame.origin.y)! + (policyLabel.superview?.frame.size.height)!)
        if UIScreen.main.applicationFrame.size.height > 568 {
            var theFrame = policyLabel.superview?.frame
            theFrame?.origin.y += 20
            policyLabel.superview?.frame = theFrame!
        }
        
        self.perform(#selector(HSSignupController.buildPolicyLabelData), with: nil, afterDelay: 0.1)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Textfield delegate
    func textFieldDidEndEditing(_ textField: HSValidationTextfield){
        switch textField.tag {
        case eTextfieldType.firstName.rawValue:
            _ = textField.validateForFirstName()
            break
        case eTextfieldType.lastName.rawValue:
            _ = textField.validateForLastName()
            break
        case eTextfieldType.email.rawValue:
            _ = textField.validateForEmail()
            break
        case eTextfieldType.phone.rawValue:
            _ = textField.validateForPhone()
            break
        case eTextfieldType.password.rawValue:
            _ =  textField.validateForPassword()
            break
        default:
            break
        }
    }
    
    func textField(_ textField: HSValidationTextfield, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        textField.clearError()
        clearErrorMessage()
        if textField.tag == eTextfieldType.phone.rawValue {
            let currentText = textField.text() ?? ""
            let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return prospectiveText.characters.count <= 10
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: HSValidationTextfield) -> Bool{
        if textField.returnKeyType == "1" {
            if textField == emailTextfield {
                onPhoneAction(UIButton())
            }
            else{
                let nextTextfield : HSValidationTextfield = self.view.viewWithTag(textField.tag+1) as! HSValidationTextfield
                nextTextfield.setFirstResponder()
            }
        }
        return true
    }
    
    //MARK:- Link Label Delegate
    
    func didClicked(onLink link : String)  {
        let URL = NSURL(string: link)!
        if #available(iOS 9.0, *) {
            let cntrl = SFSafariViewController(url: URL as URL)
            self.present(cntrl, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(URL as URL)
        }
        if link == "https://handstandapp.com/pages/terms-and-conditions" {
            HSAnalytics.setEventForTypes(withLog: HSA.termsScreen)
        }
    }
    
    //MARK:- MISC
    
    func isAllFieldValid() -> Bool {
        var status : Bool = false
        if let errMsg = firstNameTextfield.validateForFirstName() {
            showErrorMessage(errMsg)
        }
        else if let errMsg = lastNameTextfield.validateForLastName() {
            showErrorMessage(errMsg)
        }
        else if let emailErrMsg = emailTextfield.validateForEmail() {
            showErrorMessage(emailErrMsg)
        }
        else if let errMsg = phoneNumberTextfield.validateForPhone() {
            showErrorMessage(errMsg)
        }
        else if let passErrMsg = passwordTextfield.validateForPassword(){
            showErrorMessage(passErrMsg)
        }
        else if termsCheck.isHidden == true {
            showErrorMessage(NSLocalizedString("terms_check_error", comment: ""))
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
    
    func didVerifyPhone(notification: NSNotification) {
        if let phone = notification.userInfo?["phone"] as? String {
            self.phoneNumberTextfield.setText(phone)
        }
    }
    
    // MARK: - Button Action
    @IBAction func onPhoneAction(_ sender: UIButton) {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(HSSignupController.didVerifyPhone), name: NSNotification.Name(rawValue: phoneVerificationIdentifier), object: nil)
        let scene = HSPhneVerificationQueryController()
        self.navigationController?.pushViewController(scene, animated: true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func onTermsAction(_ sender: UIButton) {
        termsCheck.isHidden = !termsCheck.isHidden
    }
    
    @IBAction func onPolicyAction(_ sender: UIButton) {
        policyCheck.isHidden = !policyCheck.isHidden
    }
    
    @IBAction func showLoginAction(_ sender: UIButton) {
        if (self.navigationController?.childViewControllers.count)!==2 {
            let loginCntrl = HSLoginViewController()
            self.navigationController?.pushViewController(loginCntrl, animated: true)
        }else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onCompleteAction(_ sender: HSLoadingButton) {
        self.view.findFirstResonder()?.resignFirstResponder()
        if isAllFieldValid() {
            sender.startLoading()
            let policySelectedValue = (self.policyCheck.isHidden) ? 0 : 1
            //HSLoadingView.standardLoading().startLoading()
            HSUserNetworkHandler().signup(firstNameTextfield.text()!, lastname: lastNameTextfield.text()!, mobile: phoneNumberTextfield.text()!, email: emailTextfield.text()!, password: passwordTextfield.text()!, reebokAcceptance: policySelectedValue, completionHandler: { (success, error) in
                if success {
                    HSOnboardingServiceHandler().startService({ (success, error) in
                        //HSLoadingView.standardLoading().stopLoading()
                        
                        // HSLoadingView.standardLoading().perform(#selector(HSLoadingView.stopLoading), with: nil, afterDelay: 0.5)
                        if success {
                            HSAnalytics.setMixpanelPeopleConfiguration(HSUserManager.shared.currentUser!)
                            HSAnalytics.setEventForTypes(withLog: HSA.createdAccount)
                            //                            let homeCntrl = HSController.defaultController.getMainController()
                            //                            self.navigationController?.pushViewController(homeCntrl, animated: false)
                            HSApp().getAppFirstController({ (viewcontroller) in
                                sender.stopLoading()
                                appDelegate.window?.rootViewController = viewcontroller
                            })
                        }
                        else{
                            sender.stopLoading()
                            if error?.code == eErrorType.invalidAppVersion {
                                HSApp().alertUserToForceDownloadNewVersion((error?.message)!)
                            }
                            else if error?.code == eErrorType.updateAppVersion {
                                HSApp().alertUserToDownloadNewVersion((error?.message)!)
                            }
                            else{
                                if let msg = error?.message {
                                    HSUtility.showMessage(string: msg)
                                }
                            }
                        }
                    })
                }
                else{
                    sender.stopLoading()
                    self.showErrorMessage((error?.message)!)
                }
            })
        }
    }
    
    override func didTapBackButton() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Selectors
    
    func buildPolicyLabelData() {
        
        let termsValue = NSDictionary(object: "https://handstandapp.com/pages/terms-and-conditions", forKey: "<tc>" as NSCopying)
        
        termsLabel.buildLinkView(from: NSLocalizedString("terms_Info", comment: ""), forLinks: termsValue as [NSObject : AnyObject])
        
        let linkValue = NSDictionary(object: "http://www.reebok.com/us/customer_service/privacy-policy.php", forKey: "<pp>" as NSCopying)
        
        policyLabel.buildLinkView(from: NSLocalizedString("policy_Info", comment: ""), forLinks: linkValue as [NSObject : AnyObject])
        
    }
    
}
