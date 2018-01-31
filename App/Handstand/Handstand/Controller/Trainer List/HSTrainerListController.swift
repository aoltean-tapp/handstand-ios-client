//
//  HSTrainerListController.swift
//  Handstand
//
//  Created by Fareeth John on 4/19/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit
//import RMPZoomTransitionAnimator

// RMPZoomTransitionAnimating, RMPZoomTransitionDelegate, HSBaseNavigationControllerDelegate
class HSTrainerListController: HSBaseController, HSTrainerListHeaderViewDelegate {
    
    @IBOutlet var filterBaseView: UIView!
    @IBOutlet var tableView: UITableView!
    let cellIdentifier = "trainerCell"
    var trainers : Array<HSTrainer>! = []
    var filterView : HSTrainerFilterView! = nil
    var selectedAddress : HSAddress! = nil
    var selectedImage : UIImageView! = nil
    var footerView : HSTrainerListFooterView?
    var offset = 0
    let offset_Value = 20
    var isLoadedAllData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = HSA.trainerFilterScreen
        setupUI()
        HSNavigationBarManager.shared.applyProperties(key: .type_10, viewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapFilterButton() {
        didClickedOnFilter()
    }
    
    func didTapCancelButton() {
        didClickedOnFilter()
    }
    
    //MARK:- MISC
    
    func setupUI()  {
        tableView.register(UINib(nibName: "HSTrainerListCell", bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Filter UI
        filterView = HSTrainerFilterView.fromNib() as HSTrainerFilterView
        filterView.frame = CGRect(x: 0, y: 0, width: filterBaseView.frame.size.width, height: filterBaseView.frame.size.height)
        filterBaseView.addSubview(filterView)
        filterView.classTypes = HSAppManager.shared.classTypes
        filterView.zipTextfield.text = selectedAddress.zipCode
        
        //Header
        self.title = "(\(selectedAddress.zipCode)) Trainers"
    }
    
    func isFilterValueValid() -> Bool {
        if filterView.zipTextfield.text?.count == 5 {
            return true
            //            if (filterView.dateTextfield.text?.characters.count)! > 0 {
            //                if filterView.selectedClass.count > 0 {
            //                    return true
            //                }
            //                else{
            //                    HSUtility.showMessage(string: NSLocalizedString("filter_class_error", comment: ""))
            //                }
            //            }
            //            else{
            //                HSUtility.showMessage(string: NSLocalizedString("filter_date_error", comment: ""))
            //            }
        }
        else{
            HSUtility.showMessage(string: NSLocalizedString("filter_zip_error", comment: ""))
        }
        return false
    }
    
    func getFilterData() -> NSDictionary {
        let theData = NSMutableDictionary()
        theData.setValue(filterView.zipTextfield.text, forKey: trainerFilterZip)
        if (filterView.dateTextfield.text?.count)! > 0 {
            let formate = DateFormatter()
            formate.dateFormat = "yyyy-MM-dd"
            theData.setValue(formate.string(from: filterView.datePicker.date), forKey: trainerFilterDate)
            formate.dateFormat = "HH:mm"
            theData.setValue(formate.string(from: filterView.datePicker.date), forKey: trainerFilterTime)
        }
        if (filterView.classTextfield.text?.count)! > 0 {
            theData.setValue(filterView.classTextfield.text, forKey: trainerFilterClass)
        }
        if offset != 0 {
            theData.setValue(offset, forKey: trainerFilterOffset)
        }
        HSAnalytics.setEventForTypes(withLog: HSA.trainerFilterSearch+" "+theData.description)
        return theData
    }
    
    func showComingSoonForCity(_ city : String){
        //        self.comingSoonView.setCity(city)
        //        self.comingSoonBaseView.alpha = 1.0
        //        self.comingSoonBaseView.isHidden = false
    }
    
    //MARK:- Navigation Delegate
    
    /* func navigationController(_ navigationController: HSBaseNavigationController, animationControllerFor operation: HSBaseNavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
     let animator : RMPZoomTransitionAnimator = RMPZoomTransitionAnimator()
     animator.goingForward =  true
     animator.sourceTransition = self as RMPZoomTransitionAnimating & RMPZoomTransitionDelegate
     animator.destinationTransition = toVC as? RMPZoomTransitionAnimating & RMPZoomTransitionDelegate
     return animator
     }*/
    
    func imageViewFrame() -> CGRect {
        let frame = selectedImage.convert(selectedImage.frame, to: self.view.window)
        return frame
    }
    
    
    /*func transitionSourceImageView() -> UIImageView!{
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFill
        imageView.frame = imageViewFrame()
        imageView.image = selectedImage!.image
        return imageView
    }
    
    func transitionSourceBackgroundColor() -> UIColor!{
        return UIColor.white
    }
    
    func transitionDestinationImageViewFrame() -> CGRect{
        return imageViewFrame()
    }
    
    func zoomTransitionAnimator(_ animator: RMPZoomTransitionAnimator!, didCompleteTransition didComplete: Bool, animatingSourceImageView imageView: UIImageView!){
        
    }*/
    
    //MARK: - Tableview delegate
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        return trainers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:HSTrainerListCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! HSTrainerListCell!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if trainers.count > indexPath.row {
            let theTrainer = trainers[indexPath.row]
            cell.nameLabel.text = theTrainer.partialTrainerName()
            cell.specialityLabel.text = theTrainer.specialities
            cell.roundRectView.imageView.setImage(url: theTrainer.thumbnail, style:.rounded)
            cell.roundRectView.backgroundColor = HSColorUtility.getMarkerTagColor(with: theTrainer.color)
            cell.markerTag.applyTintAttribute(with: theTrainer.color)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if trainers.count > indexPath.row {
            let cell = tableView.cellForRow(at: indexPath as IndexPath) as! HSTrainerListCell
            selectedImage = cell.roundRectView.imageView
            let theTrainer = trainers[indexPath.row]
            //            let trainerCntrl = HSTrainerDetailController()
            //            trainerCntrl.trainer = theTrainer
            //            trainerCntrl.selectedAddress = self.selectedAddress
            //            self.navigationController?.pushViewController(trainerCntrl, animated: true)
            
            HSLoadingView.standardLoading().startLoading()
            HSTrainerNetworkHandler().getTrainerInfo(forTrainer: theTrainer.id, completionHandler: { (trainer, error) in
                HSLoadingView.standardLoading().stopLoading()
                if error == nil {
                    let trainerCntrl = HSTrainerDetailController()
                    trainerCntrl.trainer = trainer
                    trainerCntrl.selectedAddress = self.selectedAddress
                    self.navigationController?.pushViewController(trainerCntrl, animated: true)
                }
                else{
                    HSUtility.showMessage(string: error?.message)
                }
            })
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        if indexPath.row ==  trainers.count - 1 && self.isLoadedAllData == false {
            HSAnalytics.setEventForTypes(withLog: HSA.trainerListLoadMoreTriggered)
            offset += offset_Value
            footerView?.startLoading()
            HSTrainerNetworkHandler().getTrainerForGivenData(self.getFilterData(), onComplete: { (aTrainers, error) in
                self.footerView?.stopLoading()
                if error == nil{
                    self.trainers.append(contentsOf: aTrainers)
                    self.tableView.reloadData()
                }
                else{
                    if error?.code == eErrorType.noContent {
                        self.isLoadedAllData = true
                    }
                    else if error?.code == eErrorType.notAvailable{
                        self.isLoadedAllData = true
                    }
                    else{
                        if let msg = error?.message {
                            HSUtility.showMessage(string: msg)
                        }
                    }
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat{
        if self.isLoadedAllData == false {
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        footerView = HSTrainerListFooterView.fromNib() as HSTrainerListFooterView
        var theHeight = 0
        if self.isLoadedAllData == false {
            theHeight = 40
        }
        footerView?.frame = CGRect(x: 0, y: 0, width: Int(tableView.frame.size.width), height: theHeight)
        return footerView
    }
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
    //        return 56
    //    }
    //
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
    //        let headerView : HSTrainerListHeaderView = HSTrainerListHeaderView.fromNib()
    //        headerView.delegate = self
    //        return headerView
    //    }
    
    //MARK:- Header delegate
    
    @IBAction func onFilterSubmitAction(_ sender: HSLoadingButton) {
        HSNavigationBarManager.shared.applyProperties(key: .type_10, viewController: self)
        self.view.findFirstResonder()?.resignFirstResponder()
        if isFilterValueValid() {
            //            HSAnalytics.setEventForTypes(types: [.mixpanel], withLog: kMPFilterTrainer, withData:nil)
            //            HSAnalytics.setEventForTypes(types: analyticsType, withLog: kAEWorkoutFilterTrainers , withData: [kGAEventsCategoryName : kAEWorkoutCategory])
            sender.startLoading()
            offset = 0
            self.isLoadedAllData = false
            HSTrainerNetworkHandler().getTrainerForGivenData(self.getFilterData(), onComplete: { (aTrainers, error) in
                sender.stopLoading()
                self.trainers.removeAll()
                self.trainers = aTrainers
                if error == nil{
                    let scrollIndexPath: IndexPath = IndexPath(row: 0, section: 0)
                    self.tableView.scrollToRow(at: scrollIndexPath, at: UITableViewScrollPosition.top, animated: false)
                    self.tableView.reloadData()
                    if self.trainers.count > 0{
                        self.title = "\((self.filterView.zipTextfield.text)!) Trainers"
                        self.didClickedOnFilter()
                    }
                    else{
                        self.showComingSoonForCity((self.selectedAddress?.city)!)
                    }
                }
                else{
                    if error?.code == eErrorType.noContent {
                        HSUtility.showMessage(string: NSLocalizedString("No_Trainer", comment: ""))
                    }
                    else if error?.code == eErrorType.notAvailable{
                        self.showComingSoonForCity((self.selectedAddress?.city)!)
                    }
                    else{
                        HSUtility.showMessage(string: (error?.message)!)
                    }
                }
            })
        }
    }
    
    func didClickedOnFilter(){
        var setAlpha = 0.0
        if filterBaseView.alpha == 0 {
            setAlpha = 1.0
            HSNavigationBarManager.shared.applyProperties(key: .type_9, viewController: self)
        }else {
            HSNavigationBarManager.shared.applyProperties(key: .type_10, viewController: self)
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.filterBaseView.alpha = CGFloat(setAlpha)
        }, completion: {success in
            
        })
    }
    
}
