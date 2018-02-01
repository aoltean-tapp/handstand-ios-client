 import UIKit

//MARK: - Enum|AddressSectionTypes
enum AddressSectionTypes:Int {
    case Recent
    case Suggestions
    func desc()->String {
        switch self {
        case .Recent:return "Recents"
        case .Suggestions:return "Locations"
        }
    }
}
 enum locationChangeState {
    case user
    case auto
 }
//MARK: - Class|Starts
final class HSHomeController: HSBaseController {
    
    //MARK:- iVars
    @IBOutlet var mapBaseView: UIView! {
        didSet { observeMapWhenEnterForground() }
    }
    @IBOutlet fileprivate weak var searchBar: UISearchBar! {
        didSet { searchBar.delegate = self; searchBar.setCustomAppearance() }
    }
    
    fileprivate lazy var comingSoonView: HSHomeComingSoonView = {
        let view = HSHomeComingSoonView.fromNib() as HSHomeComingSoonView
        view.delegate = self
        return view
    }()
    lazy var resultsTableView: UITableView = {
        let t = UITableView.init(frame: CGRect.zero)
        t.backgroundColor = HSColorUtility.tableViewBackgroundColor()
        t.separatorStyle = .none
        t.register(HSHomeSearchCell.nib(), forCellReuseIdentifier: HSHomeSearchCell.reuseIdentifier())
        t.register(HSHomeLocationRecentsCell.nib(), forCellReuseIdentifier: HSHomeLocationRecentsCell.reuseIdentifier())
        t.delegate = self
        t.dataSource = self
        t.tableFooterView = UIView()
        t.keyboardDismissMode = .interactive
        t.estimatedRowHeight = 44.0
        return t
    }()
    lazy var mapView: HSHomeMapView = {
        let mView = HSHomeMapView.fromNib() as HSHomeMapView
        mView.delegate = self
        return mView
    }()
    fileprivate let addressSectionDataSource:[AddressSectionTypes] = {
        return [.Recent,.Suggestions]
    }()
    fileprivate lazy var recentAddressDataSource: [HSRecentAddress] = {
        return HSUserManager.shared.getRecentTrainerSearchLocation()
    }()
    fileprivate var addressDataSource:[HSAddress] = []
    fileprivate lazy var locationEnableView : HSHomeSetZipView = {
        let view = HSHomeSetZipView.fromNib() as HSHomeSetZipView
        view.delegate = self
        return view
    }()
    fileprivate var selectedAddress : HSAddress?{didSet{
        self.navigationItem.rightBarButtonItem?.isEnabled = (selectedAddress == nil) ? false : true
        self.navigationItem.rightBarButtonItem?.customView?.alpha = (selectedAddress == nil) ? 0.5 : 1.0
        }}
    fileprivate var currentLocation: HSAddress?
    fileprivate var viewArray = [UIView]()
    let locationManager = CLLocationManager()

    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = HSA.mapScreen
        view.addSubview(locationEnableView)
        view.addSubview(resultsTableView)
        mapBaseView.addSubview(mapView)
        registerForKeyboardNotifications()
        viewArray = [locationEnableView,mapBaseView,resultsTableView]
        //_ = viewArray.map{$0.isHidden = true}
        viewArray.forEach { (v) in
            v.isHidden = true
        }
        HSNavigationBarManager.shared.applyProperties(key: .type_13, viewController: self,titleView:self.getTitleLabelView())
        self.viewToShow(self.mapBaseView)
        self.mapView.setMyLocation()

