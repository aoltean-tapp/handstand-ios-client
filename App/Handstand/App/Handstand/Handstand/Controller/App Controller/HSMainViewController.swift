import UIKit
import MessageUI

class HSMainViewController: HSBaseController, HSSubcriptionControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var backgroundView: UIView!
    var selectectedVwCntrl : UIViewController?
    let kMenuIcon = "kMenuIcon"
    let kMenuTitle = "kMenuTitle"
    let cellIdentifier = "menuCell"
    
    lazy var homeController:HSHomeTileController = HSHomeTileController()
    lazy var promotionController:HSPromotionController = HSPromotionController()
    lazy var profileController:HSProfileController = HSProfileController()
    lazy var planNPaymentController:HSPlanNPaymentController = HSPlanNPaymentController()
    lazy var subscriptionTermsController:HSSubscriptionTermsController = HSSubscriptionTermsController()
    lazy var menuController:HSMenuViewController = HSMenuViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        HSNavigationBarManager.shared.applyProperties(key: .type_1, viewController: self, titleView: UIImageView.init(image: #imageLiteral(resourceName: "titleHandstandLogo")))
        loadHomeScreen()
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(HSBaseTabBarController.pushWorkoutScreen), name: NSNotification.Name(rawValue: "Notification.showMyWorkout"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HSMainViewController.didSetHomeScreen), name: NSNotification.Name(rawValue: "Notification.showHomeScreen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HSBaseTabBarController.showBookSession), name: NSNotification.Name(rawValue: "Notification.findTrainer"), object: nil)
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        updateVideoCount()
    }
    
    // MARK: - MISC
    func updateVideoCount()  {
        if let videoID = HSUtility.getSeenVideoID() {
            if let sessionVideo = HSAppManager.shared.videoSession {
                if sessionVideo.dailyVideo.id == videoID {
                    //                    videoCountLabel.isHidden = true
                }
            }
        }
    }
    
    func didSetHomeScreen() {
        HSNavigationBarManager.shared.applyProperties(key: .type_1, viewController: self, titleView: UIImageView.init(image: #imageLiteral(resourceName: "titleHandstandLogo")))
        menuController.menuSelected = false
        menuController.currentMenu  = .home
        closeMenuScene()
        presentController(viewCntrl: homeController)
    }
    
    func showBookSession() {
        didSetHomeScreen()
        homeController.showBookSession()
    }
    
    func presentController(viewCntrl : UIViewController)  {
        backgroundView.subviews.forEach({ $0.removeFromSuperview() })
        // adjust the frame to fit in the container view
        viewCntrl.view.frame = backgroundView.frame
        var theVwFrame = viewCntrl.view.frame
        theVwFrame.origin.x = 0
        theVwFrame.origin.y = 0
        viewCntrl.view.frame = theVwFrame
        
        self.addChildViewController(viewCntrl)
        backgroundView.addSubview((viewCntrl.view)!)
        viewCntrl.didMove(toParentViewController: self)
    }
    
    func showMyWorkout() {
        self.didTapHamburgerButton()
        pushWorkoutScreen()
    }
    func pushWorkoutScreen() {
        HSAnalytics.setEventForTypes(withLog: HSA.myWorkouts)
        let workoutCntrl = HSMyWorkoutController()
        self.navigationController?.pushViewController(workoutCntrl, animated: true)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
   
    
    //MARK: - Bar Buttons
    func didTapHamburgerButton() {
        menuController.menuSelected = !menuController.menuSelected
        if menuController.menuSelected == true {
            showMenuScene()
        }else {
            closeMenuScene()
        }
        
    }
    
    func didTapUpcomingWorkoutsButton() {
        didTapHamburgerButton()
        showMyWorkout()
    }
    func showMenuScene() {
        self.menuController.view.frame = CGRect(x:0,
                                                y:-(ScreenCons.SCREEN_HEIGHT+ScreenCons.NAVBAR_HEIGHT),
                                                width:ScreenCons.SCREEN_WIDTH,
                                                height:ScreenCons.SCREEN_HEIGHT-ScreenCons.NAVBAR_HEIGHT)
        self.view.addSubview(self.menuController.view)
        self.menuController.view.alpha = 0.0
        self.menuController.delegate = self
        
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.75, options: .curveLinear, animations: {
            self.menuController.view.frame = CGRect(x:0,
                                                    y:0,
                                                    width:ScreenCons.SCREEN_WIDTH,
                                                    height:ScreenCons.SCREEN_HEIGHT-ScreenCons.NAVBAR_HEIGHT)
                self.menuController.view.alpha = 1.0
        }, completion: { (isDone) in  HSAnalytics.setEventForTypes(withLog: HSA.hamburgerMenu)
//            self.navigationController?.navigationBar.alpha = 0.5
        })
    }
    func closeMenuScene() {
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.75, options: .curveLinear, animations: {
            self.menuController.view.alpha = 0.0
              self.menuController.view.frame = CGRect(x:0,y:ScreenCons.NAVBAR_HEIGHT,width:ScreenCons.SCREEN_WIDTH,height:ScreenCons.SCREEN_HEIGHT-ScreenCons.NAVBAR_HEIGHT)
        }, completion: { (isDone) in
//            self.navigationController?.navigationBar.alpha = 1.0
            self.menuController.willMove(toParentViewController: nil)
            self.menuController.view.removeFromSuperview()
        })
    }
    
}

extension HSMainViewController:MenuTapper {
    func loadHomeScreen(){
        homeController.removeSubscriptionView()
        HSAnalytics.setEventForTypes(withLog: HSA.hamburgerHome)
        self.presentController(viewCntrl: homeController)
    }
    
    func showPlanAndPayment() {
        HSAnalytics.setEventForTypes(withLog: HSA.hamburgerPackagePay)
        self.presentController(viewCntrl: planNPaymentController)
    }
    
    func setPackagesAndPaymentsNavBar() {
        HSNavigationBarManager.shared.applyProperties(key: .type_1, viewController: self,titleView: titleView())
    }
    func setHomeNavBar() {
        HSNavigationBarManager.shared.applyProperties(key: .type_1, viewController: self, titleView: UIImageView.init(image: #imageLiteral(resourceName: "titleHandstandLogo")))
    }
    
    func titleView()->UIView {
        let label = UILabel.init()
        label.text = "Packages & Payment"
        label.font = UIFont.init(name: "AvenirNext-Medium", size: 20)
        label.textColor = UIColor.rgb(0x484848)
        label.sizeToFit()
        return label
    }
    
    func showProfileController()  {
        HSAnalytics.setEventForTypes(withLog: HSA.hamburgerProfile)
        self.presentController(viewCntrl: profileController)
    }
    
    func showContactEmail()  {
        if MFMailComposeViewController.canSendMail() {
            HSAnalytics.setEventForTypes(withLog: HSA.hamburgerContact)
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients(["info@handstandapp.com"])
            self.present(mailComposerVC, animated: true, completion: {
            })
        }else {
            HSUtility.showMessage(string: "Sorry! Could not compose an Email",title:AppCons.APPNAME)
        }
    }
    
    func showPromotionView() {
        HSAnalytics.setEventForTypes(withLog: HSA.hamburgerPromotion)
        self.presentController(viewCntrl: promotionController)
    }
    
    func showSubscriptionTerms() {
        self.presentController(viewCntrl: subscriptionTermsController)
    }
    
    func doLogout(){
        HSAnalytics.setEventForTypes(withLog: HSA.logoutClick)
        let alertController = UIAlertController.init(title: AppCons.APPNAME, message: "Are you sure want to Logout?", preferredStyle: .actionSheet)
        
        let okayAction = UIAlertAction.init(title: "Logout", style: .destructive, handler: {(didTapOkayAction)in
            HSAnalytics.setEventForTypes(withLog: HSA.logout)
            HSUserManager.shared.logout()
            let appDelegate = UIApplication.shared.delegate as! HSAppDelegate
            let navCntrl = UINavigationController(rootViewController: HSPrimaryLaunchScreen())
            
            navCntrl.isNavigationBarHidden = true
            navCntrl.navigationBar.shadowImage = UIImage()
            navCntrl.navigationBar.setBackgroundImage(UIImage(), for: .default)
            appDelegate.window?.rootViewController = navCntrl
        })
        alertController.addAction(okayAction)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func removeSubscriptions() {
        homeController.removeSubscriptionView()
    }
}
