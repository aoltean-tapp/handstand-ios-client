//
//  HSPhneVerificationQueryController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 8/28/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
//import Firebase
//import FirebaseAuth

class HSPhneVerificationQueryController: HSBaseController,countryPicker,HSValidationTextfieldDelegate {

    @IBOutlet weak var countryCodeBorderView: UIView! {
        didSet {
            countryCodeBorderView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var phoneTextField: HSValidationTextfield!
    let countryList:HSCountryCodeHelper = HSCountryCodeHelper.init()
    var localeCountry:HSCountryModel?
    @IBOutlet weak var sendCodeBtn:HSLoadingButton!
    
    var _navBarType:navBarType?
    
    //MARK: - ViewLife cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        if let nType = _navBarType {
            HSNavigationBarManager.shared.applyProperties(key: nType, viewController: self)
        }else {
            HSNavigationBarManager.shared.applyProperties(key: .type_4, viewController: self)
        }
//        phoneTextField.setText("4244420933")
        self.addLocaleCountryCode()
        registerForKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(aNotification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(aNotification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    //MARK: - Observers
    @objc func keyboardWasShown(aNotification: NSNotification) {
        let info = aNotification.userInfo as! [String: AnyObject]
        let kbSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
            if !aRect.contains(phoneTextField.frame.origin) {
                self.view.frame.origin.y -= kbSize.height
            }
    }

    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        self.view.frame.origin.y = 0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    //MARK: - Private Functions
    private func addLocaleCountryCode() {
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            countryList.rkInitialize()
            self.localeCountry = countryList.countries.filter {($0.iso2Cc == countryCode)}.first
            guard let iso2Cc = self.localeCountry?.iso2Cc,
                let e164Cc = self.localeCountry?.e164Cc else {
                    self.countryCodeTextField.text = "US(+1)"
                    return
            }
            self.countryCodeTextField.text = iso2Cc + " " + "(+" + e164Cc + ")"
        }
    }
    
    func showErrorMessage(_ message : String)  {
        errorMessageLabel.text = "* " + message
        errorMessageLabel.isHidden = false
    }
    
    func clearErrorMessage()  {
        errorMessageLabel.isHidden = true
    }
    
    //MARK: - UITextField Delegates
    func textField(_ textField: HSValidationTextfield, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        textField.clearError()
        clearErrorMessage()
        let currentText = textField.text() ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if prospectiveText.count > 10 {
            return false
        }
        return true
    }
//    func textFieldShouldBeginEditing(_ textField: HSValidationTextfield) -> Bool {
//        self.view.frame.origin.y -= 50
//        return true
//    }
//    func textFieldDidEndEditing(_ textField: HSValidationTextfield) {
//        self.view.frame.origin.y = 0
//    }
    func textFieldShouldReturn(_ textField: HSValidationTextfield) -> Bool {
        return true
    }
    
    //MARK: - Button Actions
    @IBAction func didTapSendCode(_ sender: Any) {
        clearErrorMessage()
        if phoneTextField.text()?.length()==0 {
            self.showErrorMessage("Please Enter Phone number!")
            return
        }
        let phoneNumber = "+" + (self.localeCountry?.e164Cc!)! + "-" + self.phoneTextField.text()!
        sendCodeBtn.startLoading()
        HSUserNetworkHandler().requestPhneVerificationCode(with: "generate", phoneNumber:phoneNumber) { (result, message) in
            self.sendCodeBtn.stopLoading()
            if result == "success" {
                let phoneVerificationCodeVC = HSPhneVerificationCodeController()
                phoneVerificationCodeVC._navBarType = self._navBarType
                phoneVerificationCodeVC.phoneNumber = self.phoneTextField.text()
                phoneVerificationCodeVC.phoneWithLocale = phoneNumber
                self.navigationController?.pushViewController(phoneVerificationCodeVC, animated: true)
            }
            else{
                self.showErrorMessage(message!)
            }
        }
    }
    
    @IBAction func didTapCountryCode(_ sender: Any) {
        let selectionVC = CountryCodeSelectionViewController()
        selectionVC.delegate = self
        selectionVC.countryList = countryList
        selectionVC._navBarType = self._navBarType
        self.navigationController?.pushViewController(selectionVC, animated: true)
    }
    
    func didPickCountry(model: HSCountryModel) {
        self.localeCountry = model
        self.countryCodeTextField.text = model.iso2Cc! + " " + "(+" + model.e164Cc! + ")"
    }
    
}