        //        setMyLocation()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.resultsTableView.frame = self.mapBaseView.frame
        self.mapView.frame = CGRect(x:0,y:0,width:self.mapBaseView.frame.width,height:self.mapBaseView.frame.height)
        self.locationEnableView.frame = self.view.bounds
        self.comingSoonView.frame = self.view.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Selectors
    @objc private func didTapNextButton() {
        self.searchBar.endEditing(true)
        if let selectedAddress = self.selectedAddress {
            if selectedAddress.zipCode.isEmpty == true {
                //do reverse geo
                self.reverseGeoCode(selectedAddress.location!)
            }else {
                self.searchTrainer(with: selectedAddress.zipCode, location: selectedAddress.location!)
            }
        }else {
            let alertController = UIAlertController.init(title: AppCons.APPNAME, message: "Enter your Location to search Trainers", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default, handler: {[weak self] (tapped) in
                self?.searchBar.becomeFirstResponder()
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
    
    //MARK: - Selectors
    @objc private func keyboardWasShown(aNotification: NSNotification) {
        let info = aNotification.userInfo as! [String: AnyObject],
        kbSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size,
        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        resultsTableView.contentInset = contentInsets
        resultsTableView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
        
        self.resultsTableView.scrollRectToVisible(searchBar!.frame, animated: true)
    }
    
    @objc private func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.resultsTableView.contentInset = contentInsets
        self.resultsTableView.scrollIndicatorInsets = contentInsets
    }
    
    //MARK: - Private functions
    fileprivate func viewToShow(_ view:UIView) {
        viewArray.forEach { v in
            if v == view {
                v.isHidden = false
            }else {
                v.isHidden = true
            }
        }
    }
    fileprivate func getTitleLabelView()->UILabel {
        let label = UILabel()
        label.text = "Find a Local Personal Trainer"
        label.textColor = UIColor.rgb(0x2A2A2A)
        label.font = HSFontUtilities.avenirNextDemiBold(size: 17)
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        return label
    }
    
    private func observeMapWhenEnterForground() {
        NotificationCenter.default.removeObserver(self)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.checkLocationSettings), name: NSNotification.Name.UIApplicationWillEnterForeground , object: nil)
    }
    @objc private func checkLocationSettings()  {
        mapView.setMyLocation()
    }
    
    private func showComingSoonForCity(_ city : String){
        HSNavigationBarManager.shared.applyProperties(key: .type_14, viewController: self)
        comingSoonView.setCity(city)
        view.addSubview(comingSoonView)
    }
    fileprivate func searchTrainer(with zipCode:String,location:CLLocation) {
        self.startLoading()
        HSTrainerNetworkHandler().getTrainerForInfo(zipcode: zipCode, forLocation: location, completionHandler: {[weak self] (trainers, error) in
            self?.stopLoading()
            if error == nil{
                if trainers.count > 0{
                    let trainerListCntrl = HSTrainerListController()
                    trainerListCntrl.trainers = trainers
                    trainerListCntrl.selectedAddress = self?.selectedAddress!
                    self?.navigationController?.pushViewController(trainerListCntrl, animated: true)
                }else{
                    if ((self?.selectedAddress?.city)!.length()>0) {
                        self?.showComingSoonForCity((self?.selectedAddress?.city)!)
                    }else {
                        self?.showComingSoonForCity((self?.selectedAddress?.addressLine1)!)
                    }
                }
            }else{
                if error?.code == eErrorType.notAvailable || error?.code == eErrorType.noContent{
                    if let _selectedAddress = self?.selectedAddress {
                        if _selectedAddress.city.length()>0 {
                            self?.showComingSoonForCity(_selectedAddress.city)
                        }else {
                            self?.showComingSoonForCity(_selectedAddress.addressLine1)
                        }
                    }
                }else{
                    HSUtility.showMessage(string: (error?.message)!)
                }
            }
        })
    }
    
    fileprivate func getHeaderView(with desc:String)->UIView? {
        let label = UILabel.init(frame: CGRect(x:15,y:2.5,width:self.resultsTableView.frame.width-(2*15),height:25))
        label.text = desc
        label.font = HSFontUtilities.avenirNextDemiBold(size: 17)
        label.textColor = UIColor.rgb(0x2A2A2A)
        label.textAlignment = .left
        label.sizeToFit()
        let h_view = UIView.init(frame: CGRect(x:0,y:0,width:self.resultsTableView.frame.width,height:30))
        h_view.backgroundColor = resultsTableView.backgroundColor
        h_view.addSubview(label)
        return h_view
    }
    
    fileprivate func didTapSuggestion(with placeId:String) {
        HSAddressNetworkHandler().getAddressForPlaceID(placeID: placeId, onComplete: {[weak self](aAddress, error) in
            if error == nil{
                self?.searchBar.text = aAddress?.formatedAddress
                self?.mapView.showLocationWithoutDelegate((aAddress?.location?.coordinate)!)
                self?.selectedAddress = aAddress
                if let formattedAddress = aAddress?.formatedAddress,
                    let zipcode = aAddress?.zipCode,
                    let placeId = aAddress?.placeId {
                    let locationDictionary = ["latidude":aAddress?.location?.coordinate.latitude,
                                              "longitude":aAddress?.location?.coordinate.longitude]
                    let recentDictionary:[String:Any] = ["formatted_address":formattedAddress,
                                                         "location":locationDictionary,
                                                         "zip_code":zipcode,
                                                         "placeid":placeId]
                    let recentAddress = HSRecentAddress.init(object: recentDictionary)
                    HSUserManager.shared.setRecentTrainerSearchLocation(address:recentAddress)
                }
            }else{
                HSUtility.showMessage(string: (error?.message)!)
            }
        })
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(aNotification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(aNotification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func searchTrainerForCurrentLocation() {
        if let address = self.currentLocation {
            if (address.zipCode.count) > 0 {
                if let cLocation = self.currentLocation {
                    self.selectedAddress = address
                    self.searchTrainer(with: cLocation.zipCode, location: cLocation.location!)
                }
            }else{
                HSAddressNetworkHandler().getGeoLocationFromLocation((self.currentLocation?.location?.coordinate)!, onComplete: { [weak self] (address, error) in
                    if error == nil {
                        self?.currentLocation?.zipCode = (address?.zipCode)!
                        self?.selectedAddress = address
                        self?.searchTrainer(with: (self?.currentLocation?.zipCode)!, location: (self?.currentLocation?.location)!)
                    }
                })
            }
        }else {
            let alertController = UIAlertController.init(title: AppCons.APPNAME, message: "Enter your Location to search Trainers", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default, handler: {[weak self] (tapped) in
                self?.searchBar.becomeFirstResponder()
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
}

//MARK: - Extension|HSHomeMapViewDelegate
extension HSHomeController:HSHomeMapViewDelegate {
    func didLocationDisabled(){
        HSNavigationBarManager.shared.applyProperties(key: .type_14, viewController: self)
        self.locationEnableView.zipTextfield.text = ""
        self.locationEnableView.setZipButton.isHidden = true
        viewToShow(self.locationEnableView)
    }
    
    func didLocationEnabled(){
        HSNavigationBarManager.shared.applyProperties(key: .type_13, viewController: self)
        viewToShow(self.mapBaseView)
    }
    
    func didChangeLocation(_ aMapView : HSHomeMapView, _ state: locationChangeState = .auto){
        self.searchBar.text = ""
        var currentLocation:CLLocationCoordinate2D?
        if state == .auto {
            currentLocation = locationManager.location?.coordinate
        } else {
            currentLocation = mapView.centerCoordinate()
        }
        if currentLocation == nil {
            HSLoadingView.standardLoading().stopLoading()
            return
        }
        HSAddressNetworkHandler().getGeoLocationFromLocation(currentLocation!, onComplete: {[weak self] (address, error) in
            if error == nil{
                DispatchQueue.main.async {
                    HSLoadingView.standardLoading().stopLoading()
                    HSAnalytics.setEventForTypes(withLog: HSA.mapLocation)
                    self?.currentLocation = address
                    self?.selectedAddress = address
                    if self?.searchBar.text?.isEmpty == true {
                        self?.searchBar.text = address?.formatedAddress
                    }
                }
            }
        })
    }

    func RKdidChangeLocation(_ aMapView : HSHomeMapView){
        guard let currentLocation = locationManager.location?.coordinate else {return}
        HSAddressNetworkHandler().getGeoLocationFromLocation(currentLocation, onComplete: {[weak self] (address, error) in
        if error == nil{
            DispatchQueue.main.async {
                HSLoadingView.standardLoading().stopLoading()
                HSAnalytics.setEventForTypes(withLog: HSA.mapLocation)
                self?.currentLocation = address
                self?.selectedAddress = address
                self?.searchBar.text = address?.formatedAddress
                self?.mapView.showLocationWithoutDelegate(currentLocation)
                //self?.searchTrainerForCurrentLocation()
            }
        }
    })
    }

    func didClickedOnMyLocation(){
        mapView.setMyLocation()
    }

    func setMyLocation()  {
        if YMLocationManager.shared().isLocationServiceAvailable() == true{
            YMLocationManager.shared().reInitialiseLocationManager()
            YMLocationManager.shared().checkLocationStatusAndAlertUser()
            YMLocationManager.shared().refreshLocation { (aLat, aLong, err) in
                if err == nil{
                    self.viewToShow(self.mapBaseView)
//                    self.mapView.setMyLocation()
                    self.RKdidChangeLocation(self.mapView)
                }
                else{
                    self.didLocationDisabled()
                }
            }
        }
            //        else if let userLocation = HSLocationHelper.getUserDefaultLocation(){
            //            self.mapView.showLocation(userLocation.coordinate)
            //        }
        else{
            self.didLocationDisabled()
        }
    }

    func reverseGeoCode(_ location:CLLocation) {
        HSLoadingView.standardLoading().startLoading()
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if let _ = error {
                HSLoadingView.standardLoading().stopLoading()
                //debugPrint("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            if let placemark_count = placemarks?.count {
                if  placemark_count > 0 {
                    let pm = placemarks![0] as CLPlacemark
                    self.displayLocationInfo(placemark: pm)
                } else {
                    HSLoadingView.standardLoading().stopLoading()
                    debugPrint("Problem with the data received from geocoder")
                }
            }
        })
    }

    fileprivate func displayLocationInfo(placemark: CLPlacemark) {
        HSLoadingView.standardLoading().stopLoading()
        if let postal_code = placemark.postalCode {
            self.selectedAddress?.zipCode = postal_code
            self.searchTrainer(with: postal_code, location: (self.selectedAddress?.location!)!)
        }
    }
}

//MARK: - Extension|UITableViewDelegate&UITableViewDataSource
extension HSHomeController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return addressSectionDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case AddressSectionTypes.Recent.rawValue:
            //Add.+1=>Current Location
            return recentAddressDataSource.count+1
        case AddressSectionTypes.Suggestions.rawValue:
            return addressDataSource.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case AddressSectionTypes.Recent.rawValue:
            let cell:HSHomeLocationRecentsCell = tableView.dequeueReusableCell(withIdentifier: HSHomeLocationRecentsCell.reuseIdentifier()) as! HSHomeLocationRecentsCell
            cell.selectionStyle = .none
            if self.recentAddressDataSource.count == 0 || indexPath.row == self.recentAddressDataSource.count {
                cell.populate(text: "Current Location", image: #imageLiteral(resourceName: "icCurrentLocationLocator"))
            }else {
                if indexPath.row != recentAddressDataSource.count {
                    let address = self.recentAddressDataSource[indexPath.row]
                    cell.populate(text: address.formattedAddress!, image: #imageLiteral(resourceName: "icRecentLocationPin"))
                }
            }
            return cell
        case AddressSectionTypes.Suggestions.rawValue:
            let cell:HSHomeSearchCell = tableView.dequeueReusableCell(withIdentifier: HSHomeSearchCell.reuseIdentifier()) as! HSHomeSearchCell
            cell.selectionStyle = .none
            let theAddress = addressDataSource[indexPath.row]
            cell.addressTitleLabel.text = theAddress.addressLine1
            cell.addressDetailLabel.text = theAddress.addressLine2
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.text = ""
        self.selectedAddress = nil
        self.view.findFirstResonder()?.resignFirstResponder()
        self.viewToShow(self.mapBaseView)
        switch indexPath.section {
        case AddressSectionTypes.Recent.rawValue:
            if indexPath.row == recentAddressDataSource.count {
                //current Location
                self.setMyLocation()
            }else {
                let recentAddress = recentAddressDataSource[indexPath.row]
                self.searchBar.text = recentAddress.formattedAddress
            self.mapView.showLocationWithoutDelegate((recentAddress.location?.getLocation())!)
                didTapSuggestion(with: recentAddress.placeId!)
            }
            break
        case AddressSectionTypes.Suggestions.rawValue:
            let suggesstedAddress = addressDataSource[indexPath.row]
            didTapSuggestion(with: suggesstedAddress.placeId)
            break
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case AddressSectionTypes.Recent.rawValue:
            let desc = AddressSectionTypes.Recent.desc()
            return getHeaderView(with: desc)
        case AddressSectionTypes.Suggestions.rawValue:
            return (addressDataSource.count>0) ? getHeaderView(with: AddressSectionTypes.Suggestions.desc()) : nil
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case AddressSectionTypes.Recent.rawValue:
            return 25
        case AddressSectionTypes.Suggestions.rawValue:
            return (addressDataSource.count>0) ? 25 : 0
        default:
            return 0
        }
    }
    
}

//MARK: - Extension|HSHomeSetZipViewDelegate
extension HSHomeController:HSHomeSetZipViewDelegate {
    func didClickedOnEnableLocation(){
        HSAnalytics.setEventForTypes(withLog: HSA.locationPermissionClick)
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    func didClickedOnSetZip(_ zipcode : String){
        HSLoadingView.standardLoading().startLoading()
        HSAddressNetworkHandler().getGeoLocationForZipCode(zipcode: zipcode, onComplete: {[weak self](address, error) in
            HSNavigationBarManager.shared.applyProperties(key: .type_13, viewController: self!)
            HSLoadingView.standardLoading().stopLoading()
            if address != nil{
                DispatchQueue.main.async {
                    self?.selectedAddress = address
                    if let mapBaseView = self?.mapBaseView {
                        self?.viewToShow(mapBaseView)
                    }
                    HSLocationHelper.setUserZipCode(zipcode)
                    self?.currentLocation = address
                    if let coordinate = self?.currentLocation?.location?.coordinate {
                        self?.mapView.showLocation(coordinate)
                    }
                    //                self?.mapView.setMyLocation()
                    self?.searchBar.text = self?.selectedAddress?.formatedAddress
                }
            }
            else{
                HSUtility.showMessage(string: (error?.message)!)
            }
        })
    }
}

//MARK: - Extension|UISearchBarDelegate
extension HSHomeController:UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.viewToShow(self.resultsTableView)
        self.recentAddressDataSource = HSUserManager.shared.getRecentTrainerSearchLocation()
        self.resultsTableView.reloadSections(IndexSet.init(integer: AddressSectionTypes.Recent.rawValue), with: .automatic)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchLocationFor(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchLocationFor(searchText: searchBar.text!)
    }
    
    func searchLocationFor(searchText:String) {
        if searchText.isEmpty == true {
            self.selectedAddress = nil
            self.addressDataSource.removeAll()
            self.resultsTableView.reloadData()
            return
        }
        HSAddressNetworkHandler().searchLocationForText(searchText, onComplete: {[weak self](addressArr, error) in
            if addressArr != nil{
                if let addressArr = addressArr {
                    HSAnalytics.setEventForTypes(withLog: HSA.trainerListScreen)
                    self?.addressDataSource = addressArr
                }
            }
            DispatchQueue.main.async { self?.resultsTableView.reloadData() }
        })
    }
}

//MARK: - Extension|HSHomeComingSoonViewProtocol
extension HSHomeController:HSHomeComingSoonViewProtocol {
    func didTapCloseComingSoonView() {
        HSNavigationBarManager.shared.applyProperties(key: .type_13, viewController: self,titleView:self.getTitleLabelView())
    }
    func didTapToShowNewSubscriptionScreen() {
        self.didTapCloseComingSoonView()
        self.comingSoonView.removeFromSuperview()
        let newSubscriptionScreen = HSNewSubscriptionController()
        newSubscriptionScreen.delegate = self
        self.present(newSubscriptionScreen, animated: true, completion: nil)
    }
}

 //MARK: - Extension|NewSubscriptionProtocol
 extension HSHomeController:NewSubscriptionProtocol {
    func didCompletePurchase() {
        if HSAppManager.shared.videoSession != nil {
            showVideoViewController()
        }else{
            HSLoadingView.standardLoading().startLoading()
            HSUserNetworkHandler().getMyHomeInfo({ (video, error) in
                HSLoadingView.standardLoading().stopLoading()
                if error != nil{
                    HSUtility.showMessage(string: (error?.message)!)
                }else{
                    if HSAppManager.shared.videoSession != nil {
                        self.showVideoViewController()
                    }else {
                        HSUtility.showMessage(string: "Sorry! Video is not Available!", title: "Handstand")
                    }
                }
            })
        }
    }
    func showVideoViewController(){
        let videoVwCntrl = HSVideoViewController()
        let topController = HSUtility.getTopController()
        topController.present(videoVwCntrl, animated: true, completion: nil)
    }
 }
