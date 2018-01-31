//
//  HSPackageSuccessController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 9/7/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
protocol HSPlanConfirmationControllerDelegate:class {
    func makeBooking(_ payment : String)
}

class HSPackageSuccessController: HSBaseController {

    var plan : HSWorkoutPlan! = nil
    @IBOutlet weak var purchasedInfoLabel: UILabel!
    weak var delegate : HSPlanConfirmationControllerDelegate?
    var payment:String?
    var requester : UIViewController? = nil
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sessions = Int(plan.span) == 1 ? "Session!" : "Sessions!"
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

    func moveToRootViewController() {
        group.enter()
        self.navigationController?.popToRootViewController(animated: true)
        group.leave()
    }
    @IBAction func didTapFindTrainer(_ sender: Any) {
        moveToRootViewController()
        group.notify(queue: .main) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notification.findTrainer"), object: nil)
        }
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
        delegate?.makeBooking(payment)
    }
}
