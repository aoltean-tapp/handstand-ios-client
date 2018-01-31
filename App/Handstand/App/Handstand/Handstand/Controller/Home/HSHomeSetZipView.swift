//
//  HSHomeSetZipView.swift
//  Handstand
//
//  Created by Fareeth John on 4/13/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

protocol HSHomeSetZipViewDelegate:class {
    func didClickedOnEnableLocation()
    func didClickedOnSetZip(_ zipcode : String)
}

class HSHomeSetZipView: UIView , UITextFieldDelegate {

    @IBOutlet var setZipButton: UIButton!
    @IBOutlet var zipTextfield: UITextField!
    public weak var delegate : HSHomeSetZipViewDelegate?
    
    //MARK:- Button Action
    
    @IBAction func onEnableLocationAction(_ sender: UIButton) {
        self.delegate?.didClickedOnEnableLocation()
    }
    
    @IBAction func onSetZipAction(_ sender: UIButton) {
        self.findFirstResonder()?.resignFirstResponder()
        self.delegate?.didClickedOnSetZip(zipTextfield.text!)
    }
    
    //MARK:- Textfield Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if prospectiveText.count > 5 {
            return false
        }else if prospectiveText.count == 5 {
            setZipButton.isHidden = false
        }else {
            setZipButton.isHidden = true
        }
        return true
    }


}
