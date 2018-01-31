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
            HSUserNetworkHandler().updatePassword(forEmailID: emailID, withPassword: newPasswordTextfield.text()!, onComplete: { (success, error) in
                if success {
                    HSAnalytics.setEventForTypes(withLog: HSA.passwordReset)
                    self.doAutoLogin()
                }
                else{
                    sender.stopLoading()
                    self.showErrorMessage((error?.message)!)
                }
            })
        }
    }
    
    private func doAutoLogin() {
        HSUserNetworkHandler().login(emailID, password: self.reEnterTextfield.text()!) { (success, error) in
            if success {
//                HSUtility.setSubcriptionShown()
                HSOnboardingServiceHandler().startService({ (success, error) in
                    HSLoadingView.standardLoading().stopLoading()
                    if success {
                        HSAnalytics.setEventForTypes(withLog: HSA.userLogin)
                        let allSetScreen = HSUpdatePasswordConfirmationController()
                        self.present(allSetScreen, animated: true, completion: nil)
                    }
                    else{
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
        }
    }
    
}
