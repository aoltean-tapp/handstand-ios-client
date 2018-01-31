//
//  HSWorkoutPlanCell.swift
//  Handstand
//
//  Created by Fareeth John on 5/2/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSWorkoutPlanCell: UITableViewCell {

    @IBOutlet var bgView: UIView!
    @IBOutlet var bestValueLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var rebookTagImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
