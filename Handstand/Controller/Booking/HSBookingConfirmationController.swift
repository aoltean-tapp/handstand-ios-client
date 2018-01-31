//
//  HSBookingConfirmationController.swift
//  Handstand
//
//  Created by Fareeth John on 5/3/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSBookingConfirmationController: HSBaseController {

    @IBOutlet weak var roundedView: HSRoundedView! {
        didSet {
            roundedView.ivHeight = 88
            roundedView.ivWidth = 88
        }
    }
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var paymentLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var workoutLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet weak var trainerNameLabel: UILabel!
    @IBOutlet weak var sessionsRemainingLabel: UILabel!

    var bookingData : NSDictionary! = nil
    var trainer : HSTrainer! = nil
    var paymentText : String! = ""
    var bookingID : String! = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Confirmation"
        self.screenName = HSA.bookConfirmation
        HSNavigationBarManager.shared.applyProperties(key: .type_None, viewController: self)
        DispatchQueue.main.async {
            self.updateUI()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - MISC
    
    func updateUI() {
        trainerNameLabel.text = trainer.partialTrainerName()
//        userImageView.setImage(url: trainer.avatar)
        roundedView.imageView.setImage(url: trainer.avatar, style:.rounded)
        roundedView.backgroundColor = HSColorUtility.getMarkerTagColor(with: trainer.color)
        locationLabel.text = bookingData.value(forKey: kBK_Location) as! String?
        dateLabel.text = dateText()
        workoutLabel.text = bookingData.value(forKey: kBK_ClassType) as! String?
        sizeLabel.text = sizeText()
        paymentLabel.text = getPayText()
        infoLabel.text = infoLabel.text?.replacingOccurrences(of: "(name)", with: trainer.first_name)

        if let remainingWorkouts = HSUserManager.shared.currentUser?.remainingWorkouts {
                sessionsRemainingLabel.text = "\(Int(remainingWorkouts)) Sessions Remaining."
        }
    }
    
    func dateText() -> String {
        var theDate = ""
        let dateValue = bookingData.value(forKey: kBK_Date) as! String?
        let timeValue = bookingData.value(forKey: kBK_Time) as! String?
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd HH:mm"
        let dateTime = "\(dateValue!) \(timeValue!)"
        let theDateObj = dateFormate.date(from: dateTime)
        dateFormate.dateFormat = "EEEE MMMM d 'at' h:mm a"
        theDate = dateFormate.string(from: theDateObj!)
        return theDate
    }
    
    func sizeText() -> String {
        var theSize = ""
        let sizeValue = bookingData.value(forKey: kBK_WorkoutSize) as! String?
        if sizeValue == "1-On-1" {
            theSize = "Just You (1 person)"
        }
        else{
            theSize = "You + 1 (2 person)"
        }
        return theSize
    }
    
    func getPayText() -> String {
        var thePay = ""
        if paymentText == kPaymentTypeCard {
            thePay = "Using your card"
        }
        else{
//            thePay = "Using your \(paymentText!) passport"
            thePay = "Using your Package"
        }
        return thePay
    }
    
//    func showMyWorkout() {
//        
////        HSController.defaultController.getMainController().showMyWorkout()
//    }
    
    @IBAction func onAddNoteAction(_ sender: UIButton) {
        let commentsCntrl = HSBookingCommentsController()
        commentsCntrl.bookingID = self.bookingID
        self.navigationController?.pushViewController(commentsCntrl, animated: true)
    }
    
    @IBAction func onSkipAction(_ sender: UIButton) {
        self.perform(#selector(presentMyWorkoutScene), with: nil, afterDelay: 0.1)
        self.navigationController?.popToRootViewController(animated: true)
//        _ = self.navigationController?.popToViewController(HSController.defaultController.getMainController(), animated: true)
//        self.perform(#selector(self.showMyWorkout), with: nil, afterDelay: 0.6)
        
    }
    
    func presentMyWorkoutScene() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notification.showMyWorkout"), object: nil)
    }
    
}
