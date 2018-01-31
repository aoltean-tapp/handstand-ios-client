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
    fileprivate var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.basicSetup()
        registerForKeyboardNotifications()
        HSNavigationBarManager.shared.applyProperties(key: .type_12, viewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Selectors
    func didTapDoneButton() {
        didCompleteForm()
    }
    
    //MARK: - Private functions
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(aNotification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(aNotification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    private func basicSetup() {
        self.screenName = HSA.passwordResetScreen
        self.title = "Change Password"
        HSNavigationBarManager.shared.applyProperties(key: .type_0, viewController: self)
    }
    @objc func keyboardWasShown(aNotification: NSNotification) {
        let info = aNotification.userInfo as! [String: AnyObject],
        kbSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size,
        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
        if let activeTextField = activeField {
            if !aRect.contains(activeTextField.frame.origin) {
                self.tableView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }
    
    func didCompleteForm() {
        self.view.findFirstResonder()?.resignFirstResponder()
        if isAllFieldValid() {
            HSLoadingView.standardLoading().startLoading()
            let emailID = HSUserManager.shared.currentUser?.email
            let updatePasswordInputCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! HSUpdatePasswordInputCell
            let newPassword = updatePasswordInputCell.newPasswordTextField.text
            
            HSUserNetworkHandler().updatePassword(forEmailID: emailID!, withPassword: newPassword!, onComplete: { (success, error) in
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
