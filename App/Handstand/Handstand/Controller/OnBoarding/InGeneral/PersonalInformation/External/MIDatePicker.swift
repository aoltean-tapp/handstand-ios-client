//
//  MIDatePicker.swift
//  Agenda medica
//
//  Created by Mario on 15/06/16.
//  Copyright © 2016 Mario. All rights reserved.
//

import UIKit

protocol MIDatePickerDelegate: class {
    
    func miDatePicker(amDatePicker: MIDatePicker, didSelect date: Date)
    func miDatePickerDidCancelSelection(amDatePicker: MIDatePicker)
    
}

class MIDatePicker: UIView {
    
    // MARK: - Config
    struct Config {
        
        let contentHeight: CGFloat = 250
        let bouncingOffset: CGFloat = 20
        
        var startDate: Date?
        var maximumDate: Date?
        
        var confirmButtonTitle = "Seleziona"
        var cancelButtonTitle = "Annulla"
        
        var headerHeight: CGFloat = 50
        
        var animationDuration: TimeInterval = 0.3
        
        var contentBackgroundColor: UIColor = UIColor.lightGray
        var headerBackgroundColor: UIColor = UIColor.white
        var confirmButtonColor: UIColor = HSColorUtility.UIAppThemeGreenColor()
        var cancelButtonColor: UIColor = HSColorUtility.UIAppThemeGreenColor()
        
        var overlayBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    var config = Config()
    
    weak var delegate: MIDatePickerDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    var bottomConstraint: NSLayoutConstraint!
    var overlayButton: UIButton!
    
    // MARK: - Init
    static func getFromNib() -> MIDatePicker {
        return UINib.init(nibName: String(describing: self), bundle: nil).instantiate(withOwner: self, options: nil).last as! MIDatePicker
    }
    
    // MARK: - IBAction
    @IBAction func confirmButtonDidTapped(sender: AnyObject) {
        
        config.startDate = datePicker.date
        
        dismiss()
        delegate?.miDatePicker(amDatePicker: self, didSelect: datePicker.date)
        
    }
    @IBAction func cancelButtonDidTapped(sender: AnyObject) {
        dismiss()
        delegate?.miDatePickerDidCancelSelection(amDatePicker: self)
    }
    
    // MARK: - Private
    private func setup(parentVC: UIViewController) {
        
        // Loading configuration
        
        if let startDate = config.startDate {
            datePicker.date = startDate
        }
        
        if let maxDate = config.maximumDate {
            datePicker.maximumDate = maxDate
        }
        
        headerViewHeightConstraint.constant = config.headerHeight
        
        confirmButton.setTitle(config.confirmButtonTitle, for: .normal)
        cancelButton.setTitle(config.cancelButtonTitle, for: .normal)
        
        confirmButton.setTitleColor(config.confirmButtonColor, for: .normal)
        cancelButton.setTitleColor(config.cancelButtonColor, for: .normal)
        
        headerView.backgroundColor = config.headerBackgroundColor
        backgroundView.backgroundColor = config.contentBackgroundColor
        
        // Overlay view constraints setup
        
        overlayButton = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        overlayButton.backgroundColor = config.overlayBackgroundColor
        overlayButton.alpha = 0
        
        overlayButton.addTarget(self, action: #selector(cancelButtonDidTapped(sender:)), for: .touchUpInside)
        
        if !overlayButton.isDescendant(of: parentVC.view) { parentVC.view.addSubview(overlayButton) }
        
        overlayButton.translatesAutoresizingMaskIntoConstraints = false
        
        parentVC.view.addConstraints([
            NSLayoutConstraint(item: overlayButton, attribute: .bottom, relatedBy: .equal, toItem: parentVC.view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .top, relatedBy: .equal, toItem: parentVC.view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .leading, relatedBy: .equal, toItem: parentVC.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .trailing, relatedBy: .equal, toItem: parentVC.view, attribute: .trailing, multiplier: 1, constant: 0)
            ]
        )
        
        // Setup picker constraints
        
        frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: config.contentHeight + config.headerHeight)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parentVC.view, attribute: .bottom, multiplier: 1, constant: 0)
        
        if !isDescendant(of: parentVC.view) { parentVC.view.addSubview(self) }
        
        parentVC.view.addConstraints([
            bottomConstraint,
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parentVC.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parentVC.view, attribute: .trailing, multiplier: 1, constant: 0)
            ]
        )
        addConstraint(
            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: frame.height)
        )
        
        move(goUp: false)
        
    }
    private func move(goUp: Bool) {
        bottomConstraint.constant = goUp ? config.bouncingOffset : config.contentHeight + config.headerHeight
    }
    
    // MARK: - Public
    func show(inVC parentVC: UIViewController, completion: (() -> ())? = nil) {
        
        parentVC.view.endEditing(true)
        
        setup(parentVC: parentVC)
        move(goUp: true)
        
        UIView.animate(
            withDuration: config.animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseIn, animations: {
                
                parentVC.view.layoutIfNeeded()
                self.overlayButton.alpha = 1
                
        }, completion: { (finished) in
            completion?()
        }
        )
        
    }
    func dismiss(completion: (() -> ())? = nil) {
        
        move(goUp: false)
        
        UIView.animate(
            withDuration: config.animationDuration, animations: {
                
                self.layoutIfNeeded()
                self.overlayButton.alpha = 0
                
        }, completion: { (finished) in
            completion?()
            self.removeFromSuperview()
            self.overlayButton.removeFromSuperview()
        }
        )
        
    }
    
}
