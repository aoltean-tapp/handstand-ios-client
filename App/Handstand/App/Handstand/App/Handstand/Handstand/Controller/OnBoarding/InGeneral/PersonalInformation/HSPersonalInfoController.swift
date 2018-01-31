//
//  HSPersonalInfoController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/20/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSPersonalInfoController: HSBaseController {
    
    //MARK: - iVars
    @IBOutlet weak var InfoBaseView: UIView! {
        didSet {
            InfoBaseView.layer.cornerRadius = 4.0
            InfoBaseView.dropShadow()
        }
    }
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var femaleNMaleView: UIView!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var femaleNMaleButton: UIButton!
    
    @IBOutlet weak var monthBgView: UIView! {
        didSet {
            addBasicBorderAttributes(monthBgView)
        }
    }
    @IBOutlet weak var dayBgView: UIView! {
        didSet {
            addBasicBorderAttributes(dayBgView)
        }
    }
    @IBOutlet weak var yearBgView: UIView! {
        didSet {
            addBasicBorderAttributes(yearBgView)
        }
    }
    @IBOutlet weak var monthTextField: UITextField! {
        didSet {
            monthTextField.delegate = self
        }
    }
    @IBOutlet weak var dayTextField: UITextField! {
        didSet {
            dayTextField.delegate = self
        }
    }
    @IBOutlet weak var yearTextField: UITextField! {
        didSet {
            dayTextField.delegate = self
        }
    }
    
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 4.0
        }
    }
    lazy var dateOfBirthPicker:MIDatePicker = {
        let datePicker = MIDatePicker.getFromNib()
        datePicker.delegate = self
        
        datePicker.config.startDate = Date()
        datePicker.config.maximumDate = Date()
        datePicker.config.animationDuration = 0.5
        
        datePicker.config.cancelButtonTitle = "Cancel"
        datePicker.config.confirmButtonTitle = "Confirm"
        
        datePicker.config.contentBackgroundColor = UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
        datePicker.config.headerBackgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        datePicker.config.confirmButtonColor = UIColor(red: 32/255.0, green: 146/255.0, blue: 227/255.0, alpha: 1)
        datePicker.config.cancelButtonColor = UIColor(red: 32/255.0, green: 146/255.0, blue: 227/255.0, alpha: 1)
        return datePicker
    }()
    
    lazy var genderViews:[UIView] = Array<UIView>()
    
    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        genderViews = [self.maleView,femaleView,femaleNMaleView]
        self.viewToHighlight(self.maleView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Private functions
    private func addBasicBorderAttributes(_ view:UIView) {
        view.layer.cornerRadius = 4.0
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rgb(0xD6D6D8).cgColor
    }
    private func viewToHighlight(_ view:UIView) {
        genderViews.forEach { (v) in
            v.layer.cornerRadius = 4
            v.layer.borderWidth = 1
            let btn = v.subviews.first as! UIButton
            let m_image = btn.imageView?.image?.withRenderingMode(.alwaysTemplate)
            if v == view {
                v.backgroundColor = UIColor.handstandGreen()
                v.layer.borderColor = UIColor.handstandGreen().cgColor
                
                btn.imageView?.tintColor = UIColor.white
            }else {
                v.backgroundColor = UIColor.white
                v.layer.borderColor = UIColor.rgb(0xD6D6D8).cgColor
                
                btn.imageView?.tintColor = UIColor.handstandGreen()
            }
            btn.imageView?.image = m_image
        }
    }
    
    //MARK: - Button Actions
    @IBAction func didTapMaleBtn(_ sender: UIButton) {
        self.viewToHighlight(self.maleView)
    }
    @IBAction func didTapFemaleBtn(_ sender: UIButton) {
        self.viewToHighlight(self.femaleView)
    }
    @IBAction func didTapFemaleNMaleBtn(_ sender: UIButton) {
        self.viewToHighlight(self.femaleNMaleView)
    }
    
    @IBAction func didTapNextBtn(_ sender: Any) {
    }
    
}

extension HSPersonalInfoController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == monthTextField || textField == yearTextField || textField == dayTextField {
            textField.resignFirstResponder()
            dateOfBirthPicker.show(inVC: self)
        }
    }
}

extension HSPersonalInfoController:MIDatePickerDelegate {
    func miDatePicker(amDatePicker: MIDatePicker, didSelect date: Date) {
        let values:(day:Int,month:String,year:Int) = date.getDateComponents()
        self.dayTextField.text = values.day.description
        self.monthTextField.text = values.month
        self.yearTextField.text = values.year.description
    }
    func miDatePickerDidCancelSelection(amDatePicker: MIDatePicker) {
        
    }
}

extension Date {
     func getDateComponents() -> (Int,String,Int) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        return (day,getReadableMonth(with:month),year)
    }
    
    private func getReadableMonth(with index:Int)->String {
        return ["January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December"][index - 1]
    }

}
