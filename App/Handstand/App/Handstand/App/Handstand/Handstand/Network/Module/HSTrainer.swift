//
//  HSTrainer.swift
//  Handstand
//
//  Created by Fareeth John on 4/19/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSTrainer: NSObject {
    var first_name : String! = ""
    var last_name : String! = ""
    var id : String! = ""
    var avatar : String! = ""
    var thumbnail : String! = ""
    var specialities : String! = ""
    var about : String! = ""
    private var slotsAvailable : NSDictionary! = [:]
    var availableDates : Array<String>! = []

    init(withData data : NSDictionary) {
        super.init()
        
        for (key, value) in data {
            let keyName = key as! String
            let keyValue: AnyObject = value as AnyObject
            if  (self.responds(to: NSSelectorFromString(keyName))) {
                if (keyValue is NSNull) == false{
                    self.setValue("\(keyValue)", forKey: keyName)
                }
            }
        }
        
        if let theImgURL = thumbnail {
            thumbnail = theImgURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        }

    }
    
    init(withAvailabiltyData data : NSDictionary) {
        super.init()
        if let availability = data.value(forKey: "slots-available") as? NSDictionary {
            slotsAvailable = availability
            availableDates.append(contentsOf: (slotsAvailable.allKeys as! Array<String>))
            availableDates.sort()
        }
        
        if let value = data.value(forKey: "classType") as? NSArray {
            specialities = value.componentsJoined(by: ",")
        }
        
        if let theValue = data.value(forKey: "data") as? NSDictionary {
            for (key, value) in theValue {
                let keyName = key as! String
                let keyValue: AnyObject = value as AnyObject
                if  (self.responds(to: NSSelectorFromString(keyName))) {
                    if (keyValue is NSNull) == false{
                        self.setValue("\(keyValue)", forKey: keyName)
                    }
                }
            }
            
            if let theImgURL = thumbnail {
                thumbnail = theImgURL.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            }
        }
        
    }
    
    func availableTime(forData date : String) -> Array<String>? {
        return slotsAvailable.value(forKey: date) as? Array<String>
    }
    
    func fullName() -> String {
        return first_name + " " + last_name
    }

}
