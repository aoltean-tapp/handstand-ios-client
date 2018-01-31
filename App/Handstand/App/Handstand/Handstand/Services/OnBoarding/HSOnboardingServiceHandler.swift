//
//  HSOnboardingServiceHandler.swift
//  Handstand
//
//  Created by Fareeth John on 4/7/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit


class HSOnboardingServiceHandler: NSObject, HSOnboardingServiceDelegate {
    public typealias HSOnboardingServiceCompletionHandler = (_ success: Bool, _ error: HSError?) -> ()
    var services : Array<HSOnboardingService>! = []
    var currentServiceID = 0
    fileprivate var completionHandler: HSOnboardingServiceCompletionHandler?

    override init() {
        super.init()
        createServiceList()
    }
    
    func createServiceList()  {
        var service : HSOnboardingService! = nil
        service = HSOnboardingServiceProfile()
        service.delegate = self
        services.append(service)
        
        //Save IAP
        if HSAppManager.shared.iapReceiptID != nil {
            service = HSOnboardingServiceSaveIAP()
            service.delegate = self
            services.append(service)
        }
        
        //Get Home
        service = HSOnboardingServiceMyHome()
        service.delegate = self
        services.append(service)
        
        //Get Class
        service = HSOnboardingServiceClassType()
        service.delegate = self
        services.append(service)
        
        //Validate IAP
        service = HSOnboardingServiceValidateIAP()
        service.delegate = self
        services.append(service)

    }
    
    func startService(_ onComplete : @escaping HSOnboardingServiceCompletionHandler)  {
        self.completionHandler = onComplete
        let service = services[currentServiceID]
        service.start()
    }
    
    
    func onCompletedService(_ success : Bool, withError error : HSError?){
        if success {
            currentServiceID += 1
            if currentServiceID < services.count {
                let service = services[currentServiceID]
                service.start()
            }
            else{
                completionHandler!(success, error)
            }
        }
        else{
            currentServiceID = 0
            completionHandler!(success, error)
        }
    }
    
}
