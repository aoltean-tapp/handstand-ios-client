//
//  HSInboxViewController.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/8/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import UIKit
import Tapptitude

extension HSInboxViewController {
    var dataSource: FilteredDataSource<Any>? {
        get { return _dataSource as? FilteredDataSource<Any> }
        set { _dataSource = newValue }
    }
    var cellController: MultiCollectionCellController! {
        get { return _cellController as? MultiCollectionCellController }
        set { _cellController = newValue }
    }
}

class HSInboxViewController: HSBaseCollectionFeedController {

    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var unreadMessagesLabel: UILabel!
    
    var notifications: [String] = ["DANI D."]
    var conversations: [HSConversation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HSNavigationBarManager.shared.applyProperties(key: .type_20, viewController: self, titleView: getTitleView())
        
        var dataSource: [Any] = notifications
        for conversation in conversations {
            dataSource.append(conversation)
        }
        self.dataSource = FilteredDataSource<Any>(dataSource)
        self.cellController = MultiCollectionCellController([HSInboxNotificationCellController(), HSConversationCellController()])
        
        fetchAPIData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func fetchAPIData() {
        HSChatNetworkHandler().getAllChats { result in
            switch result {
            case .success(let chats):
                self.conversations = chats
                var dataSource: [Any] = self.notifications
                for conversation in chats {
                    dataSource.append(conversation)
                }
                self.dataSource = FilteredDataSource<Any>(dataSource)
            case .failure(let error):
                self.checkAndShow(error: error)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        textFieldView.layer.cornerRadius = 4.0
        textFieldView.layer.borderWidth = 1.0
        textFieldView.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
    }
    
    @IBAction func didSearchConversation(_ sender: UITextField) {
        if let searchedName = sender.text {
            dataSource?.filter(by: { element -> Bool in
                guard let conversation = element as? HSConversation else { return true }
                return conversation.name.hasPrefix(searchedName)
            })
        }
    }
}
