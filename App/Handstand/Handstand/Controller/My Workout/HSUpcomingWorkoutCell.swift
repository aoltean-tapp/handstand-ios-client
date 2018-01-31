//
//  HSUpcomingWorkoutCell.swift
//  Handstand
//
//  Created by Fareeth John on 5/9/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSUpcomingWorkoutCell: UITableViewCell {
    enum eDetailType: Int {
        case contact = 0
        case accept = 1
        case pending = 2
    }

    @IBOutlet var pendingCancelButton: UIButton!
    @IBOutlet var declineButton: UIButton!
    @IBOutlet var acceptButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var contactButton: UIButton!
    @IBOutlet var pendingDetailView: UIView!
    @IBOutlet var acceptDetailView: UIView!
    @IBOutlet var contactDetailView: UIView!
    @IBOutlet var classLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var roundedView: HSRoundedView!
    
    @IBOutlet var trainerRequestInfoView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func hideAllDetail()  {
        contactDetailView.isHidden = true
        acceptDetailView.isHidden = true
        pendingDetailView.isHidden = true
    }
    
    func showDetailForType(_ type : eDetailType)  {
        hideAllDetail()
        switch type {
        case .contact:
            contactDetailView.isHidden = false
            break
        case .accept:
            acceptDetailView.isHidden = false
            break
        case .pending:
            pendingDetailView.isHidden = false
            break
        }
    }
    
}
