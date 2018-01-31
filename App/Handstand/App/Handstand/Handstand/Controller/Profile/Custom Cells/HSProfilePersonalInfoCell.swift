//
//  HSProfilePersonalInfoCell.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/23/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

protocol HSProfilePersonalInfoCellProtocol:class {
    func didTapPhoneNumberInputField()
    func textFieldDidBeginEditing(txtField:UITextField)
}

class HSProfilePersonalInfoCell: UITableViewCell,CellConfigurer {

    public weak var delegate:HSProfilePersonalInfoCellProtocol?
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
    @IBOutlet internal weak var zipCodeTextField: UITextField! {
        didSet {
            zipCodeTextField.delegate = self
        }
    }
    @IBOutlet internal weak var emailTextField: UITextField! {
        didSet {
            emailTextField.isEnabled = false
        }
    }
    @IBOutlet internal weak var phoneNumberTextField: UITextField! {
        didSet {
            phoneNumberTextField.isEnabled = false
            phoneNumberButton.isEnabled = false
        }
    }
    
    @IBOutlet weak var phoneNumberButton: UIButton!
    public var isProfileEditing:Bool = false {
        didSet {
            firstNameTextField.isEnabled = isProfileEditing
            lastNameTextField.isEnabled = isProfileEditing
            zipCodeTextField.isEnabled = isProfileEditing
            phoneNumberTextField.isEnabled = isProfileEditing
            phoneNumberButton.isEnabled = isProfileEditing
        }
    }
    
    public func populateData(with userModel:HSUser) {
        firstNameTextField.text = userModel.firstname
        lastNameTextField.text = userModel.lastname
        zipCodeTextField.text = userModel.zip_code
        emailTextField.text = userModel.email
        phoneNumberTextField.text = userModel.mobile
    }
    
    @IBAction func didTapPhoneNumber(_ sender: Any) {
        delegate?.didTapPhoneNumberInputField()
    }
}

extension HSProfilePersonalInfoCell:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidBeginEditing(txtField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        }else if textField == lastNameTextField {
            zipCodeTextField.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
}
