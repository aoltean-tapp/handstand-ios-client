//
//  HSTrainerDetailController.swift
//  Handstand
//
//  Created by Fareeth John on 4/23/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
//import RMPZoomTransitionAnimator

struct ReebookType {
    let scheduledTime:Bool
    let bookingId:String
}

//RMPZoomTransitionAnimating, RMPZoomTransitionDelegate,HSBaseNavigationControllerDelegate
class HSTrainerDetailController: HSBaseController, HSSelectionViewDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, HSWorkoutPlanControllerDelegate, HSPlanConfirmationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    enum eViewType: Int {
        case detail = 1
        case confirm = 2
    }
    public var rebookType:ReebookType?
    @IBOutlet var dateTimePicker: UIPickerView!
    //    @IBOutlet var groupCheckImage: UIImageView!
    @IBOutlet var confirmScrollView: UIScrollView!
    @IBOutlet var planLabel: UILabel!
    @IBOutlet var classBorderView: HSBorderView!
    @IBOutlet var dateBorderView: HSBorderView!
    @IBOutlet var classTextfield: UITextField!
    @IBOutlet var dateTextfield: UITextField!
    @IBOutlet var locationTextfield: UITextField!
    @IBOutlet var classTableView: UITableView!
    @IBOutlet var workoutSelectionView: HSSelectionView!
    @IBOutlet var confirmLowerView: UIView!
    @IBOutlet var dateSelectionView: HSSelectionView!
    @IBOutlet var detailScreenView: UIView!
    @IBOutlet var confirmScreenView: UIView!
    @IBOutlet var aboutView: UIView!
    @IBOutlet var loadMoreButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var specialityLabel: UILabel!
    @IBOutlet var aboutLabel: UILabel!
    //    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    
    var trainer : HSTrainer! = nil
    var currentViewType : eViewType = .detail
    var classTypes : Array<String>! = []
    var selectedClass : String! = ""
    let cellIdentifier = "classCell"
    var selectedAddress : HSAddress! = nil
    var searchCntrl : UISearchController! = nil
    let searchCellIdentifier = "searchCell"
    var address : Array<HSAddress>! = []
    var workoutSize = "1-On-1"
    var availableDates : Array<String>! = []
    var availableTimes : Array<String>! = []
    var isFromSearch : Bool = true
    var selectedDate : String! = ""
    var selectedTime : String! = ""
    @IBOutlet var chooseOnNextScreenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = HSA.trainerProfile
        HSNavigationBarManager.shared.applyProperties(key: .type_3, viewController: self)
        updateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTextContentUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let theFrame = CGRect( x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.view.frame = theFrame
        
        let requiredHeight = confirmLowerView.frame.origin.y + confirmLowerView.frame.size.height + 40
        confirmScrollView.contentSize = CGSize(width: confirmScrollView.frame.size.width, height: requiredHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        self.navigationController?.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //        self.navigationController?.delegate = HSController.defaultController.getMainController() as? UINavigationControllerDelegate
    }
    
    //MARK:- MISC
    func updateUI(){
        let imageView = UIImageView.init(frame: CGRect(x:(ScreenCons.SCREEN_WIDTH-120)/2,y:(topView.frame.height-120)/2,width:120,height:120))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.setImage(url: trainer.thumbnail, style: .rounded)
        self.topView.addSubview(imageView)
        
        self.title = trainer.partialTrainerName()
        aboutLabel.text = trainer.about
        specialityLabel.text = trainer.specialities.replacingOccurrences(of: ",", with: ", ")
        dateSelectionView.delegate = self
        classTypes = trainer.specialities.components(separatedBy: ",")
        classTableView.register(UINib(nibName: "HSTrainerClassCell", bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        classTableView.reloadData()
        if selectedAddress.zipCode.count > 0 {
            locationTextfield.text = selectedAddress.formatedAddress
        }
        if selectedClass.count > 0 {
            classTextfield.text = selectedClass
        }
        if let remainingWorkouts = HSUserManager.shared.currentUser?.remainingWorkouts {
            if remainingWorkouts > 0 {
               
                planLabel.text = "Using your Package: \(Int(remainingWorkouts)) remaining"
                chooseOnNextScreenLabel.isHidden = true
            }
        }
        //        let calendar = Calendar.current
        //        let rightNow = Date(timeIntervalSinceNow: 60*60*2)
        //        let interval = 30
        //        let nextDiff = interval - calendar.component(.minute, from: rightNow) % interval
        //        let nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: rightNow) ?? Date()
        //        datePicker.minimumDate = nextDate
        //        datePicker.date = nextDate
        //        userImageView.isHidden = self.isFromSearch
        if trainer.availableDates.count > 0 {
            selectedDate = trainer.availableDates[0]
            availableTimes = trainer.availableTime(forData: selectedDate)
            formateTimeData()
            if availableTimes.count > 0 {
                selectedTime = availableTimes[0]
            }
            dateTimePicker.reloadAllComponents()
        }
    }
    
    func updateTextContentUI() {
        let requiredClassHeight = trainer.specialities.height(withConstrainedWidth: specialityLabel.frame.size.width, font: specialityLabel.font)
        var classFrame = specialityLabel.frame
        classFrame.size.height = CGFloat(ceilf(Float(requiredClassHeight)))
        
        let requiredAboutHeight = (aboutLabel.text?.height(withConstrainedWidth: aboutLabel.frame.size.width, font: aboutLabel.font))!
        let availableHeight = scrollView.frame.size.height - classFrame.size.height
        var aboutVwFrame = aboutView.frame
        var aboutTxtFrame = aboutLabel.frame
        if availableHeight > requiredAboutHeight {
            aboutVwFrame.size.height = requiredAboutHeight + 35
            aboutTxtFrame.origin.y = 20
            aboutTxtFrame.size.height = CGFloat(ceilf(Float(requiredAboutHeight)))
            classFrame.origin.y = aboutVwFrame.size.height + 5
            loadMoreButton.isHidden = true
        }else{
            aboutVwFrame.size.height = availableHeight - 15
            aboutTxtFrame.origin.y = 10
            aboutTxtFrame.size.height = CGFloat(ceilf(Float(availableHeight-40)))
            classFrame.origin.y = aboutVwFrame.size.height + 5
            loadMoreButton.isHidden = false
        }
        aboutLabel.frame = aboutTxtFrame
        aboutView.frame = aboutVwFrame
        specialityLabel.frame = classFrame
        scrollView.isScrollEnabled = false
    }
    
    func showConfirmScreen() {
        //        HSAnalytics.setEventForTypes(types: [.googleAnalytics], withLog: kGABookingScreen, withData: nil)
        var confirmScreenFrame = confirmScreenView.frame
        confirmScreenFrame.origin.x = confirmScreenFrame.size.width
        confirmScreenView.frame = confirmScreenFrame
        confirmScreenView.isHidden = false
        confirmScreenFrame.origin.x = 0
        var detailScreenFrame = detailScreenView.frame
        detailScreenFrame.origin.x = -detailScreenFrame.size.width
        UIView.animate(withDuration: 0.5, animations: {
            self.detailScreenView.frame = detailScreenFrame
            self.confirmScreenView.frame = confirmScreenFrame
        }, completion: {success in
            self.currentViewType = .confirm
        })
    }
    
    func showDetailScreen() {
        var confirmScreenFrame = confirmScreenView.frame
        confirmScreenFrame.origin.x = confirmScreenFrame.size.width
        var detailScreenFrame = detailScreenView.frame
        detailScreenFrame.origin.x = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.detailScreenView.frame = detailScreenFrame
            self.confirmScreenView.frame = confirmScreenFrame
        }, completion: {success in
            self.currentViewType = .detail
        })
    }
    
    func setDate()  {
        let date = selectedDate + " " + selectedTime
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let dateObject = dateFormate.date(from: date) {
            dateFormate.dateFormat = "EEE, MMM d 'at' hh:mm a"
            dateTextfield.text = dateFormate.string(from: dateObject)
        }
    }
    
    func isAllFieldValid() -> Bool {
        if (dateTextfield.text?.characters.count)! > 0 {
            if (classTextfield.text?.characters.count)! > 0 {
                return true
            }
            else{
                classBorderView.setBorderColor(forType: .error)
            }
        }
        else{
            dateBorderView.setBorderColor(forType: .error)
        }
        return false
    }
    
    func getBookingData() -> NSDictionary {
        let theData = NSMutableDictionary()
        theData.setValue(HSUserManager.shared.currentUser?.accessToken, forKey: kUserAccessToken)
        theData.setValue(trainer.id, forKey: kBK_TrainerID)
        let date = selectedDate + " " + selectedTime
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateObject = dateFormate.date(from: date)
        dateFormate.dateFormat = "yyyy-MM-dd"
        theData.setValue(dateFormate.string(from: dateObject!) , forKey: kBK_Date)
        dateFormate.dateFormat = "HH:mm"
        theData.setValue(dateFormate.string(from: dateObject!) , forKey: kBK_Time)
        theData.setValue(classTextfield.text, forKey: kBK_ClassType)
        theData.setValue(locationTextfield.text, forKey: kBK_Location)
        if selectedAddress.zipCode.characters.count > 0 {
            theData.setValue(selectedAddress.zipCode, forKey: kBK_ZipCode)
        }
        theData.setValue(workoutSize, forKey: kBK_WorkoutSize)
        theData.setValue(trainer.fullName(), forKey: kBK_TrainerName)
        return theData
    }
    
    func formateTimeData() {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-MM-dd"
        let theDate = dateFormate.date(from: selectedDate)
        dateFormate.dateFormat = "HHmm"
        var advanceTime = Int(dateFormate.string(from: Date()))
        advanceTime = advanceTime! + (HSAppManager.shared.advanceHour*100)
        var updatedTime : Array<String>! = []
        for theTime in availableTimes {
            if ((theDate as? NSDate)?.isToday())! {
                dateFormate.dateFormat = "HH:mm:ss"
                let otherDate = dateFormate.date(from: theTime)
                dateFormate.dateFormat = "HHmm"
                let otherTime = dateFormate.string(from: otherDate!)
                if Int(otherTime)! >= advanceTime!  {
                    updatedTime.append(theTime)
                }
            }
            else{
                updatedTime.append(theTime)
            }
        }
        if updatedTime.count > 0 {
            availableTimes = updatedTime
        }else{
            trainer.availableDates.remove(at: 0)
            selectedDate = trainer.availableDates[0]
            availableTimes = trainer.availableTime(forData: selectedDate)
        }
        
    }
    
    //MARK:- Plan delegate
    
    func makeBooking(_ payment : String)  {
        HSLoadingView.standardLoading().startLoading()
        let theData = getBookingData()
        if rebookType != nil {
            let theDataCopy = NSMutableDictionary.init(dictionary: theData)
            theDataCopy["book_request"] = rebookType?.scheduledTime
                theDataCopy["book_id"] = rebookType?.bookingId
            HSWorkoutNetworkHandler().onDeclinedBookWorkoutSession(forData: theDataCopy, completionHandler: {(bookingID, error) in
                if bookingID != nil {
                    HSUserNetworkHandler().getUserProfile(completionHandler: { (success, error) in
                        HSLoadingView.standardLoading().stopLoading()
                        let cnfrmCntrl = HSBookingConfirmationController()
                        cnfrmCntrl.bookingData = theDataCopy
                        cnfrmCntrl.trainer = self.trainer
                        cnfrmCntrl.paymentText = payment
                        cnfrmCntrl.bookingID = bookingID
                        self.navigationController?.pushViewController(cnfrmCntrl, animated: true)
                    })
                }
                else{
                    HSLoadingView.standardLoading().stopLoading()
                    HSUtility.showMessage(string: error?.message)
                }
            })
        }else {
            HSWorkoutNetworkHandler().bookWorkoutSession(forData: theData, completionHandler: {(bookingID, error) in
                if bookingID != nil {
                    HSUserNetworkHandler().getUserProfile(completionHandler: { (success, error) in
                        HSLoadingView.standardLoading().stopLoading()
                        let cnfrmCntrl = HSBookingConfirmationController()
                        cnfrmCntrl.bookingData = theData
                        cnfrmCntrl.trainer = self.trainer
                        cnfrmCntrl.paymentText = payment
                        cnfrmCntrl.bookingID = bookingID
                        self.navigationController?.pushViewController(cnfrmCntrl, animated: true)
                    })
                }
                else{
                    HSLoadingView.standardLoading().stopLoading()
                    HSUtility.showMessage(string: error?.message)
                }
            })
        }
    }
    
    
    //MARK:- Selection view delegate
    
    func didChangeInHeight(_ height : CGFloat, onView view : HSSelectionView){
        if view == dateSelectionView {
            var lowerViewFrame = confirmLowerView.frame
            lowerViewFrame.origin.y = view.frame.origin.y + height + 20
            UIView.animate(withDuration: 0.5, animations: {
                self.confirmLowerView.frame = lowerViewFrame
            })
        }
    }
    
    //MARK:- Transistion Delegate
    
    /*  func imageViewFrame() -> CGRect {
     var frame = userImageView.convert(userImageView.frame, to: self.view.window)
     frame.origin.x = (UIScreen.main.applicationFrame.size.width - frame.size.width) / 2
     return frame
     }
     
     func transitionSourceImageView() -> UIImageView!{
     let imageView = UIImageView()
     imageView.clipsToBounds = true
     imageView.isUserInteractionEnabled = false
     imageView.contentMode = .scaleAspectFill
     imageView.frame = imageViewFrame()
     imageView.image = userImageView.image
     return imageView
     }
     
     func transitionSourceBackgroundColor() -> UIColor!{
     return UIColor.white
     }
     
     func transitionDestinationImageViewFrame() -> CGRect{
     return imageViewFrame()
     }
     
     func zoomTransitionAnimator(_ animator: RMPZoomTransitionAnimator!, didCompleteTransition didComplete: Bool, animatingSourceImageView imageView: UIImageView!){
     userImageView.isHidden = false
     }*/
    
    // MARK: - Button Action
    
    
    func takeScreenDecision() {
        switch currentViewType {
        case .detail:
            //            self.navigationController?.delegate = HSController.defaultController.getMainController() as? HSBaseNavigationControllerDelegate
            _ = self.navigationController?.popViewController(animated: true)
            break
        case .confirm:
            HSUtility.showMessage(message: NSLocalizedString("Abort_booking_message", comment: "") , withTitle: NSLocalizedString("Abort_booking_title", comment: "") , withButtons: ["No", "Yes"], onUserResponse: { (title) in
                if title == "Yes"{
                    self.showDetailScreen()
                }
            })
            break
        }
    }
    
    override func didTapBackButton() {
        self.takeScreenDecision()
    }
    
    func didTapDismissButton() {
        self.takeScreenDecision()
    }
    
    @IBAction func loadMoreAction(_ sender: UIButton) {
        if sender.titleLabel?.text == "Read More" {
            sender.setTitle("Read Less", for: .normal)
            let requiredAboutHeight = (aboutLabel.text?.height(withConstrainedWidth: aboutLabel.frame.size.width, font: aboutLabel.font))!
            var aboutVwFrame = aboutView.frame
            var aboutTxtFrame = aboutLabel.frame
            aboutVwFrame.size.height = CGFloat(ceilf(Float(requiredAboutHeight))) + 35
            aboutTxtFrame.origin.y = 15
            aboutTxtFrame.size.height = CGFloat(ceilf(Float(requiredAboutHeight)))
            var classFrame = specialityLabel.frame
            classFrame.origin.y = aboutVwFrame.size.height + 5
            aboutLabel.frame = aboutTxtFrame
            aboutView.frame = aboutVwFrame
            specialityLabel.frame = classFrame
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: classFrame.origin.y + classFrame.size.height + 20)
            scrollView.isScrollEnabled = true
        }
        else{
            scrollView.setContentOffset( CGPoint(x: 0, y: 0), animated: false)
            sender.setTitle("Read More", for: .normal)
            updateTextContentUI()
        }
    }
    
    @IBAction func onStartBookingAction(_ sender: UIButton) {
        //Analytics
        //        HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEWorkoutStartBooking , withData: [kGAEventsCategoryName : kAEWorkoutCategory])
        HSAnalytics.setEventForTypes(withLog: HSA.bookTrainer)
        showConfirmScreen()
    }
    
    @IBAction func onDateSelectionAction(_ sender: UIButton) {
        if dateSelectionView.isDetailVisible {
            dateSelectionView.hideDetailScreen()
        }
        else{
            if workoutSelectionView.isDetailVisible {
                workoutSelectionView.hideDetailScreen()
            }
            setDate()
            dateBorderView.setBorderColor(forType: .normal)
            dateSelectionView.showDetailScreen()
        }
    }
    
    @IBAction func onWorkoutSelectionAction(_ sender: UIButton) {
        if workoutSelectionView.isDetailVisible {
            workoutSelectionView.hideDetailScreen()
        }
        else{
            if dateSelectionView.isDetailVisible {
                dateSelectionView.hideDetailScreen()
            }
            let bottomOffset = CGPoint(x: 0, y: confirmScrollView.contentSize.height - confirmScrollView.bounds.size.height)
            confirmScrollView.setContentOffset(bottomOffset, animated: true)
            workoutSelectionView.showDetailScreen()
        }
    }
    
    @IBAction func onLocationAction(_ sender: UIButton) {
        let tableCntrl : HTSearchLocationController = HTSearchLocationController()
        searchCntrl = UISearchController(searchResultsController: tableCntrl)
        self.searchCntrl.searchResultsUpdater = self
        self.searchCntrl.searchBar.barTintColor = UIColor.white.withAlphaComponent(0.7)
        self.searchCntrl.searchBar.placeholder = "Search Address"
        self.searchCntrl.searchBar.backgroundColor = UIColor.black
        self.searchCntrl.hidesNavigationBarDuringPresentation = false
        self.present(self.searchCntrl, animated: true) {
            tableCntrl.tableView.delegate = self
            tableCntrl.tableView.dataSource = self
            tableCntrl.tableView.register(UINib(nibName: "HTBookClientLocationCell", bundle: nil), forCellReuseIdentifier: self.searchCellIdentifier)
        }
    }
    
    
    @IBAction func onConfirmBookingAction(_ sender: HSLoadingButton) {
        dateSelectionView.hideDetailScreen()
        workoutSelectionView.hideDetailScreen()
        if isAllFieldValid() {
            //            HSAnalytics.setEventForTypes(types: [.mixpanel], withLog: kMPBookTrainer, withData:nil)
            //Analytics
            //            HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEWorkoutContinueBooking , withData: [kGAEventsCategoryName : kAEWorkoutCategory])
            if Int((HSUserManager.shared.currentUser?.remainingWorkouts)!) > 0 {
                makeBooking("")
            }
            else{
                sender.startLoading()
                HSPassportNetworkHandler().getPackages({ (plans, error) in
                    sender.stopLoading()
                    if error == nil {
                        HSUserManager.shared.trainerRequestAcceptType = .BookTrainerFromTrainerDetail
                        NotificationCenter.default.removeObserver(self)
                        NotificationCenter.default.addObserver(self, selector: #selector(HSTrainerDetailController.didCompletedAddingSession), name: NSNotification.Name(rawValue: "Notification.BookingTrainerFromDetailScreen"), object: nil)
                        let planCntrl = HSWorkoutPlanController()
                        planCntrl.plans = plans
                        planCntrl.delegate = self
                        self.navigationController?.pushViewController(planCntrl, animated: true)
                    }
                    else{
                        HSUtility.showMessage(string: (error?.message)!)
                    }
                })
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func didCompletedAddingSession() {
        HSUserManager.shared.trainerRequestAcceptType = nil
        makeBooking("")
    }
    
    @IBAction func onGroupAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            workoutSize = "small-group"
        }
        else{
            workoutSize = "1-On-1"
        }
        //        groupCheckImage.isHidden = !sender.isSelected
    }
    
    //MARK:- Search Delegate
    
    func updateSearchResults(for searchController: UISearchController){
        let prospectiveText = searchController.searchBar.text
        if (prospectiveText?.characters.count)! > 0 {
            HSAddressNetworkHandler().searchLocationForText(prospectiveText!, onComplete: {(addressArr, error) in
                if error == nil{
                    if (addressArr?.count)! > 0{
                        self.address = addressArr
                        let tableviewCntrl : HTSearchLocationController = searchController.searchResultsController as! HTSearchLocationController
                        tableviewCntrl.tableView.reloadData()
                    }
                }
            })
        }
    }
    
    //MARK:- Picker delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if component == 0 {
            return trainer.availableDates.count
        }
        else{
            return availableTimes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let date = trainer.availableDates[row]
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "yyyy-MM-dd"
            let theDate = dateFormate.date(from: date)
            dateFormate.dateFormat = "MMM d"
            return dateFormate.string(from: theDate!)
        }
        else{
            let time = availableTimes[row]
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "HH:mm:ss"
            let theDate = dateFormate.date(from: time)
            dateFormate.dateFormat = "hh:mm a"
            return dateFormate.string(from: theDate!)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedDate = trainer.availableDates[row]
            availableTimes = trainer.availableTime(forData: selectedDate)
            formateTimeData()
            pickerView.reloadComponent(1)
            if availableTimes.count > 0 {
                selectedTime = availableTimes[0]
            }
        }
        else{
            selectedTime = availableTimes[row]
        }
        setDate()
    }
    
    //MARK: - Tableview delegate
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if classTableView == tableView {
            return classTypes.count
        }
        else{
            return address.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if classTableView == tableView {
            let cell:HSTrainerClassCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! HSTrainerClassCell!
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            if classTypes.count > indexPath.row {
                let theClass = classTypes[indexPath.row]
                cell.nameLabel.text = theClass
                if selectedClass ==  theClass{
                    cell.backgroundSelectedView.isHidden = false
                }
                else{
                    cell.backgroundSelectedView.isHidden = true
                }
            }
            return cell
        }
        else{
            let cell:HTBookClientLocationCell = tableView.dequeueReusableCell(withIdentifier: searchCellIdentifier) as! HTBookClientLocationCell!
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            let theAddress = address[indexPath.row]
            cell.titleLabel.text = theAddress.addressLine1
            cell.locationLabel.text = theAddress.addressLine2
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if classTableView == tableView {
            let theClass = classTypes[indexPath.row]
            selectedClass = theClass
            classTextfield.text = theClass
            tableView.reloadData()
            classBorderView.setBorderColor(forType: .normal)
            workoutSelectionView.hideDetailScreen()
        }
        else{
            let theAddress = address[indexPath.row]
            locationTextfield.text = theAddress.formatedAddress
            searchCntrl.dismiss(animated: true, completion: {
            })
            HSAddressNetworkHandler().getAddressForPlaceID(placeID: theAddress.placeId, onComplete: {(aAddress, error) in
                if error == nil{
                    self.selectedAddress = aAddress
                }
                else{
                    HSUtility.showMessage(string: (error?.message)!)
                }
            })
        }
    }
    
}
