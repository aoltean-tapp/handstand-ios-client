//
//  HSInboxViewController.swift
//  Handstand
//
//  Created by Andrei Oltean on 2/8/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import UIKit

class HSInboxViewController: HSBaseController {

    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var unreadMessagesLabel: UILabel!
    @IBOutlet weak var conversationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HSNavigationBarManager.shared.applyProperties(key: .type_20, viewController: self, titleView: getTitleView())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        textFieldView.layer.cornerRadius = 4.0
        textFieldView.layer.borderWidth = 1.0
        textFieldView.layer.borderColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
    }
}
