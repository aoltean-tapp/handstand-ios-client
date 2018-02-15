//
//  HSPastSessionCell.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/7/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import UIKit

class HSPastSessionCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var trainerImageView: UIImageView!
    @IBOutlet weak var trainerNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    
    var isSlideable: Bool = true
    var isExpandable: Bool {
        return mainViewLeadingConstraint.constant == 19 && mainViewTrailingConstraint.constant == 19
    }
    
    fileprivate var previousTouchPoint: CGPoint?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didSwipeCell(_:)))
        mainView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc fileprivate func didSwipeCell(_ sender: UIPanGestureRecognizer) {
        if isSlideable {
            if sender.state == .began {
                previousTouchPoint = sender.location(in: mainView)
            } else if sender.state == .changed {
                let currentTouchPoint = sender.location(in: mainView)
                if let previousTouchPoint = previousTouchPoint {
                    let leftSwipeDifference = previousTouchPoint.x - currentTouchPoint.x
                    let rightSwipeDifference = currentTouchPoint.x - previousTouchPoint.x
                    if (mainViewTrailingConstraint.constant + leftSwipeDifference) <= 122 && (mainViewLeadingConstraint.constant + rightSwipeDifference) <= 138 {
                        mainViewTrailingConstraint.constant += leftSwipeDifference
                        mainViewLeadingConstraint.constant += rightSwipeDifference
                        self.layoutIfNeeded()
                    }
                }
            } else if sender.state == .ended {
                let xDifference = sender.translation(in: mainView).x
                // center to left
                if xDifference < 0 && mainViewTrailingConstraint.constant > 19 {
                    mainViewLeadingConstraint.constant = -84
                    mainViewTrailingConstraint.constant = 122
                }
                // left to center
                if xDifference > 0 && mainViewTrailingConstraint.constant > 19 {
                    mainViewLeadingConstraint.constant = 19
                    mainViewTrailingConstraint.constant = 19
                }
                // center to right
                if xDifference > 0 && mainViewLeadingConstraint.constant > 19 {
                    mainViewLeadingConstraint.constant = 138
                    mainViewTrailingConstraint.constant = -100
                }
                // right to center
                if xDifference < 0 && mainViewLeadingConstraint.constant > 19 {
                    mainViewLeadingConstraint.constant = 19
                    mainViewTrailingConstraint.constant = 19
                }
                UIView.animate(withDuration: 0.3, animations: {
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.layer.cornerRadius = 4.0
        
        let shadowPath = UIBezierPath(rect: mainView.bounds)
        mainView.layer.masksToBounds = false
        mainView.layer.shadowPath = shadowPath.cgPath
        mainView.layer.shadowOffset = CGSize(width: 0.0, height: 1.2)
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
