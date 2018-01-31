//
//  HSTrainerNetworkHandler.swift
//  Handstand
//
//  Created by Fareeth John on 4/19/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSTrainerNetworkHandler: HSNetworkHandler {
    func getTrainerForInfo(zipcode : String, forLocation location : CLLocation, completionHandler: @escaping (Array<HSTrainer>, HSError?) -> ()) -> () {
        
        let parameters = ["zip_code" : zipcode, "lng" : "\(location.coordinate.longitude)", "lat" : "\(location.coordinate.latitude)"]
        
        self.request("\(base_url)v3/search", method: .get, parameters: parameters).responseJSON { response in
            var error : HSError? = nil
            var theTrainers : Array<HSTrainer>! = []
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        if let theData = (JSON as AnyObject).value(forKey: "data") as? Array<NSDictionary>{
                            for theDict in theData{
                                theTrainers.append(HSTrainer(withData: theDict))
                            }
                        }
                        completionHandler(theTrainers, error)
//                        //Facebook
//                        HSAnalytics.setEventForTypes(types: [.facebook], withLog: kFBTrainerSearch, withData: nil)
                        return
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(theTrainers, error)
        }
    }
    
    func getTrainerForGivenData(_ data : NSDictionary, onComplete completionHandler: @escaping (Array<HSTrainer>, HSError?) -> ())  {
        self.request("\(url)search", method: .get, parameters: data as? Dictionary<String, Any>).responseJSON { response in
            var error : HSError? = nil
            var theTrainers : Array<HSTrainer>! = []
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        if let theData = (JSON as AnyObject).value(forKey: "data") as? Array<NSDictionary>{
                            for theDict in theData{
                                theTrainers.append(HSTrainer(withData: theDict))
                            }
                        }
                        completionHandler(theTrainers, error)
//                        //Facebook
//                        HSAnalytics.setEventForTypes(types: [.facebook], withLog: kFBTrainerSearch, withData: nil)
                        return
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(theTrainers, error)
        }
    }
    
    func getTrainerInfo(forTrainer trainerID : String,  completionHandler: @escaping (HSTrainer?, HSError?) -> ())  {
        let parameters = ["id" : trainerID]
        self.request("\(url)trainersInfo", method: .get, parameters: parameters).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        let theTrainer : HSTrainer? = HSTrainer(withAvailabiltyData: JSON as! NSDictionary)
                        completionHandler(theTrainer, error)
                        return
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(nil, error)
        }
    }
    
}
