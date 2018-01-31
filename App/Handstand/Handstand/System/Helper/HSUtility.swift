//
//  HSUtility.swift
//  Handstand
//
//  Created by Fareeth John on 4/4/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSUtility: NSObject {
    class func getTopController() -> UIViewController {
        var topController = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        if topController is HSBaseNavigationController {
            let navCntrl = topController as! HSBaseNavigationController
            topController = navCntrl.visibleViewController
        }
        return topController!
    }
    
    class func showMessage(string : String?,title:String?=nil)  {
        let  alertView : UIAlertController = UIAlertController(title: title ?? "", message: string, preferredStyle: .alert)
        let okActionHandler = { (action:UIAlertAction!) -> Void in
        }
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: okActionHandler)
        alertView.addAction(defaultAction)
        HSUtility.getTopController().present(alertView, animated: false, completion: nil)
    }
    
    class func showMessage(string : String, onUserResponse response : @escaping (Bool) -> Void )  {
        let  alertView : UIAlertController = UIAlertController(title: "", message: string, preferredStyle: .alert)
        let okActionHandler = { (action:UIAlertAction!) -> Void in
            response(true)
        }
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: okActionHandler)
        alertView.addAction(defaultAction)
        HSUtility.getTopController().present(alertView, animated: false, completion: nil)
    }
    
    class func showMessage(string : String, withButtons buttons : Array<String>,  onUserResponse response : @escaping (String) -> Void )  {
        let  alertView : UIAlertController = UIAlertController(title: "", message: string, preferredStyle: .alert)
        
        for theButton in buttons {
            let okActionHandler = { (action:UIAlertAction!) -> Void in
                response(action.title!)
            }
            let defaultAction = UIAlertAction(title: theButton, style: .default, handler: okActionHandler)
            alertView.addAction(defaultAction)
        }
        HSUtility.getTopController().present(alertView, animated: false, completion: nil)
    }
    
    class func showMessage(message : String, withTitle title : String, withButtons buttons : Array<String>,  onUserResponse response : @escaping (String) -> Void )  {
        let  alertView : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for theButton in buttons {
            let okActionHandler = { (action:UIAlertAction!) -> Void in
                response(action.title!)
            }
            let defaultAction = UIAlertAction(title: theButton, style: .default, handler: okActionHandler)
            alertView.addAction(defaultAction)
        }
        HSUtility.getTopController().present(alertView, animated: false, completion: nil)
    }
    
    
    
    class func isValidEmailID(string : String) -> Bool{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}";
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: string)
    }
    
    class func showLocalNotification(message : String){
        let notification = UILocalNotification()
        notification.fireDate = Date(timeIntervalSinceNow: 0)
        notification.alertBody = message
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    class func generateRandomCode() -> Int{
        let rangeLow  = 10000
        let randomNumber = Int(arc4random() % 90000) + rangeLow
        return randomNumber
    }
    
    class func isSubcriptionShown() -> Bool {
        if let theValue = UserDefaults.standard.value(forKey: isSubcriptionDisplayed) as? Bool {
            return theValue
        }
        return false
    }
    
    class func setSubcriptionShown()  {
        UserDefaults.standard.setValue(true, forKey: isSubcriptionDisplayed)
    }
    
    class func getSeenVideoID() -> String? {
        var videoID : String? = nil
        if let theValue = UserDefaults.standard.value(forKey: seenVideoID) as? String {
            videoID = theValue
        }
        return videoID
    }
 
    class func setSeenVideoID(_ id : String)  {
        UserDefaults.standard.setValue(id, forKey: seenVideoID)
    }
    
    class func spellInt(_ num : Int) -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return formatter.string(from: NSNumber(integerLiteral: num))!
    }
    
    class func getIAP_Receipt() -> String?{
        let url = Bundle.main.appStoreReceiptURL
        let data = try! Data.init(contentsOf: url!)
        return data.base64EncodedString(options: [])
    }
    
    class func getAppVersion() -> String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return ""
    }
    
    class func getVersionNumber(_ version : String) -> Int {
        let versions = version.components(separatedBy: ".")
        var theVerNum = 0
        if versions.count > 0 {
            theVerNum = Int(versions[0])! * 1000
            if versions.count > 1 {
                theVerNum += Int(versions[1])! * 100
            }
            if versions.count > 2 {
                theVerNum += Int(versions[2])!
            }
        }
        return theVerNum
    }
        
}
