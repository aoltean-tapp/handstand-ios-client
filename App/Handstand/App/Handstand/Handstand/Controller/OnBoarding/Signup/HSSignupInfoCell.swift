//
//  HSSignupInfoCell.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/27/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

protocol HSSignupInfoCellProtocol:class {
    func textFieldDidBeginEditing(txtField:UITextField)
    func didTapPhoneNumberInputField()
    func didCompleteForm()
}
class HSSignupInfoCell: UITableViewCell,CellConfigurer {
    
    public weak var delegate:HSSignupInfoCellProtocol?
    @IBOutlet internal weak var firstNameTextField: UITextField! {
        didSet {
            firstNameTextField.delegate = self
        }
    }
    @IBOutlet internal weak var lastNameTextField: UITextField! {
        didSet {
            lastNameTextField.delegate = self
        }
    }
    @IBOutlet internal weak var emailTextField: UITextField!{
        didSet {
            emailTextField.delegate = self
        }
    }
    @IBOutlet internal weak var phoneNumberTextField: UITextField! {
        didSet {
            phoneNumberTextField.isEnabled = false
        }
    }
    @IBOutlet internal weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var phoneButton: UIButton!
    
    @IBAction func didTapPhoneNumber(_ sender: Any) {
        delegate?.didTapPhoneNumberInputField()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        setPrefilledInputs()
    }
    
    //MARK:- Private functions
    private func setPrefilledInputs() {
        self.firstNameTextField.text = "Test"
        self.lastNameTextField.text = "Email"
        self.emailTextField.text = Date().timeIntervalSince1970.description+"@h.com"
        self.phoneNumberTextField.text = "9704963170"
        self.passwordTextField.text = "password"
    }
}

extension HSSignupInfoCell:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidBeginEditing(txtField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        }else if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        }else if textField == emailTextField{
            delegate?.didTapPhoneNumberInputField()
        }else if textField == passwordTextField {
            delegate?.didCompleteForm()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
}
