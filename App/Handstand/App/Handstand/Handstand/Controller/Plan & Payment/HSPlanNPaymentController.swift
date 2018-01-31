//
//  HSPlanNPaymentController.swift
//  Handstand
//
//  Created by Fareeth John on 5/17/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSPlanNPaymentController: HSBaseController, HSWorkoutPlanControllerDelegate, HSPlanConfirmationControllerDelegate {
    
    @IBOutlet var myCardButton: UIButton!
    @IBOutlet var myPlanButton: UIButton!
    @IBOutlet var cardView: UIView!
    @IBOutlet var planView: UIView!
    var myPlanView : HSPlanView! = nil
    var myCardView : HSCardView! = nil
    var noCardView : HSNoCardView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = HSA.myPackageScreen
        setupUI()
        HSNavigationBarManager.shared.applyProperties(key: .type_14, viewController: self,titleView: getTitleLabelView())
    }
    
    fileprivate func getTitleLabelView()->UILabel {
        let label = UILabel()
        label.text = "Packages & Payment"
        label.textColor = UIColor.rgb(0x2A2A2A)
        if ScreenCons.SCREEN_HEIGHT < 600 {
            label.font = HSFontUtilities.avenirNextDemiBold(size: 14)
        }else {
            label.font = HSFontUtilities.avenirNextDemiBold(size: 17)
        }
        label.sizeToFit()
        return label
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePlanData()
        updateCardUI()
        if (HSUserManager.shared.currentUser?.ccLast4?.count)! > 0 {
            noCardView.isHidden = true
        }
        else{
            noCardView.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - MISC
    
    func setupUI() {
        //Plan
        myPlanView = HSPlanView.fromNib() as HSPlanView
        let theFrame = CGRect(x: 0, y: 0, width: planView.frame.size.width, height: planView.frame.size.height)
        myPlanView.frame = theFrame
        planView.addSubview(myPlanView)
        
        //Card
        myCardView = HSCardView.fromNib() as HSCardView
        let theCardFrame = CGRect(x: 0, y: 0, width: cardView.frame.size.width, height: cardView.frame.size.height)
        myCardView.frame = theCardFrame
        cardView.addSubview(myCardView)
        
        //No Card
        noCardView = HSNoCardView.fromNib() as HSNoCardView
        let theNoCardFrame = CGRect(x: 0, y: 0, width: cardView.frame.size.width, height: cardView.frame.size.height)
        noCardView.frame = theNoCardFrame
        cardView.addSubview(noCardView)
    }
    
    func updatePlanData() {
        let theUser = HSUserManager.shared.currentUser
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        //        let theDate = dateFormater.date(from: (theUser?.billingMonthEndDate)!)
        dateFormater.dateFormat = "MM/dd/yyyy"
        
        let zeroWorkout:Float = 0.0
        myPlanView.noPlanLargeLabel.isHidden = false
        myPlanView.noPlanSmallLabel.isHidden = false
        
        myPlanView.remainingLargeLabel.isHidden = false
        myPlanView.remainingLabel.isHidden = false
        myPlanView.planPeriodLabel.isHidden = false
        myPlanView.sessionLabel.isHidden = false
        myPlanView.dateLabel.isHidden = false

        if((theUser?.remainingWorkouts) != zeroWorkout){
            
            myPlanView.noPlanLargeLabel.isHidden = true
            myPlanView.noPlanSmallLabel.isHidden = true
            
            myPlanView.remainingLargeLabel.isHidden = false
            myPlanView.remainingLabel.isHidden = false
            myPlanView.planPeriodLabel.isHidden = false
            myPlanView.sessionLabel.isHidden = false
            myPlanView.dateLabel.isHidden = false
            
            let sessions = theUser?.total_session ?? 0
            let remainingWorkouts = theUser?.remainingWorkouts ?? 0
            myPlanView.sessionLabel.text = "\(Int(sessions)) lifetime sessions"
            if theUser?.remainingWorkouts == 0 {
                myPlanView.priceLabel.text = "No Active Plan"
            }else if (theUser?.remainingWorkouts == 1){
                myPlanView.remainingLargeLabel.text = "\(Int((theUser?.remainingWorkouts)!))"
                myPlanView.remainingLabel.text = myPlanView.remainingLargeLabel.text
                myPlanView.planPeriodLabel.text = "remaining session"
            }else {

                myPlanView.remainingLargeLabel.text = "\(Int(remainingWorkouts))"
                myPlanView.remainingLabel.text = myPlanView.remainingLargeLabel.text
                myPlanView.planPeriodLabel.text = "remaining sessions"
                //            myPlanView.planTitleLabel.text = "Monthly: \(Int((theUser?.passport)!))/Mo."
                //            myPlanView.priceLabel.text = "$\(Int((theUser?.price)!/(theUser?.passport)!))/session ($\(Int((theUser?.price)!)) total)"
                //            myPlanView.renewLabel.text = "Auto renews on: \(dateFormater.string(from: theDate!))"
                //            myPlanView.remainingTimeLabel.text = "Time remaining: \(((theDate as? NSDate)?.remainingDaysFromToday())!) days"
            }
            myPlanView.remainingLargeLabel.text = "\(Int(remainingWorkouts))"
            myPlanView.remainingLabel.text = myPlanView.remainingLargeLabel.text
            
            //        myPlanView.bookButton.addTarget(self, action: #selector(self.onBookAction), for: .touchUpInside)
            myPlanView.changePlanButton.addTarget(self, action: #selector(self.onAddPackageAction), for: .touchUpInside)
            dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let createdDate = dateFormater.date(from: (theUser?.created)!)
            dateFormater.dateFormat = "MM/dd/yyyy"
            if createdDate != nil {
                myPlanView.dateLabel.text = "Member since: " + dateFormater.string(from: createdDate!)
            }
            myPlanView.changePlanButton.setTitle("Add more Sessions", for: UIControlState.normal)
            myPlanView.changePlanButton.setTitleColor(UIColor.rgb(0x54CC96), for: UIControlState.normal)
            myPlanView.changePlanButton.backgroundColor = UIColor.white
            myPlanView.changePlanBorderView.backgroundColor = UIColor.rgb(0x54CC96)
        }else{

            myPlanView.remainingLargeLabel.isHidden = true
            myPlanView.remainingLabel.isHidden = true
            myPlanView.planPeriodLabel.isHidden = true
            myPlanView.sessionLabel.isHidden = true
            myPlanView.dateLabel.isHidden = true

            myPlanView.changePlanButton.addTarget(self, action: #selector(self.onAddPackageAction), for: .touchUpInside)
            myPlanView.changePlanButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            myPlanView.changePlanButton.setTitle("View Packages", for: UIControlState.normal)
            myPlanView.changePlanButton.backgroundColor = UIColor.rgb(0xD662FF)
        }
        
    }
    
    func updateCardUI() {
        myCardView.tableView.reloadData()
    }
    
    func showMyPlan() {
        planView.isHidden = false
        cardView.isHidden = true
    }
    
    func showMyCard() {
        HSAnalytics.setEventForTypes(withLog: HSA.myCardScreen)
        planView.isHidden = true
        cardView.isHidden = false
        updateCardUI()
    }
    
    //MARK:- Delegate
    
    func makeBooking(_ payment : String){
        
    }
    
    // MARK: - Button Action
    
    func onBookAction() {
        
    }
    
    func onAddPackageAction() {
        HSAnalytics.setEventForTypes(withLog: HSA.myPackageAddMoreSessions)
        HSLoadingView.standardLoading().startLoading()
        HSPassportNetworkHandler().getPackages({ (plans, error) in
            HSLoadingView.standardLoading().stopLoading()
            if error == nil {
                let changePlanCntrl  = HSWorkoutPlanController()
                changePlanCntrl.delegate = self
                changePlanCntrl.plans = plans
                
                //                changePlanCntrl.requester = HSController.defaultController.getMainController().navigationController?.visibleViewController
                //                HSController.defaultController.getMainController().navigationController?.pushViewController(changePlanCntrl, animated: true)
                changePlanCntrl.requester = self
                self.navigationController?.pushViewController(changePlanCntrl, animated: true)
            }
            else{
                HSUtility.showMessage(string: (error?.message)!)
            }
        })
    }
    
    @IBAction func onMyPlanAction(_ sender: UIButton) {
        if myPlanButton.isSelected {
            myPlanButton.isSelected = false
            myCardButton.isSelected = true
        }
        showMyPlan()
    }
    
    @IBAction func onMyCardAction(_ sender: UIButton) {
        if myCardButton.isSelected {
            myCardButton.isSelected = false
            myPlanButton.isSelected = true
        }
        showMyCard()
    }
    
    @IBAction func onAddCardAction(_ sender: UIButton) {
        let addCardCntrl = HSAddCardController()
        self.navigationController?.pushViewController(addCardCntrl, animated: true)
    }
    
    @IBAction func onChangeCardAction(_ sender: UIButton) {
        let addCardCntrl = HSAddCardController()
        self.navigationController?.pushViewController(addCardCntrl, animated: true)
    }
    
}

