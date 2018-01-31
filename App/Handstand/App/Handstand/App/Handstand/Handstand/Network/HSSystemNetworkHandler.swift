//
//  HSSystemNetworkHandler.swift
//  Handstand
//
//  Created by Fareeth John on 4/20/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSSystemNetworkHandler: HSNetworkHandler {
    func fetchClassTypes(_ completionHandler: @escaping (Bool?, HSError?) -> ()) -> () {
        self.request("\(url)globalTrainersInfo", method: .get).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        if let theValue = (JSON as AnyObject).value(forKey: "classType") as? [(String)]{
                            HSAppManager.shared.classTypes = theValue
                        }
                        if let theValue = (JSON as AnyObject).value(forKey: "advanceHour") as? Int{
                            HSAppManager.shared.advanceHour = theValue
                        }else {
                            //edge case
                            HSAppManager.shared.advanceHour = 3
                        }
                        if let theValue = (JSON as AnyObject).value(forKey: "iosVersion") as? String{
                            HSAppManager.shared.latestAppVersion = HSUtility.getVersionNumber(theValue)
                                let currentAppVersion = HSUtility.getVersionNumber(HSUtility.getAppVersion())
                                if let theValue = (JSON as AnyObject).value(forKey: "iosMinimumVersion") as? String{
                                    HSAppManager.shared.minimumSupportedVersion = HSUtility.getVersionNumber(theValue)
                                    if HSAppManager.shared.minimumSupportedVersion >  currentAppVersion {
                                        let theError = HSError()
                                        theError.code = .invalidAppVersion
                                        theError.message = NSLocalizedString("Force_Update_App_Alert", comment: "")
                                        completionHandler(false, theError)
                                        return
                                    }
                                    else if HSAppManager.shared.latestAppVersion >  currentAppVersion {
                                        let theError = HSError()
                                        theError.code = .updateAppVersion
                                        theError.message = NSLocalizedString("Update_App_Alert", comment: "")
                                        completionHandler(false, theError)
                                        return
                                    }
                                }
                        }
                        completionHandler(true, error)
                        return
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(false, error)
        }
    }
    
    func getWorkoutPlans(_ completionHandler: @escaping (Array<HSWorkoutPlan>?, HSError?) -> ()) -> () {
        self.request("\(url)getpassports", method: .get).responseJSON { response in
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
