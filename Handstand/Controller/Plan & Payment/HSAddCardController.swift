//
//  HSAddCardController.swift
//  Handstand
//
//  Created by Fareeth John on 6/28/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSAddCardController: HSBaseController, LTHMonthYearPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet var cvvView: HSBorderView!
    @IBOutlet var dateView: HSBorderView!
    @IBOutlet var cardView: HSBorderView!
//    @IBOutlet var checkImageView: UIImageView!
    @IBOutlet var cvvTextfield: UITextField!
    @IBOutlet var expDateTextfield: UITextField!
    @IBOutlet var cardTextfield: UITextField!
    var datePicker : LTHMonthYearPickerView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - MISC

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
            cardView.setBorderColor(forType: .normal)
            if (expDateTextfield.text?.characters.count)! > 0 {
                if (cvvTextfield.text?.characters.count)! == 3  {
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
        let dateArr = expDateTextfield.text?.components(separatedBy: "/")
        return arr.index(of: ((dateArr![0] ).uppercased()))+1
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

    //MARK:- Textfield delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if textField == cardTextfield {
            cardView.setBorderColor(forType: .normal)
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
            cardView.setBorderColor(forType: .normal)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != expDateTextfield {
            hideDatePicker()
        }
    }
    
    //MARK:- Button Action
    
    @IBAction func onCheckAction(_ sender: UIButton) {
//        checkImageView.isHidden = !checkImageView.isHidden
    }
    
    @IBAction func onSubmitAction(_ sender: HSLoadingButton) {
        if isAllFieldValid() {
            sender.startLoading()
            HSUserNetworkHandler().saveCardWith(data: getInputData(), completionHandler: { (success, error) in
                if success {
                    HSUserNetworkHandler().getUserProfile(completionHandler: { (success, error) in
                        sender.stopLoading()
                        if success {
                            HSUtility.showMessage(string: "Card saved successfully", onUserResponse: { (success) in
                                self.navigationController?.popViewController(animated: true)
                            })
                        }
                        else{
                            HSUtility.showMessage(string: error?.message)
                        }
                    })
                }
                else{
                    sender.stopLoading()
                    HSUtility.showMessage(string: error?.message)
                }
            })
        }
    }
    
    @IBAction func onExpDateAction(_ sender: UIButton) {
        self.view.findFirstResonder()?.resignFirstResponder()
        showDatePicker()
    }
    

}
