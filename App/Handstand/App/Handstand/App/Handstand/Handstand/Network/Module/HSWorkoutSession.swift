//
//  HSWorkoutSession.swift
//  Handstand
//
//  Created by Fareeth John on 5/5/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

enum eWorkoutStatus: Int {
    case pending = 0
    case accepted = 1
    case cancelled = 2
    case completed = 3
}

class HSWorkoutSession: NSObject {
    enum eRequestedByType: Int {
        case client = 0
        case trainer = 1
    }
    

    var id : String! = ""
    var first_name : String! = ""
    var last_name : String! = ""
    var mobile : String! = ""
    var avatar : String! = ""
    var thumbnail : String! = ""
    var starts_at : String! = ""
    var formatted_location : String! = ""
    var size : String! = ""
    var speciality : String! = ""
    var startDate : Date! = nil
    var startTime : String! = ""
    var user_id : String! = ""
    var zipcode : String! = ""
    var session_comments : String! = ""
    var rating : String! = ""
    var requestedBy : eRequestedByType = .client
    var rating_comments : String! = ""
    var isSingle : Bool = true
    var workoutStatus : eWorkoutStatus = .pending
    var isHidden : Bool = false


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
        
        if starts_at.characters.count > 0 {
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
            startDate = dateFormate.date(from: starts_at)
            dateFormate.dateFormat = "hh:mm a"
            startTime = dateFormate.string(from: startDate)
        }        
    }
    
    init(withUpcomingData data : NSDictionary) {
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
        if let theValue = data.value(forKey: "date") as? String {
            if let theValue2 = data.value(forKey: "start") as? String {
                let theDate = theValue + " " + theValue2
                let dateFormate = DateFormatter()
                dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
                startDate = dateFormate.date(from: theDate)
            }
        }
        if let theValue = data.value(forKey: "session_location") as? String {
            formatted_location = theValue
        }
        if let theValue = data.value(forKey: "session_type") as? String {
            speciality = theValue
        }
        if let theValue = data.value(forKey: "requested_by") as? Int {
            if theValue == 1 {
                requestedBy = .trainer
            }
            else{
                requestedBy = .client
            }
        }
        if let theValue = data.value(forKey: "status") as? Int {
            workoutStatus = eWorkoutStatus.init(rawValue: theValue)!
        }
        if let theValue = data.value(forKey: "session_size") as? String {
            size = theValue
            if theValue == "1-On-1" {
                isSingle = true
            }
            else{
                isSingle = false
            }
        }
        if let theValue = data.value(forKeyPath: "trainer.firstname") as? String {
            first_name = theValue
        }
        if let theValue = data.value(forKeyPath: "trainer.lastname") as? String {
            last_name = theValue
        }
        if let theValue = data.value(forKeyPath: "trainer.mobile") as? String {
            mobile = theValue
        }
        if let theValue = data.value(forKeyPath: "trainer.thumbnailUrl") as? String {
            thumbnail = theValue.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        }
        if let theValue = data.value(forKeyPath: "trainer.is_hidden") as? Bool {
            isHidden = theValue
        }
    }
    
    func partialTrainerName() -> String {
        var partialName = self.first_name
        if self.last_name.characters.count > 0 {
            partialName = partialName! + " " + "\(self.last_name.characters.first!)."
        }
        return partialName!
    }
}
