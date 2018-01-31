//
//  HSOnboardingServiceValidateIAP.swift
//  Handstand
//
//  Created by Fareeth John on 5/11/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSOnboardingServiceValidateIAP: HSOnboardingService {
    override func start() {
        HSUserNetworkHandler().validateMembership { (success, error) in
            self.delegate.onCompletedService(true, withError: error)
        }
    }
}
