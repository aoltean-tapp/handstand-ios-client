//
//  HSProfileViewController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/23/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

//MARK: - ENUM/ProfileSectionTypes
fileprivate enum ProfileSectionTypes:Int {
    case profilePicture
    case personalInfo
    case settings
    
    func desc()->String {
        switch self {
        case .profilePicture:return ""
        case .personalInfo:return "PERSONAL INFORMATION"
        case .settings:return "SETTINGS"
        }
    }
}
//MARK: - ENUM/ProfileSettingsRowTypes
//TODO: - Make this as Nested ENUM for ProfileSectionTypes
internal enum ProfileSettingsRowTypes:Int {
    case changePassword
    case subscriptionTerms
    case termsOfService
    case contactUs
    case rateUs
    case logout
    
    func desc()->String {
        switch self {
        case .changePassword:return "Change Password"
        case .subscriptionTerms:return "Subscription Terms"
        case .termsOfService:return "View Terms of Service"
        case .contactUs:return "Contact Support"
        case .rateUs:return "Rate the App"
        case .logout:return "Log Out"
        }
    }
}

class HSProfileViewController: HSBaseController,MFMailComposeViewControllerDelegate {
    
    //MARK: - iVars
    @IBOutlet fileprivate weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(HSProfilePictureCell.nib(), forCellReuseIdentifier: HSProfilePictureCell.reuseIdentifier())
            tableView.register(HSProfilePersonalInfoCell.nib(), forCellReuseIdentifier: HSProfilePersonalInfoCell.reuseIdentifier())
            tableView.register(HSProfileSettingsCell.nib(), forCellReuseIdentifier: HSProfileSettingsCell.reuseIdentifier())
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.keyboardDismissMode = .interactive
            addVersionOnFooterView()
        }
    }
    fileprivate lazy var datasource:[ProfileSectionTypes] = [.profilePicture,.personalInfo,.settings]
    fileprivate var isEditingModeEnabled:Bool = false {
        didSet {
            if isEditingModeEnabled == true {
                self.tabBarController?.tabBar.isHidden = true
                title = "Edit Profile"
                HSNavigationBarManager.shared.applyProperties(key: .type_7, viewController: self)
                datasource = [.profilePicture,.personalInfo]
                self.tableView.tableFooterView = UIView()
            }else {
                self.tabBarController?.tabBar.isHidden = false
                title = "Profile"
                HSNavigationBarManager.shared.applyProperties(key: .type_6, viewController: self)
                datasource = [.profilePicture,.personalInfo,.settings]
                addVersionOnFooterView()
            }
            tableView.reloadData()
        }
    }
    fileprivate var isProfilePictureChanged:Bool = false
    fileprivate lazy var settingsSectionDataSource:[ProfileSettingsRowTypes] = [.changePassword,.subscriptionTerms,.termsOfService,.contactUs,.rateUs,.logout]
    fileprivate var activeField: UITextField?
    
    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        HSNavigationBarManager.shared.applyProperties(key: .type_6, viewController: self)
        registerForKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: - Button Actions
    func didTapEditButton() {
        isEditingModeEnabled = !isEditingModeEnabled
    }
    func didTapNotificationsButton() {
        let notificationsScene = HSNotificationsController()
        self.navigationController?.pushViewController(notificationsScene, animated: true)
    }
    func didTapCancelButton() {
        isEditingModeEnabled = !isEditingModeEnabled
    }
    func didTapDoneButton() {
        self.tabBarController?.tabBar.isHidden = false
        addVersionOnFooterView()
        view.endEditing(true)
        HSLoadingView.standardLoading().startLoading()
        if self.isProfilePictureChanged == true {
            let indexpath = IndexPath.init(row: 0, section: ProfileSectionTypes.profilePicture.rawValue)
            let profilePictureCell = tableView.cellForRow(at: indexpath) as! HSProfilePictureCell
            if let image = profilePictureCell.roundRectView.imageView.image {
                HSUserNetworkHandler().saveProfileInfo(profileData: getInputData(), withImage:image, completionHandler: { [weak self] (isSuccess, error) in
                    if error == nil {
                        self?.updateProfile()
                    }else{
                        HSLoadingView.standardLoading().stopLoading()
                        HSUtility.showMessage(string: error?.message)
                    }
                })
            }
        }else {
            HSUserNetworkHandler().saveProfileInfo(profileData: getInputData(), completionHandler: {[weak self] (success, error) in
                if error == nil {
                    self?.updateProfile()
                }else{
                    HSLoadingView.standardLoading().stopLoading()
                    HSUtility.showMessage(string: error?.message)
                }
            })
        }
    }
    //MARK: - Selectors
    @objc func keyboardWasShown(aNotification: NSNotification) {
        let info = aNotification.userInfo as! [String: AnyObject],
        kbSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size,
        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
        if let activeField = activeField {
            if !aRect.contains(activeField.frame.origin) {
                self.tableView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
    
    
    //MARK: - Private functions
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(aNotification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(aNotification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    private func addVersionOnFooterView() {
        let label = UILabel.init(frame: CGRect(x:15,y:0,width:ScreenCons.SCREEN_WIDTH-(2*15),height:50))
        label.textAlignment = .center
        label.numberOfLines = 2
        let text = AppCons.APPNAME+"\n Version "+HSUtility.getAppVersion()
        let attr = attributedString(from: text, range: NSMakeRange(0, AppCons.APPNAME.count))
        label.attributedText = attr
        let f_view = UIView.init(frame: CGRect(x:0,y:0,width:ScreenCons.SCREEN_WIDTH,height:50))
        f_view.addSubview(label)
        tableView.tableFooterView = f_view
    }
    private func attributedString(from string: String, range: NSRange?) -> NSAttributedString {
        let boldAttribute = [
            NSFontAttributeName:HSFontUtilities.avenirNextMedium(size: 12)
        ]
        let regularAttribute = [
            NSFontAttributeName: HSFontUtilities.avenirNextRegular(size:12)
        ]
        let attrStr = NSMutableAttributedString(string: string, attributes: regularAttribute)
        
        attrStr.setAttributes(boldAttribute, range: range!)
        return attrStr
    }
    private func updateProfile()  {
        HSUserNetworkHandler().getUserProfile(completionHandler: {[weak self] (success, error) in
            HSLoadingView.standardLoading().stopLoading()
            if error == nil {
                HSAnalytics.setEventForTypes(withLog: HSA.editProfile)
                DispatchQueue.main.async {
                    self?.isEditingModeEnabled = false
                    self?.isProfilePictureChanged = false
                }
            }
            else{
                HSUtility.showMessage(string: error?.message)
            }
        })
    }
    fileprivate func getInputData()->Dictionary<String,String>? {
        let profileInfoCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: ProfileSectionTypes.personalInfo.rawValue)) as! HSProfilePersonalInfoCell
        
        var inputValues:[String:String] = Dictionary()
        if let firstName = profileInfoCell.firstNameTextField.text {
            if firstName.count == 0 {
                HSUtility.showMessage(string:NSLocalizedString("invalid_firstName_error", comment: ""))
                return nil
            }
            inputValues[kPU_FirstName] = firstName
        }
        if let lastName = profileInfoCell.lastNameTextField.text {
            if lastName.count == 0 {
                HSUtility.showMessage(string:NSLocalizedString("invalid_lastName_error", comment: ""))
                return nil
            }
            inputValues[kPU_LastName] = lastName
        }
        inputValues[kPU_Email] = profileInfoCell.emailTextField.text
        inputValues[kPU_Phone] = profileInfoCell.phoneNumberTextField.text
        if let zip = profileInfoCell.zipCodeTextField.text {
            if zip.count == 0 {
                inputValues[kPU_Zipcode] = ""
            }else {
                inputValues[kPU_Zipcode] = zip
            }
        }
        return inputValues
    }
    
    fileprivate func getHeaderView(with desc:String)->UIView? {
        let label = UILabel.init(frame: CGRect(x:15,y:30,width:self.tableView.frame.width-(2*15),height:20))
        label.text = desc
        label.font = HSFontUtilities.avenirNextRegular(size: 13)
        label.textColor = UIColor.rgb(0x989899)
        label.textAlignment = .left
        label.sizeToFit()
        let h_view = UIView.init(frame: CGRect(x:0,y:0,width:self.tableView.frame.width,height:50))
        h_view.backgroundColor = UIColor.rgb(0xFAFAFA)
        h_view.addSubview(label)
        return h_view
    }
    fileprivate func pushChangePasswordController() {
//        let changePasswordScene = HSUpdatePasswordController()
//        changePasswordScene.emailID = HSUserManager.shared.currentUser?.email
        let updatePasswordScene = HSUpdatePasswordViewController()
        self.navigationController?.pushViewController(updatePasswordScene, animated: true)
    }
    fileprivate func pushSubscriptionTermsScene() {
        let subscriptionTermsController:HSSubscriptionTermsController = HSSubscriptionTermsController()
        self.navigationController?.pushViewController(subscriptionTermsController, animated: true)
    }
   fileprivate func doLogout(){
        HSAnalytics.setEventForTypes(withLog: HSA.logoutClick)
        let alertController = UIAlertController.init(title: AppCons.APPNAME, message: "Are you sure want to Logout?", preferredStyle: .actionSheet)
        
        let okayAction = UIAlertAction.init(title: "Log Out", style: .destructive, handler: {(didTapOkayAction)in
            HSAnalytics.setEventForTypes(withLog: HSA.logout)
            HSUserManager.shared.logout()
            let appDelegate = UIApplication.shared.delegate as! HSAppDelegate
            let nc = HSBaseNavigationController.init(rootViewController: HSPrimaryLaunchScreen())
            nc.isNavigationBarHidden = true
            appDelegate.window?.rootViewController = nc
        })
        alertController.addAction(okayAction)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
   fileprivate func showContactEmail()  {
        if MFMailComposeViewController.canSendMail() {
            HSAnalytics.setEventForTypes(withLog: HSA.hamburgerContact)
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients([AppCons.CONTACTUS])
            self.present(mailComposerVC, animated: true, completion: {
            })
        }else {
            HSUtility.showMessage(string: "Sorry! Could not compose an Email",title:AppCons.APPNAME)
        }
    }
    fileprivate func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    fileprivate func showImagePicker() {
        let alert=UIAlertController(title: "", message: "Profile Picture", preferredStyle: UIAlertControllerStyle.actionSheet);
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil));
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                let imag : UIImagePickerController = UIImagePickerController()
                imag.delegate = self
                imag.sourceType = UIImagePickerControllerSourceType.camera
                imag.allowsEditing = false
                self.present(imag, animated: true, completion: nil)
            }
        }));
        alert.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
                let imag : UIImagePickerController = UIImagePickerController()
                imag.delegate = self
                imag.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imag.allowsEditing = false
                self.present(imag, animated: true, completion: nil)
            }
        }));
        present(alert, animated: true, completion: nil)
    }
    fileprivate func showTermsOfService() {
        let url = URL.init(string: AppCons.TERMS_CONS)
        if #available(iOS 9.0, *) {
            let cntrl = SFSafariViewController(url: url!)
            self.present(cntrl, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(url!)
        }
    }
    
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension HSProfileViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case ProfileSectionTypes.profilePicture.rawValue,
             ProfileSectionTypes.personalInfo.rawValue:
            return 1
        case ProfileSectionTypes.settings.rawValue:
            return settingsSectionDataSource.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case ProfileSectionTypes.profilePicture.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: HSProfilePictureCell.reuseIdentifier()) as! HSProfilePictureCell
            cell.populateData(with:HSUserManager.shared.currentUser!)
            cell.isProfileEditing = isEditingModeEnabled
            cell.selectionStyle = .none
            return cell
        case ProfileSectionTypes.personalInfo.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: HSProfilePersonalInfoCell.reuseIdentifier()) as! HSProfilePersonalInfoCell
            cell.populateData(with:HSUserManager.shared.currentUser!)
            cell.isProfileEditing = isEditingModeEnabled
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case ProfileSectionTypes.settings.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: HSProfileSettingsCell.reuseIdentifier()) as! HSProfileSettingsCell
            cell.selectionStyle = .none
            cell.populate(with: indexPath.row)
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case ProfileSectionTypes.profilePicture.rawValue:
            return nil
        case ProfileSectionTypes.personalInfo.rawValue:
            return self.getHeaderView(with: ProfileSectionTypes.personalInfo.desc())
        case ProfileSectionTypes.settings.rawValue:
            return self.getHeaderView(with: ProfileSectionTypes.settings.desc())
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case ProfileSectionTypes.profilePicture.rawValue:
            return 0
        case ProfileSectionTypes.personalInfo.rawValue,
             ProfileSectionTypes.settings.rawValue:
            return 50
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditingModeEnabled == false && indexPath.section != ProfileSectionTypes.settings.rawValue {
            return
        }
        switch indexPath.section {
        case ProfileSectionTypes.profilePicture.rawValue:
            showImagePicker()
            break
        case ProfileSectionTypes.personalInfo.rawValue:
            break
        case ProfileSectionTypes.settings.rawValue:
            switch indexPath.row {
            case ProfileSettingsRowTypes.changePassword.rawValue:
                pushChangePasswordController()
                break
            case ProfileSettingsRowTypes.subscriptionTerms.rawValue:
                pushSubscriptionTermsScene()
                break
            case ProfileSettingsRowTypes.termsOfService.rawValue:
                showTermsOfService()
                break
            case ProfileSettingsRowTypes.contactUs.rawValue:
                showContactEmail()
                break
            case ProfileSettingsRowTypes.rateUs.rawValue:
                rateApp(appId: AppCons.APPID, completion: { (isSuccess) in
                    debugPrint("Rate us:\(isSuccess)")
                })
                break
            case ProfileSettingsRowTypes.logout.rawValue:
                doLogout()
                break
            default:
                break
            }
        default: break
        }
    }
}

