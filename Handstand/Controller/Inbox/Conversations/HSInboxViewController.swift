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
    var dataSource: FilteredDataSource<HSConversation>? {
        get { return _dataSource as? FilteredDataSource<HSConversation> }
        set { _dataSource = newValue }
    }
    var cellController: HSConversationCellController! {
        get { return _cellController as? HSConversationCellController }
        set { _cellController = newValue }
    }
}

class HSInboxViewController: HSBaseCollectionFeedController {

    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var unreadMessagesLabel: UILabel!
    
    var conversations: [HSConversation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HSNavigationBarManager.shared.applyProperties(key: .type_20, viewController: self, titleView: getTitleView())
        
        self.dataSource = FilteredDataSource<HSConversation>(conversations)
        self.cellController = HSConversationCellController()
        
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
                self.dataSource = FilteredDataSource<HSConversation>(chats)
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
            dataSource?.filter(by: { conversation -> Bool in
                return conversation.name.hasPrefix(searchedName)
            })
        }
    }
}
