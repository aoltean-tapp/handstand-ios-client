//
//  HSPaymentBeginController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/22/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

protocol HSPaymentBeginProtocol:class {
    func didTapSelectDifferentPlan()
    func didTapCreditCard()
}

class HSPaymentBeginController: HSBaseController {

    //MARK: - iVars
    public weak var delegate:HSPaymentBeginProtocol?
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var packageCaptionLabel: UILabel!
    public var firstPlan:HSFirstPlanListResponse?
    
    @IBOutlet weak var creditCardBtn: UIButton! {
        didSet {
            creditCardBtn.layer.borderWidth = 1
            creditCardBtn.layer.borderColor = UIColor.rgb(0xD6D6D8).cgColor
            creditCardBtn.layer.cornerRadius = 4
        }
    }
    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateSelectedPlanData(plan: self.firstPlan!)
    }
    
    //MARK: - Private functions
    private func populateSelectedPlanData(plan:HSFirstPlanListResponse) {
        priceLabel.text = plan.price
        packageCaptionLabel.text = plan.text
    }

    //MARK: - Button Actions
    @IBAction func didTapSelectDifferentPlan(_ sender: Any) {
        self.delegate?.didTapSelectDifferentPlan()
    }
    @IBAction func didTapCreditCard(_ sender: Any) {
        self.delegate?.didTapCreditCard()
    }
    
}
