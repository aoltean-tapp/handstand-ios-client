//
//  HSWhyHandstandViewController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/19/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSWhyHandstandViewController: HSBaseController {
    
    //MARK: - iVars
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(HSWhyHandstandCell.nib(), forCellReuseIdentifier: HSWhyHandstandCell.reuseIdentifier())
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    @IBOutlet weak var shadowView: UIView! {
        didSet { shadowView.dropShadow() }
    }
    
    @IBOutlet weak var continueButton: UIButton! {
        didSet { continueButton.layer.cornerRadius = 4.0 }
    }
    lazy var paymentBeginController:HSPaymentBeginController = {
        let pb = HSPaymentBeginController()
        pb.delegate = self
        let attributes:(frame:CGSize,cornerRadius:CGFloat,masksToBounds:Bool) = HSWhyHandstandViewController.POPUpViewAttributes()
        pb.view.frame.size = attributes.frame
        pb.view.layer.cornerRadius = attributes.cornerRadius
        pb.view.layer.masksToBounds = attributes.masksToBounds
        return pb}()
    lazy var paymentDetailController:HSPaymentDetailsController = {
        let pd = HSPaymentDetailsController()
        pd.delegate = self
        let attributes:(frame:CGSize,cornerRadius:CGFloat,masksToBounds:Bool) = HSWhyHandstandViewController.POPUpViewAttributes()
        pd.view.frame.size = attributes.frame
        pd.view.layer.cornerRadius = attributes.cornerRadius
        pd.view.layer.masksToBounds = attributes.masksToBounds
        return pd}()
    lazy var paymentSuccessController:HSPaymentSuccessfulController = {
        let ps = HSPaymentSuccessfulController()
        ps.delegate = self
        let attributes:(frame:CGSize,cornerRadius:CGFloat,masksToBounds:Bool) = HSWhyHandstandViewController.POPUpViewAttributes()
        ps.view.frame.size = attributes.frame
        ps.view.layer.cornerRadius = attributes.cornerRadius
        ps.view.layer.masksToBounds = attributes.masksToBounds
        return ps}()
    
    lazy var blurredBgView:UIView = {
        let bv = UIView.init(frame: UIScreen.main.bounds)
        bv.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return bv
    }()
    fileprivate var dataSource:HSWhyHandstandGetResponse?
    public var handpickedQuiz:HSQuizPostResponse?
    public var selectedPlan:HSFirstPlanListResponse?
    var navType:navBarType = .type_0

    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()

        HSNavigationBarManager.shared.applyProperties(key: navType, viewController: self, titleView: getTitleView())
        if self.selectedPlan != nil && HSAppManager.shared.newPlan == false {
            showPaymentsBeginScreen(with: selectedPlan!)
        }else {
            getHandstandQueries()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Class functions
    class func POPUpViewAttributes()->(CGSize,CGFloat,Bool) {
        if ScreenCons.SCREEN_HEIGHT < 600 {
            return (CGSize(width: ScreenCons.SCREEN_WIDTH-(2*20),
                    height: ScreenCons.SCREEN_HEIGHT*0.7),
             4,true)
        }
        return (CGSize(width: ScreenCons.SCREEN_WIDTH-(2*20),
                       height: ScreenCons.SCREEN_HEIGHT*0.5),
                4,true)
    }
    
    //MARK: - Private functions
    fileprivate func getHandstandQueries() {
        continueButton.isHidden = true
        HSLoadingView.standardLoading().startLoading()
        HSPlanQuizDataCenter.init().getWhyHandstandQueries { (result) in
            HSLoadingView.standardLoading().stopLoading()
            switch result {
            case .success(let plans):
                DispatchQueue.main.async {
                    self.continueButton.isHidden = false
                    let response = plans
                    self.dataSource = response
                    self.tableView.reloadData()
                }
                break
            case .failure(let error):
                HSUtility.showMessage(string: error?.message, title: "Error")
                break
            }
        }
    }
    
    private func postHandstandQuery(query:HSWhyHandstandDataMeta) {
        HSLoadingView.standardLoading().startLoading()
        HSPlanQuizDataCenter.init().postWhyHandstandQuery(with: query) { (result) in
            HSLoadingView.standardLoading().stopLoading()
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    let quizResultScreen = HSQuizStyleResultController()
                    quizResultScreen.handpickedQuiz = self.handpickedQuiz
                    self.navigationController?.pushViewController(quizResultScreen, animated: true)
                }
                break
            case .failure(let error):
                HSUtility.showMessage(string: error?.message, title: "Error")
                break
            }
        }
    }
    private func showPaymentsBeginScreen(with plan:HSFirstPlanListResponse) {
        paymentBeginController.firstPlan = plan
        paymentBeginController.view.center = blurredBgView.center
        blurredBgView.addSubview(paymentBeginController.view)
        self.navigationController?.view.addSubview(blurredBgView)
    }
    fileprivate func dismissPaymentsBeginScreen() {
        blurredBgView.removeFromSuperview()
    }
    fileprivate func showPaymentDetailScreen(with plan:HSFirstPlanListResponse) {
        //remove PaymentBegin View
        blurredBgView.subviews.first?.removeFromSuperview()
        paymentDetailController.view.center = blurredBgView.center
        paymentDetailController.selectedPlan = plan
        blurredBgView.addSubview(paymentDetailController.view)
    }
    fileprivate func showPaymentSuccessController() {
        HSAppManager.shared.newPlan = true
        blurredBgView.subviews.first?.removeFromSuperview()
        paymentSuccessController.view.center = blurredBgView.center
        blurredBgView.addSubview(paymentSuccessController.view)
    }
    fileprivate func dismissPaymentDetailScreen() {
        blurredBgView.removeFromSuperview()
    }
    
    //MARK: - Button functions
    @IBAction private func didTapContinue(_ sender: Any) {
        let selectedQueries = self.dataSource?.data.filter({q in q.isSelected == true})
        if (selectedQueries?.count == 0) {
            HSUtility.showMessage(string: "Please pick your reason to install Handstand?", title: AppCons.APPNAME)
        }else {
            let selectedQuery = selectedQueries?.first
            self.postHandstandQuery(query:selectedQuery!)
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension HSWhyHandstandViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.data.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HSWhyHandstandCell.reuseIdentifier()) as! HSWhyHandstandCell
        if let query = self.dataSource?.data[indexPath.row] {
            cell.populate(query: query)
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let copyQueries = self.dataSource?.data,
            let query = self.dataSource?.data[indexPath.row]{
            copyQueries.forEach({ q in
                if query == q {
                    q.isSelected = true
                }else {
                    q.isSelected = false
                }
            })
            self.dataSource?.data = copyQueries
            self.tableView.reloadData()
        }
    }
}

//MARK: - HSPaymentBeginProtocol Delegates
extension HSWhyHandstandViewController:HSPaymentBeginProtocol {
    func didTapSelectDifferentPlan() {
        self.dismissPaymentsBeginScreen()
    }
    func didTapCreditCard() {
        self.showPaymentDetailScreen(with: self.selectedPlan!)
    }
}
//MARK: - HSPaymentDetailsProtocol Delegates
extension HSWhyHandstandViewController:HSPaymentDetailsProtocol {
    func didCompletePayment() {
        self.showPaymentSuccessController()
    }
}
//MARK: - HSPaymentSuccessProtocol Delegates
extension HSWhyHandstandViewController:HSPaymentSuccessProtocol {
    func didTapPaymentSuccess() {
       self.dismissPaymentDetailScreen()
        getHandstandQueries()
    }
}
