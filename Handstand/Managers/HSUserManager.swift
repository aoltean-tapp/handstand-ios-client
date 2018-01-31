//
//  HSUserManager.swift
//  Handstand
//
//  Created by Ranjith Kumar on 8/23/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import Foundation

let kAccessTokenKey                 =   "access_token"
let kCurrentUserDataKey             =   "loggedInUserData"
let kCurrentUserTrainerSearchKey    =   "trainer_search_Data"
let kCurrentUserEmailKey            =   "email"
let kCurrentUserPasswordKey         =   "passsword"

//TR->TrainerRequest
enum TRAcceptType {
    case AcceptFromHome
    case AcceptFromMyWorkouts
    case BookTrainerFromTrainerDetail
}

class HSUserManager {
    let userDefault = UserDefaults.standard
    //Iphone 5 and lesser screens Recents are hidding the new search results
    fileprivate let maxRecentLocationsCount:Int = (ScreenCons.SCREEN_HEIGHT<600) ? 2 : 3
    
    class var shared: HSUserManager {
        struct Static {
            static let instance: HSUserManager = HSUserManager()
        }
        return Static.instance
    }
    
    var trainerRequestAcceptType:TRAcceptType?
    public var hasValidMembership: Bool = false
    public var email:String? {
        set {
            userDefault.set(newValue, forKey: kCurrentUserEmailKey)
        }
        get {
            if userDefault.object(forKey: kCurrentUserEmailKey) != nil {
                return userDefault.object(forKey: kCurrentUserEmailKey) as? String
            }
            return nil
        }
    }
    public var password:String? {
        set {
            userDefault.set(newValue, forKey: kCurrentUserPasswordKey)
        }
        get {
            if userDefault.object(forKey: kCurrentUserPasswordKey) != nil {
                return userDefault.object(forKey: kCurrentUserPasswordKey) as? String
            }
            return nil
        }
    }
    
    var accessToken:String? {
        set {
            userDefault.set(newValue, forKey: kAccessTokenKey)
        }
        get {
            if userDefault.object(forKey: kAccessTokenKey) != nil {
                return userDefault.object(forKey: kAccessTokenKey) as? String
            }
            return nil
        }
    }
    var tempAccessToken:String?
    
    var currentUser:HSUser? {
        set {
            newValue?.accessToken = self.accessToken
            userDefault.set(newValue?.dictionaryRepresentation(), forKey: kCurrentUserDataKey)
        }
        get {
            if (userDefault.object(forKey: kCurrentUserDataKey) != nil) {
                let dictionary = userDefault.object(forKey: kCurrentUserDataKey)
                return HSUser.init(dictionary: dictionary as! Dictionary<String, Any>)
            }
            return nil
        }
    }
    
    func removeCurrentUser() {
        userDefault.removeObject(forKey: kCurrentUserDataKey)
    }
    
    func removeAccessToken() {
        userDefault.removeObject(forKey: kAccessTokenKey)
    }
    
    func isUserLoggedIn()->Bool {
        if let accessToken = self.accessToken {
            return accessToken.length() > 0
        }
        return false
    }
    private func removeTrainerSearchResults() {
        userDefault.removeObject(forKey: kCurrentUserTrainerSearchKey)
    }
    
    func logout() {
        self.currentUser = nil
        self.accessToken = nil
        self.email = nil
        self.password = nil
        Kahuna.logout()
        removeCurrentUser()
        removeAccessToken()
        removeTrainerSearchResults()
    }
    
    func getRecentTrainerSearchLocation()->[HSRecentAddress] {
        if (userDefault.object(forKey: kCurrentUserTrainerSearchKey) != nil) {
            let array = userDefault.object(forKey: kCurrentUserTrainerSearchKey) as! [[String:Any]]
            let arrayOfAddress = array.map({dictionary in HSRecentAddress.init(object: dictionary)})
            return arrayOfAddress
        }
        return []
    }
    
    func setRecentTrainerSearchLocation(address:HSRecentAddress) {
        if (userDefault.object(forKey: kCurrentUserTrainerSearchKey) != nil) {
            var history = userDefault.object(forKey: kCurrentUserTrainerSearchKey) as! [[String:Any]]
            //There is some value
            if history.count == maxRecentLocationsCount {
                history.removeLast()
            }
            //Avoiding duplicates
            let zipCodeMatches = history.filter{dict in
                guard let address = address.formattedAddress else {return false}
                return "\(dict["formatted_address"]!)" == address
            }
            if zipCodeMatches.count == 0 {
                history.insert(address.dictionaryRepresentation(), at: 0)
                userDefault.set(history, forKey: kCurrentUserTrainerSearchKey)
            }
        }else {
            let newArray = [address.dictionaryRepresentation()]
            userDefault.set(newArray, forKey: kCurrentUserTrainerSearchKey)
        }
        userDefault.synchronize()
    }
}
