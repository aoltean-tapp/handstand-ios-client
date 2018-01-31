import UIKit
import MessageUI
import SafariServices
import ReachabilitySwift

enum eTileType:Int {
    case title
    case newTrainerAcceptance
    case upcomingSession
    case trainerRequest
    case video
    case location
    case pushNotification
    case booking
    case info
    case shop
    case buyPackage
    case share
    case blog
}

fileprivate let tileType = "tileType"

typealias HomeTileControlerProtocols =  HSSubcriptionControllerDelegate &  HSWorkoutPlanControllerDelegate &  HSPlanConfirmationControllerDelegate & SubscriptionRegisterProtocol & UIScrollViewDelegate

class HSHomeTileController: HSBaseController,HomeTileControlerProtocols {
    
    //MARK: - iVars
    @IBOutlet fileprivate weak var tableView: UITableView!{
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(HSTilesTitleCell.nib(), forCellReuseIdentifier: HSTilesTitleCell.reuseIdentifier())
            tableView.register(HSTileNewTrainerAcceptanceCell.nib(), forCellReuseIdentifier: HSTileNewTrainerAcceptanceCell.reuseIdentifier())
            tableView.register(HSTileUpcomingSessionCell.nib(), forCellReuseIdentifier: HSTileUpcomingSessionCell.reuseIdentifier())
            tableView.register(HSTileVideoCell.nib(), forCellReuseIdentifier: HSTileVideoCell.reuseIdentifier())
            tableView.register(HSTileBuyPackageCell.nib(), forCellReuseIdentifier: HSTileBuyPackageCell.reuseIdentifier())
            tableView.register(HSTileBookCell.nib(), forCellReuseIdentifier: HSTileBookCell.reuseIdentifier())
            tableView.register(HSTileInfoCell.nib(), forCellReuseIdentifier: HSTileInfoCell.reuseIdentifier())
            tableView.register(HSSubscribeTileInfoCell.nib(), forCellReuseIdentifier: HSSubscribeTileInfoCell.reuseIdentifier())
            tableView.register(HSTitleReebokShopCell.nib(), forCellReuseIdentifier: HSTitleReebokShopCell.reuseIdentifier())
            tableView.register(HSTileShareCell.nib(), forCellReuseIdentifier: HSTileShareCell.reuseIdentifier())
            tableView.register(HSTileLocationCell.nib(), forCellReuseIdentifier: HSTileLocationCell.reuseIdentifier())
            tableView.register(HSTileBlogCell.nib(), forCellReuseIdentifier: HSTileBlogCell.reuseIdentifier())
            tableView.register(HSTilePushNotificationCell.nib(), forCellReuseIdentifier: HSTilePushNotificationCell.reuseIdentifier())
            tableView.register(HSTileTrainerRequestCell.nib(), forCellReuseIdentifier: HSTileTrainerRequestCell.reuseIdentifier())
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableViewAutomaticDimension
            setupPullToRefresh()
        }
    }
    fileprivate var dataSource : [[String:eTileType]] = []
    fileprivate var refreshControl : ISRefreshControl! = nil
    fileprivate var currentUser:HSUser! = nil
    fileprivate var userTryingToConfrmBooking:Bool = false
    fileprivate lazy var subscriptionController:HSSubcriptionController = HSSubcriptionController()
    fileprivate lazy var subscribeToRegisterController:HSSubscriptionRegisterController = HSSubscriptionRegisterController()
    fileprivate lazy var newSubscriptionController:HSNewSubscriptionController = HSNewSubscriptionController()
    
    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = HSA.homePageScreen
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTileUI), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        HSNavigationBarManager.shared.applyProperties(key: .type_5, viewController: self, titleView: getTitleView())
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeSubscriptionView()
        
        currentUser = HSUserManager.shared.currentUser
        reloadTileUI()
        
        HSUserNetworkHandler().getMyHomeInfo { (success, error) in
            DispatchQueue.main.async {
                if success {
                    self.reloadTileUI()
                }
            }
        }
    }
    
    //MARK: - Private functions
    private func setupPullToRefresh() {
        refreshControl = ISRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func reloadTileUI()  {
        var tiles:[[String:eTileType]] = []
        tiles.append([tileType:eTileType.title])
        if HSAppManager.shared.declinedRequest != nil {
            tiles.append([tileType:eTileType.newTrainerAcceptance])
        }
        if HSAppManager.shared.upcomingSession != nil {
            tiles.append([tileType:eTileType.upcomingSession])
        }
        if HSAppManager.shared.trainerRequest != nil {
            tiles.append([tileType:eTileType.trainerRequest])
        }
        
        tiles.append([tileType:eTileType.video])
        tiles.append([tileType:eTileType.buyPackage])
        tiles.append([tileType:eTileType.info])
        tiles.append([tileType:eTileType.booking])
        
        if YMLocationManager.shared().isLocationServiceAvailable() == false {
            tiles.append([tileType:eTileType.location])
        }
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings: UNNotificationSettings) in
                if settings.authorizationStatus != .authorized {
                    tiles.append([tileType:eTileType.pushNotification])
                }
                tiles.append([tileType:eTileType.shop])
                tiles.append([tileType:eTileType.share])
                tiles.append([tileType:eTileType.blog])
                self.dataSource = tiles
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        } else {
            if UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert) == false{
                tiles.append([tileType:eTileType.pushNotification])
            }
            tiles.append([tileType:eTileType.shop])
            tiles.append([tileType:eTileType.share])
            tiles.append([tileType:eTileType.blog])
            self.dataSource = tiles
            self.tableView.reloadData()
        }
    }
    
    func cancelWorkoutOnDeclinedRequest() {
        if let sessionID = HSAppManager.shared.declinedRequest?.internalIdentifier?.description {
            HSLoadingView.standardLoading().startLoading()
            HSWorkoutNetworkHandler().cancelWorkoutSessionOnDelcinedRequest(forSessionID: sessionID, completionHandler: { (success, withInCancelWindow, error) in
                HSLoadingView.standardLoading().stopLoading()
                if withInCancelWindow == false {
                    HSUtility.showMessage(message: NSLocalizedString("Force_Cancel_Message", comment: "") , withTitle: NSLocalizedString("Force_Cancel_Title", comment: "") , withButtons: ["Don't Cancel","I Understand"], onUserResponse: {buttonTitle in
                        if buttonTitle == "I Understand" {
                            HSLoadingView.standardLoading().startLoading()
                            HSWorkoutNetworkHandler().forceCancelWorkoutSessionOnDeclinedRequest(forSessionID:  (HSAppManager.shared.declinedRequest?.internalIdentifier?.description)!, completionHandler: { (success, error) in
                                HSAnalytics.setEventForTypes(withLog: HSA.bookingCancelUnder12)
                                HSLoadingView.standardLoading().stopLoading()
                                if error == nil{
                                    HSUserNetworkHandler().getMyHomeInfo { (success, error) in
                                        if error != nil{
                                            HSUtility.showMessage(string: error?.message)
                                        }else{
                                            self.reloadTileUI()
                                        }
                                    }
                                }else{
                                    HSUtility.showMessage(string: error?.message)
                                }
                            })
                        }
                    })
                }else if error == nil{
                    if withInCancelWindow {
                        HSUserNetworkHandler().getMyHomeInfo { (success, error) in
                            if error != nil{
                                HSUtility.showMessage(string: error?.message)
                            }else{
                                self.reloadTileUI()
                            }
                        }
                    }
                }else{
                    HSUtility.showMessage(string: error?.message)
                }
            })
        }else{
            HSLoadingView.standardLoading().startLoading()
            HSUserNetworkHandler().getMyHomeInfo { (success, error) in
                HSLoadingView.standardLoading().stopLoading()
                if error != nil{
                    HSUtility.showMessage(string: error?.message)
                }else{
                    self.reloadTileUI()
                }
            }
        }
    }
    
    func cancelWorkout()  {
        if let sessionID = HSAppManager.shared.upcomingSession?.id {
            HSLoadingView.standardLoading().startLoading()
            HSWorkoutNetworkHandler().cancelWorkoutSession(forSessionID: sessionID, status: .accepted , completionHandler: {(success, withInCancelWindow, error) in
                HSLoadingView.standardLoading().stopLoading()
                if withInCancelWindow == false {
                    HSUtility.showMessage(message: NSLocalizedString("Force_Cancel_Message", comment: "") , withTitle: NSLocalizedString("Force_Cancel_Title", comment: "") , withButtons: ["Don't Cancel","I Understand"], onUserResponse: {buttonTitle in
                        if buttonTitle == "I Understand" {
                            HSLoadingView.standardLoading().startLoading()
                            HSWorkoutNetworkHandler().forceCancelWorkoutSession(forSessionID: (HSAppManager.shared.upcomingSession?.id)!, completionHandler: { (success, error) in
                                HSAnalytics.setEventForTypes(withLog: HSA.bookingCancelUnder12)
                                HSLoadingView.standardLoading().stopLoading()
                                if error == nil{
                                    HSUserNetworkHandler().getMyHomeInfo { (success, error) in
                                        if error != nil{
                                            HSUtility.showMessage(string: error?.message)
                                        }else{
                                            self.reloadTileUI()
                                        }
                                    }
                                }else{
                                    HSUtility.showMessage(string: error?.message)
                                }
                            })
                        }
                    })
                }else if error == nil{
                    if withInCancelWindow {
                        HSUserNetworkHandler().getMyHomeInfo { (success, error) in
                            if error != nil{
                                HSUtility.showMessage(string: error?.message)
                            }else{
                                self.reloadTileUI()
                            }
                        }
                    }
                }else{
                    HSUtility.showMessage(string: error?.message)
                }
            })
        }
        else{
            HSLoadingView.standardLoading().startLoading()
            HSUserNetworkHandler().getMyHomeInfo { (success, error) in
                HSLoadingView.standardLoading().stopLoading()
                if error != nil{
                    HSUtility.showMessage(string: error?.message)
                }else{
                    self.reloadTileUI()
                }
            }
        }
    }
    
    //MARK:- Button Action
    func onConfirmAction() {
        if Int((HSUserManager.shared.currentUser?.remainingWorkouts)!) > 0 {
            doAcceptBooking()
        }
        else{
            userTryingToConfrmBooking = true
            HSAnalytics.setEventForTypes(withLog: HSA.packages)
            HSLoadingView.standardLoading().startLoading()
            HSPassportNetworkHandler().getPackages({ (plans, error) in
                HSLoadingView.standardLoading().stopLoading()
                if error == nil {
                    let changePlanCntrl  = HSWorkoutPlanController()
                    changePlanCntrl.delegate = self
                    changePlanCntrl.plans = plans
                    changePlanCntrl.hidesBottomBarWhenPushed = true
                    HSUserManager.shared.trainerRequestAcceptType = .AcceptFromHome
                    NotificationCenter.default.removeObserver(self)
                    NotificationCenter.default.addObserver(self, selector: #selector(HSHomeTileController.doAcceptBooking), name: NSNotification.Name(rawValue: "Notification.AccpetTrainerBooking"), object: nil)
                    //                    changePlanCntrl.requester = HSController.defaultController.getMainController().navigationController?.visibleViewController
                    //                    HSController.defaultController.getMainController().navigationController?.pushViewController(changePlanCntrl, animated: true)
                    self.navigationController?.pushViewController(changePlanCntrl, animated: true)
                }else{
                    HSUtility.showMessage(string: (error?.message)!)
                }
            })
        }
    }
    
    func makeBooking(_ payment : String)  {
        if userTryingToConfrmBooking == true {
            userTryingToConfrmBooking = false
            doAcceptBooking()
        }else {
            // This call back happens during simply buying a package
        }
    }
    
    func doAcceptBooking() {
        HSUserManager.shared.trainerRequestAcceptType = nil
        HSAnalytics.setEventForTypes(withLog: HSA.trainerBookedConfirm)
        HSLoadingView.standardLoading().startLoading()
        HSWorkoutNetworkHandler().acceptWorkoutSession(forSessionID: (HSAppManager.shared.trainerRequest?.id?.description)!, completionHandler: {(success, error) in
            if error == nil{
                HSAppManager.shared.trainerRequest = nil
                HSAppManager.shared.upcomingSession = nil
                HSUserNetworkHandler().getUserProfile(completionHandler: { (success, error) in
                    HSUserNetworkHandler().getMyHomeInfo { (success, error) in
                        HSLoadingView.standardLoading().stopLoading()
                        if error != nil{
                            HSUtility.showMessage(string: error?.message)
                        }else{
                            self.reloadTileUI()
                        }
                    }
                })
            }else{
                HSLoadingView.standardLoading().stopLoading()
                HSUtility.showMessage(string: error?.message)
            }
        })
    }
    
    func onRejectAction() {
        HSAnalytics.setEventForTypes(withLog: HSA.trainerBookedReject)
        HSUtility.showMessage(message: NSLocalizedString("Decline_booking_Message", comment: ""), withTitle: NSLocalizedString("Decline_booking_Request", comment: ""), withButtons: ["Nevermind","Decline"], onUserResponse: {buttonText in
            if buttonText == "Decline" {
                HSLoadingView.standardLoading().startLoading()
                HSWorkoutNetworkHandler().declineWorkoutSession(forSessionID: (HSAppManager.shared.trainerRequest?.id?.description)!, completionHandler: {(success, error) in
                    HSLoadingView.standardLoading().stopLoading()
                    if error == nil{
                        HSAppManager.shared.trainerRequest = nil
                        HSAppManager.shared.upcomingSession = nil
                        self.reloadTileUI()
                    }else{
                        HSUtility.showMessage(string: error?.message)
                    }
                })
            }
        })
    }
    
    func showRebookForDeclinedBooking() {
        HSAnalytics.setEventForTypes(withLog: HSA.rebookTrainer)
        HSLoadingView.standardLoading().startLoading()
        let originalTrainer = HSAppManager.shared.declinedRequest?.originalTrainerDetails
        HSTrainerNetworkHandler().getTrainerInfo(forTrainer: (originalTrainer?.trainerId?.description)!, completionHandler: {(trainer, error) in
            HSLoadingView.standardLoading().stopLoading()
            if error == nil{
                let trainerCntrl = HSTrainerDetailController()
                trainerCntrl.hidesBottomBarWhenPushed = true
                let scheduleTrainer = (HSAppManager.shared.declinedRequest?.scheduleTrainer)!
                let bookingId = (HSAppManager.shared.declinedRequest?.internalIdentifier?.description)!
                trainerCntrl.rebookType = ReebookType.init(scheduledTime: scheduleTrainer,bookingId: bookingId)
                trainerCntrl.trainer = trainer
                trainerCntrl.isFromSearch = false
                trainerCntrl.selectedClass = HSAppManager.shared.declinedRequest?.speciality
                let theAddress = HSAddress(withFormatedAddress: (HSAppManager.shared.declinedRequest?.formattedLocation)!)
                theAddress.zipCode = (HSAppManager.shared.declinedRequest?.zipCode)!
                trainerCntrl.selectedAddress = theAddress
                self.navigationController?.pushViewController(trainerCntrl, animated: true)
            }else{
                HSUtility.showMessage(string: error?.message)
            }
        })
    }
    
    func refresh(sender:AnyObject) {
        HSUserNetworkHandler().getMyHomeInfo { (success, error) in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.reloadTileUI()
            }
        }
    }
    
    //MARK:- Package Delegate
    func onClickPushNotificationEnable() {
        HSAnalytics.setEventForTypes(withLog: HSA.pushPermissionClick)
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    
    //MARK: - Private functions
    internal func showNewSubscriptionScene() {
        let newSubscriptionScreen = HSNewSubscriptionController()
        self.present(newSubscriptionScreen, animated: true, completion: nil)
        
//        self.tabBarController?.tabBar.isHidden = true
//        self.newSubscriptionController.view.frame = CGRect(x:0,
//                                                        y:self.view.frame.height,
//                                                        width:ScreenCons.SCREEN_WIDTH,
//                                                        height:self.view.frame.height)
//        self.view.addSubview(self.newSubscriptionController.view)
//        self.newSubscriptionController.view.alpha = 0.0
////        self.newSubscriptionController.delegate = self
//        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
//            self.subscriptionController.view.frame = CGRect(x:0,
//                                                            y:0,
//                                                            width:ScreenCons.SCREEN_WIDTH,
//                                                            height:self.view.frame.height)
//            self.subscriptionController.view.alpha = 1.0
//        }) { (finished) in
//            HSAnalytics.setEventForTypes(withLog: HSA.subscriptionsScreen)
//        }
    }
    
   internal func showSubscriptionScene() {
        self.tabBarController?.tabBar.isHidden = true
        self.subscriptionController.view.frame = CGRect(x:0,
                                                        y:self.view.frame.height,
                                                        width:ScreenCons.SCREEN_WIDTH,
                                                        height:self.view.frame.height)
        self.view.addSubview(self.subscriptionController.view)
        self.subscriptionController.view.alpha = 0.0
        self.subscriptionController.delegate = self
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
            self.subscriptionController.view.frame = CGRect(x:0,
                                                            y:0,
                                                            width:ScreenCons.SCREEN_WIDTH,
                                                            height:self.view.frame.height)
            self.subscriptionController.view.alpha = 1.0
        }) { (finished) in
            HSAnalytics.setEventForTypes(withLog: HSA.subscriptionsScreen)
        }
    }
   public func closeSubscriptionScene() {
        self.tabBarController?.tabBar.isHidden = false
        self.subscriptionController.view.frame = CGRect(x:0,y:self.view.frame.height,width:ScreenCons.SCREEN_WIDTH,height:self.view.frame.height)
        self.subscriptionController.willMove(toParentViewController: nil)
        self.subscriptionController.view.alpha = 1.0
    
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
            self.subscriptionController.view.frame = CGRect(x:0,y:self.view.frame.height,width:ScreenCons.SCREEN_WIDTH,height:self.view.frame.height)
            self.subscriptionController.view.alpha = 0.0
        }) { (finished) in
            self.tableView.reloadData()
            self.subscriptionController.view.removeFromSuperview()
            self.subscriptionController.removeFromParentViewController()
        }
    }
    
   public func removeSubscriptionView() {
        self.tabBarController?.tabBar.isHidden = false
        self.subscriptionController.view.removeFromSuperview()
        self.subscriptionController.removeFromParentViewController()
        self.subscribeToRegisterController.view.removeFromSuperview()
        self.subscribeToRegisterController.removeFromParentViewController()
    }
    
   fileprivate func showSubscriptionRegisterScene() {
        self.tabBarController?.tabBar.isHidden = true
        self.subscribeToRegisterController.view.frame = CGRect(x:0,
                                                               y:ScreenCons.SCREEN_HEIGHT,
                                                               width:ScreenCons.SCREEN_WIDTH,
                                                               height:ScreenCons.SCREEN_HEIGHT)
        self.view.addSubview(self.self.subscribeToRegisterController.view)
        self.subscribeToRegisterController.view.alpha = 0.0
        self.subscribeToRegisterController.delegate = self
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
            self.subscribeToRegisterController.view.frame = CGRect(x:0,
                                                                   y:0,
                                                                   width:ScreenCons.SCREEN_WIDTH,
                                                                   height:ScreenCons.SCREEN_HEIGHT)
            self.subscribeToRegisterController.view.alpha = 1.0
        }) { (finished) in
            HSAnalytics.setEventForTypes(withLog: HSA.subFreeTrailScreen) }
    }
    
    internal func closeSubscriptionRegisterScene() {
        self.tabBarController?.tabBar.isHidden = false
        self.subscribeToRegisterController.view.frame = CGRect(x:0,y:self.view.frame.height,width:ScreenCons.SCREEN_WIDTH,height:self.view.frame.height)
        self.subscribeToRegisterController.willMove(toParentViewController: nil)
        self.subscribeToRegisterController.view.alpha = 1.0
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
            self.subscribeToRegisterController.view.frame = CGRect(x:0,y:self.view.frame.height,width:ScreenCons.SCREEN_WIDTH,height:self.view.frame.height)
            self.subscribeToRegisterController.view.alpha = 0.0
        }) { (finished) in
            self.tableView.reloadData()
            self.subscribeToRegisterController.view.removeFromSuperview()
            self.subscribeToRegisterController.removeFromParentViewController()
        }
    }
    
    fileprivate func takeActionOnSubscription() {
        if self.currentUser?.subscribeBefore == true {
            self.showSubscriptionScene()
        }else {
            self.showSubscriptionRegisterScene()
        }
    }
    
   @objc func didTapNotificationsButton() {
        let notificationsScreen = HSNotificationsController()
        navigationController?.pushViewController(notificationsScreen, animated: true)
    }
    
}

