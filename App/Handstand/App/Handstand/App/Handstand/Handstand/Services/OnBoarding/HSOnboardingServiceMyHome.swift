//
//  HSOnboardingServiceMyHome.swift
//  Handstand
//
//  Created by Fareeth John on 5/5/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSOnboardingServiceMyHome: HSOnboardingService {
    override func start() {
        HSUserNetworkHandler().getMyHomeInfo { (success, error) in
            self.delegate.onCompletedService(true, withError: error)
        }
    }
}
