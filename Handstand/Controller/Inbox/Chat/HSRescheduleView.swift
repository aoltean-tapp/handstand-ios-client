//
//  HSRescheduleView.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/15/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class HSRescheduleView: UIView {
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var trainerNameLabel: UILabel!
    @IBOutlet weak var trainerLocationLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var trainerLocationMap: MKMapView!
    @IBOutlet weak var detailedLocationLabel: UILabel!
    
    func setupView() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        timeView.layer.borderWidth = 1.5
        timeView.layer.borderColor = #colorLiteral(red: 0.3529411765, green: 0.7764705882, blue: 0.5725490196, alpha: 1).cgColor
    }
}
