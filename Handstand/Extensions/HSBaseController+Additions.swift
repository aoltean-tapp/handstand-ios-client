//
//  HSBaseController+Additions.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/20/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import Foundation

extension HSBaseController {
    func hideKeyboardWhenTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissCurrentKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissCurrentKeyboard(){
        view.endEditing(true)
    }
}
