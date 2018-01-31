//
//  HSWorkoutPlanController.swift
//  Handstand
//
//  Created by Fareeth John on 5/2/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

protocol HSWorkoutPlanControllerDelegate:class {
    func makeBooking(_ payment : String)
}

class HSWorkoutPlanController: HSBaseController {

    @IBOutlet var tableView: UITableView!
    let cellIdentifier = "planCell"
    var plans : Array<HSWorkoutPlan>! = []
    weak var delegate : HSWorkoutPlanControllerDelegate?
    var requester : UIViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = HSA.packageSelectionScreen
        tableView.register(UINib(nibName: "HSWorkoutPlanCell", bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        HSNavigationBarManager.shared.applyProperties(key: .type_3, viewController: self)
    }
    
    func didTapDismissButton() {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - Tableview delegate
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        return plans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:HSWorkoutPlanCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! HSWorkoutPlanCell!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let thePlan = plans[indexPath.row]
        cell.titleLabel.text = thePlan.name
        cell.infoLabel.text = "$"+thePlan.price
        if thePlan.best_value == "1" {
            cell.bestValueLabel.isHidden = false
        }else{
            cell.bestValueLabel.isHidden = true
        }
        cell.rebookTagImageView.isHidden = !thePlan.reebok_active
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let thePlan  = plans[indexPath.row]
        //Business Logic:
        //People who bought $14.99 Subscription they can buy 5 or 10 session
        //And people who bought $9.99 Subsription, here we are indirectly encourage him to go for $14.99 Subscription, Instead of going for Session purhcase
        if thePlan.purchase == false {
            let newSubscriptionScreen = HSNewSubscriptionController()
            newSubscriptionScreen.requestingForPackageBundle = true
            newSubscriptionScreen.delegate = self
            self.present(newSubscriptionScreen, animated: true, completion: nil)
        }else {
            let planCnfrmCntrl = HSPlanConfirmationController()
            planCnfrmCntrl.plan = thePlan
            planCnfrmCntrl.delegate = delegate as? HSPlanConfirmationControllerDelegate
            planCnfrmCntrl.requester = requester
            switch thePlan.span {
            case "1":
                planCnfrmCntrl.screenNameEString = HSA.package1Screen
                planCnfrmCntrl.bookingConfrmEString = HSA.package1
                break
            case "5":
                planCnfrmCntrl.screenNameEString = HSA.package5Screen
                planCnfrmCntrl.bookingConfrmEString = HSA.package5
                break
            case "10":
                planCnfrmCntrl.screenNameEString = HSA.package10Screen
                planCnfrmCntrl.bookingConfrmEString = HSA.package10
            default:
                break
            }
            self.navigationController?.pushViewController(planCnfrmCntrl, animated: true)
        }
    }
    
    //MARK:- Button Action
    
    @IBAction func onBackAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }

}

extension HSWorkoutPlanController:NewSubscriptionProtocol {
    func didCompletePurchase() {
        HSLoadingView.standardLoading().startLoading()
        HSPassportNetworkHandler().getPackages({ (plans, error) in
            HSLoadingView.standardLoading().stopLoading()
            if error == nil {
                DispatchQueue.main.async {
                    self.plans = plans
                    self.tableView.reloadData()
                }
            }
            else{
                HSUtility.showMessage(string: (error?.message)!)
            }
        })
    }
}

