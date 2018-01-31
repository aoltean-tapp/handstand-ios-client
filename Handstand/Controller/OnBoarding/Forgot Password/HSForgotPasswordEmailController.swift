//
//  HSForgotPasswordEmailController.swift
//  Handstand
//
//  Created by Fareeth John on 5/12/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSForgotPasswordEmailController: HSBaseController, HSValidationTextfieldDelegate {

    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var emailTextfield: HSValidationTextfield!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.handstandGreen()
        self.screenName = HSA.forgotPasswordScreen
        emailTextfield.textfield.textfield.autocorrectionType = .no
        HSNavigationBarManager.shared.applyProperties(key: .type_4, viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //MARK:- MISC
    
    func isAllFieldValid() -> Bool {
        var status : Bool = false
        if let errMsg = emailTextfield.validateForEmail() {
            showErrorMessage(errMsg)
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
    
    //MARK:- Button Action
   
    @IBAction func onSendAction(_ sender: HSLoadingButton) {
        self.view.findFirstResonder()?.resignFirstResponder()
        if isAllFieldValid() {
            clearErrorMessage()
            sender.startLoading()
            HSUserNetworkHandler().forgotPassword(forEmailID: emailTextfield.text()!, onComplete: { (success, error) in
                sender.stopLoading()
                if success {
                    HSAnalytics.setEventForTypes(withLog: HSA.forgotPasswordSent)
                    let verfiyCntrl = HSForgotPasswordVerifyCodeController()
                    verfiyCntrl.emailID = self.emailTextfield.text()
                    self.navigationController?.pushViewController(verfiyCntrl, animated: true)
                }
                else{
                    self.showErrorMessage((error?.message)!)
                }
            })
        }
    }


}
