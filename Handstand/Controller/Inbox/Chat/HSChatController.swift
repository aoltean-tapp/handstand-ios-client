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
    
    var conversation: HSConversation?
    
    fileprivate var allMessages: [Any] = []
    fileprivate var chatManager: SocketManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HSNavigationBarManager.shared.applyProperties(key: .type_21, viewController: self, titleView: getTitleView())
        
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
                        self.collectionView.scrollToItem(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
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
//        config.insert(.forceWebsockets(true))

        let manager = SocketManager(socketURL: URL(string: chat_url)!, config: config)
        self.chatManager = manager
        let socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            self.chatManager.defaultSocket.emitWithAck("authentication", HSUserManager.shared.accessToken ?? "").timingOut(after: 10, callback: { response in
                print("join response :\(response)")
            })
        }
        
        socket.on(clientEvent: .error) { data, ack in
            print(data)
        }
        
        socket.on("message") { data, ack in
            print("Got a message")
        }
        
        socket.connect()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if let message = messageTextView.text {
            if let conversation = conversation {
                let socketData: [String: Any] = ["chat": conversation.id, "message": message]
                chatManager.defaultSocket.emitWithAck("message", socketData).timingOut(after: 10, callback: { response in
                    print("join response :\(response)")
                })
                let newChatMessage = HSChatMessage()
                newChatMessage.chatId = conversation.id
                newChatMessage.message = message
                allMessages.append(newChatMessage)
                self.dataSource = DataSource<Any>(allMessages)
                self.collectionView.scrollToItem(at: IndexPath(row: allMessages.count - 1, section: 0), at: .bottom, animated: true)
                messageTextView.text = ""
            }
        }
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
