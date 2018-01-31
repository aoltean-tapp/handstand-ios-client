//
//  HSChoosePlanController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/21/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSChoosePlanController: HSBaseController {
    
    //MARK: - iVars
    lazy var paymentBeginController:HSPaymentBeginController = {
        let pb = HSPaymentBeginController()
        pb.delegate = self
        pb.view.frame.size = CGSize(width: ScreenCons.SCREEN_WIDTH-(2*20), height: ScreenCons.SCREEN_HEIGHT*0.6)
        pb.view.layer.cornerRadius = 4
        pb.view.layer.masksToBounds = true
        return pb}()
    lazy var paymentDetailController:HSPaymentDetailsController = {
        let pd = HSPaymentDetailsController()
        pd.delegate = self
        pd.view.frame.size = CGSize(width: ScreenCons.SCREEN_WIDTH-(2*20), height: ScreenCons.SCREEN_HEIGHT*0.6)
        pd.view.layer.cornerRadius = 4
        pd.view.layer.masksToBounds = true
        return pd}()
    lazy var paymentSuccessController:HSPaymentSuccessfulController = {
        let ps = HSPaymentSuccessfulController()
        ps.delegate = self
        ps.view.frame.size = CGSize(width: ScreenCons.SCREEN_WIDTH-(2*20), height: ScreenCons.SCREEN_HEIGHT*0.6)
        ps.view.layer.cornerRadius = 4
        return ps}()
    
    lazy var blurredBgView:UIView = {
        let bv = UIView.init(frame: UIScreen.main.bounds)
        bv.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return bv
    }()
    
    @IBOutlet weak var collectionview: UICollectionView! {
        didSet {
            collectionview.showsVerticalScrollIndicator = false
            collectionview.delegate = self
            collectionview.dataSource = self
            
            collectionview.register(HSPlansHeaderReusableView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HSPlansHeaderReusableView.reuseIdentifier())
            
            collectionview.register(HSPlansHeaderTitleReusableView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HSPlansHeaderTitleReusableView.reuseIdentifier())
            
            collectionview.register(HSChoosePlanCVCell.nib(), forCellWithReuseIdentifier: HSChoosePlanCVCell.reuseIdentifier())
        }
    }
    @IBOutlet weak var subscribeButton: HSButton! {
        didSet {
            subscribeButton.btnType = .typeD
        }
    }
    fileprivate var dataSource:HSGetPlanListResponse?
    
    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        HSNavigationBarManager.shared.applyProperties(key: .type_0, viewController: self, titleView: getTitleView())
        getPlans()
    }
    
    //MARK: - Private functions
    func getPlans() {
        subscribeButton.isHidden = true
        HSLoadingView.standardLoading().startLoading()
        HSPlanQuizDataCenter.init().getPlans { (result) in
            switch result {
            case .success(let plans):
                DispatchQueue.main.async {
                    self.subscribeButton.isHidden = false
                    HSLoadingView.standardLoading().stopLoading()
                    let response = plans
                    self.dataSource = response
                    self.collectionview.reloadData()
                }
                break
            case .failure(let error):
                HSLoadingView.standardLoading().stopLoading()
                HSUtility.showMessage(string: error?.message, title: "Error")
                break
            }
        }
    }
    
    //MARK: - Button Actions
    @IBAction func didTapSubscribeButton(_ sender: Any) {
        if let zerothPlan = dataSource?.zerothPlan,
            let secondPlan = dataSource?.secondPlan,
            let firstPlan = dataSource?.firstPlan{
            if zerothPlan.isSelected || secondPlan.isSelected {
                //Subscription
                if zerothPlan.isSelected == true {
                    
                }else {
                    //second one
                }
            }else {
                showPaymentsBeginScreen(with: firstPlan)
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
    fileprivate func showPaymentDetailScreen() {
        //remove PaymentBegin View
        blurredBgView.subviews.first?.removeFromSuperview()
        paymentDetailController.view.center = blurredBgView.center
        blurredBgView.addSubview(paymentDetailController.view)
    }
    fileprivate func showPaymentSuccessController() {
        blurredBgView.subviews.first?.removeFromSuperview()
        paymentSuccessController.view.center = blurredBgView.center
        blurredBgView.addSubview(paymentSuccessController.view)
    }
    private func dismissPaymentDetailScreen() {
        blurredBgView.removeFromSuperview()
    }
    
}

//MARK: - Extension:UICollectionViewDelegate|UICollectionViewDataSource
extension HSChoosePlanController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let v = (self.dataSource?.getPlanDetailsCount() ?? 0) / 3
        return v+1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Static 3Rows
        return section == 0 ? 0 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HSChoosePlanCVCell.reuseIdentifier(), for: indexPath) as? HSChoosePlanCVCell else {return UICollectionViewCell()}
        if indexPath.section > 0{
            let section = indexPath.section - 1
            if indexPath.row == 0 {
                let plan = self.dataSource?.getPlan(with: indexPath.row)
                let planDetail = (plan?.planDetails![section])
                if let detail = planDetail {
                    let value = detail.value
                    if plan?.isSelected == true {
                        cell._imageView.image = value ? #imageLiteral(resourceName: "icPlansCheckMark") : #imageLiteral(resourceName: "icPlansCrossActive")
                    }else {
                        cell._imageView.image = value ? #imageLiteral(resourceName: "icPlansUnCheckMark") : #imageLiteral(resourceName: "icPlansCrossInActive")
                    }
                }
            }else if indexPath.row == 1 {
                let plan = self.dataSource?.getPlan(with: indexPath.row)
                let planDetail = (plan?.planDetails![section])
                if let detail = planDetail {
                    let value = detail.value
                    if plan?.isSelected == true {
                        cell._imageView.image = value ? #imageLiteral(resourceName: "icPlansCheckMark") : #imageLiteral(resourceName: "icPlansCrossActive")
                    }else {
                        cell._imageView.image = value ? #imageLiteral(resourceName: "icPlansUnCheckMark") : #imageLiteral(resourceName: "icPlansCrossInActive")
                    }
                }
            }else {
                let plan = self.dataSource?.getPlan(with: indexPath.row)
                let planDetail = (plan?.planDetails![section])
                if let detail = planDetail {
                    let value = detail.value
                    if plan?.isSelected == true {
                        cell._imageView.image = value ? #imageLiteral(resourceName: "icPlansCheckMark") : #imageLiteral(resourceName: "icPlansCrossActive")
                    }else {
                        cell._imageView.image = value ? #imageLiteral(resourceName: "icPlansUnCheckMark") : #imageLiteral(resourceName: "icPlansCrossInActive")
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if self.dataSource == nil {
            return UICollectionReusableView()
        }
        if indexPath.section == 0 {
            let headerView = (collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HSPlansHeaderReusableView.reuseIdentifier(), for: indexPath) as! HSPlansHeaderReusableView)
            headerView.delegate = self
            if let dataSource = self.dataSource {
                headerView.populatePlansInfo(plan: dataSource)
            }
            return headerView
        }else {
            let headerView = (collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HSPlansHeaderTitleReusableView.reuseIdentifier(), for: indexPath) as! HSPlansHeaderTitleReusableView)
            if indexPath.section > 0{
                let section = indexPath.section - 1
                let plan = self.dataSource?.getPlan(with: indexPath.row)
                let planDetail = (plan?.planDetails![section])
                headerView.populatePlansTitle(title:(planDetail?.text)!)
            }
            return headerView
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width-4)/3
        return CGSize(width: itemSize, height: HSChoosePlanCVCell.getHeight())
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.dataSource != nil {
            if section == 0 {
                return CGSize(width: collectionView.frame.width, height: HSPlansHeaderReusableView.getHeight())
            }else {
                let indexPath = IndexPath.init(row: 0, section: section)
                let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionElementKindSectionHeader, at: indexPath) as! HSPlansHeaderTitleReusableView
                
                return CGSize(width: collectionView.frame.width, height: headerView.getHeight())
            }
        }
        return CGSize(width:0,height:0)
    }
}

//MARK: - HSPlansHeaderViewProtocol Delegates
extension HSChoosePlanController:HSPlansHeaderViewProtocol {
    func reloadUI() {
        self.collectionview.reloadData()
    }
}
//MARK: - HSPaymentBeginProtocol Delegates
extension HSChoosePlanController:HSPaymentBeginProtocol {
    func didTapSelectDifferentPlan() {
        self.dismissPaymentsBeginScreen()
    }
    func didTapCreditCard() {
        self.showPaymentDetailScreen()
    }
}
//MARK: - HSPaymentDetailsProtocol Delegates
extension HSChoosePlanController:HSPaymentDetailsProtocol {
    func didCompletePayment() {
        self.showPaymentSuccessController()
    }
}
//MARK: - HSPaymentSuccessProtocol Delegates
extension HSChoosePlanController:HSPaymentSuccessProtocol {
    func didTapPaymentSuccess() {
        
    }
}
