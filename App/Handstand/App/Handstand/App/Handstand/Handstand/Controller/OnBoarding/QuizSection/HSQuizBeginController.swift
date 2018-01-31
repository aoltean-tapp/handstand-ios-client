//
//  HSQuizBeginController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/11/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSQuizBeginController: HSBaseController {

    @IBOutlet weak var getStartedButton: HSButton!{
        didSet {
            getStartedButton.btnType = .typeD
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HSNavigationBarManager.shared.applyProperties(key: .type_0, viewController: self,titleView:self.getTitleView())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Button Actions
    @IBAction func didTapGetStarted(_ sender: Any) {
        let quizSelectionScreen = HSQuizStyleSelectionController()
        self.navigationController?.pushViewController(quizSelectionScreen, animated: true)
    }
    
}
