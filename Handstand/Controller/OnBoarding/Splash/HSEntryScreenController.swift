//
//  HSEntryScreenController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/20/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSEntryScreenController: HSBaseController {

    //MARK: - iVars
    @IBOutlet weak var getStartedButton: HSButton! {
        didSet {
            getStartedButton.btnType = .typeC
        }
    }
    @IBOutlet weak var loginButton: HSButton! {
        didSet {
            loginButton.btnType = .typeB
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.handstandGreen()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Button Actions
    @IBAction func didTapGetStarted(_ sender: Any) {
        let planScreen = HSChoosePlanController()
        self.navigationController?.pushViewController(planScreen, animated: true)
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        let loginScreen = HSLoginController()
        navigationController?.pushViewController(loginScreen, animated: true)
    }
    
}