//MARK: - IUIImagePickerControllerDelegate
extension HSProfileViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        picker.dismiss(animated: true, completion: {[weak self] in
            DispatchQueue.main.async {
                let indexpath = IndexPath.init(row: 0, section: ProfileSectionTypes.profilePicture.rawValue)
                let profilePictureCell = self?.tableView.cellForRow(at: indexpath) as! HSProfilePictureCell
                profilePictureCell.roundRectView.imageView.image = image
                profilePictureCell.roundRectView.backgroundColor = HSColorUtility.markerTagColor()
                self?.isProfilePictureChanged = true
            }
        })
    }
}

//MARK: - HSProfilePersonalInfoCellProtocol
extension HSProfileViewController:HSProfilePersonalInfoCellProtocol {
    func textFieldDidBeginEditing(txtField: UITextField) {
        self.activeField = txtField
    }
    func didTapPhoneNumberInputField() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(HSProfileViewController.didVerifyPhone), name: NSNotification.Name(rawValue: phoneVerificationIdentifier), object: nil)
        let scene = HSPhneVerificationQueryController()
        scene._navBarType = .type_0
        self.navigationController?.pushViewController(scene, animated: true)
    }
    
    func didVerifyPhone(notification: NSNotification) {
        if let phone = notification.userInfo?["phone"] as? String {
            let profileInfoCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: ProfileSectionTypes.personalInfo.rawValue)) as! HSProfilePersonalInfoCell
            profileInfoCell.phoneNumberTextField.text = phone
        }
    }
}
