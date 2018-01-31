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
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
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
    fileprivate var selectedDate:Date?
    public var selectedPlan:HSFirstPlanListResponse?
    
    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        genderViews = [self.maleView,femaleView,femaleNMaleView]
        self.viewToHighlight(self.maleView)
        HSNavigationBarManager.shared.applyProperties(key: .type_None, viewController: self,titleView:self.getTitleView())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Private functions
    private func addBasicBorderAttributes(_ view:UIView) {
        view.layer.cornerRadius = 4.0
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.rgb(0xD4D4D4).cgColor
    }
    private func viewToHighlight(_ view:UIView) {
        genderViews.forEach { (v) in
            v.layer.cornerRadius = 4
            v.layer.borderWidth = 0.5
            let btn = v.subviews.first as! UIButton
            let m_image = btn.imageView?.image?.withRenderingMode(.alwaysTemplate)
            if v == view {
                v.backgroundColor = UIColor.handstandGreen()
                v.layer.borderColor = UIColor.handstandGreen().cgColor
                
                btn.imageView?.tintColor = UIColor.white
                btn.isSelected = true
            }else {
                v.backgroundColor = UIColor.white
                v.layer.borderColor = UIColor.rgb(0xD4D4D4).cgColor
                
                btn.imageView?.tintColor = UIColor.handstandGreen()
                btn.isSelected = false
            }
            btn.imageView?.image = m_image
        }
    }
    private func getInputData()->Dictionary<String,String>? {
        let selectedBtn = [maleButton,femaleButton,femaleNMaleButton].filter({$0?.isSelected == true}).first as? UIButton
        if let selectedBtnTag = selectedBtn?.tag {
            if let selectdDate = self.selectedDate {
                if (selectdDate.calcAge()>=18) {
                    return ["gender":selectedBtnTag.description,
                            "date_of_birth":selectdDate.getBackendInput()]
                }else {
                    HSUtility.showMessage(string: "Ineligible Date of Birth. You must be atleast 18 years or older.")
                }
            }else {
                HSUtility.showMessage(string: "Please select your Date of Birth")
            }
        }
        return nil
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
        if let inputData = getInputData() {
            HSLoadingView.standardLoading().startLoading()
            HSUserNetworkHandler().saveProfileInfo(profileData: inputData, completionHandler: { [weak self] (isSuccess, error) in
                if isSuccess == true {
                    DispatchQueue.main.async {
                        HSLoadingView.standardLoading().stopLoading()
                        let quizStyleSelectionScreen = HSQuizStyleSelectionController()
                        quizStyleSelectionScreen.selectedPlan = self?.selectedPlan
                        self?.navigationController?.pushViewController(quizStyleSelectionScreen, animated: true)
                    }
                }else{
                    HSLoadingView.standardLoading().stopLoading()
                    HSUtility.showMessage(string: error?.message)
                }
            })
        }
    }
    
    @IBAction func didTapDateOfBirth(_ sender: Any) {
        dateOfBirthPicker.show(inVC: self)
    }
}

//MARK: - Extension:MIDatePickerDelegate
extension HSPersonalInfoController:MIDatePickerDelegate {
    func miDatePicker(amDatePicker: MIDatePicker, didSelect date: Date) {
        selectedDate = date
        let values:(day:Int,month:String,year:Int) = date.getDateComponents()
        self.dayTextField.text = values.day.description
        self.monthTextField.text = values.month
        self.yearTextField.text = values.year.description
    }
    func miDatePickerDidCancelSelection(amDatePicker: MIDatePicker) {
        
    }
}
