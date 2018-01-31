//
//  HSOnboardingServiceSaveIAP.swift
//  Handstand
//
//  Created by Fareeth John on 5/11/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSOnboardingServiceSaveIAP: HSOnboardingService {
    override func start() {
        HSUserNetworkHandler().saveIAPRecepit(forReceiptID: HSAppManager.shared.iapReceiptID!, withSubcription: HSAppManager.shared.handPickedProductIdentifier!, completionHandler: {(success, error) in
            self.delegate.onCompletedService(success, withError: error)
        })
    }
}
