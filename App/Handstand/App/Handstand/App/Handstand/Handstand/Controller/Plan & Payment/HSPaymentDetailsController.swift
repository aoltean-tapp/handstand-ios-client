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

class HSPaymentDetailsController: HSBaseController {

    //MARK: - iVars
    public weak var delegate:HSPaymentDetailsProtocol?
    @IBOutlet weak var payButton: UIButton! {
        didSet {
          payButton.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    
    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Button Actions
    @IBAction func didTapPay(_ sender: Any) {
        self.delegate?.didCompletePayment()
    }
}
