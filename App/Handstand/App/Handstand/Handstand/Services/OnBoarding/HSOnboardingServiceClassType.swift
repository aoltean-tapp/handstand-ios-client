//
//  HSOnboardingServiceClassType.swift
//  Handstand
//
//  Created by Fareeth John on 4/20/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSOnboardingServiceClassType: HSOnboardingService {
    override func start() {
        HSSystemNetworkHandler().fetchSystemVersion { (success, error) in
            if error?.code == eErrorType.invalidAppVersion {
                self.delegate.onCompletedService(success!, withError: error)
            }
            else{
                if error?.code == eErrorType.updateAppVersion {
                    HSApp().alertUserToDownloadNewVersion((error?.message)!)
                }
                self.delegate.onCompletedService(true, withError: error)
            }
        }
    }
}
