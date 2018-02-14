//
//  HSChatController.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/12/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import UIKit
import Tapptitude

extension HSChatController {
    var dataSource: DataSource<Any>? {
        get { return _dataSource as? DataSource<Any> }
        set { _dataSource = newValue }
    }
    var cellController: MultiCollectionCellController! {
        get { return _cellController as? MultiCollectionCellController }
        set { _cellController = newValue }
    }
}

class HSChatController: HSBaseCollectionFeedController {

    @IBOutlet weak var trainerNameLabel: UILabel!
    @IBOutlet weak var sessionDateLabel: UILabel!
    @IBOutlet weak var sessionStatusLabel: UILabel!
    
    var conversation: HSConversation?
    
    fileprivate var allMessages: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HSNavigationBarManager.shared.applyProperties(key: .type_21, viewController: self, titleView: getTitleView())
        
        trainerNameLabel.text = conversation?.name
        
        self.cellController = MultiCollectionCellController([HSTrainerChatBubbleCellController(), HSOwnChatBubbleCellController()])
        
        fetchAPIData()
    }
    
    fileprivate func fetchAPIData() {
        if let chatId = conversation?.id {
            HSChatNetworkHandler().getChatMessages(for: chatId) { result in
                switch result {
                case .success(let allMessages):
                    if let currentUser = HSUserManager.shared.currentUser {
                        let currentUserId = Int(currentUser.user_id!)!
                        var messages: [Any] = []
                        for chatMessage in allMessages {
                            if chatMessage.userId == currentUserId {
                                messages.append(chatMessage)
                            } else {
                                messages.append((self.conversation?.trainerAvatar ?? "", chatMessage))
                            }
                        }
                        self.allMessages = messages
                        self.dataSource = DataSource<Any>(allMessages)
                        self.collectionView.scrollToItem(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
                    }
                case .failure(let error):
                    self.checkAndShow(error: error)
                }
            }
        }
    }
}
