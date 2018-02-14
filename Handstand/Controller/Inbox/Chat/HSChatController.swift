//
//  HSChatController.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/12/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import UIKit

class HSChatController: HSBaseController {

    @IBOutlet weak var trainerNameLabel: UILabel!
    @IBOutlet weak var sessionDateLabel: UILabel!
    @IBOutlet weak var sessionStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HSNavigationBarManager.shared.applyProperties(key: .type_21, viewController: self, titleView: getTitleView())
    }
}
