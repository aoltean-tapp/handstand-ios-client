//
//  HSPhneVerificationCodeController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 8/28/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
//import Firebase
//import FirebaseAuth

class HSPhneVerificationCodeController: HSBaseController,HSValidationTextfieldDelegate {
    
    @IBOutlet weak var verificationCodeTextField: HSValidationTextfield!
    @IBOutlet weak var errorMessageLabel: UILabel!
    var _navBarType:navBarType?
    
    var verificationID:String?
    var phoneNumber:String?
    var phoneWithLocale:String?
    @IBOutlet weak var confirmBtn:HSLoadingButton!
    @IBOutlet weak var changePhoneNumberBtn: UIButton! {
        didSet {
            let title = changePhoneNumberBtn.titleLabel?.text
            let attStr = NSMutableAttributedString.init(string: title!)
            attStr.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, title!.count))
            attStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.handstandGreen(), range: NSMakeRange(0, title!.count))
            changePhoneNumberBtn.setAttributedTitle(attStr, for: .normal)
        }
    }
    @IBOutlet weak var resendSMSBtn: UIButton! {
        didSet {
            let string = "Resend SMS again to "+phoneWithLocale!
            let attStr = NSMutableAttributedString.init(string: string)
            attStr.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, string.count))
            attStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.handstandGreen(), range: NSMakeRange(0, string.count))
            resendSMSBtn.setAttributedTitle(attStr, for: .normal)
        }
    }
    
    //MARK: - ViewLifeCycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        if let nType = _navBarType {
            HSNavigationBarManager.shared.applyProperties(key: nType, viewController: self)
        }else {
            HSNavigationBarManager.shared.applyProperties(key: .type_4, viewController: self)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verificationCodeTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Private functions
    func showErrorMessage(_ message : String)  {
        errorMessageLabel.text = "* " + message
        errorMessageLabel.isHidden = false
    }
    func clearErrorMessage()  {
        errorMessageLabel.isHidden = true
    }
    func textField(_ textField: HSValidationTextfield, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        textField.clearError()
        clearErrorMessage()
        return true
    }
    func textFieldDidBeginEditing(_ textField: HSValidationTextfield) {}
    func textFieldDidEndEditing(_ textField: HSValidationTextfield) {}
    func textFieldShouldReturn(_ textField: HSValidationTextfield) -> Bool {
        return true
    }
    
    //MARK: - Button Actions
    @IBAction func didTapConfirm(_ sender: Any) {
        view.endEditing(true)
        clearErrorMessage()
        //let phoneNumber = "+" + (self.localeCountry?.e164Cc!)! + self.phoneTextField.text()!
        if verificationCodeTextField.text()?.length()==0 {
            self.showErrorMessage("Please Enter Verification code!")
            return
        }
        confirmBtn.startLoading()
        HSUserNetworkHandler().requestPhneVerificationCode(with: "verify", phoneNumber:phoneWithLocale!,code:verificationCodeTextField.text()) { (result, message) in                            self.confirmBtn.stopLoading()
            if result == "success" {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: phoneVerificationIdentifier), object: nil, userInfo: ["phone":self.phoneNumber ?? ""])
                    if let signupScene = self.navigationController?.childViewControllers.filter({
                        $0 is HSSignupViewController
                    }).first {
                        self.navigationController?.popToViewController(signupScene, animated: true)
                    }else {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
            }else {
                HSUtility.showMessage(string: message!)
            }
        }
        
//        if let verificationCode = verificationCodeTextField.text() {
//            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: verificationCode)
//            self.view.endEditing(true)
//            confirmBtn.startLoading()
//            Auth.auth().signIn(with: credential) { (user, error) in
//                self.confirmBtn.stopLoading()
//                if let error = error {
//                    self.showErrorMessage(error.localizedDescription)
//                    return
//                }else {
//                    try! Auth.auth().signOut()
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: phoneVerificationIdentifier), object: nil, userInfo: ["phone":self.phoneNumber ?? ""])
//                    if let signupScene = self.navigationController?.childViewControllers.filter({
//                        $0 is HSSignupController
//                    }).first {
//                        self.navigationController?.popToViewController(signupScene, animated: true)
//                    }else {
//                        self.navigationController?.popToRootViewController(animated: true)
//                    }
//                }
//            }
//        }
    }
    
    @IBAction func didTapChangePhoneNumber(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapResendSMS(_ sender: Any) {
        HSLoadingView.standardLoading().startLoading()
        HSUserNetworkHandler().requestPhneVerificationCode(with: "generate", phoneNumber:phoneWithLocale!) { (result, message) in
            HSLoadingView.standardLoading().stopLoading()
            if result == "success" {
                self.verificationCodeTextField.setText("")
                self.verificationCodeTextField.textfield.textfield.becomeFirstResponder()
            }
            else{
                HSUtility.showMessage(string: message!)
            }
        }
//        PhoneAuthProvider.provider().verifyPhoneNumber(phoneWithLocale!) { (verificationID, error) in
//            HSLoadingView.standardLoading().stopLoading()
//            if let error = error {
//                self.showErrorMessage(error.localizedDescription)
//                return
//            }
//            guard let verificationID = verificationID else { return }
//            self.verificationID = verificationID
//        }
    }
}
