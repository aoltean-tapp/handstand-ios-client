//
//  HSSessionCell.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/2/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import UIKit

class HSUpcomingSessionCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayMonthView: UIView!
    @IBOutlet weak var trainerNameLabel: UILabel!
    @IBOutlet weak var classDurationLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var trainerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.layer.cornerRadius = 4.0
        
        let shadowPath = UIBezierPath(rect: mainView.bounds)
        mainView.layer.masksToBounds = false
        mainView.layer.shadowPath = shadowPath.cgPath
        mainView.layer.shadowOffset = CGSize(width: 0.0, height: 1.2)
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 0.5
        
        dayMonthView.layer.borderWidth = 1.5
        dayMonthView.layer.borderColor = #colorLiteral(red: 0.3529411765, green: 0.7764705882, blue: 0.5725490196, alpha: 1)
        dayMonthView.layer.cornerRadius = 4.0
        
        trainerImageView.layer.cornerRadius = 4.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
