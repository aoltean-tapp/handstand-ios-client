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
    @IBOutlet var textView: UITextView!
    var bookingID : String! = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = HSA.commentScreen
        self.screenName = HSA.bookTrainerNotes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
