//
//  HSFavoritesController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/23/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSFavoritesController: HSBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        HSNavigationBarManager.shared.applyProperties(key: .type_5, viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
