//
//  HSInboxNotificationCellController.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/16/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import Foundation
import Tapptitude

class HSInboxNotificationCellController: CollectionCellController<String, HSInboxNotificationCell> {
    
    init() {
        super.init(cellSize: CGSize(width: -1.0, height: 71.0))
    }
    
    override func configureCell(_ cell: HSInboxNotificationCell, for content: String, at indexPath: IndexPath) {
        cell.notificationTitleLabel.text = "LEAVE A REVIEW FOR \(content.uppercased())"
    }
}
