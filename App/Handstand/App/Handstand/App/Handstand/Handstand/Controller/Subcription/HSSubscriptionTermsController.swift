//
//  HSSubscriptionTermsController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 8/31/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

fileprivate let no_ofTerms = 12

class HSSubscriptionTermsController: HSBaseController {

    @IBOutlet weak var termsTableView: UITableView! {
        didSet {
            termsTableView.delegate = self
            termsTableView.dataSource = self
            let nib:UINib = UINib.init(nibName: HSSubscriptionTermsCell.reuseIdentifier(), bundle: nil)
            self.termsTableView.register(nib, forCellReuseIdentifier: HSSubscriptionTermsCell.reuseIdentifier())
            let linkNib:UINib = UINib.init(nibName: HSSubscriptionTermsLinkCell.reuseIdentifier(), bundle: nil)
            termsTableView.register(linkNib, forCellReuseIdentifier: HSSubscriptionTermsLinkCell.reuseIdentifier())
            termsTableView.estimatedRowHeight = 70
            termsTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
   fileprivate let datasource:[String] = {
        var terms:[String] = []
        for i in 1..<no_ofTerms {
            terms.append(NSLocalizedString("Term_\(i)", comment: ""))
        }
        return terms
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Subscription Terms"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}

extension HSSubscriptionTermsController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Why special case for these two because these Terms has links
        if indexPath.row == 7 || indexPath.row == 8 {
            let cell:HSSubscriptionTermsLinkCell = tableView.dequeueReusableCell(withIdentifier: HSSubscriptionTermsLinkCell.reuseIdentifier(), for: indexPath) as! HSSubscriptionTermsLinkCell
            cell.termsTextView?.text = datasource[indexPath.row]
            return cell
        }else {
            let cell:HSSubscriptionTermsCell = tableView.dequeueReusableCell(withIdentifier: HSSubscriptionTermsCell.reuseIdentifier(), for: indexPath) as! HSSubscriptionTermsCell
            cell.termsLabel?.text = datasource[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Why special case for these two because these Terms has links
        if indexPath.row == 7 || indexPath.row == 8 {
            return (ScreenCons.SCREEN_HEIGHT<600) ? 130 : 100
        }else {
            return UITableViewAutomaticDimension
        }
    }
    
}
