//
//  HSTrainerFilterView.swift
//  Handstand
//
//  Created by Fareeth John on 4/19/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSTrainerFilterView: UIView, UITextFieldDelegate {

    @IBOutlet var zipCheckImageView: UIImageView!
    @IBOutlet var dateCheckImageView: UIImageView!
    @IBOutlet var classCheckImageView: UIImageView!
    @IBOutlet var samplingView: UIView!
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var classButton: UIButton!
    @IBOutlet var classView: UIView!
    @IBOutlet var dateSelectionView: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var dateTextfield: UITextField!
    @IBOutlet var classTextfield: UITextField!
    @IBOutlet var classTableView: UITableView!
    @IBOutlet var zipTextfield: UITextField!
    var classTypes : Array<String>! = []
    let cellIdentifier = "classCell"
    var selectedClass : Array<String>! = []

    override func awakeFromNib() {
        classTableView.register(UINib(nibName: "HSTrainerClassCell", bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
        classTableView.reloadData()
        self.perform(#selector(self.setDateForPick), with: nil, afterDelay: 0.5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var classTableFrame = samplingView.frame
        classTableFrame.size.height = samplingView.frame.size.height
        classTableView.frame = classTableFrame
    }
    
    //MARK:- MISC
    
    func setDateForPick()  {
        let calendar = Calendar.current
        let rightNow = Date(timeIntervalSinceNow: 60*60*2)
        let interval = 30
        let nextDiff = interval - calendar.component(.minute, from: rightNow) % interval
        let nextDate = calendar.date(byAdding: .minute, value: nextDiff, to: rightNow) ?? Date()
        datePicker.minimumDate = nextDate
        datePicker.date = nextDate
    }
    
    func showDatePicker()  {
        let dateRequriedHeight = (datePicker.superview?.frame.origin.y)! + datePicker.frame.size.height
        let classReq_Y = dateSelectionView.frame.origin.y + dateRequriedHeight + CGFloat(20.0)
        let classReqHeight = classTextfield.frame.size.height
        var dateFrame = dateSelectionView.frame
        dateFrame.size.height = dateRequriedHeight
        var classFrame = classView.frame
        classFrame.origin.y = classReq_Y
        classFrame.size.height = classReqHeight
        UIView.animate(withDuration: 0.5, animations: {
            self.dateSelectionView.frame = dateFrame
            self.classView.frame = classFrame
        }, completion: {success in
            self.classTableView.isHidden = true
        })
    }
    
    func hideDatePicker() {
        let dateRequriedHeight = dateTextfield.frame.size.height
        let classReq_Y = dateSelectionView.frame.origin.y + dateRequriedHeight + CGFloat(20.0)
        var dateFrame = dateSelectionView.frame
        dateFrame.size.height = dateRequriedHeight
        var classFrame = classView.frame
        classFrame.origin.y = classReq_Y
        UIView.animate(withDuration: 0.5, animations: {
            self.dateSelectionView.frame = dateFrame
            self.classView.frame = classFrame
        })
    }
    
    func showClass()  {
        let dateRequriedHeight = dateTextfield.frame.size.height
        let classReq_Y = dateSelectionView.frame.origin.y + dateRequriedHeight + CGFloat(20.0)
        let classReqHeight = classTableView.frame.origin.y + samplingView.frame.size.height
        var dateFrame = dateSelectionView.frame
        dateFrame.size.height = dateRequriedHeight
        var classFrame = classView.frame
        classFrame.origin.y = classReq_Y
        classFrame.size.height = classReqHeight
        self.classTableView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.dateSelectionView.frame = dateFrame
            self.classView.frame = classFrame
        })
    }
    
    func hideClass() {
        let classReqHeight = classTextfield.frame.size.height
        var classFrame = classView.frame
        classFrame.size.height = classReqHeight
        UIView.animate(withDuration: 0.5, animations: {
            self.classView.frame = classFrame
        }, completion: {success in
            self.classTableView.isHidden = true
        })
    }
    
    func setDate()  {
        let date = datePicker.date
        let formater = DateFormatter()
        formater.dateFormat = "EEE, MMM d 'at' hh:mm a"
        dateTextfield.text = formater.string(from: date)
        dateCheckImageView.isHidden = false
    }
    
    //MARK:- Button Action
    
    @IBAction func onDateAction(_ sender: UIButton) {
        self.findFirstResonder()?.resignFirstResponder()
        sender.isSelected = !sender.isSelected
        classButton.isSelected = false
        if sender.isSelected {
            showDatePicker()
        }
        else{
            hideDatePicker()
            setDate()
        }
    }
    
    @IBAction func onWorkoutAction(_ sender: UIButton) {
        self.findFirstResonder()?.resignFirstResponder()
        sender.isSelected = !sender.isSelected
        dateButton.isSelected = false
        if sender.isSelected {
            if dateSelectionView.frame.size.height > (dateTextfield.superview?.frame.size.height)! {
                setDate()
            }
            showClass()
        }
        else{
            hideClass()
        }
    }
    
    //MARK: - Tableview delegate
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return classTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:HSTrainerClassCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! HSTrainerClassCell!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if classTypes.count > indexPath.row {
            let theClass = classTypes[indexPath.row]
            cell.nameLabel.text = theClass
            if selectedClass.contains(theClass) {
                cell.backgroundSelectedView.isHidden = false
            }
            else{
                cell.backgroundSelectedView.isHidden = true
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let theClass = classTypes[indexPath.row]
        if selectedClass.contains(theClass) {
            selectedClass.remove(at: selectedClass.index(of: theClass)!)
        }
        else{
            if selectedClass.count < 5 {
                selectedClass.append(theClass)
            }
        }
        classTextfield.text = selectedClass.joined(separator: ",")
        if selectedClass.count > 0 {
            classCheckImageView.isHidden = false
        }
        else{
            classCheckImageView.isHidden = true
        }
        tableView.reloadData()
    }

    //MARK:- Textfield delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if prospectiveText.characters.count > 5 {
            return false
        }
        if prospectiveText.characters.count == 5 {
            zipCheckImageView.isHidden = false
        }
        else{
            zipCheckImageView.isHidden = true
        }
        return true
    }

    
}
