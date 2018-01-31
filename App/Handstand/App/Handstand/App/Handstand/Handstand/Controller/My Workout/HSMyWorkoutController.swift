//
//  HSMyWorkoutController.swift
//  Handstand
//
//  Created by Fareeth John on 5/9/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
import MessageUI
import SDWebImage

class HSMyWorkoutController: HSBaseController, MFMessageComposeViewControllerDelegate, HSSubcriptionControllerDelegate, HSWorkoutPlanControllerDelegate, HSPlanConfirmationControllerDelegate {
    
    @IBOutlet var noWorkoutLabel: UILabel!
    @IBOutlet var pastButton: UIButton!
    @IBOutlet var upcomingButton: UIButton!
    @IBOutlet var tableView: UITableView!
    let upcomingCellIdentifier = "upcomingCell"
    let pastCellIdentifier = "pastCellIdentifier"
    var upcomingWorkouts : Array<HSWorkoutSession>! = []
    var pastWorkouts : Array<HSWorkoutSession>! = []
    var selectedWorkout : HSWorkoutSession! = nil
    var refreshControl : ISRefreshControl! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Workouts"
        HSNavigationBarManager.shared.applyProperties(key: .type_None, viewController: self)
        self.screenName = HSA.upcomingWorkoutsScreen
        tableView.register(UINib(nibName: "HSUpcomingWorkoutCell", bundle: nil), forCellReuseIdentifier: self.upcomingCellIdentifier)
        tableView.register(UINib(nibName: "HSPastWorkoutCell", bundle: nil), forCellReuseIdentifier: self.pastCellIdentifier)
        setupPullToRefresh()
        fetchWorkouts(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - MISC
    
    func setupPullToRefresh() {
        refreshControl = ISRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func fetchWorkouts(_ animation : Bool) {
        if animation {
            HSLoadingView.standardLoading().startLoading()
        }
        self.tableView.isUserInteractionEnabled = false
        HSUserNetworkHandler().getMyWorkoutInfo { (workouts, error) in
            if animation {
                HSLoadingView.standardLoading().stopLoading()
            }
            else{
                self.refreshControl.endRefreshing()
            }
            if error == nil{
                var lupcomingWorkouts:[HSWorkoutSession] = []
                var lpastWorkouts:[HSWorkoutSession] = []
                for theWorkout in workouts {
                    if (theWorkout.startDate != nil) {
                        if theWorkout.startDate.compare(Date()) == .orderedAscending{
                            lpastWorkouts.append(theWorkout)
                            //                            self.pastWorkouts.append(theWorkout)
                        }
                        else{
                            lupcomingWorkouts.append(theWorkout)
                            //                            self.upcomingWorkouts.append(theWorkout)
                        }
                    }
                }
                self.pastWorkouts = lpastWorkouts
                self.upcomingWorkouts = lupcomingWorkouts
            }
            else{
                HSUtility.showMessage(string: error?.message)
            }
            self.reloadData()
        }
    }
    
    func reloadData()  {
        self.tableView.isUserInteractionEnabled = true
        self.tableView.reloadData()
        if upcomingButton.isSelected == false {
            if upcomingWorkouts.count == 0 {
                noWorkoutLabel.isHidden = false
            }
            else{
                noWorkoutLabel.isHidden = true
            }
        }
        else{
            if pastWorkouts.count == 0 {
                noWorkoutLabel.isHidden = false
            }
            else{
                noWorkoutLabel.isHidden = true
            }
        }
    }
    
    func cancelWorkout(_ workout : HSWorkoutSession)  {
        HSAnalytics.setEventForTypes(withLog: HSA.trainerBookedReject)
        HSLoadingView.standardLoading().startLoading()
        HSWorkoutNetworkHandler().cancelWorkoutSession(forSessionID: workout.id, status: workout.workoutStatus, completionHandler: {(success, withInCancelWindow, error) in
            if  withInCancelWindow == false {
                HSUtility.showMessage(message: NSLocalizedString("Force_Cancel_Message", comment: "") , withTitle: NSLocalizedString("Force_Cancel_Title", comment: "") , withButtons: ["Don't Cancel","I Understand"], onUserResponse: {buttonTitle in
                    if buttonTitle == "I Understand" {
                        HSAnalytics.setEventForTypes(withLog: HSA.bookingCancelUnder12)
                        HSLoadingView.standardLoading().startLoading()
                        HSWorkoutNetworkHandler().forceCancelWorkoutSession(forSessionID: workout.id, completionHandler: { (success, error) in
                            HSLoadingView.standardLoading().stopLoading()
                            if error == nil{
                                self.fetchWorkouts(true)
                            }
                            else{
                                HSUtility.showMessage(string: error?.message)
                            }
                        })
                    }
                })
            }
            else if error == nil{
                if withInCancelWindow{
                    HSUserNetworkHandler().getUserProfile(completionHandler: { (success, error) in
                        HSLoadingView.standardLoading().stopLoading()
                        self.fetchWorkouts(true)
                    })
                }else {
                    HSLoadingView.standardLoading().stopLoading()
                }
            }
            else{
                HSLoadingView.standardLoading().stopLoading()
                HSUtility.showMessage(string: error?.message)
            }
        })
    }
    
    func showRebook() {
        //        HSAnalytics.setEventForTypes(types: [.mixpanel], withLog: kMPWorkoutRebook, withData:nil)
        HSAnalytics.setEventForTypes(withLog: HSA.rebookTrainer)
        HSLoadingView.standardLoading().startLoading()
        HSTrainerNetworkHandler().getTrainerInfo(forTrainer: selectedWorkout.user_id, completionHandler: {(trainer, error) in
            HSLoadingView.standardLoading().stopLoading()
            if error == nil{
                //                let homeCntrl = HSController.defaultController.getMainController()
                HSUserManager.shared.trainerRequestAcceptType = .BookTrainerFromTrainerDetail
                let trainerCntrl = HSTrainerDetailController()
                trainerCntrl.trainer = trainer
                trainerCntrl.isFromSearch = false
                trainerCntrl.selectedClass = self.selectedWorkout.speciality
                let theAddress = HSAddress(withFormatedAddress: self.selectedWorkout.formatted_location)
                theAddress.zipCode = self.selectedWorkout.zipcode
                trainerCntrl.selectedAddress = theAddress
                self.navigationController?.pushViewController(trainerCntrl, animated: true)
                //                homeCntrl.navigationController?.pushViewController(trainerCntrl, animated: true)
            }
            else{
                HSUtility.showMessage(string: error?.message)
            }
        })
    }
    
    func doAcceptBooking() {
        if let theWorkout = selectedWorkout {
            HSUserManager.shared.trainerRequestAcceptType = nil
            HSAnalytics.setEventForTypes(withLog: HSA.trainerBookedConfirm)
            HSLoadingView.standardLoading().startLoading()
            HSWorkoutNetworkHandler().acceptWorkoutSession(forSessionID: (theWorkout.id)!, completionHandler: {(success, error) in
                HSLoadingView.standardLoading().stopLoading()
                if error == nil{
                    HSUserNetworkHandler().getUserProfile(completionHandler: { (success, error) in
                        if error == nil{
                            self.fetchWorkouts(true)
                        }
                        else{
                            HSUtility.showMessage(string: error?.message)
                        }
                    })
                }
                else{
                    HSUtility.showMessage(string: error?.message)
                }
            })
        }
    }
    
    //MARK: Message Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult){
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Button Action
    
    func refresh() {
        self.fetchWorkouts(false)
    }
    
    @IBAction func onUpcomingAction(_ sender: UIButton) {
        //        HSAnalytics.setEventForTypes(types: [.googleAnalytics], withLog: kGAUpcomingWorkoutScreen, withData:nil)
        HSAnalytics.setEventForTypes(withLog: HSA.upcomingWorkoutsScreen)
        if upcomingButton.isSelected {
            upcomingButton.isSelected = false
            pastButton.isSelected = true
        }
        self.reloadData()
    }
    
    @IBAction func onPastAction(_ sender: UIButton) {
        //        HSAnalytics.setEventForTypes(types: [.googleAnalytics], withLog: kGApastWorkoutScreen, withData:nil)
        HSAnalytics.setEventForTypes(withLog: HSA.pastRebookScreen)
        if pastButton.isSelected {
            upcomingButton.isSelected = true
            pastButton.isSelected = false
        }
        self.reloadData()
    }
    
    func onContactAction(_ sender: UIButton)  {
        if (MFMessageComposeViewController.canSendText()) {
            //            HSAnalytics.setEventForTypes(types: [.mixpanel], withLog: kMPWorkoutContact, withData:nil)
            HSAnalytics.setEventForTypes(withLog: HSA.upcomingBookingContact)
            let controller = MFMessageComposeViewController()
            let theWorkout = upcomingWorkouts[sender.tag]
            controller.recipients = [theWorkout.mobile]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else{
            HSUtility.showMessage(string: NSLocalizedString("no_sms", comment: ""))
        }
    }
    
    func onCancelAction(_ sender: UIButton)  {
        let theWorkout = upcomingWorkouts[sender.tag]
        HSUtility.showMessage(message: "", withTitle: NSLocalizedString("Workout_Cancel_Title", comment: "") , withButtons: ["Don't Cancel","Yes, Cancel"], onUserResponse: {buttonTitle in
            if buttonTitle == "Yes, Cancel" {
                self.cancelWorkout(theWorkout)
            }
        })
    }
    
    func onAcceptAction(_ sender: UIButton)  {
        selectedWorkout = upcomingWorkouts[sender.tag]
        if Int((HSUserManager.shared.currentUser?.remainingWorkouts)!) > 0 {
            doAcceptBooking()
        }
        else{
            HSLoadingView.standardLoading().startLoading()
            HSPassportNetworkHandler().getPackages({ (plans, error) in
                HSLoadingView.standardLoading().stopLoading()
                if error == nil {
                    let planCntrl = HSWorkoutPlanController()
                    planCntrl.plans = plans
                    planCntrl.delegate = self
                    HSUserManager.shared.trainerRequestAcceptType = .AcceptFromMyWorkouts
                    NotificationCenter.default.removeObserver(self)
                    NotificationCenter.default.addObserver(self, selector: #selector(HSMyWorkoutController.doAcceptBooking), name: NSNotification.Name(rawValue: "Notification.AccpetTrainerBooking.fromWorkouts"), object: nil)
                    
                    //                    planCntrl.requester = HSController.defaultController.getMainController().navigationController?.visibleViewController
                    //                    HSController.defaultController.getMainController().navigationController?.pushViewController(planCntrl, animated: true)
                    self.navigationController?.pushViewController(planCntrl, animated: true)
                }
                else{
                    HSUtility.showMessage(string: (error?.message)!)
                }
            })
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func onDeclineAction(_ sender: UIButton)  {
        //        HSAnalytics.setEventForTypes(types: [.mixpanel], withLog: kMPWorkoutDecline, withData:nil)
        HSUtility.showMessage(message: NSLocalizedString("Decline_booking_Message", comment: ""), withTitle: NSLocalizedString("Decline_booking_Request", comment: ""), withButtons: ["Nevermind","Decline"], onUserResponse: {buttonText in
            if buttonText == "Decline" {
                let theWorkout = self.upcomingWorkouts[sender.tag]
                HSLoadingView.standardLoading().startLoading()
                HSWorkoutNetworkHandler().declineWorkoutSession(forSessionID: theWorkout.id, completionHandler: {(success, error) in
                    HSLoadingView.standardLoading().stopLoading()
                    if error == nil{
                        self.fetchWorkouts(true)
                    }
                    else{
                        HSUtility.showMessage(string: error?.message)
                    }
                })
            }
        })
    }
    
    func onPendingCancelAction(_ sender: UIButton)  {
        self.onCancelAction(sender)
    }
    
    func onRebookAction(_ sender: UIButton)  {
        selectedWorkout = pastWorkouts[sender.tag]
        self.showRebook()
    }
    
    
    //MARK:- Plan delegate
    
    func makeBooking(_ payment : String)  {
        doAcceptBooking()
    }
        
    //MARK: - Tableview delegate
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if upcomingButton.isSelected {
            return pastWorkouts.count
        }
        else{
            return upcomingWorkouts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if upcomingButton.isSelected == false {
            let cell:HSUpcomingWorkoutCell = tableView.dequeueReusableCell(withIdentifier: upcomingCellIdentifier) as! HSUpcomingWorkoutCell!
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let theWorkout = upcomingWorkouts[indexPath.row]
            cell.profileImageView.setImage(url: theWorkout.thumbnail, style: .rounded)
            cell.nameLabel.text = theWorkout.partialTrainerName()
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "M/d/yy '-' h:mm a"
            cell.timeLabel.text = dateFormate.string(from: theWorkout.startDate)
            cell.locationLabel.text = theWorkout.formatted_location
            if theWorkout.isSingle {
                cell.classLabel.text = theWorkout.speciality + ", 1 person"
            }
            else{
                cell.classLabel.text = theWorkout.speciality + ", 2 person"
            }
            if theWorkout.requestedBy == .trainer {
                cell.trainerRequestInfoView.isHidden = false
                if theWorkout.workoutStatus == .pending {
                    cell.showDetailForType(.accept)
                }
                else{
                    cell.showDetailForType(.contact)
                }
            }
            else{
                cell.trainerRequestInfoView.isHidden = true
                if theWorkout.workoutStatus == .pending {
                    cell.showDetailForType(.pending)
                }
                else{
                    cell.showDetailForType(.contact)
                }
            }
            cell.contactButton.tag = indexPath.row
            cell.contactButton.addTarget(self, action: #selector(self.onContactAction(_:)), for: .touchUpInside)
            cell.cancelButton.tag = indexPath.row
            cell.cancelButton.addTarget(self, action: #selector(self.onCancelAction(_:)), for: .touchUpInside)
            cell.acceptButton.tag = indexPath.row
            cell.acceptButton.addTarget(self, action: #selector(self.onAcceptAction(_:)), for: .touchUpInside)
            cell.declineButton.tag = indexPath.row
            cell.declineButton.addTarget(self, action: #selector(self.onDeclineAction(_:)), for: .touchUpInside)
            cell.pendingCancelButton.tag = indexPath.row
            cell.pendingCancelButton.addTarget(self, action: #selector(self.onPendingCancelAction(_:)), for: .touchUpInside)
            return cell
        }
        else{
            let cell:HSPastWorkoutCell = tableView.dequeueReusableCell(withIdentifier: pastCellIdentifier) as! HSPastWorkoutCell!
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            if pastWorkouts.count > 0 {
                let theWorkout = pastWorkouts[indexPath.row]
                cell.profileImageView.setImage(url: theWorkout.thumbnail, style: .rounded)
                cell.nameLabel.text = theWorkout.partialTrainerName()
                cell.classLabel.text = theWorkout.speciality
                let dateFormate = DateFormatter()
                dateFormate.dateFormat = "M/d/yy '-' h:mm a"
                cell.dateLabel.text = dateFormate.string(from: theWorkout.startDate)
                cell.rebookButton.tag = indexPath.row
                if theWorkout.isHidden {
                    cell.notAvailableLabel.isHidden = false
                    cell.rebookButton.isUserInteractionEnabled = false
                    cell.rebookButton.alpha = 0.4
                }
                else{
                    cell.notAvailableLabel.isHidden = true
                    cell.rebookButton.isUserInteractionEnabled = true
                    cell.rebookButton.alpha = 1.0
                }
                cell.rebookButton.addTarget(self, action: #selector(self.onRebookAction(_:)), for: .touchUpInside)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        if upcomingButton.isSelected == false {
            return 130
        }
        else{
            return 105
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
    }
    
}
