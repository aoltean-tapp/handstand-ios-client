//
//  HSPastWorkoutCell.swift
//  Handstand
//
//  Created by Fareeth John on 5/9/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSPastWorkoutCell: UITableViewCell {

    @IBOutlet var notAvailableLabel: UILabel!
    @IBOutlet var rebookButton: UIButton!
    @IBOutlet var classLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var roundedView: HSRoundedView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
