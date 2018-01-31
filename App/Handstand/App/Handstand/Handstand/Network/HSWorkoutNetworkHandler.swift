//
//  HSWorkoutNetworkHandler.swift
//  Handstand
//
//  Created by Fareeth John on 5/3/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSWorkoutNetworkHandler: HSNetworkHandler {
    func bookWorkoutSession(forData data : NSDictionary,  completionHandler: @escaping (String?, HSError?) -> ())  {
        self.request("\(url)booksession", method: .post, parameters: data as? Dictionary<String, Any>).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        if let bookingID = (JSON as AnyObject).value(forKey: "booking_id") {
                            completionHandler("\(bookingID)", error)
                            
                            //Answers
                            var zipCode = data.value(forKey: kBK_ZipCode) as? String
                            if zipCode?.characters.count == 0 || zipCode == nil{
                                zipCode = ""
                            }
//                            HSAnalytics.setEventForTypes(types: [.answers, .facebook], withLog: kFBSessionBooked, withData: [kAnswersType : eAnswersType.customEvents, kAnswersLocation : zipCode!, kAnswersClassType : data.value(forKey: kBK_ClassType) as! String, kAnswersTrainerName : data.value(forKey: kBK_TrainerName) as! String])

                            //Kahuna
                            let userAttributes = [kKahunaTrainer: data.value(forKey: kBK_TrainerName) as! String, kKahunaLastWorkout: data.value(forKey: kBK_ClassType) as! String, kKahunaLastSession: "\(data.value(forKey: kBK_Date)!)" + " \(data.value(forKey: kBK_Time)!)"]
                            HSAnalytics.setEventForTypes(types: [.kahuna], withLog: kKahunaLogSessionBooked, withData: userAttributes as NSDictionary?)
                            
                            //Appsflyer
                            self.logAppsflyerEvent(data)
                            
                            //Analytics
//                            HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEWorkoutBookTrainer , withData: [kGAEventsCategoryName : kAEWorkoutCategory])
                            
                            return
                        }
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(nil, error)
        }
    }
    
    
    func onDeclinedBookWorkoutSession(forData data : NSDictionary,  completionHandler: @escaping (String?, HSError?) -> ())  {
        self.request("\(url)rebooksession", method: .post, parameters: data as? Dictionary<String, Any>).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        if let bookingID = (JSON as AnyObject).value(forKey: "booking_id") {
                            completionHandler("\(bookingID)", error)
                            
                            //Answers
                            var zipCode = data.value(forKey: kBK_ZipCode) as? String
                            if zipCode?.characters.count == 0 || zipCode == nil{
                                zipCode = ""
                            }
                            //                            HSAnalytics.setEventForTypes(types: [.answers, .facebook], withLog: kFBSessionBooked, withData: [kAnswersType : eAnswersType.customEvents, kAnswersLocation : zipCode!, kAnswersClassType : data.value(forKey: kBK_ClassType) as! String, kAnswersTrainerName : data.value(forKey: kBK_TrainerName) as! String])
                            
                            //Kahuna
                            let userAttributes = [kKahunaTrainer: data.value(forKey: kBK_TrainerName) as! String, kKahunaLastWorkout: data.value(forKey: kBK_ClassType) as! String, kKahunaLastSession: "\(data.value(forKey: kBK_Date)!)" + " \(data.value(forKey: kBK_Time)!)"]
                            HSAnalytics.setEventForTypes(types: [.kahuna], withLog: kKahunaLogSessionBooked, withData: userAttributes as NSDictionary?)
                            
                            //Appsflyer
                            self.logAppsflyerEvent(data)
                            
                            //Analytics
                            //                            HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEWorkoutBookTrainer , withData: [kGAEventsCategoryName : kAEWorkoutCategory])
                            
                            return
                        }
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(nil, error)
        }
    }
    
    private func logAppsflyerEvent(_ data : NSDictionary) {
//        let passportCount = Int((HSController.defaultController.currentUser()?.passport)!)
//        let remainingPassCount = Int((HSController.defaultController.currentUser()?.remainingWorkouts)!)
//        var singleSessionCost = Int(kSingleSessionCost)
        var singleSessionCost = 0
        let workoutSize = "\((data.value(forKey: kBK_WorkoutSize))!)"
        if "small-group" == workoutSize {
            singleSessionCost = singleSessionCost + 15
        }
        var appsFlyerLog = ""
        var bookingCost = ""
        /*
        if passportCount > 0 {
            if remainingPassCount == 0 {
                appsFlyerLog = "Passport \(passportCount) User - 0 Remaining : " + workoutSize
                bookingCost = "\(singleSessionCost)"
            }
            else{
                appsFlyerLog = "Passport \(passportCount) User : Monthly Charge"
//                let passportPrice = Int((HSController.defaultController.currentUser()?.price)!)
                if "small-group" == workoutSize {
                    bookingCost = "15"
                }
                else{
                    bookingCost = "0"
                }
            }
        }
        else{
 */
            appsFlyerLog = "User Booking: " + workoutSize
            bookingCost = "\(singleSessionCost)"
//        }
        HSAnalytics.setEventForTypes(types: [.appsflyer], withLog: appsFlyerLog, withData: [AFEventParamRevenue : bookingCost, AFEventParamCurrency: "USD"])
    }
    
    func cancelWorkoutSession(forSessionID sessionID : String,  status : eWorkoutStatus ,  completionHandler: @escaping (Bool, Bool, HSError?) -> ())  {
        let token = (HSUserManager.shared.currentUser?.accessToken)!
        let param = ["sessionId" : sessionID, "access_token" : token  ] as [String : Any]
        var api = "\(url)destroyreservation"
        if status == .accepted {
            api = "\(url)destroybooking"
        }
        self.request(api, method: .post, parameters: param).responseJSON { response in
            var error : HSError? = nil
            var withInWindow = true
            if let theCode = response.response?.statusCode{
                if theCode == eErrorType.invalidRequestWindow.rawValue {
                    withInWindow = false
                }
            }
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        if withInWindow == true {
                            //Analytics
//                            HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEWorkoutCancelBooking , withData: [kGAEventsCategoryName : kAEWorkoutCategory])
                            //                                HSAnalytics.setEventForTypes(types: [.facebook], withLog: kFBSessionCancelled, withData: nil)
                            //                                HSAnalytics.setEventForTypes(types: [.mixpanel], withLog: kMPWorkoutCancel, withData:nil)
                        }
                        completionHandler(true, withInWindow, error)
                        return
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(false, withInWindow, error)
        }
    }
    
    func cancelWorkoutSessionOnDelcinedRequest(forSessionID sessionID : String,  completionHandler: @escaping (Bool, Bool, HSError?) -> ())  {
        let token = (HSUserManager.shared.currentUser?.accessToken)!
        let param = ["sessionId" : sessionID, "access_token" : token  ] as [String : Any]
           let api = "\(url)deletebooking"
        self.request(api, method: .post, parameters: param).responseJSON { response in
            var error : HSError? = nil
            var withInWindow = true
            if let theCode = response.response?.statusCode{
                if theCode == eErrorType.invalidRequestWindow.rawValue {
                    withInWindow = false
                }
            }
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        completionHandler(true, withInWindow, error)
                        return
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(false, withInWindow, error)
        }
    }
    
    func forceCancelWorkoutSessionOnDeclinedRequest(forSessionID sessionID : String,  completionHandler: @escaping (Bool, HSError?) -> ())  {
        let param = ["sessionId" : sessionID , "force": 1 ] as [String : Any]
        self.request("\(url)deletebooking", method: .post, parameters: param).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        completionHandler(true, error)
                        return
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(false, error)
        }
    }

    
    func forceCancelWorkoutSession(forSessionID sessionID : String,  completionHandler: @escaping (Bool, HSError?) -> ())  {
//        let token = (HSController.defaultController.currentUser()?.accessToken)!
//        "access_token" : token
        let param = ["sessionId" : sessionID , "force": 1 ] as [String : Any]
        self.request("\(url)destroybooking", method: .post, parameters: param).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        completionHandler(true, error)
                        //Analytics
//                        HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEWorkoutCancelBooking , withData: [kGAEventsCategoryName : kAEWorkoutCategory])
//                        HSAnalytics.setEventForTypes(types: [.facebook], withLog: kFBSessionCancelled, withData: nil)
//                        HSAnalytics.setEventForTypes(types: [.mixpanel], withLog: kMPWorkoutCancel, withData:nil)
                        return
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(false, error)
        }
    }

    
    func acceptWorkoutSession(forSessionID sessionID : String,  completionHandler: @escaping (Bool, HSError?) -> ())  {
        let parameters = ["user_id" : (HSUserManager.shared.currentUser?.user_id)!, "booking_id" : sessionID, "status" : 1] as [String : Any]
        self.request("\(url)clientconfirmation", method: .post, parameters: parameters).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                            completionHandler(true, error)
                        
                        //Analytics
//                        HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEWorkoutAcceptBooking , withData: [kGAEventsCategoryName : kAEWorkoutCategory])
//                        HSAnalytics.setEventForTypes(types: [.mixpanel], withLog: kMPWorkoutAccept, withData:nil)
//                        HSAnalytics.setEventForTypes(types: [.facebook], withLog: kFBReservationAccept, withData: nil)
                        return
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(false, error)
        }
    }

    func declineWorkoutSession(forSessionID sessionID : String,  completionHandler: @escaping (Bool, HSError?) -> ())  {
        let parameters = ["user_id" : (HSUserManager.shared.currentUser?.user_id)!, "booking_id" : sessionID, "status" : 2] as [String : Any]
        self.request("\(url)declineclientsession", method: .post, parameters: parameters).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        completionHandler(true, error)
                        //Analytics
//                        HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEWorkoutDeclineBooking , withData: [kGAEventsCategoryName : kAEWorkoutCategory])
//                        HSAnalytics.setEventForTypes(types: [.facebook], withLog: kFBReservationDeclined, withData: nil)
                        return
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(false, error)
        }
    }
    
    func addNotesToWorkoutSession(forSessionID sessionID : String, withComments comments : String,  completionHandler: @escaping (Bool, HSError?) -> ())  {
        let parameters = ["booking_id" : sessionID, "comments" : comments]
        self.request("\(url)bookingcomments", method: .post, parameters: parameters).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        //Analytics
//                        HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEWorkoutAddNote , withData: [kGAEventsCategoryName : kAEWorkoutCategory])
                        completionHandler(true, error)
                        return
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(false, error)
        }
    }


}
