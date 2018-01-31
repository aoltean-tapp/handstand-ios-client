//
//  HSPlanConfirmationController.swift
//  Handstand
//
//  Created by Fareeth John on 5/2/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSPlanConfirmationController: HSBaseController, LTHMonthYearPickerViewDelegate, UITextFieldDelegate,HSPlanConfirmationControllerDelegate {
    
    @IBOutlet weak var applyPromoCodeBtn: UIButton!
    @IBOutlet var payButton: HSLoadingButton!
    //    @IBOutlet var checkBorderView: HSBorderView!
    //    @IBOutlet var agreeLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    //    @IBOutlet var checkImg: UIImageView!
    @IBOutlet var cvvView: HSBorderView!
    @IBOutlet var dateView: HSBorderView!
    @IBOutlet var cardNumberView: HSBorderView!
    @IBOutlet var expDateTextfield: UITextField!
    @IBOutlet var cvvTextfield: UITextField!
    @IBOutlet var cardTextfield: UITextField!
    @IBOutlet var cardView: UIView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    var plan : HSWorkoutPlan! = nil
    var datePicker : LTHMonthYearPickerView! = nil
    var requester : UIViewController? = nil
    var screenNameEString:String?
    var bookingConfrmEString:String?
    var planString:String?
    var delegate : HSPlanConfirmationControllerDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.planString = self.plan.price
        self.screenName = screenNameEString!
        updateUI()
        toggleApplyPromoBtn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MISC
    
    func updateUI() {
        if plan != nil {
            priceLabel.text = "$" + plan.price
            infoLabel.text = plan.planDescription
            if plan.sessions == "1" {
                titleLabel.text = "1 Session"
            }else {
                titleLabel.text = plan.title
            }
        }
        else{
            var cardUIFrame = cardView.frame
            cardUIFrame.origin.y = infoLabel.frame.origin.y
            cardView.frame = cardUIFrame
        }
        let theUser = HSUserManager.shared.currentUser
        if (theUser?.ccLast4?.characters.count)! > 0 {
            cardView.isUserInteractionEnabled = false
            cardTextfield.text = "Card ending with \((theUser?.ccLast4)!)"
            dateView.isHidden = true
            cvvView.isHidden = true
            //            checkBorderView.isHidden = true
            //            agreeLabel.isHidden = true
        }
        scrollView.contentSize = CGSize(width: UIScreen.main.applicationFrame.size.width, height: cardView.frame.origin.y + cardView.frame.size.height)
    }
    
    func getDatePicker() -> LTHMonthYearPickerView {
        if datePicker != nil {
            return datePicker
        }
        else{
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "MM/YYYY"
            
            datePicker = LTHMonthYearPickerView(date: dateFormater.date(from: "03/2016"), shortMonths: true, numberedMonths: false, andToolbar: true, minDate: NSDate() as Date!, andMaxDate: dateFormater.date(from: "03/2116"))
            datePicker.backgroundColor = UIColor.white
            datePicker.delegate = self
            return datePicker
        }
    }
    
    func showDatePicker() {
        var theDateFrame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 300)
        let theDatePicker = getDatePicker()
        theDatePicker.frame = theDateFrame
        self.view.addSubview(theDatePicker)
        theDateFrame.origin.y = theDateFrame.origin.y - theDateFrame.size.height
        UIView.animate(withDuration: 0.5) {
            theDatePicker.frame = theDateFrame
        }
    }
    
    func hideDatePicker() {
        let theDatePicker = getDatePicker()
        var theDateFrame =  theDatePicker.frame
        theDateFrame.origin.y = self.view.frame.size.height
        UIView.animate(withDuration: 0.5) {
            theDatePicker.frame = theDateFrame
        }
    }
    
    func isAllFieldValid() -> Bool {
        if (cardTextfield.text?.characters.count)! >= 15 && (cardTextfield.text?.characters.count)! <= 19 {
            if (expDateTextfield.text?.characters.count)! > 0 {
                if (cvvTextfield.text?.characters.count)! == 3 {
                    return true
                }
                else{
                    cvvView.setBorderColor(forType: .error)
                }
            }
            else{
                dateView.setBorderColor(forType: .error)
            }
        }
        else{
            cardNumberView.setBorderColor(forType: .error)
        }
        return false
    }
    
    func makeBooking(_ payment : String)  {
        if let bookingConfrmEString = bookingConfrmEString {
            HSAnalytics.setEventForTypes(withLog: bookingConfrmEString)
        }
        if HSUserManager.shared.trainerRequestAcceptType == .AcceptFromMyWorkouts {
            if let workoutScreen = self.navigationController?.viewControllers.filter({vc in vc.isKind(of: HSMyWorkoutController.self)}).first {
                self.navigationController?.popToViewController(workoutScreen, animated: true)
                self.callAccpetBookingForWorkouts()
//                self.perform(#selector(HSPlanConfirmationController.callAccpetBookingForWorkouts), with: nil, afterDelay: 0.5)
            }
        }else if HSUserManager.shared.trainerRequestAcceptType == .AcceptFromHome{
            self.callAcceptBookingFromHome()
            //self.perform(#selector(HSPlanConfirmationController.callAcceptBookingFromHome), with: nil, afterDelay: 1.0)
            self.navigationController?.popToRootViewController(animated: true)
        }else if HSUserManager.shared.trainerRequestAcceptType == .BookTrainerFromTrainerDetail{
            //self.callTrainerBookingConfirm()
            //self.perform(#selector(HSPlanConfirmationController.callTrainerBookingConfirm), with: nil, afterDelay: 1.0)
            if let trainerDetailScreen = self.navigationController?.childViewControllers.filter({ vc in vc is HSTrainerDetailController
            }).first {
                let td = trainerDetailScreen as! HSTrainerDetailController
                td.makeBooking("")
                self.navigationController?.popToViewController(trainerDetailScreen, animated: true)
            }
        }else {
            let packageSuccessVC = HSPackageSuccessController()
            packageSuccessVC.payment = payment
            if let price = planString {
                self.plan.price = price
            }
            packageSuccessVC.plan = self.plan
            packageSuccessVC.requester = self.requester
            self.navigationController?.pushViewController(packageSuccessVC, animated: true)
        }
        HSUserManager.shared.trainerRequestAcceptType = nil
    }
    
    func callAcceptBookingFromHome() {
        HSUserManager.shared.trainerRequestAcceptType = nil
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notification.AccpetTrainerBooking"), object: nil)
    }
    func callAccpetBookingForWorkouts() {
        HSUserManager.shared.trainerRequestAcceptType = nil
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notification.AccpetTrainerBooking.fromWorkouts"), object: nil)
    }
    
    func callTrainerBookingConfirm() {
        HSUserManager.shared.trainerRequestAcceptType = nil
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notification.BookingTrainerFromDetailScreen"), object: nil)
    }
    
    //MARK:- Textfield delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if textField == cardTextfield {
            cardNumberView.setBorderColor(forType: .normal)
        }
        else if textField == expDateTextfield{
            dateView.setBorderColor(forType: .normal)
        }
        else{
            cvvView.setBorderColor(forType: .normal)
        }
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if textField == self.cardTextfield {
            cardNumberView.setBorderColor(forType: .normal)
            if prospectiveText.characters.count > 19{
                return false
            }
        }
        else if textField == self.cvvTextfield {
            cvvView.setBorderColor(forType: .normal)
            if prospectiveText.characters.count > 4{
                return false
            }
        }
        return true
    }
    
    //MARK: - Date Delegate
    func pickerDidPressDone(withMonth month : String, andYear year : String ) {
        dateView.setBorderColor(forType: .normal)
        expDateTextfield.text = month + "/" + year
        hideDatePicker()
    }
    
    func pickerDidPressCancel()  {
        hideDatePicker()
    }
    
    func getMonthInt() -> Int {
        let arr = NSArray(objects: "JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC")
        if let dateArr = expDateTextfield.text?.components(separatedBy: "/") {
            if dateArr.count > 0 {
                return arr.index(of: ((dateArr[0] ).uppercased()))+1
            }
        }
        return 0
    }
    
    func getYearInt() -> Int {
        let dateArr = expDateTextfield.text?.components(separatedBy: "/")
        return Int(dateArr![1])!
    }
    
    func getInputData() -> NSDictionary {
        let theData = NSMutableDictionary()
        theData.setValue(cardTextfield.text, forKey: kPK_CardNumber)
        theData.setValue(getMonthInt(), forKey: kPK_CardExpMonth)
        theData.setValue(getYearInt(), forKey: kPK_CardExpYear)
        theData.setValue(cvvTextfield.text, forKey: kPK_CardCvv)
        return theData
    }
    
    func savePlan() {
        payButton.startLoading()
        HSPassportNetworkHandler().purchasePassport(forPackage: self.plan.code, forPrice:(self.plan?.price)!, forPlan: self.plan.sessions , completionHandler: { (success, error) in
            if success {
                HSAnalytics.setMixpanelTrackRevene(Double(self.plan.price)!)
                HSUserNetworkHandler().getUserProfile(completionHandler: { (success, error) in
                    self.payButton.stopLoading()
                    self.makeBooking(self.plan.sessions)
                })
            }
            else{
                self.payButton.stopLoading()
                HSUtility.showMessage(string: error?.message)
            }
        })
    }
    
    func saveCard()  {
        HSAnalytics.setEventForTypes(withLog: HSA.addCard)
        //        HSAnalytics.setEventForTypes(types: [.mixpanel], withLog: kMPSaveCard, withData:nil)
        self.payButton.startLoading()
        HSUserNetworkHandler().saveCardWith(data: getInputData(), completionHandler: { (success, error) in
            if success {
                if self.plan != nil{
                    // Save Plan
                    self.payButton.stopLoading()
                    self.savePlan()
                }
                else{
                    //Make booking
                    self.payButton.stopLoading()
                    self.makeBooking(kPaymentTypeCard)
                }
            }
            else{
                self.payButton.stopLoading()
                HSUtility.showMessage(string: error?.message)
            }
        })
    }
    
    
    
    //MARK:- Button Action
    
    @IBAction func onBackAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onPayAction(_ sender: HSLoadingButton) {
        self.view.findFirstResonder()?.resignFirstResponder()
        let theUser = HSUserManager.shared.currentUser
        if (theUser?.ccLast4?.characters.count)! > 0 {
            if plan == nil {
                self.makeBooking(kPaymentTypeCard)
            }
            else{
                savePlan()
            }
        }
        else{
            if isAllFieldValid() {
                saveCard()
            }
        }
    }
    
    @IBAction func onExpDateAction(_ sender: UIButton) {
        self.view.findFirstResonder()?.resignFirstResponder()
        showDatePicker()
    }
    
    @IBAction func onCheckAction(_ sender: UIButton) {
        //        checkImg.isHidden = !checkImg.isHidden
    }
    
    @IBAction func didTapAddcode(_ sender: UIButton) {
        if sender.titleLabel?.text == "Apply Promocode?" {
            let promoVC = HSPromotionController()
            promoVC.delegate = self
            self.navigationController?.pushViewController(promoVC, animated: true)
        }else {
            let  alertView : UIAlertController = UIAlertController(title: AppCons.APPNAME, message: "Currently you have applied '\(sender.titleLabel?.text ?? "")'", preferredStyle: .actionSheet)
            let clearAction = UIAlertAction.init(title: "Clear", style: .destructive, handler: { _ in
                HSLoadingView.standardLoading().startLoading()
                HSUserNetworkHandler().clearPromoCode { (result, error) in
                    HSLoadingView.standardLoading().stopLoading()
                    if error == nil {
                        self.toggleApplyPromoBtn()
                        self.planString = self.plan.price
                        self.priceLabel.text = "$"+self.plan.price
                    }else {
                        HSUtility.showMessage(string: (error?.message!)!)
                    }
                }
            })
            let changeAction = UIAlertAction.init(title: "Change", style: .default, handler: { (_) in
                HSLoadingView.standardLoading().startLoading()
                HSUserNetworkHandler().clearPromoCode { (result, error) in
                    HSLoadingView.standardLoading().stopLoading()
                    if error == nil {
                        self.toggleApplyPromoBtn()
                        self.planString = self.plan.price
                        self.priceLabel.text = "$"+self.plan.price
                        let promoVC = HSPromotionController()
                        promoVC.delegate = self
                        self.navigationController?.pushViewController(promoVC, animated: true)
                    }else {
                        HSUtility.showMessage(string: (error?.message!)!)
                    }
                }
            })
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (_) in })
            alertView.addAction(clearAction)
            alertView.addAction(changeAction)
            alertView.addAction(cancelAction)
            self.present(alertView, animated: true, completion: nil)
        }
    }
}

