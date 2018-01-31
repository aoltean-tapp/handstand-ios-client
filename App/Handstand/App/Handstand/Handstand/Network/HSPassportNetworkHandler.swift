//
//  HSPassportNetworkHandler.swift
//  Handstand
//
//  Created by Fareeth John on 6/22/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSPassportNetworkHandler: HSNetworkHandler {

    func purchasePassport(forPackage packageID : String, forPrice price : String? = nil, forPlan plan : String? = nil,  completionHandler: @escaping (Bool, HSError?) -> ())  {
        let parameters = ["id" : packageID]
        self.request("\(base_url)v3/purchasesession", method: .post, parameters: parameters).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        return completionHandler(true, error)
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(false, error)
        }
    }

    func getPackages(_ completionHandler: @escaping (Array<HSWorkoutPlan>?, HSError?) -> ()) -> () {
        self.request("\(base_url)v3/getpackages", method: .get).responseJSON { response in
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
                                return Int(plan1.price)! < Int(plan2.price)!
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
