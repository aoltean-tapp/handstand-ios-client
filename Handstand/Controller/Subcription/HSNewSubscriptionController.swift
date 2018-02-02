//
//  HSNewSubscriptionController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 1/10/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import UIKit

protocol NewSubscriptionProtocol:class {
    func didCompletePurchase()
}

class HSNewSubscriptionController: UIViewController {

    //MARK: - iVars
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(HSSubscriptionInfoCell.nib(), forCellReuseIdentifier: HSSubscriptionInfoCell.reuseIdentifier())
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    @IBOutlet weak var purchaseButton: UIButton! {
        didSet {
            if HSUserManager.shared.currentUser?.subscribeBefore == false {
                purchaseButton.setTitle("START MY FREE TRIAL NOW", for: .normal)
            }
            purchaseButton.layer.cornerRadius = 4.0
        }
    }
    
    fileprivate var datasource:HSGetNewSubscriptionsResponse?
    lazy var headerView:HSNewSubscriptionHeaderView? = {
        if let view = Bundle.main.loadNibNamed("HSNewSubscriptionHeaderView", owner: nil, options: nil)?.first as? HSNewSubscriptionHeaderView {
            view.frame = CGRect(x:0,y:0,width:ScreenCons.SCREEN_WIDTH,height:HSNewSubscriptionHeaderView.getHeight(with: 0))
            view.delegate = self
            return view
        }
        return nil
    }()
    var requestingForPackageBundle:Bool = false
    public weak var delegate:NewSubscriptionProtocol?

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        headerView?.frame = CGRect(x:0,y:0,width:ScreenCons.SCREEN_WIDTH,height:datasource == nil ? HSNewSubscriptionHeaderView.getHeight(with: 0) : HSNewSubscriptionHeaderView.getHeight(with: (self.datasource?.data?.plans?.count)!))
//    }

    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
//        HSNavigationBarManager.shared.applyProperties(key: .type_None, viewController: self, titleView: self.getTitleView())
        getSubscriptions()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var headerFrame = headerView.frame

            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
            }
        }
    }
    
    //MARK: - Private functions
    private func getSubscriptions() {
        HSLoadingView.standardLoading().startLoading()
        HSUserNetworkHandler().getNewSubscriptionPlansData(forPackageBundle: requestingForPackageBundle) { (result) in
            HSLoadingView.standardLoading().stopLoading()
            switch result {
            case .success(let subscriptions):
                DispatchQueue.main.async {
                    //To Show the first set of plans at Begining State.
                    subscriptions.data?.plans?.first?.isSelected = true
                    self.datasource = subscriptions
                    self.headerView?.dataSource = subscriptions
                    self.tableView.tableHeaderView = self.headerView
                    self.tableView.reloadData()
                    self.tableView.tableHeaderView?.layoutIfNeeded()
                }
                break
            case .failure(let error):
                HSUtility.showMessage(string: error?.message, title: "Error")
                break
            }
        }
    }
    
    private func requestProductsNBuy(with identifier:String) {
        HSLoadingView.standardLoading().startLoading()
        HSAppManager.shared.iapHelper.requestProducts(completionHandler: { (success, products) in
            if success {
                if let products = products {
                    let products = IAPHelper.createIAP_Product(products: products)
                    NotificationCenter.default.removeObserver(self)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.didBuySubscription), name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: nil)
                    
                    let filtered = products.filter({
                        $0.product?.productIdentifier == identifier
                    }).first
                    HSAppManager.shared.handPickedProductIdentifier = identifier
                    HSAppManager.shared.iapHelper.buyProduct((filtered?.product)!)
                }
            }
            else{
                HSLoadingView.standardLoading().stopLoading()
                HSAppManager.shared.handPickedProductIdentifier = nil
                HSUtility.showMessage(string: NSLocalizedString("internal_error", comment: ""))
            }
        })
    }
    
    func didBuySubscription()  {
        if let iapReceipt = HSUtility.getIAP_Receipt() {
            HSUserNetworkHandler().saveIAPRecepit(forReceiptID: iapReceipt , withSubcription: HSAppManager.shared.handPickedProductIdentifier!, completionHandler: {(success, error) in
                HSLoadingView.standardLoading().stopLoading()
                if success {
                    if let handPickedIdentifier = HSAppManager.shared.handPickedProductIdentifier {
                        switch handPickedIdentifier {
                        case nine99ID:
                            HSAnalytics.setEventForTypes(withLog: HSA.nine99Subscribed)
                            break
                        case fourteen99ID:
                            HSAnalytics.setEventForTypes(withLog: HSA.fourteen99Subscribed)
                            break
                        default:
                            break
                        }
                    }
                    HSAppManager.shared.handPickedProductIdentifier = nil
                    HSAppManager.shared.iapReceiptID = nil
                    HSUserManager.shared.hasValidMembership = true
                    self.dismiss(animated: true, completion: {
                        self.delegate?.didCompletePurchase()
                    })
//                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    HSLoadingView.standardLoading().stopLoading()
                    HSUtility.showMessage(string: error?.message)
                }
            })
        }
    }
    
    //MARK: - Button Actions
    @IBAction func didTapPurcahseNow(_ sender: Any) {
        if self.datasource?.data?.plans?.count == 0 {
            HSUtility.showMessage(string: "Sorry! No Subscriptions are available", title: AppCons.APPNAME)
            return
        }
        let selectedPlan = self.datasource?.data?.plans?.filter({ (plan) -> Bool in
            plan.isSelected == true
        }).first
        self.requestProductsNBuy(with: (selectedPlan?.sku)!)
    }
    
    @IBAction func didTapMaybeLater(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Extension|TableViewDelegate&TableViewDataSource
extension HSNewSubscriptionController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if datasource == nil {
            return 0
        }
        let plan = datasource?.data?.plans?.filter({ (plan) -> Bool in
            plan.isSelected == true
        }).first
        return plan?.descriptionValue?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HSSubscriptionInfoCell = tableView.dequeueReusableCell(withIdentifier: HSSubscriptionInfoCell.reuseIdentifier()) as! HSSubscriptionInfoCell!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let plan = datasource?.data?.plans?.filter({ (plan) -> Bool in
            plan.isSelected == true
        }).first
        if let descriptions = plan?.descriptionValue {
            let desc = descriptions[indexPath.row]
            cell.populateInfo(data: desc)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


extension HSNewSubscriptionController:SubscriptionHeaderViewProtocol {
    func didChangePlan() {
        self.tableView.reloadData()
    }
}
