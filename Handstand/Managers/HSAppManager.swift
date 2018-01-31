//
//  HSAppManager.swift
//  Handstand
//
//  Created by Ranjith Kumar on 10/20/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import Foundation
import StoreKit

class HSAppManager:NSObject {
    
    class var shared: HSAppManager {
        struct Static {
            static let instance: HSAppManager = HSAppManager()
        }
        return Static.instance
    }
    
    var iapHelper : IAPHelper! = nil
    var videoSession : HSVideoSession? = nil
    var upcomingSession : HSWorkoutSession? = nil
    var trainerRequest: HSTrainerRequest? = nil
    var declinedRequest: HSDeclineRequest? = nil
    var classTypes : Array<String>! = []
    var advanceHour : Int = 0
    var latestAppVersion : Int! = 0
    var minimumSupportedVersion : Int! = 0
    var iapReceiptID : String? = nil
    var handPickedProductIdentifier : String? = nil
    public var newPlan:Bool = true
    
}

extension HSAppManager:SKStoreProductViewControllerDelegate {
    
   public func loadIAPProducts() {
        var set = Set<ProductIdentifier>()
        set.insert(trialSubID)
        set.insert(monthlySubID)
        set.insert(yearlySubID)
        set.insert(fourteen99ID)
        set.insert(nine99ID)
        iapHelper = IAPHelper(productIds: set)
    }

    public func openStoreProductWithiTunesItemIdentifier(identifier: String) {
       /* let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        storeViewController.loadProduct(withParameters: parameters) { (loaded, error) -> Void in
            if loaded {
                HSUtility.getTopController().present(storeViewController, animated: true, completion: nil)
            }
        }*/
        let AppStoreLink = "itms-apps://itunes.apple.com/us/app/handstand-workouts-on-demand/"+identifier
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: AppStoreLink)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: AppStoreLink)!)
        }
    }
    
    /*func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }*/
}
