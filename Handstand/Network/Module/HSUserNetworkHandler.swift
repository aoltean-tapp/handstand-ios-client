//
//  HSUserNetworkHandler.swift
//  Handstand
//
//  Created by Fareeth John on 4/6/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
import Alamofire
import Stripe
import Crashlytics
import SwiftyJSON

class HSUserNetworkHandler: HSNetworkHandler {
    func login(_ email: String, password: String, completionHandler: @escaping (Bool, HSError?) -> ()) -> () {
        
        let parameters = ["email" : email, "password" : password]
        
        self.request("\(base_url)v3/login", method: .post, parameters: parameters).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                let result = (JSON as AnyObject).value(forKey: "result") as! String
                var success = false
                if result == "success" {
                    //Save credential
//                    PDKeychainBindings.shared().setString(email, forKey: kUserEmail)
//                    PDKeychainBindings.shared().setString(password, forKey: kUserPassword)
                    HSUserManager.shared.email = email
                    HSUserManager.shared.password = password
                    HSUserManager.shared.accessToken = (JSON as AnyObject).value(forKey: "access_token") as? String
                    success = true
                }
                else if let errorObject: NSArray =  (JSON as AnyObject).value(forKey: "errors") as? NSArray{
                    error = HSError()
                    error?.message = errorObject.object(at: 0) as? String
                    error?.code = eErrorType.emailPassword
                }
                completionHandler(success, error)
            }
            else{
                error = HSError()
                error?.code = eErrorType.internalServer
                error?.message = NSLocalizedString("internal_error", comment: "")
                completionHandler(false, error)
            }
        }
    }
    
    func signup(_ firstname:String,
                lastname:String,
                mobile:String,
                email:String,
                password:String,
                reebokAcceptance:Int,
                completionHandler: @escaping (Bool, HSError?) -> ()) -> () {
        let parameters = ["first_name":firstname,
                          "last_name":lastname,
                          "mobile":mobile,
                          "email":email,
                          "password":password,
                          "reebok_accept":reebokAcceptance] as [String : Any]
        self.request("\(base_url)v3/register", method: .post, parameters: parameters).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                let result = (JSON as AnyObject).value(forKey: "result") as! String
                var success = false
                if result == "success" {
                    success = true
                    HSUserManager.shared.email = email
                    HSUserManager.shared.password = password
                    HSUserManager.shared.accessToken = (JSON as AnyObject).value(forKey: "access_token") as? String
                }else if let errorObject: NSArray =  (JSON as AnyObject).value(forKey: "errors") as? NSArray{
                    error = HSError()
                    error?.message = errorObject.object(at: 0) as? String
                    error?.code = eErrorType.emailPassword
                }
                completionHandler(success, error)
            }else{
                error = HSError()
                error?.code = eErrorType.internalServer
                error?.message = NSLocalizedString("internal_error", comment: "")
                completionHandler(false, error)
            }
        }
    }
    
    func getUserProfile(completionHandler: @escaping (Bool, HSError?) -> ()) -> () {
        self.request("\(base_url)v3/profile", method: .get, parameters: [:]).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                let result = (JSON as AnyObject).value(forKey: "result") as! String
                var success = false
                if result == "success" {
                    success = true
                    let data = (JSON as AnyObject).value(forKey: "data") as! NSDictionary
                    HSUserManager.shared.currentUser = HSUser.init(object: data)
                    
                    //Kahuna log
                    let creds:KahunaUserCredentials = KahunaUserCredentials()
                    creds.addCredential(kKahunaEmail, withValue: HSUserManager.shared.currentUser?.email)
                    creds.addCredential(kKahunaUserName, withValue:HSUserManager.shared.currentUser?.firstname)
                    
                    Kahuna.login(with: creds, error: nil)
                    let userAttributes = [kKahunaUserID : HSUserManager.shared.currentUser?.user_id, kKahunaUserName : HSUserManager.shared.currentUser?.firstname, kKahunaUserType : kKahunaUserTypeUser]
                    HSAnalytics.setEventForTypes(types: [.kahuna], withLog: kKahunaLogLogin, withData: userAttributes as NSDictionary?)
                    
                    //Crashlytics
                    Crashlytics.sharedInstance().setUserEmail(HSUserManager.shared.currentUser?.email)
                    Crashlytics.sharedInstance().setUserIdentifier(HSUserManager.shared.currentUser?.user_id)
                    Crashlytics.sharedInstance().setUserName(HSUserManager.shared.currentUser?.name())
                    
                    //Answers
                    HSAnalytics.setEventForTypes(types: [.answers], withLog: "User", withData: [kAnswersType : eAnswersType.login,kAnswersUserName : "\(HSUserManager.shared.currentUser?.name() ?? "")"])
                }else if let errorObject: NSArray =  (JSON as AnyObject).value(forKey: "errors") as? NSArray{
                    error = HSError()
                    error?.message = errorObject.object(at: 0) as? String
                    error?.code = eErrorType.emailPassword
                }
                completionHandler(success, error)
            }else{
                error = HSError()
                error?.code = eErrorType.internalServer
                error?.message = NSLocalizedString("internal_error", comment: "")
                completionHandler(false, error)
            }
        }
    }
    
    func saveCardWith(data : NSDictionary , completionHandler: @escaping (Bool, HSError?) -> ()){
        getTokenForGivenCard(cardData: data, completionHandler: {(token, error) in
            if error != nil{
                completionHandler(false, error)
            }
            else{
                let parameters = ["stripeToken" : "\(token!)"]
                self.request("\(url)addcards", method: .post, parameters: parameters).responseJSON { response in
                    var error : HSError? = nil
                    if let JSON = response.result.value {
                        if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                            if result == "success" {
                                //Analytics
                                //                                HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEUserAddCreditCard , withData: [kGAEventsCategoryName : kAEUserCategory])
                                completionHandler(true, error)
                                return
                            }
                        }
                    }
                    error = self.processForError(response)
                    completionHandler(false, error)
                }
            }
        })
    }
    
    func addPassport(forPlan plan : String, forPrice price : String,  completionHandler: @escaping (Bool, HSError?) -> ())  {
        let parameters = ["plan" : plan]
        self.request("\(url)passport", method: .post, parameters: parameters).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        completionHandler(true, error)
                        //Analytics
                        //                        HSAnalytics.setEventForTypes(types: [.facebook], withLog: kFBPassportBought, withData: nil)
                        let appFlyerLog = "Passport \(plan) Bought"
                        //                        HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEUserPurchasePassport , withData: [kAELabel : plan + " Sessions", kGAEventsCategoryName : kAEUserCategory])
                        HSAnalytics.setEventForTypes(types: [.appsflyer], withLog: appFlyerLog, withData: [AFEventParamRevenue : price, AFEventParamCurrency: "USD"])
                        return
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(false, error)
        }
    }
    
    func getMyHomeInfo(_ completionHandler: @escaping (Bool, HSError?) -> ())  {
        self.request("\(url)myhome", method: .get, parameters: nil).responseJSON { response in
            var error : HSError? = nil
            HSAppManager.shared.upcomingSession = nil
            HSAppManager.shared.videoSession = nil
            HSAppManager.shared.trainerRequest = nil
            HSAppManager.shared.declinedRequest = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        if let videoData = (JSON as AnyObject).value(forKey: "daily_video") as? NSDictionary{
                            if videoData.count > 0{
                                let theVideo = HSVideoSession(withData: videoData)
                                HSAppManager.shared.videoSession = theVideo
                            }
                        }
                        if let declinedRequest = (JSON as AnyObject).value(forKey: "decline_request") as? NSDictionary{
                            if declinedRequest.count > 0 {
                                let theRequest = HSDeclineRequest.init(object: declinedRequest)
                                if theRequest.scheduleTrainer == true {
                                    HSAppManager.shared.declinedRequest = theRequest
                                }
                            }
                        }
                        if let upcomingSession = (JSON as AnyObject).value(forKey: "session") as? NSDictionary{
                            if upcomingSession.count > 0 {
                                let theSession = HSWorkoutSession(withData: upcomingSession)
                                HSAppManager.shared.upcomingSession = theSession
                            }
                        }
                        if let declinedRequest = HSAppManager.shared.declinedRequest {
                            if let trainerId = declinedRequest.internalIdentifier?.description {
                                if let upcomingSession = HSAppManager.shared.upcomingSession {
                                    if trainerId.description == upcomingSession.id {
                                        HSAppManager.shared.upcomingSession = nil
                                    }
                                }
                            }
                        }
                        if let trainerRequest = (JSON as AnyObject).value(forKey: "trainer_request") as? NSDictionary {
                            if trainerRequest.count > 0 {
                                let trainerRequest = HSTrainerRequest.init(object: trainerRequest)
                                HSAppManager.shared.trainerRequest = trainerRequest
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
    
    func getMyWorkoutInfo(_ completionHandler: @escaping (Array<HSWorkoutSession>, HSError?) -> ())  {
        self.request("\(url)workouts", method: .get, parameters: [:]).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        var workouts : Array<HSWorkoutSession>! = []
                        if let resultArr = (JSON as AnyObject).value(forKey: "data") as? NSArray{
                            for theWorkoutData in resultArr{
                                workouts.append(HSWorkoutSession(withUpcomingData: theWorkoutData as! NSDictionary))
                            }
                        }
                        completionHandler(workouts, error)
                        return
                    }
                }
            }
            error = self.processForError(response)
            completionHandler([], error)
        }
    }
    
    private func getTokenForGivenCard( cardData : NSDictionary, completionHandler : @escaping (String?, HSError?) -> ())  {
        let creditCard = STPCardParams()
        creditCard.number = cardData.value(forKey: kPK_CardNumber) as? String
        creditCard.cvc = cardData.value(forKey: kPK_CardCvv) as? String
        let expYear: NSNumber = NSNumber(integerLiteral: (cardData.value(forKey: kPK_CardExpYear) as! Int))
        creditCard.expYear = expYear.uintValue
        let expMonth: NSNumber =  NSNumber(integerLiteral: (cardData.value(forKey: kPK_CardExpMonth) as! Int))
        creditCard.expMonth = expMonth.uintValue
        var error : HSError? = nil
        STPAPIClient.shared().createToken(withCard: creditCard) { (token, tokenError) in
            if tokenError != nil {
                error = HSError()
                error?.code = eErrorType.internalServer
                error?.message = tokenError?.localizedDescription
                completionHandler(nil, error)
            } else if let token = token {
                completionHandler(token.tokenId, error)
            }
        }
    }
    
    func saveProfileInfo( profileData : Dictionary<String,String>?, completionHandler: @escaping (Bool, HSError?) -> ())  {
        self.request("\(base_url)v3/profile", method: .post, parameters: profileData).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        //Analytics
                        //                        HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEUserEditProfile , withData: [kGAEventsCategoryName : kAEUserCategory])
                        HSAppManager.shared.handPickedProductIdentifier = nil
                        HSAppManager.shared.iapReceiptID = nil
                        return completionHandler(true, error)
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(false, error)
        }
    }
    
    func saveProfileInfo( profileData : Dictionary<String,String>?, withImage image : UIImage, completionHandler: @escaping (Bool, HSError?) -> ())  {
        let time = Int(Date().timeIntervalSinceReferenceDate)
        let filename :String = "\(time).png"
        Alamofire.upload(multipartFormData:{ multipartFormData in
            if let imageData = UIImageJPEGRepresentation(image, 0.1) {
                multipartFormData.append(imageData, withName: "image",fileName: filename, mimeType: "image/png")
            }
            for (key, value) in profileData! {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
        },
                         usingThreshold:UInt64.init(),
                         to:"\(base_url)v3/profile",
            method:.post,
            headers:HSNetworkHandler.headers(),
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        var error : HSError? = nil
                        if let JSON = response.result.value {
                            if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                                if result == "success" {
                                    //Analytics
                                    //                                    HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEUserEditProfile , withData: [kGAEventsCategoryName : kAEUserCategory])
                                    completionHandler(true, nil)
                                    return
                                }
                            }
                        }
                        error = self.processForError(response)
                        completionHandler(false, error)
                    }
                    break
                case .failure(let encodingError):
                    let error : HSError? = HSError()
                    error?.message = encodingError.localizedDescription
                    completionHandler(false, error)
                    break
                }
        })
    }
    
    func applyPromoCode(_ code : String, onComplete completionHandler: @escaping (HSPromoResponse?, HSError?) -> ()) {
        let parameters = ["promocode" : code]
        self.request("\(url)promocode", method: .post, parameters: parameters).responseJSON { response in
            var error : HSError? = nil
            if let result = response.result.value {
                let json = JSON(result)
                if json["result"] == "success" {
                    let resp = HSPromoResponse.init(json: json)
                    return completionHandler(resp,nil)
                }
            }
            error = self.processForError(response)
            completionHandler(nil, error)
        }
    }
    
    func clearPromoCode(onComplete completionHandler: @escaping (Bool?, HSError?) -> ()) {
        
        self.request("\(url)deletecoupon", method: .get, parameters:[:]).responseJSON { response in
            var error : HSError? = nil
            if let result = response.result.value {
                let json = JSON(result)
                if json["result"] == "success" {
                    return completionHandler(true,nil)
                }
            }
            error = self.processForError(response)
            completionHandler(false, error)
        }
    }
    
    
    //MARK:- IAP
    
    func saveIAPRecepit(forReceiptID receiptID : String, withSubcription subcription : String,  completionHandler: @escaping (Bool, HSError?) -> ())  {
        let parameters = ["platform" : "ITUNES", "receipt" : receiptID, "subscription" : subcription]
        self.request("\(base_url)v3/savesubscription", method: .post, parameters: parameters).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        return completionHandler(true, error)
                    }
                    if error == nil {
                        let e = HSError.init()
                        e.message = NSLocalizedString("internal_error", comment: "")
                        return completionHandler(false, e)
                    }
                    return completionHandler(false, error)
                }
            }
            error = self.processForError(response)
            completionHandler(false, error)
        }
    }
    
    func validateMembership(_ completionHandler: @escaping (Bool, HSError?) -> ()) {
        self.request("\(base_url)v3/validatesubscription", method: .get, parameters: nil).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        guard let theMembership = (JSON as AnyObject).value(forKey: "membership") as? Bool else {return }
                        HSUserManager.shared.hasValidMembership = theMembership
                        return completionHandler(true, error)
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(false, error)
        }
    }
    
    //MARK:- Forgot Password
    
    func forgotPassword(forEmailID emailID : String, onComplete completionHandler: @escaping (Bool, HSError?) -> ()) {
        let parameters = ["email" : emailID, "action" : "generate","flag":"1"]
        self.request("\(base_url)v3/forgotpassword", method: .get, parameters: parameters).responseJSON { response in
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
    
    func verifyCode(forEmailID emailID : String, withCode code : String, onComplete completionHandler: @escaping (Bool, HSError?) -> ()) {
        let parameters = ["email" : emailID, "action" : "verify", "flag":"1", "code":code]
        self.request("\(base_url)v3/forgotpassword", method: .get, parameters: parameters).responseJSON { response in
            var error : HSError? = nil
            if let JSON = response.result.value {
                if let result = (JSON as AnyObject).value(forKey: "result") as? String{
                    if result == "success" {
                        HSUserManager.shared.tempAccessToken = (JSON as AnyObject).value(forKey: "access_token") as? String
                        return completionHandler(true, error)
                    }
                }
            }
            error = self.processForError(response)
            completionHandler(false, error)
        }
    }
    
    func updatePassword(forEmailID emailID : String, withPassword password : String, withOldPassword oldPassword:String, onComplete completionHandler: @escaping (Bool, HSError?) -> ()) {
        let parameters = ["email":emailID,
                          "current_password":oldPassword,
                          "new_password":password]
        self.request("\(base_url)v3/changepassword", method: .post, parameters: parameters).responseJSON { response in
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
    
    func requestPhneVerificationCode(with verb:String,
                                     phoneNumber:String,code:String?=nil,
                                     onSucess completionHandler:@escaping (String?,String?)->())->() {
        var subRoute:String = ""
        if let code = code {
            subRoute = "&action=\(verb)&mobile=\(phoneNumber)&code=\(code)"
        }else {
            subRoute = "&action=\(verb)&mobile=\(phoneNumber)"
        }
        // https://stage.handstandapp.com/api/verification?action=generate&mobile=4244420933
        self.request("\(base_url)v3/verification?"+subRoute, method: .get, parameters: [:]).responseJSON { response in
            var result:String?
            var message:String?
            
            if let JSON = response.result.value {
                result = (JSON as AnyObject).value(forKey: "result") as? String
                message = (JSON as AnyObject).value(forKey: "message") as? String
                
                if result == "success" {
                    message = ""
                }
                else if(message == nil){
                    let errorObject: AnyObject? = (JSON as AnyObject).value(forKey: "errors") as AnyObject
                    let errorArray = (errorObject as! NSArray) as Array
                    
                    let array1 = errorArray[0]
                    message = array1 as? String
                }
            }
            else{
                result = ""
                message = response.result.error?.localizedDescription
            }
            
            completionHandler(result, message)
        }
    }
    
    func getNewSubscriptionPlansData(forPackageBundle:Bool=false,completion:@escaping (AsyncResult<HSGetNewSubscriptionsResponse>)->()) {
        var connectingURL:String = ""
        if forPackageBundle == true {
            connectingURL = "\(base_url)v3/subscriptionpopup?package=true"
        }else {
            connectingURL = "\(base_url)v3/subscriptionpopup"
        }
        self.request(connectingURL, method: .get, parameters: [:]).responseJSON { response in
            var error : HSError? = nil
            if let _JSON = response.result.value {
                let result = (_JSON as AnyObject).value(forKey: "result") as! String
                if result == "success" {
                    let resp = HSGetNewSubscriptionsResponse.init(json: JSON(_JSON))
                    return completion(AsyncResult.success(resp))
                }else if let errorObject: NSArray =  (_JSON as AnyObject).value(forKey: "errors") as? NSArray{
                    error = HSError()
                    error?.message = errorObject.object(at: 0) as? String
                    error?.code = eErrorType.emailPassword
                }
                completion(AsyncResult.failure(error))
            }else{
                error = HSError()
                error?.code = eErrorType.internalServer
                error?.message = NSLocalizedString("internal_error", comment: "")
                completion(AsyncResult.failure(error))
            }
        }
    }

    public func getSpecialities(completion:@escaping (AsyncResult<HSSpecialitiesData>)->()) {
        self.request("\(base_url)v3/specialities", method: .get, parameters: [:]).responseJSON { response in
            var error : HSError? = nil
            if let _JSON = response.result.value {
                let result = (_JSON as AnyObject).value(forKey: "result") as! String
                if result == "success" {
                     let resultArr = (_JSON as AnyObject).value(forKey: "data") 
                    let obj = HSSpecialitiesData.init(json: JSON(resultArr ?? (Any).self))
                    return completion(AsyncResult.success(obj))
                }else if let errorObject: NSArray =  (_JSON as AnyObject).value(forKey: "errors") as? NSArray{
                    error = HSError()
                    error?.message = errorObject.object(at: 0) as? String
                    error?.code = eErrorType.emailPassword
                }
                completion(AsyncResult.failure(error))
            }else{
                error = HSError()
                error?.code = eErrorType.internalServer
                error?.message = NSLocalizedString("internal_error", comment: "")
                completion(AsyncResult.failure(error))
            }
        }
    }
    
}