extension HSHomeTileController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : HSBaseTableViewCell! = nil
        let dictionary = dataSource[indexPath.row]
        let type = dictionary[tileType]!
        switch type {
        case eTileType.title:
            cell = getTableViewCell(with: HSTilesTitleCell.reuseIdentifier())
            break
        case eTileType.newTrainerAcceptance:
            cell = getTableViewCell(with: HSTileNewTrainerAcceptanceCell.reuseIdentifier())
            (cell as? HSTileNewTrainerAcceptanceCell)?.delegate = self
            break
        case eTileType.upcomingSession:
            cell = getTableViewCell(with: HSTileUpcomingSessionCell.reuseIdentifier())
            (cell as? HSTileUpcomingSessionCell)?.delegate = self
            break
        case eTileType.trainerRequest:
            cell = getTableViewCell(with: HSTileTrainerRequestCell.reuseIdentifier())
            (cell as? HSTileTrainerRequestCell)?.delegate = self
            break
        case eTileType.video:
            cell = getTableViewCell(with: HSTileVideoCell.reuseIdentifier())
            (cell as? HSTileVideoCell)?.delegate = self
            break
        case eTileType.location:
            cell = getTableViewCell(with: HSTileLocationCell.reuseIdentifier())
            (cell as? HSTileLocationCell)?.delegate = self
            break
        case eTileType.booking:
            cell = getTableViewCell(with: HSTileBookCell.reuseIdentifier())
            (cell as? HSTileBookCell)?.delegate = self
            break
        case eTileType.info:
            if HSUserManager.shared.hasValidMembership == true {
                cell = getTableViewCell(with: HSTileInfoCell.reuseIdentifier())
            }else {
                cell = getTableViewCell(with: HSSubscribeTileInfoCell.reuseIdentifier())
                (cell as? HSSubscribeTileInfoCell)?.delegate = self
            }
            break
        case eTileType.shop:
            cell = getTableViewCell(with: HSTitleReebokShopCell.reuseIdentifier())
            break
        case eTileType.buyPackage:
            cell = getTableViewCell(with: HSTileBuyPackageCell.reuseIdentifier())
            (cell as? HSTileBuyPackageCell)?.delegate = self
            break
        case eTileType.share:
            cell = getTableViewCell(with: HSTileShareCell.reuseIdentifier())
            (cell as? HSTileShareCell)?.shareButton.addTarget(self, action: #selector(showShareOption), for: .touchUpInside)
            break
        case eTileType.blog:
            cell = getTableViewCell(with: HSTileBlogCell.reuseIdentifier())
            break
        case eTileType.pushNotification:
            cell = getTableViewCell(with: HSTilePushNotificationCell.reuseIdentifier())
            (cell as? HSTilePushNotificationCell)?.delegate = self
            break
        }
        cell.populateData()
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictionary = dataSource[indexPath.row]
        let type = dictionary[tileType]!
        switch type {
        //Membership Overlays
        case eTileType.title:
            if HSUserManager.shared.hasValidMembership == false {
               /* if self.currentUser?.subscribeBefore == false {
                    //First time user
                    self.showSubscriptionRegisterScene()
                }else {
                    //Already subscribed before, but somehow got cancelled or expired
                    self.showSubscriptionScene()
                }*/
                tableView.deselectRow(at: indexPath, animated: false)
                self.showNewSubscriptionScene()
            }
            break
        case eTileType.video:
            self.onVideoAction()
            break
        case eTileType.shop:
            self.showReebokShoping()
            break
        case eTileType.share:
            self.showShareOption()
            break
        case eTileType.blog:
            self.showBlogOption()
            break
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    fileprivate func getTableViewCell<T:HSBaseTableViewCell>(with identifier:String)->T {
        if let cell:T = tableView.dequeueReusableCell(withIdentifier: identifier) as? T {
            return cell
        }
        return T()
    }
}


//MARK: - Custom Cell Protocols
typealias HomeTilesCustomCellProtocols =  HSTileNewTrainerAcceptanceCellProtocol & HSTileUpcomingSessionCellProtocol & HSTileTrainerRequestCellProtocol & HSTileVideoCellProtocol & HSTileBookCellProtocol & HSTileBuyPackageCellProtocol & HSTileLocationCellProtocol & HSTilePushNotificationCellProtocol & HSSubscribeTileInfoCellProtocol

extension HSHomeTileController:HomeTilesCustomCellProtocols {
    
    func onVideoAction(){
        let reachability = Reachability()!
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                self.videoClicked()
            }
        }
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                HSUtility.showMessage(string: NSLocalizedString("network_error", comment: ""), title: "Handstand")
            }
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func videoClicked() {
        HSAnalytics.setEventForTypes(withLog: HSA.videoDayClick)
        if HSUserManager.shared.hasValidMembership == false {
            /*if self.currentUser?.subscribeBefore == false {
                //First time user
                self.showSubscriptionRegisterScene()
            }else {
                //Already subscribed before, but somehow got cancelled or expired
                self.showSubscriptionScene()
            }*/
            self.showNewSubscriptionScene()
        }else {
            if let _ = HSAppManager.shared.videoSession?.dailyVideo {
                let videoVwCntrl = HSVideoViewController()
                self.present(videoVwCntrl, animated: true, completion: nil)
            }else {
                HSUtility.showMessage(string: "Sorry! Video is not Available!", title: "Handstand")
            }
        }
    }
    
    func showBookSession()  {
        HSAnalytics.setEventForTypes(withLog: HSA.bookTrainerTileClick)
        let homeCntrl = HSHomeController()
        homeCntrl.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(homeCntrl, animated: true)
    }
    
    func onContactAction(){
        HSAnalytics.setEventForTypes(withLog: HSA.upcomingBookingContact)
        let session = HSAppManager.shared.upcomingSession
        sentMessage(number: (session?.mobile)!)
    }
    
    func onCancelAction() {
        HSAnalytics.setEventForTypes(withLog: HSA.upcomingBookingCancel)
        HSUtility.showMessage(message: "", withTitle: NSLocalizedString("Workout_Cancel_Title", comment: "") , withButtons: ["Don't Cancel","Yes, Cancel"], onUserResponse: {buttonTitle in
            if buttonTitle == "Yes, Cancel" {
                self.cancelWorkout()
            }
        })
    }
    
    func onCancelActionForDeclinedRequest() {
        HSAnalytics.setEventForTypes(withLog: HSA.upcomingBookingCancel)
        HSUtility.showMessage(message: "", withTitle: NSLocalizedString("Workout_Cancel_Title", comment: "") , withButtons: ["Don't Cancel","Yes, Cancel"], onUserResponse: {buttonTitle in
            if buttonTitle == "Yes, Cancel" {
                self.cancelWorkoutOnDeclinedRequest()
            }
        })
    }
    
    func showLocationEnable() {
        HSAnalytics.setEventForTypes(withLog: HSA.locationPermissionClick)
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    func showReebokShoping(){
        if HSUserManager.shared.hasValidMembership == false {
            self.showNewSubscriptionScene()
//            if self.currentUser?.subscribeBefore == false {
//                //First time user
//                self.showSubscriptionRegisterScene()
//            }else {
//                //Already subscribed before, but somehow got cancelled or expired
//                self.showSubscriptionScene()
//            }
        }else {
            HSAnalytics.setEventForTypes(withLog: HSA.reebokStoreClick)
            //            HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEUserShopReebok , withData: [kGAEventsCategoryName : kAEUserCategory])
            let URL = NSURL(string: reebokShopURL)!
            if #available(iOS 9.0, *) {
                let cntrl = SFSafariViewController(url: URL as URL)
                self.present(cntrl, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL as URL)
            }
        }
    }
    
    func showBuyPackage()  {
        HSAnalytics.setEventForTypes(withLog: HSA.packages)
        HSLoadingView.standardLoading().startLoading()
        HSPassportNetworkHandler().getPackages({ (plans, error) in
            HSLoadingView.standardLoading().stopLoading()
            if error == nil {
                let changePlanCntrl  = HSWorkoutPlanController()
                changePlanCntrl.delegate = self // here we dont want any callback
                changePlanCntrl.plans = plans
                changePlanCntrl.hidesBottomBarWhenPushed = true
                //                changePlanCntrl.requester = HSController.defaultController.getMainController().navigationController?.visibleViewController
                //                HSController.defaultController.getMainController().navigationController?.pushViewController(changePlanCntrl, animated: true)
                self.navigationController?.pushViewController(changePlanCntrl, animated: true)
            }
            else{
                HSUtility.showMessage(string: (error?.message)!)
            }
        })
    }
    
   @objc func showShareOption() {
        HSAnalytics.setEventForTypes(withLog: HSA.shareHandstand)
        let shareURL = URL(string: tileShareURL)!
        let shareContect = [NSLocalizedString("share_Text", comment: "") , shareURL] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareContect, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func showBlogOption() {
        if HSUserManager.shared.hasValidMembership == false {
            self.showNewSubscriptionScene()
//            if self.currentUser?.subscribeBefore == false {
//                //First time user
//                self.showSubscriptionRegisterScene()
//            }else {
//                //Already subscribed before, but somehow got cancelled or expired
//                self.showSubscriptionScene()
//            }
        }else {
            HSAnalytics.setEventForTypes(withLog: HSA.blogArticles)
            //            HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEUserBlogHandstand , withData: [kGAEventsCategoryName : kAEUserCategory])
            let URL = NSURL(string: blogHandstandURL)!
            if #available(iOS 9.0, *) {
                let cntrl = SFSafariViewController(url: URL as URL)
                self.present(cntrl, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL as URL)
            }
        }
    }
    
    func didTapViewBenefitsBtn() {
        HSAnalytics.setEventForTypes(withLog: HSA.membershipBenefitsClick)
//        self.takeActionOnSubscription()
        self.showNewSubscriptionScene()
    }
}

extension HSHomeTileController:MFMessageComposeViewControllerDelegate{
    func didTapContactContactTrainerViaMessage(number:String) {
        sentMessage(number: number)
    }
    func didTapContactContactTrainerViaPhone(number:String) {
        callMobile(number:number)
    }
    func didTapRejectNewTrainerRequest() {
        onCancelActionForDeclinedRequest()
    }
    func didTapConfirmNewTrainerRequest() {
        onConfirmAction()
    }
    func didTapOldTrainerBookButton() {
        showRebookForDeclinedBooking()
    }
    
    //Mark:- SMS
    func sentMessage(number : String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.recipients = [number]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else{
            HSUtility.showMessage(string: NSLocalizedString("no_sms", comment: ""))
        }
    }
    //Mark:- PHONE
    func callMobile(number:String) {
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didTapCancelTheUpcomingSession() {
        let alertController = UIAlertController.init(title: AppCons.APPNAME, message: "Are you sure want to Cancel the Workout?", preferredStyle: .actionSheet)
        
        let okayAction = UIAlertAction.init(title: "OK", style: .destructive, handler: {(didTapOkayAction)in
           self.cancelWorkout()
        })
        alertController.addAction(okayAction)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
