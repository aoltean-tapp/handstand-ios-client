//
//  HSSignupViewController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/27/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
import SafariServices

class HSSignupViewController: HSBaseController {
    //MARK:- iVars
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(HSSignupInfoCell.nib(), forCellReuseIdentifier: HSSignupInfoCell.reuseIdentifier())
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.keyboardDismissMode = .interactive
//            tableView.tableHeaderView = self.getHeaderView(with: "Quiz is over. All your quiz answers remain 100% anonymous. We will not spam or use any of your personal information unless permission is granted.")
            tableView.tableFooterView = signupTermsView!
        }
    }
    lazy var signupTermsView:HSSignupTermsView? = {
        if let view = Bundle.main.loadNibNamed("HSSignupTermsView", owner: nil, options: nil)?.first as? HSSignupTermsView {
            view.frame = CGRect(x:0,y:0,width:ScreenCons.SCREEN_WIDTH,height:HSSignupTermsView.getHeight())
            view.delegate = self
            return view
        }
        return nil
    }()
    fileprivate var activeField: UITextField?
    public var handpickedQuiz:HSQuizPostResponse?
    
    //MARK:- Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        HSNavigationBarManager.shared.applyProperties(key: .type_12, viewController: self,titleView:self.getTitleView())
        registerForKeyboardNotifications()
    }
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(aNotification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(aNotification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.signupTermsView?.buildPolicyLabelData()
        }
    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.signupTermsView?.frame = CGRect(x:0,y:0,width:self.tableView.frame.width,height:HSSignupTermsView.getHeight())
//    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWasShown(aNotification: NSNotification) {
        let info = aNotification.userInfo as! [String: AnyObject],
        kbSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size,
        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
        if let activeTextField = activeField {
            if !aRect.contains(activeTextField.frame.origin) {
                self.tableView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
    
    func didVerifyPhone(notification: NSNotification) {
        if let phone = notification.userInfo?["phone"] as? String {
            let signupInfoCell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! HSSignupInfoCell
            signupInfoCell.phoneNumberTextField.text = phone
        }
        let cell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! HSSignupInfoCell
        cell.passwordTextField.becomeFirstResponder()
        self.tableView.tableFooterView = signupTermsView
    }
    //MARK:- Private functions
    func isAllFieldValid() -> Bool {
        var status : Bool = false
        let cell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! HSSignupInfoCell
        if let errMsg = cell.firstNameTextField.validateForFirstName() {
            showErrorMessage(errMsg)
        }else if let errMsg = cell.lastNameTextField.validateForLastName() {
            showErrorMessage(errMsg)
        }else if let emailErrMsg = cell.emailTextField.validateForEmail() {
            showErrorMessage(emailErrMsg)
        }else if let errMsg = cell.phoneNumberTextField.validateForPhone() {
            showErrorMessage(errMsg)
        }else if let passErrMsg = cell.passwordTextField.validateForPassword(){
            showErrorMessage(passErrMsg)
        }else if signupTermsView?.termsCheck.isHidden == true {
            showErrorMessage(NSLocalizedString("terms_check_error", comment: ""))
        }else{
            status = true
        }
        return status
    }
    
    func showErrorMessage(_ message : String)  {
        HSUtility.showMessage(string: message)
    }
    //MARK:- Selectors
    func didTapDoneButton() {
        let quizBeginScreen = HSQuizBeginController()
        self.navigationController?.pushViewController(quizBeginScreen, animated: true)
        
        /*
        view.endEditing(true)
        if isAllFieldValid() {
            var policyState = ""
            if self.signupTermsView?.policyCheck.isHidden == false {
                policyState = "on"
            }
            HSLoadingView.standardLoading().startLoading()
            let cell = self.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! HSSignupInfoCell
            HSUserNetworkHandler().signup(cell.firstNameTextField.text!, lastname: cell.lastNameTextField.text!, mobile: cell.phoneNumberTextField.text!, email: cell.emailTextField.text!, password: cell.passwordTextField.text!, inputData: ["rebook_accept" : policyState], completionHandler: { (success, error) in
                if success {
                    HSOnboardingServiceHandler().startService({ [weak self] (success, error) in
                        if success {
                            HSLoadingView.standardLoading().stopLoading()
                            let quizBeginScreen = HSQuizBeginController()
                            self?.navigationController?.pushViewController(quizBeginScreen, animated: true)
                        }
                        else{
                            HSLoadingView.standardLoading().stopLoading()
                            if error?.code == eErrorType.invalidAppVersion {
                                HSApp().alertUserToForceDownloadNewVersion((error?.message)!)
                            }
                            else if error?.code == eErrorType.updateAppVersion {
                                HSApp().alertUserToDownloadNewVersion((error?.message)!)
                            }
                            else{
                                if let msg = error?.message {
                                    HSUtility.showMessage(string: msg)
                                }
                            }
                        }
                    })
                }
                else{
                    HSLoadingView.standardLoading().stopLoading()
                    self.showErrorMessage((error?.message)!)
                }
            })
        }*/
    }
}

//MARK:- UITableViewDelegate & UITableViewDataSource
extension HSSignupViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HSSignupInfoCell.reuseIdentifier()) as! HSSignupInfoCell
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    fileprivate func getHeaderView(with desc:String)->UIView? {
        //+20 Extra Trailing Space as given in Sketch
        let label = UILabel.init(frame: CGRect(x:15,y:20,width:ScreenCons.SCREEN_WIDTH-(2*15+20),height:70))
        label.text = desc
        label.numberOfLines = 0
        label.font = HSFontUtilities.avenirNextRegular(size: 12)
        label.textColor = UIColor.rgb(0xC7C7CC)
        label.textAlignment = .left
        label.sizeToFit()
        let h_view = UIView.init(frame: CGRect(x:0,y:0,width:ScreenCons.SCREEN_WIDTH,height:100))
        h_view.backgroundColor = tableView.backgroundColor
        h_view.addSubview(label)
        return h_view
    }
}

//MARK:- HSSignupInfoCellProtocol
extension HSSignupViewController:HSSignupInfoCellProtocol {
    func textFieldDidBeginEditing(txtField: UITextField) {
        self.activeField = txtField
    }
    func didTapPhoneNumberInputField() {
        //NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(HSProfileViewController.didVerifyPhone), name: NSNotification.Name(rawValue: phoneVerificationIdentifier), object: nil)
        let scene = HSPhneVerificationQueryController()
        scene._navBarType = .type_0
        self.navigationController?.pushViewController(scene, animated: true)
    }
    func didCompleteForm() {
        didTapDoneButton()
    }
}

extension HSSignupViewController:SignupTermsViewDelegate {
    func didTapTermsAndCons(link:String) {
        let URL = NSURL(string: link)!
        if #available(iOS 9.0, *) {
            let cntrl = SFSafariViewController(url: URL as URL)
            self.present(cntrl, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(URL as URL)
        }
        if link == "https://handstandapp.com/pages/terms-and-conditions" {
            HSAnalytics.setEventForTypes(withLog: HSA.termsScreen)
        }
    }
}
