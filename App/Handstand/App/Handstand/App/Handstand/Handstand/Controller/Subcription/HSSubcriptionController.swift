//
//  HSSubcriptionController.swift
//  Handstand
//
//  Created by Fareeth John on 5/11/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
import SafariServices
import ReachabilitySwift

protocol HSSubcriptionControllerDelegate {
    func closeSubscriptionScene()
}

extension HSSubcriptionControllerDelegate {
    func closeSubscriptionScene() {}
}

class HSSubcriptionController: HSBaseController {
    
    @IBOutlet var plan3TitleLabel: UILabel!
    @IBOutlet var plan2TitleLabel: UILabel!
    @IBOutlet var plan1TitleLabel: UILabel!
    @IBOutlet weak var noLongerSubsCaptionLabel: UILabel! {
        didSet {
            noLongerSubsCaptionLabel.text = "Your subscription is no longer active. \nIn order to view daily videos and\n access other premium services, you \nwill need to subscribe."
        }
    }
    @IBOutlet weak var closeImge: UIImageView! {
        didSet {
            closeImge.image = closeImge.image!.withRenderingMode(.alwaysTemplate)
            closeImge.tintColor = UIColor.rgb(0x484848)
        }
    }
    
    var products : Array<HSIAPProduct>! = []
    var isIAPCallSet = false
    var delegate : HSSubcriptionControllerDelegate? = nil
    var iapReceipt : String! = nil
    var purchasedProduct: HSIAPProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- MISC
    func updateUI(){
        if self.products.count>0 {
            return
        }
        HSLoadingView.standardLoading().startLoading()
        HSAppManager.shared.iapHelper.requestProducts(completionHandler: { (success, products) in
            HSLoadingView.standardLoading().stopLoading()
            if success {
                if let products = products {
                    self.products = IAPHelper.createIAP_Product(products: products)
                    
                    let filtered = products.filter({
                        $0.productIdentifier == yearlySubID
                    })
                    let plan1String = "~" + (IAPHelper.createIAP_Product(products:[filtered.first!]).first?.weeklyPrice!)! + "\n/week"
                    let weeklyCaption = "\nYearly"
                    self.plan1TitleLabel.attributedText = self.attributedString(from: plan1String+weeklyCaption, range: NSMakeRange(0, plan1String.count))
                    
                    let filteredMonthlyProducts = products.filter({
                        $0.productIdentifier == monthlySubID
                    })
                    let plan2String = "~" + (IAPHelper.createIAP_Product(products:[filteredMonthlyProducts.first!]).first?.weeklyPrice!)! + "\n/week"
                    let yearlyCaption = "\nMonthly"
                    self.plan2TitleLabel.attributedText = self.attributedString(from: plan2String+yearlyCaption, range: NSMakeRange(0, plan2String.count))
                    
                    let filteredWeeklyProducts = products.filter({
                        $0.productIdentifier == trialSubID
                    })
                    let plan3String = "~" + (IAPHelper.createIAP_Product(products:[filteredWeeklyProducts.first!]).first?.weeklyPrice!)! + "\n/week"
                    self.plan3TitleLabel.attributedText = self.attributedString(from: plan3String+"\nWeekly", range: NSMakeRange(0, plan3String.count))
                }
            }
            else{
                HSUtility.showMessage(string: NSLocalizedString("internal_error", comment: ""))
            }
        })
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func showNextScreen()  {
        if let iapReceipt = HSUtility.getIAP_Receipt() {
            HSUserNetworkHandler().saveIAPRecepit(forReceiptID: iapReceipt , withSubcription: HSAppManager.shared.handPickedProductIdentifier!, completionHandler: {(success, error) in
                if success {
                    if let handPickedIdentifier = HSAppManager.shared.handPickedProductIdentifier {
                        switch handPickedIdentifier {
                        case trialSubID:
                            HSAnalytics.setEventForTypes(withLog: HSA.weeklySubscribed)
                            break
                        case monthlySubID:
                            HSAnalytics.setEventForTypes(withLog: HSA.monthlySubscribed)
                            break
                        case yearlySubID:
                            HSAnalytics.setEventForTypes(withLog: HSA.yearlySubscribed)
                            break
                        default:
                            break
                        }
                    }
                    HSAppManager.shared.handPickedProductIdentifier = nil
                    HSAppManager.shared.iapReceiptID = nil
                    HSUserManager.shared.hasValidMembership = true
                    HSUserNetworkHandler().getUserProfile(completionHandler: { (success, error) in
                        HSLoadingView.standardLoading().stopLoading()
                        self.delegate?.closeSubscriptionScene()
                    })
                }
                else{
                    HSLoadingView.standardLoading().stopLoading()
                    HSUtility.showMessage(string: error?.message)
                }
            })
        }
    }
    
    func showLink(_ link : String)  {
        let URL = NSURL(string: link)!
        if #available(iOS 9.0, *) {
            let cntrl = SFSafariViewController(url: URL as URL)
            self.present(cntrl, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(URL as URL)
        }
    }
    
    // MARK: - Button Action
    
    @IBAction func onCloseAction(_ sender: UIButton) {
        self.delegate?.closeSubscriptionScene()
    }
    
    @IBAction func onSubscriptionInfoAction(_ sender: UIButton) {
        showLink(iapSubscriptionInfoLink)
    }
    
    @IBAction func onPrivacyAction(_ sender: UIButton) {
        showLink(iapPrivacyLink)
    }
    
    @IBAction func didClickedOnPlan(_ sender: UIButton) {
        let reachability = Reachability()!
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                self.buyProduct(sender:sender)
            }
        }
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                HSUtility.showMessage(string: NSLocalizedString("network_error", comment: ""), title: "Handstand")
            }
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func buyProduct(sender:UIButton) {
        if iapReceipt != nil {
            showNextScreen()
            return
        }
        if isIAPCallSet == false {
            NotificationCenter.default.removeObserver(self)
            NotificationCenter.default.addObserver(self, selector: #selector(self.showNextScreen), name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: nil)
        }
        HSLoadingView.standardLoading().startLoading()
        switch sender.tag {
        case 0:
            HSAnalytics.setEventForTypes(withLog: HSA.subscriptionClickMonthly)
            HSAppManager.shared.handPickedProductIdentifier = monthlySubID
            break
        case 1:
            HSAnalytics.setEventForTypes(withLog: HSA.subscriptionClickYearly)
            HSAppManager.shared.handPickedProductIdentifier = yearlySubID
            break
        case 2:
            HSAnalytics.setEventForTypes(withLog: HSA.subscriptionClickWeekly)
            HSAppManager.shared.handPickedProductIdentifier = trialSubID
            break
        default:
            break
        }
        let finalProduct = products.filter({
            $0.product?.productIdentifier == HSAppManager.shared.handPickedProductIdentifier
        })
        purchasedProduct = finalProduct.first
        HSAppManager.shared.iapHelper.buyProduct((purchasedProduct?.product)!)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- Private functions
    private func attributedString(from string: String, range: NSRange?) -> NSAttributedString {
        let boldAttribute = [
            NSFontAttributeName:UIFont.boldSystemFont(ofSize: 15)
        ]
        let regularAttribute = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 10)
        ]
        let attrStr = NSMutableAttributedString(string: string, attributes: regularAttribute)
        
        attrStr.setAttributes(boldAttribute, range: range!)
        return attrStr
    }
    
}
