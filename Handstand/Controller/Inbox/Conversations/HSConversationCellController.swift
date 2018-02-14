//
//  HSConversationCellController.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/12/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import Tapptitude

class HSConversationCellController: CollectionCellController<HSConversation, HSConversationCell> {
    
    init() {
        super.init(cellSize: CGSize(width: -1.0, height: 138.0))
    }
    
    override func configureCell(_ cell: HSConversationCell, for content: HSConversation, at indexPath: IndexPath) {
//        if content.sessionStatus == "confirmed" {
//            cell.sessionStatusImageView.image = #imageLiteral(resourceName: "icUpcomingSession")
//        } else if content.sessionStatus == "pending" {
//            cell.sessionStatusImageView.image = #imageLiteral(resourceName: "icPendingApproval")
//        } else if content.sessionStatus == "passed" {
//            cell.sessionStatusImageView.image = #imageLiteral(resourceName: "icApprovedSession")
//        }
//        cell.trainerImageView.sd_setImage(with: URL(string: content.trainerAvatar))
        cell.trainerNameLabel.text = content.name
//        cell.lastMessageLabel.text = content.lastMessage
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMMM dd, yyyy | h:mm a"
//        cell.sessionDateLabel.text = "SESSION DATE: \(dateFormatter.string(from: content.sessionDate).uppercased())"
        dateFormatter.dateFormat = "h:mm a"
        cell.lastContactedTimeLabel.text = dateFormatter.string(from: content.updatedAt)
    }
    
    override func didSelectContent(_ content: HSConversation, at indexPath: IndexPath, in collectionView: UICollectionView) {
        let chatViewController = HSChatController()
        chatViewController.hidesBottomBarWhenPushed = true
        parentViewController?.navigationController?.pushViewController(chatViewController, animated: true)
    }
}
