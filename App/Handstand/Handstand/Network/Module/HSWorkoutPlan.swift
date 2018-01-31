//
//  HSWorkoutPlan.swift
//  Handstand
//
//  Created by Fareeth John on 5/2/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSWorkoutPlan: NSObject {
    var id : String! = ""
    var stripe_plan_id : String! = ""
    var name : String! = ""
    var planDescription : String! = ""
    var price : String! = ""
    var span : String! = ""
    var code : String! = ""
    var price_per_session : String! = ""
    var trial_days : String! = ""
    var sessions : String! = ""
    var active : String! = ""
    var best_value : String! = ""
    var title : String! = ""
    var info : String! = ""
    var reebok_active:Bool = false

    init(withData data : NSDictionary) {
        super.init()
        
        for (key, value) in data {
            let keyName = key as! String
            let keyValue: AnyObject = value as AnyObject
            if  (self.responds(to: NSSelectorFromString(keyName))) {
                if (keyValue is NSNull) == false{
                    if keyName == "description" {
                        self.planDescription = keyValue as! String
                    }else if ((keyValue is Bool) && (keyName == "reebok_active")){
                        self.reebok_active = keyValue as! Bool
                    }else{
                        self.setValue("\(keyValue)", forKey: keyName)
                    }
                }
            }
        }
        processTitle()
        processInfo()
    }
    
    func processTitle() {
//        var months = "Month"
//        if Int(span)! > 1 {
//            months = span + " Months"
//        }
        let session = sessions +  " Sessions"
//        title = session + "/" + months
        title = session
    }
    
    func processInfo() {
        let thePrice = "$\(price_per_session!)/session"
//        var period = "mo"
//        if span == "3" {
//            period = "Quaterly"
//        }
//        else if span == "6" {
//            period = "Halfly"
//        }
//        else if span == "12" {
//            period = "Yearly"
//        }
//        else if Int(span)! > 1 {
//            period = "\(span!) mo"
//        }

//        let theSubPrice = "$\(price!)/" + period
        let theSubPrice = "$\(price!)"
        info = thePrice + " (" + theSubPrice + ")"
    }
    
}
