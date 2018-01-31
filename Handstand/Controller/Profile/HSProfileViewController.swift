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
import Photos
import AVKit
import AVFoundation

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
//TODO: Make this as Nested ENUM for ProfileSectionTypes
internal enum ProfileSettingsRowTypes:Int {
    case changePassword
    case packagesNPayment
    case subscriptionTerms
    case termsOfService
    case contactUs
    case rateUs
    case logout
    
    func desc()->String {
        switch self {
        case .changePassword:return "Change Password"
        case .packagesNPayment:return "Packages & Payment"
        case .subscriptionTerms:return "Subscription Terms"
        case .termsOfService:return "View Terms of Service"
        case .contactUs:return "Contact Support"
        case .rateUs:return "Rate the App"
        case .logout:return "Log Out"
        }
    }
}

class HSProfileViewController: HSBaseController {
    
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
    lazy var picker = UIImagePickerController()
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
    fileprivate lazy var settingsSectionDataSource:[ProfileSettingsRowTypes] = [.changePassword,.packagesNPayment,.subscriptionTerms,.termsOfService,.contactUs,.rateUs,.logout]
    fileprivate var activeField: UITextField?
    
    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        HSNavigationBarManager.shared.applyProperties(key: .type_6, viewController: self)
        registerForKeyboardNotifications()
        self.edgesForExtendedLayout = []
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
  
