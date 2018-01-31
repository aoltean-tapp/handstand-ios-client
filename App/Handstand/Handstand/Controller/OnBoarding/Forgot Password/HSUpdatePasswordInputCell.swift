//
//  HSUpdatePasswordInputCell.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/18/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

protocol HSUpdatePasswordInputCellProtocol:class {
    func textFieldDidBeginEditing(_ textField: UITextField)
    func didCompleteForm()
}

class HSUpdatePasswordInputCell: UITableViewCell,CellConfigurer {
    
    public weak var delegate:HSUpdatePasswordInputCellProtocol?
    
    @IBOutlet weak var currentPasswordTextField: UITextField! {
        didSet {
            currentPasswordTextField.delegate = self
        }
    }
    @IBOutlet weak var newPasswordTextField: UITextField! {
        didSet {
            newPasswordTextField.delegate = self
        }
    }
    @IBOutlet weak var reTypePasswordTextField: UITextField! {
        didSet {
            reTypePasswordTextField.delegate = self
        }
    }
    
}

extension HSUpdatePasswordInputCell:UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidBeginEditing(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == currentPasswordTextField {
            newPasswordTextField.becomeFirstResponder()
        }else if textField == newPasswordTextField {
            reTypePasswordTextField.becomeFirstResponder()
        }else if textField == reTypePasswordTextField{
            delegate?.didCompleteForm()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
}
