//
//  HSPassportNetworkHandler.swift
//  Handstand
//
//  Created by Fareeth John on 6/22/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSPassportNetworkHandler: HSNetworkHandler {

    func purchasePassport(forPackage packageID : String, forPrice price : String, forPlan plan : String,  completionHandler: @escaping (Bool, HSError?) -> ())  {
        let parameters = ["packageId" : packageID]
        self.request("\(url)purchasepackage", method: .post, parameters: parameters).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        completionHandler(true, error)
                        //Analytics
//                        let appFlyerLog = "Package \(plan) Bought"
//                        HSAnalytics.setEventForTypes(types: [eAnalyticsType.googleAnalyticsEvent, .mixpanel, .facebook, .kahuna], withLog: kAEUserPurchasePassport , withData: [kAELabel : plan + " Sessions", kGAEventsCategoryName : kAEUserCategory])
//                        HSAnalytics.setEventForTypes(types: [.appsflyer], withLog: appFlyerLog, withData: [AFEventParamRevenue : price, AFEventParamCurrency: "USD"])
                        return
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(false, error)
        }
    }

    func getPackages(_ completionHandler: @escaping (Array<HSWorkoutPlan>?, HSError?) -> ()) -> () {
        self.request("\(url)getpackages", method: .get).responseJSON { response in
            var error : HSError? = nil
            var plans : Array<HSWorkoutPlan>? = []
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        if let theData = (JSON as AnyObject).value(forKeyPath: "data.plans") as? NSArray{
                            for thePlan in theData{
                                plans?.append(HSWorkoutPlan(withData: thePlan as! NSDictionary))
                            }
                            plans = plans?.sorted(by: { (plan1, plan2) -> Bool in
                                return Int(plan1.sessions)! < Int(plan2.sessions)!
                            })
                        }
                        completionHandler(plans, error)
                        return
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(plans, error)
        }
    }

}
