//
//  HSSystemConstant.swift
//  Handstand
//
//  Created by Fareeth John on 4/3/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import Foundation
import UIKit

let appDelegate : HSAppDelegate = UIApplication.shared.delegate as! HSAppDelegate

//IAP
let monthlySubID                = "com.handstandapp.trainers.monthlyVideoPlan"
let yearlySubID                 = "com.handstandapp.trainers.yearlyVideoPlan"
let trialSubID                  = "com.handstandapp.trainers.freetrail"
let fourteen99ID                = "com.handstandapp.monthlysubscription.14.99"
let nine99ID                    = "com.handstandapp.monthlysubscription.9.99"

let isSubcriptionDisplayed      = "isSubcriptionDisplayed"
let iapPeriodWeekly             = "Weekly"
let iapPeriodMonthly            = "Monthly"
let iapPeriodYearly             = "Yearly"
let iapPrivacyLink              = "https://www.handstandapp.com/mobile-privacy"
let iapSubscriptionInfoLink     = "http://www.handstandapp.com/mobile-subscription"

//System
let googleMapsAPIKey            = "AIzaSyDLkOsb1w5ffKLI7c5hTuZI1Ft0TSOTFIg"
let userZipCode                 = "userZipCode"
let userDefaultLocation         = "userDefaultLocation"

#if Handstand
var stripePublishableKey        = "pk_live_EJkEEgYOjw2SDeyCp5TYuXtN"
var googleAnalyticsTrackID      = "UA-54900113-1"
let kMixpanelToken              = "f4e72804815845c9b723d5ffc6167313"
#elseif HandstandStage
var stripePublishableKey        = "pk_test_nLYXFoOg61djfAtQWuBCGS2M"
//var kahunaSecretKey: String   = "f0b725597a40439b9bc2fe0919e379f9"
var googleAnalyticsTrackID      = "UA-99898702-1"
let kMixpanelToken              = "a4739c09769dc805edecbb857ad3fa85"
#endif
let kAppsFlyerDevKey            = "JHXbMHMTizRM53CAuoBDnS"
let kAppsFlyerAppID             = "943258959"
let analyticsType               = [eAnalyticsType.googleAnalyticsEvent, .mixpanel, .facebook, .appsflyer, .kahuna]

//Kahuna
var kahunaSecretKey: String     = "3d406a8d078b47b8b29cf7af71e5b9d9"

//User
let userToken                   = "token"
let kUserEmail                  = "userEmail"
let kUserPassword               = "userPassword"

//Home
let seenVideoID                 = "seenVideoID"
let reebokShopURL               = "https://goo.gl/pFjO1w"
let blogHandstandURL            = "http://blog.handstandapp.com/"
let tileShareURL                = "https://itunes.apple.com/us/app/handstand-workouts-on-demand/id943258959"

//Trainer Filter
let trainerFilterZip            = "zip_code"
let trainerFilterDate           = "date"
let trainerFilterTime           = "time"
let trainerFilterClass          = "goal"
let trainerFilterOffset         = "offset"

//Payment
let kPaymentTypeCard            = "Card"
let kSingleSessionCost          = "79"

//Media Center
let kMCAudioDidPlay             = "kMCAudioDidPlay"
let kMCAudioDidPause            = "kMCAudioDidPause"

struct AppCons {
    static let APPNAME:String = "HANDSTAND"
    static let TERMS_CONS:String = "https://handstandapp.com/pages/terms-and-conditions"
    static let PRIVACY_POLICY:String = "http://www.reebok.com/us/customer_service/privacy-policy.php"
    static let APPID:String = "id943258959"
    static let CONTACTUS:String = "info@handstandapp.com"
}

struct ScreenCons {
   static let NAVBAR_HEIGHT:CGFloat = 60
   static let SCREEN_WIDTH  = UIScreen.main.bounds.width
   static let SCREEN_HEIGHT = UIScreen.main.bounds.height
}
