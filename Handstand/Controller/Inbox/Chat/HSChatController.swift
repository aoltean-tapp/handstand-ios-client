//
//  HSChatController.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/12/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import UIKit
import Tapptitude
import SocketIO

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
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var rescheduleView: HSRescheduleView!
    @IBOutlet weak var rescheduleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reviewOverlayView: UIView!
    
    var conversation: HSConversation?
    
    fileprivate var allMessages: [Any] = []
    fileprivate var chatManager: SocketManager!
    
    var shouldReschedule: Bool = false
    var shouldReview: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HSNavigationBarManager.shared.applyProperties(key: .type_21, viewController: self, titleView: getTitleView())
        
        if shouldReschedule {
            rescheduleView.isHidden = false
            rescheduleViewHeight.constant = 379.0
        } else {
            rescheduleView.isHidden = true
            rescheduleViewHeight.constant = 0.0
        }
        
        if shouldReview {
            reviewOverlayView.isHidden = false
        } else {
            reviewOverlayView.isHidden = true
        }
        
        trainerNameLabel.text = conversation?.name
        
        self.cellController = MultiCollectionCellController([HSTrainerChatBubbleCellController(), HSOwnChatBubbleCellController()])
        
        fetchAPIData()
        initChatSocket()
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
                        self.dataSource = DataSource<Any>(messages)
                        if messages.count > 0 {
                            self.collectionView.scrollToItem(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
                        }
                    }
                case .failure(let error):
                    self.checkAndShow(error: error)
                }
            }
        }
    }
    
    fileprivate func initChatSocket() {
        var config = SocketIOClientConfiguration()
        config.insert(.log(true))
        config.insert(.compress)
        config.insert(.forceWebsockets(true))

        chatManager = SocketManager(socketURL: URL(string: chat_url)!, config: config)
        let socket = chatManager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            self.chatManager.defaultSocket.emit("authentication", HSUserManager.shared.accessToken ?? "")
        }
        
        socket.on(clientEvent: .error) { data, ack in
            print(data)
        }
        
        socket.on("message") { data, ack in
            if let responseDict = data[0] as? NSDictionary {
                if let chatId = responseDict["chat"] as? Int, let message = responseDict["message"] as? String {
                    let newChatMessage = HSChatMessage()
                    newChatMessage.chatId = chatId
                    newChatMessage.message = message
                    self.allMessages.append((self.conversation?.trainerAvatar ?? "", newChatMessage))
                    self.dataSource = DataSource<Any>(self.allMessages)
                    self.collectionView.scrollToItem(at: IndexPath(row: self.allMessages.count - 1, section: 0), at: .bottom, animated: true)
                }
            }
        }
        
        socket.connect()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if let message = messageTextView.text {
            if let conversation = conversation {
                let socketData: [String: Any] = ["chat": conversation.id, "message": message]
                chatManager.defaultSocket.emit("message", socketData)
                let newChatMessage = HSChatMessage()
                newChatMessage.chatId = conversation.id
                newChatMessage.message = message
                allMessages.append(newChatMessage)
                dataSource = DataSource<Any>(allMessages)
                collectionView.scrollToItem(at: IndexPath(row: allMessages.count - 1, section: 0), at: .bottom, animated: true)
                messageTextView.text = ""
            }
        }
    }
    
    @IBAction func reviewTrainer(_ sender: Any) {
        let reviewController = HSReviewTrainerController()
        navigationController?.pushViewController(reviewController, animated: true)
    }
}

extension HSChatController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Write a message"
        }
    }
}
