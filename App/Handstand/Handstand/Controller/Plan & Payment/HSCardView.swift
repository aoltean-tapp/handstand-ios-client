//
//  HSCardView.swift
//  Handstand
//
//  Created by Fareeth John on 5/18/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSCardView: UIView {
    
    @IBOutlet var tableView: UITableView!
    let cellIdentifier = "cardCell"

    override func awakeFromNib() {
        tableView.register(UINib(nibName: "HSPaymentCardCell", bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
    }

    //MARK: - Tableview delegate
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:HSPaymentCardCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! HSPaymentCardCell!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let theUser = HSUserManager.shared.currentUser
        cell.brandLabel.text = theUser?.ccBrand
        cell.cardNumberLabel.text = "*" + (theUser?.ccLast4)!
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
    }

}
