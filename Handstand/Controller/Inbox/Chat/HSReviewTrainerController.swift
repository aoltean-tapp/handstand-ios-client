//
//  HSReviewTrainerController.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/16/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import UIKit

class HSReviewTrainerController: HSBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        HSNavigationBarManager.shared.applyProperties(key: .type_21, viewController: self, titleView: getTitleView())
    }
}
