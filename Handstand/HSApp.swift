//
//  HSApp.swift
//  Handstand
//
//  Created by Ranjith Kumar on 8/23/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
import Stripe
import Fabric
import Mixpanel
import Crashlytics
import UserNotifications
import IQKeyboardManagerSwift

class HSApp:NSObject,KahunaDelegate,UNUserNotificationCenterDelegate {
    
   private var window:UIWindow?
    
    //MARK: - Public functions
    public func application(_ window:UIWindow, application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = window
        setupConfiguration(application: application, launchOptions: launchOptions)
        setupConfigureAppNotifications(application: application)
        setupRootScene()
        registerEventWhenFreshInstall()
        HSAppManager.shared.loadIAPProducts()
        applyGlobalTheme()
        return true
    }
    public func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerTracker.shared().trackAppLaunch()
        FBSDKAppEvents.activateApp()
    }
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Kahuna.setDeviceToken(deviceToken)
    }
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Kahuna.handleNotificationRegistrationFailure(error)
    }
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        Kahuna.handleNotification(userInfo, with: application.applicationState)
    }
    public func getAppFirstController(_ onComplete : @escaping (UIViewController?) -> ()) {
        HSOnboardingServiceHandler().startService({ (success, error) in
            if success {
                onComplete(HSBaseTabBarController())
            } else{
                if error?.code == eErrorType.invalidAppVersion {
                    self.alertUserToForceDownloadNewVersion((error?.message)!)
                }else if error?.code == eErrorType.updateAppVersion {
                    self.alertUserToDownloadNewVersion((error?.message)!)
                }else{
                    if let msg = error?.message {
                        HSUtility.showMessage(string: msg)
                    }
                }
            }
        })
    }
    public func alertUserToForceDownloadNewVersion(_ message : String) {
        HSUtility.showMessage(string: message, withButtons: ["Update"]) { (button) in
            HSAppManager.shared.openStoreProductWithiTunesItemIdentifier(identifier: kAppsFlyerAppID)
        }
    }
    public func alertUserToDownloadNewVersion(_ message : String) {
        HSUtility.showMessage(string: message, withButtons: ["Cancel","Update"]) { (button) in
            if button == "Update" {
                HSAppManager.shared.openStoreProductWithiTunesItemIdentifier(identifier: kAppsFlyerAppID)
            }
        }
    }
    
    //MARK: - Private functions
    private func applyGlobalTheme() {
        if #available(iOS 9.0, *) {
            UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.handstandGreen()
        } else {
            // Fallback on earlier versions
        }
    }
    private func registerEventWhenFreshInstall() {
        if (UserDefaults.standard.value(forKey: "isAppInstalled") as? Bool) == nil {
            UserDefaults.standard.set(true, forKey: "isAppInstalled")
            HSAnalytics.setEventForTypes(withLog: HSA.appInstall)
        }
    }
    private func setupConfigureAppNotifications(application:UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    private func setupRootScene() {
        let nc = HSBaseNavigationController()
//        nc.viewControllers = [HSNewSubscriptionController()]
        nc.viewControllers = [HSSplashController()]
//        nc.viewControllers = [HSPersonalInfoController()]
//        nc.viewControllers = [HSChoosePlanController()]
//        nc.viewControllers = [HSQuizStyleSelectionController()]
//        nc.viewControllers = [HSPaymentBeginController()]
//        nc.viewControllers = [HSSignupViewController()]
//        nc.viewControllers = [HSWhyHandstandViewController()]
//        nc.viewControllers = [HSQuizStyleResultController()]
        
        nc.isNavigationBarHidden = true
        window?.rootViewController = nc
    }
    private func setupConfiguration(application:UIApplication,launchOptions:[UIApplicationLaunchOptionsKey: Any]?) {
        //Fabric
        Fabric.with([Crashlytics.self,Answers.self])
        
        //Kahuna
        Kahuna.logout()
        Kahuna.handleNotification(launchOptions, withActionIdentifier: UIApplicationLaunchOptionsKey.remoteNotification.rawValue, with: application.applicationState)
        
        //GOOGLE MAPs initialization
        GMSServices.provideAPIKey(googleMapsAPIKey)
        GMSPlacesClient.provideAPIKey(googleMapsAPIKey)
        
        //Stripe
        STPPaymentConfiguration.shared().publishableKey = stripePublishableKey
        
        //Kahuna
        Kahuna.launch(withKey: kahunaSecretKey)
        Kahuna.enablePushNotifications()
        
        //Google Analytics
        let gai = GAI.sharedInstance()
        gai?.trackUncaughtExceptions = true
//        gai?.logger.logLevel = GAILogLevel.verbose
        _ = gai?.tracker(withTrackingId: googleAnalyticsTrackID)
        
        //Mixpanel
        Mixpanel.initialize(token: kMixpanelToken)
        
        //Appsflyer
        #if Handstand
            AppsFlyerTracker.shared().appsFlyerDevKey = kAppsFlyerDevKey
            AppsFlyerTracker.shared().appleAppID = kAppsFlyerAppID
        #endif
        
        //IQKeyboardManagerSwift
        IQKeyboardManager.sharedManager().enable = true
    }
    
}
