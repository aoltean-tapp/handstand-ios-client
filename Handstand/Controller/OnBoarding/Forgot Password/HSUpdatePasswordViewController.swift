//
//  HSUpdatePasswordViewController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/18/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSUpdatePasswordViewController: HSBaseController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(HSUpdatePasswordInputCell.nib(), forCellReuseIdentifier: HSUpdatePasswordInputCell.reuseIdentifier())
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.keyboardDismissMode = .interactive
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.basicSetup()
        HSNavigationBarManager.shared.applyProperties(key: .type_17, viewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Selectors
    func didTapDoneButton() {
        didCompleteForm()
    }
    func didTapCancelButton() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Private functions

    private func basicSetup() {
        self.screenName = HSA.passwordResetScreen
        self.title = "Change Password"
        HSNavigationBarManager.shared.applyProperties(key: .type_0, viewController: self)
    }
    
    func isAllFieldValid() -> Bool {
        let updatePasswordInputCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! HSUpdatePasswordInputCell
        
        let currentPassword = updatePasswordInputCell.currentPasswordTextField.text
        let newPassword = updatePasswordInputCell.newPasswordTextField.text
        let reTypedPassword = updatePasswordInputCell.reTypePasswordTextField.text
        
        if currentPassword?.isEmpty == false {
            if newPassword?.isEmpty == false {
                if newPassword == reTypedPassword {
                    return true
                }else {
                    showErrorMessage(NSLocalizedString("password_not_matching", comment: ""))
                }
            }else {
                showErrorMessage(NSLocalizedString("invalid_new_password_error", comment: ""))
            }
        }else {
            showErrorMessage(NSLocalizedString("invalid_password_error", comment: ""))
        }
        return false
    }
    
    func showErrorMessage(_ message : String)  {
        HSUtility.showMessage(string: message)
    }
    
    fileprivate func doAutoLogin() {
        let emailID = HSUserManager.shared.currentUser?.email
        let updatePasswordInputCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! HSUpdatePasswordInputCell
        let reTypedPassword = updatePasswordInputCell.reTypePasswordTextField.text
        
        HSUserNetworkHandler().login(emailID!, password: reTypedPassword!) { (success, error) in
            if success {
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

//MARK:- UITableViewDelegate & UITableViewDataSource
extension HSUpdatePasswordViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HSUpdatePasswordInputCell.reuseIdentifier()) as! HSUpdatePasswordInputCell
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

//MARK:- HSUpdatePasswordInputCellProtocol
extension HSUpdatePasswordViewController:HSUpdatePasswordInputCellProtocol {
    
    func didCompleteForm() {
        self.view.findFirstResonder()?.resignFirstResponder()
        if isAllFieldValid() {
            let emailID = HSUserManager.shared.currentUser?.email
            let updatePasswordInputCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! HSUpdatePasswordInputCell
            let newPassword = updatePasswordInputCell.newPasswordTextField.text
            let oldPassword = updatePasswordInputCell.currentPasswordTextField.text
            HSLoadingView.standardLoading().startLoading()
            HSUserNetworkHandler().updatePassword(forEmailID: emailID!, withPassword: newPassword!,withOldPassword: oldPassword!, onComplete: { (success, error) in
                if success {
                    HSAnalytics.setEventForTypes(withLog: HSA.passwordReset)
                    self.doAutoLogin()
                }
                else{
                    HSLoadingView.standardLoading().stopLoading()
                    self.showErrorMessage((error?.message)!)
                }
            })
        }
    }
}
