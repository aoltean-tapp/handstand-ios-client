//
//  TextField+Additions.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/21/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import Foundation

extension UITextField {
    func validateForEmail() -> String? {
        var message : String? = nil
        if self.text.characters.count == 0 {
            message = NSLocalizedString("enter_email_error", comment: "")
        }
        else if HSUtility.isValidEmailID(string: self.text) == false{
            message = NSLocalizedString("invalid_email_error", comment: "")
        }
        if message != nil {
            self.setErrorMessage(message!)
        }
        return message
    }
    
    func validateForPassword()  -> String? {
        var message : String? = nil
        if self.text.characters.count == 0 {
            message = NSLocalizedString("invalid_password_error", comment: "")
        }
        if message != nil {
            self.setErrorMessage(message!)
        }
        return message
    }
    
    func validateForPhone() -> String?  {
        var message : String? = nil
        if self.text.characters.count != 10 {
            message = NSLocalizedString("invalid_phone_error", comment: "")
        }
        if message != nil {
            self.setErrorMessage(message!)
        }
        return message
    }
    
    func validateForZipCode() -> String?  {
        var message : String? = nil
        if self.text.characters.count != 5 {
            message = NSLocalizedString("invalid_zip_error", comment: "")
        }
        if message != nil {
            self.setErrorMessage(message!)
        }
        return message
    }
    
    func validateForFirstName() -> String?  {
        var message : String? = nil
        if self.text.characters.count == 0 {
            message = NSLocalizedString("invalid_firstName_error", comment: "")
        }
        if message != nil {
            self.setErrorMessage(message!)
        }
        return message
    }
    
    func validateForLastName() -> String?  {
        var message : String? = nil
        if self.text.characters.count == 0 {
            message = NSLocalizedString("invalid_lastName_error", comment: "")
        }
        if message != nil {
            self.setErrorMessage(message!)
        }
        return message
    }
}
