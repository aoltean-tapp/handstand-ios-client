//
//  HSOnboardingService.swift
//  Handstand
//
//  Created by Fareeth John on 4/7/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

protocol HSOnboardingServiceDelegate {
    func onCompletedService(_ success : Bool, withError error : HSError?)
}

class HSOnboardingService: NSObject {
    
    var delegate : HSOnboardingServiceDelegate! = nil
    
    func start()  {
        //Implemented in child class
    }
}
