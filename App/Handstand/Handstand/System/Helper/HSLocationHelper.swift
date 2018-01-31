//
//  HSLocationHelper.swift
//  Handstand
//
//  Created by Fareeth John on 4/18/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSLocationHelper: NSObject {

    class func getUserDefaultLocation() -> CLLocation? {
        if let theValue = UserDefaults.standard.value(forKey: userDefaultLocation) as? String {
            let arrayVal = theValue.components(separatedBy: ",")
            return CLLocation(latitude: Double(arrayVal[0])!, longitude: Double(arrayVal[1])!)
        }
        return nil
    }
    
    class func setUserDefaultLocation(_ location : CLLocation) {
        let locationStr = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        UserDefaults.standard.setValue(locationStr, forKey: userDefaultLocation)
    }
    
    class func getUserDefaultZipCode() -> String? {
        if let theValue = UserDefaults.standard.value(forKey: userZipCode) as? String {
            return theValue
        }
        return nil
    }
    
    class func setUserZipCode(_ zipCode : String) {
        UserDefaults.standard.setValue(zipCode, forKey: userZipCode)
    }
}
