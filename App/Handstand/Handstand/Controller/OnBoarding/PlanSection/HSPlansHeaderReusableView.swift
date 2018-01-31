//
//  HSPlansHeaderView.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/11/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

//Plan Selected Theme Applier
class HSPlansHeaderBorderView: UIView {
    
    var isSelected:Bool = false {
        didSet {
            if isSelected == true {
                applySelectedPlanView()
            }else {
                applyUnSelectedPlanView()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4
    }
    
    func applySelectedPlanView() {
        self.layer.borderColor = UIColor.handstandGreen().cgColor
    }
    func applyUnSelectedPlanView() {
        self.layer.borderColor = UIColor.rgb(0x8E8E93).cgColor
    }
}

protocol HSPlansHeaderViewProtocol:class {
    func reloadUI()
}

class HSPlansHeaderReusableView: UICollectionReusableView,CellConfigurer {

    public weak var delegate:HSPlansHeaderViewProtocol?
    
    //Content-And-inPerson-Training
    @IBOutlet weak var contentNinPersonTrainingView: HSPlansHeaderBorderView!
    @IBOutlet weak var contentNinPersonTraining30DaysFreeTrailLabel: UILabel!
    @IBOutlet weak var contentNinPersonTrainingPriceLabel: UILabel!
    @IBOutlet weak var contentNinPersonTrainingCaptionLabel: UILabel!
    @IBOutlet weak var contentNinPersonTrainingTopLabel: UILabel!
    @IBOutlet weak var contentNinPersonTrainingReebokTagImageView: UIImageView!
    
    //inPerson-Training
    @IBOutlet weak var nPersonTrainingOnlyView: HSPlansHeaderBorderView!
    @IBOutlet weak var inPersonTrainingOnlyPriceLabel: UILabel!
    @IBOutlet weak var inPersonTrainingOnlyCaptionLabel: UILabel!
    @IBOutlet weak var inPersonTrainingReebokTagImageView: UIImageView!
    
    //content-only
    @IBOutlet weak var contentOnlyView: HSPlansHeaderBorderView!
    @IBOutlet weak var contentOnly30DaysFreeTrailLabel: UILabel!
    @IBOutlet weak var contentOnlyPriceLabel: UILabel!
    @IBOutlet weak var contentOnlyTopBGView: UIView!
    @IBOutlet weak var contentOnlyCaptionLabel: UILabel!
    @IBOutlet weak var contentOnlyReebokTagImageView: UIImageView!
    
    
    private var planListResponse:HSGetPlanListResponse?
    
    //MARK: - Public functions
    public func populatePlansInfo(plan:HSGetPlanListResponse) {
        self.planListResponse = plan
        //contentOnly
        contentOnlyPriceLabel.text = (plan.zerothPlan?.price)! + "\n" + (plan.zerothPlan?.duration)!
        contentOnlyCaptionLabel.text = plan.zerothPlan?.text
        contentOnly30DaysFreeTrailLabel.text = plan.zerothPlan?.planText
        contentOnlyViewSelected(isSelected: (plan.zerothPlan?.isSelected)!)
        contentOnlyReebokTagImageView.isHidden = !(plan.zerothPlan?.reebokActive)!
        
        //inPerson-Training
        inPersonTrainingOnlyPriceLabel.text = (plan.firstPlan?.price)! + "\n" + (plan.firstPlan?.duration)!
        inPersonTrainingOnlyCaptionLabel.text = plan.firstPlan?.text
        inPersonTrainingOnlySelected(isSelected: (plan.firstPlan?.isSelected)!)
        inPersonTrainingReebokTagImageView.isHidden = !(plan.firstPlan?.reebokActive)!
        
        //Content-And-inPerson-Training
        contentNinPersonTraining30DaysFreeTrailLabel.text = plan.secondPlan?.planText
        contentNinPersonTrainingPriceLabel.text = (plan.secondPlan?.price)! + "\n" + (plan.secondPlan?.duration)!
        contentNinPersonTrainingCaptionLabel.text = plan.secondPlan?.text
        contentNInPersonTrainingSelected(isSelected: (plan.secondPlan?.isSelected)!)
        contentNinPersonTrainingReebokTagImageView.isHidden = !(plan.secondPlan?.reebokActive)!
    }
    
    //MARK: - Private functions
    private func contentNInPersonTrainingSelected(isSelected:Bool) {
        contentNinPersonTrainingView.isSelected = isSelected
        contentNinPersonTrainingPriceLabel.textColor = isSelected ? UIColor.handstandGreen() : UIColor.rgb(0x8E8E93)
        contentNinPersonTrainingCaptionLabel.textColor = isSelected ? UIColor.handstandGreen() : UIColor.rgb(0x8E8E93)
        contentNinPersonTrainingTopLabel.textColor = isSelected ? UIColor.handstandGreen() : UIColor.rgb(0x8E8E93)
    }
    private func inPersonTrainingOnlySelected(isSelected:Bool) {
        nPersonTrainingOnlyView.isSelected = isSelected
        inPersonTrainingOnlyPriceLabel.textColor = isSelected ? UIColor.handstandGreen() : UIColor.rgb(0x8E8E93)
        inPersonTrainingOnlyCaptionLabel.textColor = isSelected ? UIColor.handstandGreen() : UIColor.rgb(0x8E8E93)
    }
    
    private func contentOnlyViewSelected(isSelected:Bool) {
        contentOnlyView.isSelected = isSelected
        contentOnlyPriceLabel.textColor = isSelected ? UIColor.handstandGreen() : UIColor.rgb(0x8E8E93)
        contentOnlyTopBGView.backgroundColor = isSelected ? UIColor.handstandGreen() : UIColor.rgb(0x8E8E93)
        contentOnlyCaptionLabel.textColor = isSelected ? UIColor.handstandGreen() : UIColor.rgb(0x8E8E93)
    }
    
    //MARK:- IBActions
    @IBAction func didTapContentOnlyButton(_ sender: Any) {
        self.planListResponse?.zerothPlan?.isSelected = true
        self.planListResponse?.firstPlan?.isSelected = false
        self.planListResponse?.secondPlan?.isSelected = false
        
        contentOnlyViewSelected(isSelected: true)
        contentNInPersonTrainingSelected(isSelected: false)
        inPersonTrainingOnlySelected(isSelected:false)
        
        self.delegate?.reloadUI()
    }
    
    @IBAction func didTapInPersonTrainingOnly(_ sender: Any) {
        self.planListResponse?.zerothPlan?.isSelected = false
        self.planListResponse?.firstPlan?.isSelected = true
        self.planListResponse?.secondPlan?.isSelected = false
        
        contentOnlyViewSelected(isSelected: false)
        inPersonTrainingOnlySelected(isSelected:true)
        contentNInPersonTrainingSelected(isSelected: false)
        
        self.delegate?.reloadUI()
    }
    
    @IBAction func didTapContentNInPersonTraining(_ sender: Any) {
        self.planListResponse?.zerothPlan?.isSelected = false
        self.planListResponse?.firstPlan?.isSelected = false
        self.planListResponse?.secondPlan?.isSelected = true

        contentOnlyViewSelected(isSelected: false)
        contentNInPersonTrainingSelected(isSelected: true)
        inPersonTrainingOnlySelected(isSelected:false)
        
        self.delegate?.reloadUI()
    }
    
    class public func getHeight()->CGFloat {
        return 250
    }
}

