import UIKit

/*enum HudPosition {
    case top,bottom
}

enum HudBgColor {
    case red,blue,gray,green
}
*/

protocol EventTrackingProtocol:class {
    func sendEvent(with log:String)
}
extension EventTrackingProtocol where Self:UIViewController {
    func sendEvent(with log:String) {
        HSAnalytics.setEventForTypes(withLog: log)
    }
}
protocol LongTaskHelperProtocol:class {
    func startLoading()
    func stopLoading()
}
extension LongTaskHelperProtocol where Self:UIViewController {
    func startLoading() {
        HSLoadingView.standardLoading().startLoading()
    }
    func stopLoading() {
        HSLoadingView.standardLoading().stopLoading()
    }
}

class HSBaseController: UIViewController,EventTrackingProtocol,LongTaskHelperProtocol {
    var screenName:String = "" {
        didSet {
            if screenName.length()>0 {
                self.sendEvent(with: screenName)
            }
        }
    }
    //internal var isErrorHudAnimating: Bool = false
    //internal var messageView:MessageView?
    //var tapGesture :UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HSNavigationBarManager.shared.applyProperties(key: .type_0, viewController: self)
    }
    
    func getTitleView()->UIImageView {
        return UIImageView.init(image: #imageLiteral(resourceName: "icHandstandLogoIcon"))
    }
}

//Navigation items Selectors
extension HSBaseController {
    func didTapBackButton() {
        HSUserManager.shared.trainerRequestAcceptType = nil
        _ = self.navigationController?.popViewController(animated: true)
    }
    func didTapHomeButton() {
        HSUserManager.shared.trainerRequestAcceptType = nil
        _ = self.navigationController?.popToRootViewController(animated: true)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notification.showHomeScreen"), object: [:])
    }
}

//Error | Success Huds
/*extension HSBaseController {
    public func showErrorHud(position: HudPosition = .top, message:String, bgColor: HudBgColor, isPermanent:Bool = false,completion:((_ tapped:Bool)->Void)? = nil) {
        messageView = MessageView.viewFromNib(layout: .messageView)
        messageView?.configureContent(title: message, body: "")
        
        switch bgColor {
        case .red:
            messageView?.configureTheme(backgroundColor:HSColorUtility.UIAppThemeErrorColor(), foregroundColor: UIColor.white, iconImage: nil, iconText: "")
            break
        case.gray:
            messageView?.configureTheme(backgroundColor:HSColorUtility.UIAppThemeLightGrayColor(), foregroundColor: UIColor.white, iconImage: nil, iconText: "")
            break
        default:
            messageView?.configureTheme(backgroundColor: UIColor.rgb(0x2babe2), foregroundColor: UIColor.white, iconImage: nil, iconText: "")
            break
        }
        
        messageView?.bodyLabel?.isHidden = true
        messageView?.titleLabel?.font = HSFontUtilities.avenirNextRegular(size: 12)
        messageView?.button?.isHidden = true
        messageView?.iconImageView?.isHidden = true
        messageView?.iconLabel?.isHidden = true
        
        var config = SwiftMessages.defaultConfig
        config.duration = .seconds(seconds: 2)
        if isPermanent == true {
            config.duration = .forever
        }
        config.dimMode = .none
        config.interactiveHide = true
        config.preferredStatusBarStyle = .lightContent
        
        messageView?.tapHandler = { _ in
            SwiftMessages.hide()
            completion!(true)
        }
        SwiftMessages.show(config: config, view: (self.messageView)!)
    }
    
}*/
