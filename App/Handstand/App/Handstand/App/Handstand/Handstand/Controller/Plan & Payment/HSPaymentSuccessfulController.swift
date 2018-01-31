//
//  HSPaymentSuccessfulController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/22/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

protocol HSPaymentSuccessProtocol:class {
    func didTapPaymentSuccess()
}

class HSPaymentSuccessfulController: HSBaseController {

    //MARK: - iVars
    public weak var delegate:HSPaymentSuccessProtocol?
    @IBOutlet weak var continueBtn: UIButton! {
        didSet {
            continueBtn.layer.cornerRadius = 4
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Button Actions
    @IBAction func didTapContinue(_ sender: Any) {
        self.delegate?.didTapPaymentSuccess()
    }
    
}
