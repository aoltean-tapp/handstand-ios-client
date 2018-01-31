//
//  HSOnboardingServiceVideo.swift
//  Handstand
//
//  Created by Fareeth John on 4/7/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSOnboardingServiceVideo: HSOnboardingService {

    override func start() {
        HSVideoNetworkHandler().getDailyVideo { (video, error) in
            self.delegate.onCompletedService(true, withError: error)
        }
    }

}
