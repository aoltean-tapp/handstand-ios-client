import UIKit
import Mixpanel
import Crashlytics

enum eAnalyticsType: Int {
    case googleAnalytics = 1
    case mixpanel = 2
    case answers = 3
    case appsflyer = 4
    case kahuna = 5
    case facebook = 6
    case googleAnalyticsEvent = 7
}

enum eAnswersType: Int {
    case login = 1
    case signup = 2
    case search = 3
    case customEvents = 5
}

let kAnswersType = "kAnswersType"
let kAnswersUserName = "User"
let kAnswersSpecialties = "kAnswersSpecialties"
let kAnswersTrainerName = "Trainer"
let kAnswersLocation = "Location"
let kAnswersClassType = "Class Type"
let kGAEventsCategoryName = "kGAEventsCategoryName"

struct HSAnalytics {
    static func setEventForTypes(types : Array<eAnalyticsType>=[.mixpanel,.answers,.appsflyer,.kahuna,.facebook,.googleAnalyticsEvent,.googleAnalytics], withLog log : String, withData data : NSDictionary? = nil ) {
        let logString = "iOS_"+log
        for theType in types {
            switch theType {
            case .googleAnalytics:
                let tracker = GAI.sharedInstance().defaultTracker
                tracker?.set(kGAIScreenName, value: logString)
                let builder = GAIDictionaryBuilder.createScreenView()
                tracker?.send(builder?.build() as! [AnyHashable : Any]!)
                break
            case .mixpanel:
                if let theLabel = data?.value(forKey: kAELabel) as? String {
                    Mixpanel.mainInstance().track(event: logString, properties: [kAELabel : theLabel])
                }
                else{
                    Mixpanel.mainInstance().track(event: logString)
                }
                break
            case .answers:
                //                HSAnalytics.setAnswersEvent(type: data?.value(forKey: kAnswersType) as! eAnswersType, withLog: log, withData: data)
                break
            case .appsflyer:
                #if Handstand
                    if let theLabel = data?.value(forKey: kAELabel) as? String {
                        AppsFlyerTracker.shared().trackEvent(logString, withValues: [kAELabel : theLabel])
                    }
                    else{
                        AppsFlyerTracker.shared().trackEvent(logString, withValues: data as! [AnyHashable : Any]!)
                    }
                #endif
                break
            case .kahuna:
                if let theLabel = data?.value(forKey: kAELabel) as? String {
                    Kahuna.setUserAttributes([logString : theLabel])
                }
                else{
                    Kahuna.setUserAttributes(data as! [AnyHashable : Any]!)
                }
                Kahuna.trackEvent(log)
                break
            case .facebook:
                if let theLabel = data?.value(forKey: kAELabel) as? String {
                    FBSDKAppEvents.logEvent(logString, parameters: [kAELabel : theLabel])
                }
                else{
                    FBSDKAppEvents.logEvent(logString)
                }
                break
            case .googleAnalyticsEvent:
                let tracker = GAI.sharedInstance().defaultTracker
                var theLabel : String? = nil
                if let value = data?.value(forKey: kAELabel) as? String {
                    theLabel = value
                    if let data = data {
                        let gaiDict = GAIDictionaryBuilder.createEvent(withCategory: data.value(forKey: kGAEventsCategoryName) as! String, action: logString, label: theLabel, value: nil)
                        tracker?.send(gaiDict?.build() as! [AnyHashable : Any]!)
                    }
                }else {
                    let gaiDict = GAIDictionaryBuilder.createEvent(withCategory:kAEUserCategory, action: log, label: logString, value: nil)
                    tracker?.send(gaiDict?.build() as! [AnyHashable : Any]!)
                }
            }
        }
    }
    
    private static func setAnswersEvent(type : eAnswersType, withLog log : String, withData data : NSDictionary? ){
        let updatedData = NSMutableDictionary(dictionary: data!)
        updatedData.removeObject(forKey: kAnswersType)
        let logString = "iOS_"+log
        switch type {
        case .login:
            Answers.logLogin(withMethod: "User",
                             success: true,
                             customAttributes: updatedData as? [String : Any])
            break
        case .signup:
            Answers.logSignUp(withMethod: "New User",
                              success: true,
                              customAttributes: [:])
            break
        case .search:
            Answers.logSearch(withQuery: logString,
                              customAttributes: updatedData as? [String : Any])
            break
        case .customEvents:
            Answers.logCustomEvent(withName: logString,
                                   customAttributes: updatedData as? [String : Any])
            break
        }
    }
    
    public static func setMixpanelLoginConfiguration(_ user:HSUser) {
        Mixpanel.mainInstance().identify(distinctId: user.user_id!)
    }
    
    public static func setMixpanelPeopleConfiguration(_ user:HSUser) {
        Mixpanel.mainInstance().createAlias(user.user_id!, distinctId: Mixpanel.mainInstance().distinctId)
        
        Mixpanel.mainInstance().people.set(properties: [
            "$first_name": user.firstname!,
            "$last_name": user.lastname!,
            "$email": user.email!,
            "$phone": user.mobile!
            ])
    }
    public static func setMixpanelTrackRevene(_ charge:Double) {
        Mixpanel.mainInstance().people.trackCharge(amount: charge, properties: ["time":Date()])
    }
}
