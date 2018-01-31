import UIKit

@UIApplicationMain
class HSAppDelegate: UIResponder,UIApplicationDelegate {
    
    lazy var app = HSApp()
    lazy var window: UIWindow? = { let w =  UIWindow()
        w.backgroundColor = .white
        w.makeKeyAndVisible()
        return w }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let window = window {
            return app.application(window, application: application, didFinishLaunchingWithOptions: launchOptions)
        };return false
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        app.applicationDidBecomeActive(application)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        app.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        app.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        app.application(application, didReceiveRemoteNotification: userInfo)
    }
    
}
