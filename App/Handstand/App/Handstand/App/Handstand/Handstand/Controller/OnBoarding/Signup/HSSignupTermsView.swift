//
//  HSSignupTermsView.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/5/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

protocol SignupTermsViewDelegate:class {
    func didTapTermsAndCons(link:String)
}

class HSSignupTermsView: UIView,UGLinkLabelDelegate {

    public weak var delegate:SignupTermsViewDelegate?
    @IBOutlet var termsCheck: UIImageView!
    @IBOutlet var policyCheck: UIImageView!
    @IBOutlet var policyLabel: UGLinkLabel!
    @IBOutlet var termsLabel: UGLinkLabel!

    @IBAction func onTermsAction(_ sender: UIButton) {
        termsCheck.isHidden = !termsCheck.isHidden
    }
    
    @IBAction func onPolicyAction(_ sender: UIButton) {
        policyCheck.isHidden = !policyCheck.isHidden
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func buildPolicyLabelData() {
        let termsValue = NSDictionary(object: "https://handstandapp.com/pages/terms-and-conditions", forKey: "<tc>" as NSCopying)
        termsLabel.buildLinkView(from: NSLocalizedString("terms_Info", comment: ""), forLinks: termsValue as [NSObject : AnyObject])
        
        let linkValue = NSDictionary(object: "http://www.reebok.com/us/customer_service/privacy-policy.php", forKey: "<pp>" as NSCopying)
        policyLabel.buildLinkView(from: NSLocalizedString("policy_Info", comment: ""), forLinks: linkValue as [NSObject : AnyObject])
    }

    //MARK:- Link Label Delegate
    func didClicked(onLink link : String)  {
       self.delegate?.didTapTermsAndCons(link: link)
    }
    
    public class func getHeight()->CGFloat {
        return 170
    }
}
