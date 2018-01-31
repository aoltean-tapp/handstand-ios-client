//
//  HSValidationTextfield.swift
//  Handstand
//
//  Created by Fareeth John on 4/4/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

protocol HSValidationTextfieldDelegate {
    func textFieldDidBeginEditing(_ textField: HSValidationTextfield)
    func textFieldDidEndEditing(_ textField: HSValidationTextfield)
    func textField(_ textField: HSValidationTextfield, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func textFieldShouldReturn(_ textField: HSValidationTextfield) -> Bool
    func textFieldShouldBeginEditing(_ textField: HSValidationTextfield) -> Bool
}

extension HSValidationTextfieldDelegate {
    func textFieldShouldBeginEditing(_ textField: HSValidationTextfield) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: HSValidationTextfield) -> Bool{
        return true
    }
    func textFieldDidBeginEditing(_ textField: HSValidationTextfield){}
    func textFieldDidEndEditing(_ textField: HSValidationTextfield){}
}

class HSValidationTextfield: UIView, UITextFieldDelegate {
    var textfield : HSTextfiledView! = nil
    @IBInspectable var textColor: UIColor = UIColor.gray { didSet{ updateTextUI() } }
    @IBInspectable var errorTextColor: UIColor = UIColor.red
    @IBInspectable var placeholder: String? = ""
    @IBInspectable var isSecureTextEntry: String? = nil
    @IBInspectable var keyboardType: String? = ""
    @IBInspectable var returnKeyType: String? = ""
    @IBOutlet weak var ibDelegate: NSObject?
    
    override func awakeFromNib() {
        textfield  = HSTextfiledView.fromNib() as HSTextfiledView
        textfield.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(textfield)
        
        setupUI()
    }
    
    private func setupUI()  {
        textfield.textBorderView.layer.borderWidth = 0.5
        textfield.textBorderView.layer.borderColor = UIColor.lightGray.cgColor
        textfield.textBorderView.layer.cornerRadius = 3
        textfield.errorTag.textColor = errorTextColor
        textfield.errorLabel.textColor = errorTextColor
        textfield.textfield.placeholder = placeholder
        textfield.textfield.font = UIFont(name: "AvenirNext-Medium", size: 16)
        if isSecureTextEntry != nil {
            if isSecureTextEntry == "1" {
                textfield.textfield.isSecureTextEntry = true
            }
            else{
                textfield.textfield.isSecureTextEntry = false
            }
        }
        if keyboardType == "1" {
            textfield.textfield.keyboardType = .emailAddress
            //Disable suggestion for keyboard
            textfield.textfield.autocapitalizationType = .none
        }
        else if keyboardType == "2"{
            textfield.textfield.keyboardType = .numberPad
        }
        else{
            textfield.textfield.keyboardType = .default
        }
        textfield.textfield.delegate = self
        
        if returnKeyType == "1" {
            textfield.textfield.returnKeyType = .next
            textfield.textfield.autocorrectionType = .no
        }
        else if returnKeyType == "2"{
            textfield.textfield.returnKeyType = .done
        }else{
            textfield.textfield.returnKeyType = .default
        }
        /*else if keyboardType == "2"{
         textfield.textfield.returnKeyType = .done
         }*/
    }
    
    private func updateTextUI(){
        if textfield != nil {
            textfield.textfield.textColor = textColor
        }
    }
    
    func setFirstResponder()  {
        textfield.textfield.becomeFirstResponder()
    }
    
    func setErrorMessage(_ message : String)  {
        textfield.textBorderView.layer.borderColor = errorTextColor.cgColor
        textfield.errorTag.isHidden = false
        //        textfield.errorLabel.isHidden = false
        //        textfield.errorLabel.text = "* " + message
    }
    
    func clearError()  {
        textfield.textBorderView.layer.borderColor = UIColor.lightGray.cgColor
        textfield.errorLabel.isHidden = true
        textfield.errorTag.isHidden = true
    }
    
    func text() -> String? {
        return textfield.textfield.text
    }
    
    func setText(_ str : String) {
        textfield.textfield.text = str
    }
    
    func getDelegate() -> NSObject? {
        if ibDelegate != nil {
            return ibDelegate
        }
        return nil
    }
    
    //MARK:- Textfield validation
    
    func validateForEmail() -> String? {
        var message : String? = nil
        if self.text()?.characters.count == 0 {
            message = NSLocalizedString("enter_email_error", comment: "")
        }
        else if HSUtility.isValidEmailID(string: self.text()!) == false{
            message = NSLocalizedString("invalid_email_error", comment: "")
        }
        if message != nil {
            self.setErrorMessage(message!)
        }
        return message
    }
    
    func validateForPassword()  -> String? {
        var message : String? = nil
        if self.text()?.characters.count == 0 {
            message = NSLocalizedString("invalid_password_error", comment: "")
        }
        if message != nil {
            self.setErrorMessage(message!)
        }
        return message
    }
    
    func validateForPhone() -> String?  {
        var message : String? = nil
        if self.text()?.characters.count != 10 {
            message = NSLocalizedString("invalid_phone_error", comment: "")
        }
        if message != nil {
            self.setErrorMessage(message!)
        }
        return message
    }
    
    func validateForZipCode() -> String?  {
        var message : String? = nil
        if self.text()?.characters.count != 5 {
            message = NSLocalizedString("invalid_zip_error", comment: "")
        }
        if message != nil {
            self.setErrorMessage(message!)
        }
        return message
    }
    
    func validateForFirstName() -> String?  {
        var message : String? = nil
        if self.text()?.characters.count == 0 {
            message = NSLocalizedString("invalid_firstName_error", comment: "")
        }
        if message != nil {
            self.setErrorMessage(message!)
        }
        return message
    }
    
    func validateForLastName() -> String?  {
        var message : String? = nil
        if self.text()?.characters.count == 0 {
            message = NSLocalizedString("invalid_lastName_error", comment: "")
        }
        if message != nil {
            self.setErrorMessage(message!)
        }
        return message
    }
    
    //MARK:- Textfield Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        if getDelegate() != nil {
            (getDelegate() as! HSValidationTextfieldDelegate).textFieldDidBeginEditing(self)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        if getDelegate() != nil {
            (getDelegate() as! HSValidationTextfieldDelegate).textFieldDidEndEditing(self)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if getDelegate() == nil {
            return true
        }
        return (getDelegate() as! HSValidationTextfieldDelegate).textField(self, shouldChangeCharactersIn: range, replacementString: string)
    }
    /*
     func textFieldShouldReturn(_ textField: UITextField) -> Bool{
     if getDelegate() == nil {
     return true
     }
     return (getDelegate() as! HSValidationTextfieldDelegate).textFieldShouldReturn(self)
     }*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textfield.textfield.returnKeyType == .next){
            if let delegate = getDelegate() {
                return (delegate as! HSValidationTextfieldDelegate).textFieldShouldReturn(self)
            }
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let delegate = getDelegate() {
            return (delegate as! HSValidationTextfieldDelegate).textFieldShouldBeginEditing(self)
        }
        return true
    }
    
}
