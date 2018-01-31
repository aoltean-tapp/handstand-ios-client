//
//  HSOnboardingServiceProfile.swift
//  Handstand
//
//  Created by Fareeth John on 4/7/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSOnboardingServiceProfile: HSOnboardingService {

    override func start() {
        HSUserNetworkHandler().getUserProfile(completionHandler: { (success, error) in
            self.delegate.onCompletedService(success, withError: error)
        })
    }
    
}