extension HSPlanConfirmationController:promoCodeAdder {
    func didApplyPromo(code: String, response: HSPromoResponse) {
        let lastPlanString = priceLabel.text
        if response.discountType == HSPromoResponse.discountPriceTypeKey {
            let value = Int((self.plan.price)!)!-response.discountValue!
            self.planString = value.description
        }else if response.discountType == HSPromoResponse.discountPercentageTypeKey {
            let divided:Double = (Double(response.discountValue!) / 100)
            let deductionValue = Double((self.plan.price)!)! * divided
            let finalPrice = Double(self.plan.price)! - deductionValue
            self.planString? = finalPrice.roundTo1f() as String
        }
        let mutableAttributed = NSMutableAttributedString.init(string: lastPlanString!)
        mutableAttributed.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber(value: 0), range: NSMakeRange(0, lastPlanString!.length()))
        mutableAttributed.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue), range: NSMakeRange(0, lastPlanString!.length()))
        mutableAttributed.addAttribute(NSStrikethroughColorAttributeName, value: UIColor.rgb(0xE17BFF), range: NSMakeRange(0, lastPlanString!.length()))
        
        let newPlanString = "  "+"$"+planString!
        
        let newValueAttrString = NSMutableAttributedString.init(string: newPlanString)
        newValueAttrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.handstandGreen(), range: NSMakeRange(0, newPlanString.length()))
        newValueAttrString.addAttribute(NSFontAttributeName, value:UIFont(name: "AvenirNext-Medium", size: 20)!, range: NSMakeRange(0, newPlanString.length()))
        mutableAttributed.append(newValueAttrString)
        self.priceLabel.attributedText = mutableAttributed
        toggleApplyPromoBtn(code)
    }
    func toggleApplyPromoBtn(_ title:String="Apply Promocode?") {
        let attStr = NSMutableAttributedString.init(string: title)
        attStr.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, title.characters.count))
        attStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.handstandGreen(), range: NSMakeRange(0, title.characters.count))
        applyPromoCodeBtn.setAttributedTitle(attStr, for: .normal)
    }
    
}

extension Double
{
    func roundTo1f() -> NSString
    {
        return NSString(format: "%.1f", self)
    }
}
