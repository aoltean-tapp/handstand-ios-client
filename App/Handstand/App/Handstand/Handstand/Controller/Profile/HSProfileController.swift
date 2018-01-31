//
//  HSProfileController.swift
//  Handstand
//
//  Created by Fareeth John on 5/9/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSProfileController: HSBaseController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, HSValidationTextfieldDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var profileImageView: UIView!
    @IBOutlet var dataInputView: UIView!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var passwordTextfield: HSValidationTextfield!
    @IBOutlet var phoneTextfield: HSValidationTextfield!
    @IBOutlet var zipTextfield: HSValidationTextfield!
    @IBOutlet var emailTextfield: HSValidationTextfield!
    @IBOutlet var nameTextfield: HSValidationTextfield!
    var isProfilePictureChanged : Bool = false
    enum eTextfieldType: Int {
        case name = 1
        case email = 2
        case zipCode = 3
        case phone = 4
        case password = 5
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Profile"
        HSNavigationBarManager.shared.applyProperties(key: .type_None, viewController: self)
        self.screenName = HSA.userProfileSection
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - MISC
    
    func updateUI() {
        let theUser = HSUserManager.shared.currentUser
        nameTextfield.setText((theUser?.name())!)
        emailTextfield.setText((theUser?.email)!)
        zipTextfield.setText(theUser?.zip_code ?? "")
        phoneTextfield.setText((theUser?.mobile)!)
//        passwordTextfield.setText("12345678")
        scrollView.contentSize = CGSize(width: UIScreen.main.applicationFrame.size.width, height: errorLabel.frame.origin.y + 215)
        userImageView.setImage(url: (theUser?.avatar)!, style: .squared)
    }

    func isAllFieldValid() -> Bool {
        var status : Bool = false
        if let errMsg = nameTextfield.validateForFirstName() {
            showErrorMessage(errMsg)
        }
        else if let errMsg = emailTextfield.validateForEmail() {
            showErrorMessage(errMsg)
        }
//        else if let emailErrMsg = zipTextfield.validateForZipCode() {
//            showErrorMessage(emailErrMsg)
//        }
//        else if let errMsg = phoneTextfield.validateForPhone() {
//            showErrorMessage(errMsg)
//        }
//        else if userImageView.image == nil {
//            showErrorMessage(NSLocalizedString("provide_image_error", comment: ""))
//        }
//        else if let passErrMsg = passwordTextfield.validateForPassword(){
//            showErrorMessage(passErrMsg)
//        }
        else{
            status = true
        }
        return status
    }
    
    func showErrorMessage(_ message : String)  {
        errorLabel.text = "* " + message
        errorLabel.isHidden = false
    }

    func clearErrorMessage()  {
        errorLabel.isHidden = true
    }
    
    func getInputData() -> NSDictionary {
        let theData = NSMutableDictionary()
        let names = nameTextfield.text()?.components(separatedBy: " ")
        if (names?.count)! > 0{
            theData.setValue(names?[0], forKey: kPU_FirstName)
        }
        if (names?.count)! > 1{
            theData.setValue(names?[1], forKey: kPU_LastName)
        }
        theData.setValue(emailTextfield.text(), forKey: kPU_Email)
        theData.setValue(phoneTextfield.text(), forKey: kPU_Phone)
        if (zipTextfield.text()?.characters.count)! > 0 {
            theData.setValue(zipTextfield.text(), forKey: kPU_Zipcode)
        }
        else{
            theData.setValue("", forKey: kPU_Zipcode)
        }
        if (passwordTextfield.text()?.characters.count)! > 0 {
            theData.setValue(passwordTextfield.text(), forKey: kPU_Password)
        }
//        theData.setValue(HSController.defaultController.currentUser()?.accessToken, forKey: kUserAccessToken)
        return theData
    }
    
    func updateProfile()  {
        HSLoadingView.standardLoading().startLoading()
        HSUserNetworkHandler().getUserProfile(completionHandler: { (success, error) in
            HSLoadingView.standardLoading().stopLoading()
            if error == nil {
                HSAnalytics.setEventForTypes(withLog: HSA.editProfile)
                self.dataInputView.isUserInteractionEnabled = false
                self.profileImageView.isUserInteractionEnabled = false
            }
            else{
                HSUtility.showMessage(string: error?.message)
            }
        })
    }

    // MARK: - Textfield delegate
    
    func textFieldShouldBeginEditing(_ textField: HSValidationTextfield) -> Bool {
        if textField == phoneTextfield {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: HSValidationTextfield){
       
    }
    
    func textFieldDidEndEditing(_ textField: HSValidationTextfield){
        switch textField.tag {
        case eTextfieldType.name.rawValue:
            _ = textField.validateForFirstName()
            break
//        case eTextfieldType.zipCode.rawValue:
//            _ = textField.validateForZipCode()
//            break
        case eTextfieldType.phone.rawValue:
//            _ = textField.validateForPhone()
            break
        case eTextfieldType.email.rawValue:
            _ = textField.validateForEmail()
            break
        case eTextfieldType.password.rawValue:
//            _ = textField.validateForPassword()
            break
        default:
            break
        }
    }
    
    func textField(_ textField: HSValidationTextfield, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        textField.clearError()
        let currentText = textField.text() ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        switch textField.tag {
//        case eTextfieldType.zipCode.rawValue:
//            if prospectiveText.characters.count > 5 {
//                return false
//            }
//            break
        case eTextfieldType.phone.rawValue:
            if prospectiveText.characters.count > 10 {
                return false
            }
            break
        default:
            break
        }
        clearErrorMessage()
        return true
    }
    
    func textFieldShouldReturn(_ textField: HSValidationTextfield) -> Bool{
        if textField.returnKeyType == "1" {
            if textField == zipTextfield {
                onPhoneAction(UIButton())
            }
            else{
                let nextTextfield : HSValidationTextfield = self.view.viewWithTag(textField.tag+1) as! HSValidationTextfield
                nextTextfield.setFirstResponder()
            }
        }
        return true
    }

    // MARK: - Button Action
    
    @IBAction func onShowCameraPickAction(_ sender: UIButton) {
        let alert=UIAlertController(title: "", message: "Profile Picture", preferredStyle: UIAlertControllerStyle.actionSheet);
        //no event handler (just close dialog box)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil));
        //event handler with closure
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                let imag : UIImagePickerController = UIImagePickerController()
                imag.delegate = self
                imag.sourceType = UIImagePickerControllerSourceType.camera;
                //imag.mediaTypes = [kUTTypeImage];
                imag.allowsEditing = false
                self.present(imag, animated: true, completion: nil)
            }
        }));
        alert.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
                let imag : UIImagePickerController = UIImagePickerController()
                imag.delegate = self
                imag.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                //imag.mediaTypes = [kUTTypeImage];
                imag.allowsEditing = false
                self.present(imag, animated: true, completion: nil)
            }
        }));
        present(alert, animated: true, completion: nil);
    }
    
    @IBAction func onEditAction(_ sender: UIButton) {
        HSAnalytics.setEventForTypes(withLog: HSA.editProfileClick)
        if sender.isSelected == false  {
            sender.isSelected = true
            dataInputView.isUserInteractionEnabled = true
            profileImageView.isUserInteractionEnabled = true
        }
        else {
            self.view.findFirstResonder()?.resignFirstResponder()
            if isAllFieldValid() {
//                HSAnalytics.setEventForTypes(types: [.mixpanel], withLog: kMPUpdateProfile, withData:nil)
                HSLoadingView.standardLoading().startLoading()
                if isProfilePictureChanged {
                    HSAnalytics.setEventForTypes(withLog: HSA.uploadPhoto)
                    HSUserNetworkHandler().saveProfileInfo(profileData: getInputData() as! Dictionary<String, String>, withImage: userImageView.image!, completionHandler: { (success, error) in
                        sender.isSelected = false
                        
                        HSLoadingView.standardLoading().stopLoading()
                        if error == nil {
                            self.updateProfile()
                        }
                        else{
                            HSUtility.showMessage(string: error?.message)
                        }
                    })
                }
                else{
                    HSUserNetworkHandler().saveProfileInfo(profileData: getInputData() as! Dictionary<String, String>, completionHandler: { (success, error) in
                        sender.isSelected = false
                        HSLoadingView.standardLoading().stopLoading()
                        if error == nil {
                            self.updateProfile()
                        }
                        else{
                            HSUtility.showMessage(string: error?.message)
                        }
                    })
                }
            }
        } 
    }
    
    @IBAction func onPhoneAction(_ sender: UIButton) {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(HSSignupController.didVerifyPhone), name: NSNotification.Name(rawValue: phoneVerificationIdentifier), object: nil)
        let scene = HSPhneVerificationQueryController()
        self.navigationController?.pushViewController(scene, animated: true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func didVerifyPhone(notification: NSNotification) {
        if let phone = notification.userInfo?["phone"] as? String {
            self.phoneTextfield.setText(phone)
        }
    }
    
    // MARK: - Image picker delegate
    
    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        clearErrorMessage()
        self.userImageView.image=image
        self.isProfilePictureChanged = true
        self.dismiss(animated: true, completion: nil)
    }
    
}
