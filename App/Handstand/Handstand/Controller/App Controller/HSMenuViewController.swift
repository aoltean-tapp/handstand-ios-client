//
//  HSMenuViewController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 8/24/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

fileprivate let kMenuIcon = "kMenuIcon"
fileprivate let kMenuTitle = "kMenuTitle"

protocol MenuTapper:class {
    func didTapHamburgerButton()
    func loadHomeScreen()
    func showPlanAndPayment()
    func showContactEmail()
    func showPromotionView()
    func showProfileController()
    func showSubscriptionTerms()
    func doLogout()
    func setPackagesAndPaymentsNavBar()
    func setHomeNavBar()
    func removeSubscriptions()
}

enum eMenuType: Int {
    case home
    case payment
    case profile
    case contact
    case subscriptionTerms
    case logout
}

class HSMenuViewController: HSBaseController {

    @IBOutlet weak var menuTableView: UITableView!{
        didSet {
            menuTableView.register(UINib(nibName: "HSHomeMenuCell", bundle: nil), forCellReuseIdentifier: self.cellIdentifier)
            menuTableView.delegate = self
            menuTableView.dataSource = self

            let label = UILabel()
            label.text = "Handstand App.Version("+HSUtility.getAppVersion()+")"
            label.textAlignment = .center
            label.numberOfLines = 1
            label.font = UIFont.init(name: "AvenirNext-Medium", size: 12)
            label.sizeToFit()
            label.textColor = UIColor.black.withAlphaComponent(0.5)
            menuTableView.tableFooterView = label
        }
    }
    lazy var menuData:[[String:String]]  = {
        var returnValue:[[String:String]] = []
        returnValue.append([kMenuIcon : "menuHomeImg", kMenuTitle : "Home"])
        returnValue.append([kMenuIcon : "menyPayImg", kMenuTitle : "Packages & Payment"])
        returnValue.append([kMenuIcon : "menuProfileImg", kMenuTitle : "Profile"])
        returnValue.append([kMenuIcon : "menuContactImg", kMenuTitle : "Contact"])
        returnValue.append([kMenuIcon : "icSubscriptionTerms", kMenuTitle : "Subscription Terms"])
        returnValue.append([kMenuIcon : "menuLogoutImg", kMenuTitle : "Log Out"])
        return returnValue
    }()
    let cellIdentifier = "menuCell"
    var currentMenu : eMenuType = .home
    var menuSelected:Bool = false
    public weak var delegate:MenuTapper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension HSMenuViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HSHomeMenuCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! HSHomeMenuCell!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let theData = menuData[indexPath.row]
        cell.iconImageView.image = UIImage.init(named: theData[kMenuIcon]!)
        cell.menuTitleLabel.text = theData[kMenuTitle]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.delegate?.didTapHamburgerButton()
        self.delegate?.removeSubscriptions()
        if currentMenu.rawValue == indexPath.row {
            return
        }
        switch indexPath.row {
        case eMenuType.home.rawValue:
            currentMenu = .home
            self.delegate?.setHomeNavBar()
            self.delegate?.loadHomeScreen()
            break
        case eMenuType.payment.rawValue:
            currentMenu = .payment
            self.delegate?.setPackagesAndPaymentsNavBar()
            self.delegate?.showPlanAndPayment()
            break
        case eMenuType.profile.rawValue:
            currentMenu = .profile
            self.delegate?.setHomeNavBar()
            self.delegate?.showProfileController()
            break
        case eMenuType.contact.rawValue:
            self.delegate?.setHomeNavBar()
            self.delegate?.showContactEmail()
            break
        case eMenuType.subscriptionTerms.rawValue:
            currentMenu = .subscriptionTerms
            self.delegate?.setHomeNavBar()
            self.delegate?.showSubscriptionTerms()
            break
        case eMenuType.logout.rawValue:
            self.delegate?.setHomeNavBar()
            self.delegate?.doLogout()
            break
        default:break
        }
    }
}

