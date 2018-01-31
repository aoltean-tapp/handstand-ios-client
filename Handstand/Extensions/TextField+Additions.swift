//
//  TextField+Additions.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/21/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import Foundation
import TextFieldEffects

extension HoshiTextField {
    func isEmail()->String? {
        var errorMsg:String? = nil
        if text?.count == 0 {
            errorMsg =  NSLocalizedString("enter_email_error", comment: "")
        }else if HSUtility.isValidEmailID(string: text!) == false {
            errorMsg = NSLocalizedString("invalid_email_error", comment: "")
        }
        return errorMsg
    }
    
    func isPassword()->String? {
        var errorMsg:String? = nil
        if text?.count == 0 {
           errorMsg = NSLocalizedString("invalid_password_error", comment: "")
        }
        return errorMsg
    }
}

extension UITextField {
    func validateForEmail() -> String? {
        var message : String? = nil
        if self.text?.count == 0 {
            message = NSLocalizedString("enter_email_error", comment: "")
        }
        else if HSUtility.isValidEmailID(string: self.text!) == false{
            message = NSLocalizedString("invalid_email_error", comment: "")
        }
        return message
    }
    
    func validateForPassword()  -> String? {
        var message : String? = nil
        if self.text?.count == 0 {
            message = NSLocalizedString("invalid_password_error", comment: "")
        }
        return message
    }
    
    func validateForPhone() -> String?  {
        var message : String? = nil
        if self.text?.count != 10 {
            message = NSLocalizedString("invalid_phone_error", comment: "")
        }
        return message
    }
    
    func validateForZipCode() -> String?  {
        var message : String? = nil
        if self.text?.count != 5 {
            message = NSLocalizedString("invalid_zip_error", comment: "")
        }
        return message
    }
    
    func validateForFirstName() -> String?  {
        var message : String? = nil
        if self.text?.count == 0 {
            message = NSLocalizedString("invalid_firstName_error", comment: "")
        }
        return message
    }
    
    func validateForLastName() -> String?  {
        var message : String? = nil
        if self.text?.count == 0 {
            message = NSLocalizedString("invalid_lastName_error", comment: "")
        }
        return message
    }
}
