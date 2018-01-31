//
//  HSForgotPasswordVerifyCodeController.swift
//  Handstand
//
//  Created by Fareeth John on 5/12/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSForgotPasswordVerifyCodeController: HSBaseController, HSValidationTextfieldDelegate {

    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var codeTextfield: HSValidationTextfield!
    var emailID : String! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = HSA.passwordCodeScreen
        HSNavigationBarManager.shared.applyProperties(key: .type_4, viewController: self)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- MISC
    
    func isAllFieldValid() -> Bool {
        var status : Bool = false
        if (codeTextfield.text()?.characters.count)! > 0 {
            status = true
        }
        else{
            showErrorMessage(NSLocalizedString("enter_verify_Code", comment: ""))
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
    
    //MARK:- Textfield delagate
    
    func textField(_ textField: HSValidationTextfield, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        textField.clearError()
        clearErrorMessage()
        return true
    }

    // MARK: - Button Action
    
    @IBAction func onVerifyCodeAction(_ sender: HSLoadingButton) {
        self.view.findFirstResonder()?.resignFirstResponder()
        if isAllFieldValid() {
            clearErrorMessage()
            sender.startLoading()
            HSUserNetworkHandler().verifyCode(forEmailID: emailID, withCode: codeTextfield.text()!, onComplete: { (success, error) in
                sender.stopLoading()
                if success {
                    HSAnalytics.setEventForTypes(withLog: HSA.passwordCodeSuccess)
                    let updatePasswordCntrl = HSUpdatePasswordController()
                    updatePasswordCntrl.emailID = self.emailID
                   HSUserManager.shared.email = self.emailID
                    self.navigationController?.pushViewController(updatePasswordCntrl, animated: true)
                }
                else{
                    self.showErrorMessage((error?.message)!)
                }
            })
        }
    }
    
    
}