    func didTapCancelButton() {
        isEditingModeEnabled = !isEditingModeEnabled
    }
    func didTapDoneButton() {
        self.tabBarController?.tabBar.isHidden = false
        addVersionOnFooterView()
        view.endEditing(true)
        if self.isProfilePictureChanged == true {
            let indexpath = IndexPath.init(row: 0, section: ProfileSectionTypes.profilePicture.rawValue)
            let profilePictureCell = tableView.cellForRow(at: indexpath) as! HSProfilePictureCell
            if let image = profilePictureCell.roundRectView.imageView.image {
                let newImage = self.fixImageOrientation(image)
                if let inputData = getInputData() {
                    HSLoadingView.standardLoading().startLoading()
                    HSUserNetworkHandler().saveProfileInfo(profileData: inputData, withImage:newImage, completionHandler: { [weak self] (isSuccess, error) in
                        if error == nil {
                            self?.updateProfile()
                        }else{
                            self?.tabBarController?.tabBar.isHidden = true
                            HSLoadingView.standardLoading().stopLoading()
                            HSUtility.showMessage(string: error?.message)
                        }
                    })
                }else {
                    self.tabBarController?.tabBar.isHidden = true
                }
            }
        }else {
            if let inputData = getInputData() {
                HSLoadingView.standardLoading().startLoading()
                HSUserNetworkHandler().saveProfileInfo(profileData: inputData, completionHandler: {[weak self] (success, error) in
                    if error == nil {
                        self?.updateProfile()
                    }else{
                        self?.tabBarController?.tabBar.isHidden = true
                        HSLoadingView.standardLoading().stopLoading()
                        HSUtility.showMessage(string: error?.message)
                    }
                })
            }else {
                self.tabBarController?.tabBar.isHidden = true
            }
        }
    }
    func fixImageOrientation(_ image: UIImage)->UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? image
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
            if zip.count > 0 {
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
        let changePasswordScene = HSUpdatePasswordViewController()
        changePasswordScene.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(changePasswordScene, animated: true)
    }
    fileprivate func pushPackagesNPaymentController() {
        let packagesNPaymentScene = HSPlanNPaymentController()
        packagesNPaymentScene.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(packagesNPaymentScene, animated: true)
    }
    fileprivate func pushSubscriptionTermsScene() {
        let subscriptionTermsController:HSSubscriptionTermsController = HSSubscriptionTermsController()
        subscriptionTermsController.hidesBottomBarWhenPushed = true
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
            let iOSVersion = HSUtility.getAppVersion()
            mailComposerVC.setSubject("Handstand iOS Client Support")
            let systemVersion = UIDevice.current.systemVersion
            let model = UIDevice.current.modelName
            let body = "App Version:\(iOSVersion)\nUser ID:\(HSUserManager.shared.currentUser?.user_id ?? "")\niOS Version:\(systemVersion)\nDevice:\(model)\nEnter your message below:\n---------------------------"
            mailComposerVC.setMessageBody(body, isHTML: false)
            self.present(mailComposerVC, animated: true, completion: {
            })
        }else {
            HSUtility.showMessage(string: "Sorry! Could not compose an Email",title:AppCons.APPNAME)
        }
    }
    fileprivate func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            return completion(false)
        }
        guard #available(iOS 10, *) else {
            return completion(UIApplication.shared.openURL(url))
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    fileprivate func showImagePicker() {
        let alert=UIAlertController(title: "", message: "Profile Picture", preferredStyle: UIAlertControllerStyle.actionSheet);
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil));
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            self.cameraSelected()
        }));
        alert.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction) in
            self.pickFile()
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

    func cameraSelected() {
        // First we check if the device has a camera (otherwise will crash in Simulator - also, some iPod touch models do not have a camera).
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            switch authStatus {
            case .authorized:
                showCameraPicker()
            case .denied:
                alertPromptToAllowCameraAccessViaSettings()
            case .notDetermined:
                permissionPrimeCameraAccess()
            default:
                permissionPrimeCameraAccess()
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (alert) in })
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    func alertPromptToAllowCameraAccessViaSettings() {
        let alert = UIAlertController(title: "Handstand Would Like To Access the Camera", message: "Please grant permission to use the Camera so that you can set Profile Picture.", preferredStyle: .alert )
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { alert in
            if let appSettingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(appSettingsURL)
            }
        })
        present(alert, animated: true, completion: nil)
    }

    func permissionPrimeCameraAccess() {
        let alert = UIAlertController( title: "Handstand Would Like To Access the Camera", message: "Handstand would like to access your Camera so that you can set Profile Picture.", preferredStyle: .alert )
        let allowAction = UIAlertAction(title: "Allow", style: .default, handler: { (alert) -> Void in
            if AVCaptureDevice.devices().count > 0 {
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { [weak self] granted in
                    DispatchQueue.main.async {
                        self?.cameraSelected() // try again
                    }
                })
            }
        })
        alert.addAction(allowAction)
        let declineAction = UIAlertAction(title: "Not Now", style: .cancel) { (alert) in}
        alert.addAction(declineAction)
        present(alert, animated: true, completion: nil)
    }

    func showCameraPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.camera
        present(picker, animated: true, completion: nil)
    }

    private func buildAlert(with title:String,message:String)->UIAlertController {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        return alert
    }

    private func alertPromptToAllowPhotoLibraryAccessViaSettings() {
        let alert = UIAlertController(title: "Handstand", message: "Please grant permission to use the Photo Library, so that you can set Profile Picture.", preferredStyle: .alert )
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { alert in
            UIApplication.shared.openURL(NSURL.init(string: UIApplicationOpenSettingsURLString)! as URL)
        })
        self.present(alert, animated: true, completion: nil)
    }

    func pickFile (){
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            //handle authorized status
            showPhotoPicker()
        case .denied, .restricted :
            //handle denied status
            alertPromptToAllowPhotoLibraryAccessViaSettings()
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    // as above
                    self.showPhotoPicker()
                case .denied, .restricted:
                    // as above
                    self.alertPromptToAllowPhotoLibraryAccessViaSettings()
                case .notDetermined:
                    // won't happen but still
                    self.alertPromptToAllowPhotoLibraryAccessViaSettings()
                }
            }
        }
    }
    func showPhotoPicker() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
                let imag : UIImagePickerController = UIImagePickerController()
                imag.delegate = self
                imag.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imag.allowsEditing = false
                self.present(imag, animated: true, completion: nil)
            }
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
            case ProfileSettingsRowTypes.packagesNPayment.rawValue:
                pushPackagesNPaymentController()
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
                if let code = HSUserManager.shared.currentUser?.quizData?.color {
                    profilePictureCell.roundRectView.backgroundColor = HSColorUtility.getMarkerTagColor(with: code)
                }
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

//MARK:- Extension|MFMailComposeViewControllerDelegate
extension HSProfileViewController:MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

public extension UIDevice {

    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }

}


