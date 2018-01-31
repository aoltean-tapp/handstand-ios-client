//
//  HSPackageSuccessController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 9/7/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
protocol HSPlanConfirmationControllerDelegate {
    func makeBooking(_ payment : String)
}

class HSPackageSuccessController: HSBaseController {

    var plan : HSWorkoutPlan! = nil
    @IBOutlet weak var purchasedInfoLabel: UILabel!
    var delegate : HSPlanConfirmationControllerDelegate! = nil
    var payment:String?
    var requester : UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sessions = Int(plan.sessions) == 1 ? "Session!" : "Sessions!"
        purchasedInfoLabel.text = "You've successfully purchased \(plan.sessions ?? "") \(sessions)"
        HSNavigationBarManager.shared.applyProperties(key: .type_2, viewController: self,titleView: UIImageView.init(image: #imageLiteral(resourceName: "titleHandstandLogo")))
    }
    
    override func didTapBackButton() {
        HSUserManager.shared.trainerRequestAcceptType = nil
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func didTapFindTrainer(_ sender: Any) {
//        self.makeBooking(payment!)
        self.navigationController?.popToRootViewController(animated: false)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notification.findTrainer"), object: nil)
    }
    
    func didTapDismissButton() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func makeBooking(_ payment : String)  {
        let cntrl = delegate as! UIViewController
        if (self.navigationController?.viewControllers.contains(cntrl))! {
            _ = self.navigationController?.popToViewController(cntrl, animated: false)
        }
        else if requester != nil {
            _ = self.navigationController?.popToViewController(requester!, animated: false)
        }
        else{
            _ = self.navigationController?.popViewController(animated: false)
        }
        delegate.makeBooking(payment)
    }
}
