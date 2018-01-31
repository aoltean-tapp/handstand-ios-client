//
//  HSPaymentDetailsController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/22/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

protocol HSPaymentDetailsProtocol:class {
    func didCompletePayment()
}

class HSPaymentDetailsController: HSBaseController,UITextFieldDelegate {
    
    //MARK: - iVars
    public weak var delegate:HSPaymentDetailsProtocol?
    
    @IBOutlet weak var cardView: HSBorderView! {
        didSet {
            cardView.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var cvvView: HSBorderView! {
        didSet {
            cvvView.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var dateView: HSBorderView! {
        didSet {
            dateView.layer.cornerRadius = 4
        }
    }
    
    @IBOutlet weak var cardTextfield: UITextField! {
        didSet {
            cardTextfield.delegate = self
        }
    }
    @IBOutlet weak var monthNYearTextField: UITextField! {
        didSet {
            monthNYearTextField.delegate = self
        }
    }
    @IBOutlet weak var cvvTextfield: UITextField! {
        didSet {
            cvvTextfield.delegate = self
        }
    }
    
    @IBOutlet weak var payButton: HSLoadingButton! {
        didSet {
            payButton.layer.cornerRadius = 4
        }
    }
    private var datePicker : LTHMonthYearPickerView! = nil
    public var selectedPlan:HSFirstPlanListResponse?
    
    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setPrefilledInputs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Button Actions
    @IBAction func didTapPay(_ sender: HSLoadingButton) {
        if isAllFieldValid() {
            sender.startLoading()
//            self.pay()
            saveCard()
        }
    }
    
    private func pay() {
        HSPassportNetworkHandler().purchasePassport(forPackage: (self.selectedPlan?.packageId?.description)!, completionHandler: { (success, error) in
            if success {
                if let price = self.selectedPlan?.price {
                    let finalPrice = price.replacingOccurrences(of: "$", with: "")
                    HSAnalytics.setMixpanelTrackRevene(Double(finalPrice)!)
                }
                self.payButton.stopLoading()
                self.delegate?.didCompletePayment()
            }
            else{
                self.payButton.stopLoading()
                HSUtility.showMessage(string: error?.message)
            }
        })
    }
    
    private func saveCard() {
        HSUserNetworkHandler().saveCardWith(data: getInputData(), completionHandler: { (success, error) in
            if success {
                HSUserNetworkHandler().getUserProfile(completionHandler: { (success, error) in
                    if success {
                        self.pay()
                    }else{
                        self.payButton.stopLoading()
                        HSUtility.showMessage(string: error?.message)
                    }
                })
            }else{
                self.payButton.stopLoading()
                HSUtility.showMessage(string: error?.message)
            }
        })
    }
    
    @IBAction func onExpDateAction(_ sender: UIButton) {
        self.view.findFirstResonder()?.resignFirstResponder()
        showDatePicker()
    }
    
    //MARK: - Private functions
    private func setPrefilledInputs() {
        self.cardTextfield.text = "4242424242424242"
        self.monthNYearTextField.text = "JAN/2022"
        self.cvvTextfield.text = "111"
    }
    private func getMonthInt() -> Int {
        let arr = NSArray(objects: "JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC")
        let dateArr = monthNYearTextField.text?.components(separatedBy: "/")
        return arr.index(of: ((dateArr![0] ).uppercased()))+1
    }
    
    private func getYearInt() -> Int {
        let dateArr = monthNYearTextField.text?.components(separatedBy: "/")
        return Int(dateArr![1])!
    }
    
    private func getInputData() -> NSDictionary {
        let theData = NSMutableDictionary()
        theData.setValue(cardTextfield.text, forKey: kPK_CardNumber)
        theData.setValue(getMonthInt(), forKey: kPK_CardExpMonth)
        theData.setValue(getYearInt(), forKey: kPK_CardExpYear)
        theData.setValue(cvvTextfield.text, forKey: kPK_CardCvv)
        return theData
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
        var theDateFrame = CGRect(x: 0, y: ScreenCons.SCREEN_HEIGHT, width:  ScreenCons.SCREEN_WIDTH, height: 300)
        let theDatePicker = getDatePicker()
        theDatePicker.frame = theDateFrame
        theDatePicker.tag = 44
        appDelegate.window?.addSubview(theDatePicker)
        theDateFrame.origin.y = theDateFrame.origin.y - theDateFrame.size.height
        UIView.animate(withDuration: 0.5) {
            theDatePicker.frame = theDateFrame
        }
    }
    
    func hideDatePicker() {
        let theDatePicker = getDatePicker()
        var theDateFrame =  theDatePicker.frame
        theDateFrame.origin.y = ScreenCons.SCREEN_HEIGHT
        UIView.animate(withDuration: 0.5, animations: {
            theDatePicker.frame = theDateFrame
        }) { (isDone) in
            appDelegate.window?.subviews.filter({$0.tag == 44}).first?.removeFromSuperview()
        }
    }
    
    func isAllFieldValid() -> Bool {
        if (cardTextfield.text?.count)! >= 15 && (cardTextfield.text?.count)! <= 19 {
            cardView.setBorderColor(forType: .normal)
            if (monthNYearTextField.text?.count)! > 0 {
                if (cvvTextfield.text?.count)! == 3  {
                    cvvView.setBorderColor(forType: .normal)
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
            cardView.setBorderColor(forType: .error)
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != monthNYearTextField {
            hideDatePicker()
        }
    }
    
}

//Extension: - LTHMonthYearPickerViewDelegate
extension HSPaymentDetailsController:LTHMonthYearPickerViewDelegate {
    func pickerDidPressDone(withMonth month : String, andYear year : String ) {
        dateView.setBorderColor(forType: .normal)
        monthNYearTextField.text = month + "/" + year
        hideDatePicker()
    }
    
    func pickerDidPressCancel()  {
        hideDatePicker()
    }
}
