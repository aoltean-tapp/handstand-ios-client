//
//  HSBookingCommentsController.swift
//  Handstand
//
//  Created by Fareeth John on 5/11/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSBookingCommentsController: HSBaseController {

    @IBOutlet var confirmView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var textView: UITextView!
    var bookingID : String! = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Additional Comments"
        self.screenName = HSA.commentScreen
        self.screenName = HSA.bookTrainerNotes

        registerForKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(aNotification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(aNotification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    //MARK: - Observers
    @objc func keyboardWasShown(aNotification: NSNotification) {
        let info = aNotification.userInfo as! [String: AnyObject],
        kbSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size,
        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
            if !aRect.contains(textView.frame.origin) {
                self.scrollView.scrollRectToVisible(textView!.frame, animated: true)
            }
    }

    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func showHomeScreen() {
        self.navigationController?.popToRootViewController(animated: true)
//        _ = self.navigationController?.popToViewController(HSController.defaultController.getMainController(), animated: true)
    }

    // MARK: - Button Action
    
    @IBAction func onBackAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSubmitAction(_ sender: HSLoadingButton) {
        self.view.findFirstResonder()?.resignFirstResponder()
        if textView.text.characters.count > 0 {
//            HSAnalytics.setEventForTypes(types: [.mixpanel], withLog: kMPBookingAddComment, withData:nil)
            sender.startLoading()
            HSWorkoutNetworkHandler().addNotesToWorkoutSession(forSessionID: bookingID, withComments: textView.text, completionHandler: { (success, error) in
                sender.stopLoading()
                if success {
                    HSAnalytics.setEventForTypes(withLog: HSA.commentSendToTrainer+" "+"comment("+self.textView.text+")"+"bookingId("+self.bookingID+")")
//                    HSAnalytics.setEventForTypes(types: [.googleAnalytics], withLog: kGANoteConfirmationScreen, withData: nil)
                    self.confirmView.isHidden = false
                    self.perform(#selector(self.showHomeScreen), with: nil, afterDelay: 1)
                }
                else{
                    HSUtility.showMessage(string: error?.message)
                }
            })
        }
        else{
            HSUtility.showMessage(string: NSLocalizedString("notes_err", comment: ""))
        }
    }
    
    @IBAction func onSkipAction(_ sender: UIButton) {
        showHomeScreen()
    }
    

}
