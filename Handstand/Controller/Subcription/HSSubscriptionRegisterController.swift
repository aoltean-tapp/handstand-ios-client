//
//  HSSubscriptionRegisterController.swift
//  Handstand
//
//  Created by science on 8/4/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
import StoreKit
import Alamofire

protocol SubscriptionRegisterProtocol:class {
    func closeSubscriptionRegisterScene()
}

class HSSubscriptionRegisterController: HSBaseController {
    
    @IBOutlet weak var readyToTrainLabel: UILabel! {
        didSet {
            readyToTrainLabel.text = "Ready to train your mind, body and\n soul with daily video, audio and\n personalized fitness plans?"
        }
    }
    @IBOutlet weak var closeImge: UIImageView! {
        didSet {
            closeImge.image = closeImge.image!.withRenderingMode(.alwaysTemplate)
            closeImge.tintColor = UIColor.rgb(0x484848)
        }
    }
    public weak var delegate:SubscriptionRegisterProtocol?
    var isIAPCallSet = false
    var iapReceipt : String! = nil
    var purchasedProduct: SKProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Button Actions
    @IBAction func onCloseAction(_ sender: UIButton) {
        self.delegate?.closeSubscriptionRegisterScene()
    }
    
    @IBAction func didTapStartTrail(_ sender: Any) {
        HSLoadingView.standardLoading().startLoading()
        HSAppManager.shared.iapHelper.requestProducts(completionHandler: { (success, products) in
            if success {
                if self.iapReceipt != nil {
                    self.showNextScreen()
                    return
                }
                if self.isIAPCallSet == false {
                    NotificationCenter.default.removeObserver(self)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.showNextScreen), name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: nil)
                }
                let filtered = products?.filter({
                    $0.productIdentifier == trialSubID
                })
                self.purchasedProduct = filtered?.first
                HSAppManager.shared.handPickedProductIdentifier = self.purchasedProduct?.productIdentifier
                HSAppManager.shared.iapHelper.buyProduct(self.purchasedProduct!)
            }else {
                HSLoadingView.standardLoading().stopLoading()
                HSUtility.showMessage(string: NSLocalizedString("network_error", comment: ""), title: "Handstand")
            }
        })
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func showNextScreen()  {
        let iapReceipt = HSUtility.getIAP_Receipt()!
        HSUserNetworkHandler().saveIAPRecepit(forReceiptID: iapReceipt , withSubcription:  HSAppManager.shared.handPickedProductIdentifier!, completionHandler: {(success, error) in
            if success {
                HSUserManager.shared.hasValidMembership = true
                HSUserNetworkHandler().getUserProfile(completionHandler: { (success, error) in
                    HSLoadingView.standardLoading().stopLoading()
                    self.delegate?.closeSubscriptionRegisterScene()
                })
            }
            else{
                HSLoadingView.standardLoading().stopLoading()
                HSUtility.showMessage(string: error?.message)
            }
        })
    }
}

//                HSUserNetworkHandler().validateMembership { (success, error) in
//                    if success == true {
//
//                    }else {
//                        HSLoadingView.standardLoading().stopLoading()
//                        HSUtility.showMessage(string: NSLocalizedString("internal_error", comment: ""), title: "Handstand")
//                    }
//                }
