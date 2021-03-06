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
import TTSegmentedControl

enum WorkoutType {
    case upcoming
    case past
}

class HSMyWorkoutController: HSBaseController, MFMessageComposeViewControllerDelegate, HSSubcriptionControllerDelegate, HSWorkoutPlanControllerDelegate, HSPlanConfirmationControllerDelegate {
    
    //MARK: - iVars
    @IBOutlet weak var noWorkoutLabel: UILabel!
    @IBOutlet weak var sessionTypeSegmentedControl: TTSegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    let upcomingSessionCellIdentifier = "upcomingSessionCellIdentifier"
    let pastSessionCellIdentifier = "pastSessionCellIdentifier"
    var upcomingWorkouts: [HSWorkoutSession] = []
    var pastWorkouts: [HSWorkoutSession] = []
    var upcomingExpandedCells: [Bool] = []
    var pastExpandedCells: [Bool] = []
    var selectedWorkout : HSWorkoutSession! = nil
    var refreshControl : ISRefreshControl! = nil
    
    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Workouts"
        self.screenName = HSA.upcomingWorkoutsScreen
        tableView.register(UINib(nibName: "HSUpcomingSessionCell", bundle: nil), forCellReuseIdentifier: self.upcomingSessionCellIdentifier)
        tableView.register(UINib(nibName: "HSPastSessionCell", bundle: nil), forCellReuseIdentifier: self.pastSessionCellIdentifier)
        setupPullToRefresh()
        fetchWorkouts(true)
        self.edgesForExtendedLayout = []
        HSNavigationBarManager.shared.applyProperties(key: .type_5, viewController: self)
        
        sessionTypeSegmentedControl.layer.borderWidth = 1.0
        sessionTypeSegmentedControl.layer.borderColor = #colorLiteral(red: 0.3568627451, green: 0.7803921569, blue: 0.5764705882, alpha: 1).cgColor
        
        sessionTypeSegmentedControl.padding = CGSize(width: 0, height: 0)
        sessionTypeSegmentedControl.itemTitles = ["UPCOMING", "RE-BOOK"]
        sessionTypeSegmentedControl.allowChangeThumbWidth = false
        sessionTypeSegmentedControl.defaultTextColor = #colorLiteral(red: 0.3725490196, green: 0.3725490196, blue: 0.3725490196, alpha: 1)
        sessionTypeSegmentedControl.defaultTextFont = UIFont(name: "Lato-Bold", size: 13.0)!
        sessionTypeSegmentedControl.selectedTextFont = UIFont(name: "Lato-Bold", size: 13.0)!
        
        sessionTypeSegmentedControl.didSelectItemWith = { [weak self] (index, title) -> () in
            if index == 0 {
                self?.getWorkouts(of: .upcoming)
            } else {
                self?.getWorkouts(of: .past)
            }
        }
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
                self.upcomingExpandedCells = []
                self.pastExpandedCells = []
                for theWorkout in workouts {
                    if (theWorkout.startDate != nil) {
                        if theWorkout.startDate.compare(Date()) == .orderedAscending{
                            lpastWorkouts.append(theWorkout)
                            self.pastExpandedCells.append(false)
                            //                            self.pastWorkouts.append(theWorkout)
                        }
                        else{
                            lupcomingWorkouts.append(theWorkout)
                            self.upcomingExpandedCells.append(false)
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
        if sessionTypeSegmentedControl.currentIndex == 0 {
            noWorkoutLabel.text = "Book a session by going to your home screen!"
            if upcomingWorkouts.count == 0 {
                noWorkoutLabel.isHidden = false
            }
            else {
                noWorkoutLabel.isHidden = true
            }
        }
        else{
            noWorkoutLabel.text = "You don't have any past workouts!"
            if pastWorkouts.count == 0 {
                noWorkoutLabel.isHidden = false
            }
            else {
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
                trainerCntrl.hidesBottomBarWhenPushed = true
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
    
    fileprivate func getWorkouts(of type: WorkoutType) {
        switch type {
        case .upcoming:
            HSAnalytics.setEventForTypes(withLog: HSA.upcomingWorkoutsScreen)
        case .past:
            HSAnalytics.setEventForTypes(withLog: HSA.pastRebookScreen)
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
                    planCntrl.hidesBottomBarWhenPushed = true
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
                    }else{
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
}

//MARK: - UITableViewDelegate and UITableViewDataSource
extension HSMyWorkoutController {
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        if sessionTypeSegmentedControl.currentIndex == 0 {
            return upcomingWorkouts.count
        } else {
            return pastWorkouts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if sessionTypeSegmentedControl.currentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: upcomingSessionCellIdentifier) as! HSUpcomingSessionCell
            let theWorkout = upcomingWorkouts[indexPath.row]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM"
            cell.monthLabel.text = dateFormatter.string(from: theWorkout.startDate).uppercased()
            dateFormatter.dateFormat = "dd"
            cell.dayLabel.text = dateFormatter.string(from: theWorkout.startDate)
            dateFormatter.dateFormat = "h:mm a"
            cell.classDurationLabel.text = dateFormatter.string(from: theWorkout.startDate)
            
            cell.trainerNameLabel.text = "\(theWorkout.first_name ?? "") \(theWorkout.last_name ?? "")".uppercased()
            cell.classNameLabel.text = theWorkout.speciality
            cell.trainerImageView.sd_setImage(with: URL(string: theWorkout.avatar))
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: pastSessionCellIdentifier) as! HSPastSessionCell
            let theWorkout = pastWorkouts[indexPath.row]
            
            cell.trainerImageView.sd_setImage(with: URL(string: theWorkout.avatar))
            cell.trainerNameLabel.text = "\(theWorkout.first_name ?? "") \(theWorkout.last_name ?? "")".uppercased()
            cell.locationLabel.text = theWorkout.formatted_location
            cell.classNameLabel.text = theWorkout.speciality
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        if sessionTypeSegmentedControl.currentIndex == 0 {
            if upcomingExpandedCells[indexPath.row] {
                return 156
            } else {
                return 93
            }
        } else {
            if pastExpandedCells[indexPath.row] {
                return 156
            } else {
                return 93
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        // upcoming workouts
        if sessionTypeSegmentedControl.currentIndex == 0 {
            if let selectedCell = tableView.cellForRow(at: indexPath) as? HSUpcomingSessionCell {
                // cell is in center position (not slided)
                if selectedCell.isExpandable {
                    upcomingExpandedCells[indexPath.row] = !upcomingExpandedCells[indexPath.row]
                    // cell is expanded => not slideable
                    if upcomingExpandedCells[indexPath.row] {
                        selectedCell.isSlideable = false
                    // cell is not expanded => slideable
                    } else {
                        selectedCell.isSlideable = true
                    }
                }
            }
        } else {
            if let selectedCell = tableView.cellForRow(at: indexPath) as? HSPastSessionCell {
                // cell is in center position (not slided)
                if selectedCell.isExpandable {
                    pastExpandedCells[indexPath.row] = !pastExpandedCells[indexPath.row]
                    // cell is expanded => not slideable
                    if pastExpandedCells[indexPath.row] {
                        selectedCell.isSlideable = false
                        // cell is not expanded => slideable
                    } else {
                        selectedCell.isSlideable = true
                    }
                }
            }
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
