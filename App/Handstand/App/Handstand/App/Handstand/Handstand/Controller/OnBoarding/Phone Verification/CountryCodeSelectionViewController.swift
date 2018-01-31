//
//  CountryCodeSelectionViewController.swift
//  FirebasePhone
//
//  Created by Ranjith Kumar on 8/31/17.
//  Copyright © 2017 Ranjith Kumar. All rights reserved.
//

import UIKit

protocol countryPicker {
    func didPickCountry(model:HSCountryModel)
}

class CountryCodeSelectionViewController: HSBaseController {
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var countryListTableView: UITableView! {
        didSet {
            countryListTableView.delegate = self
            countryListTableView.dataSource = self
            let nib:UINib = UINib.init(nibName: CountrySelectionTableViewCell.reuseIdentifier(), bundle: nil)
            self.countryListTableView.register(nib, forCellReuseIdentifier: CountrySelectionTableViewCell.reuseIdentifier())
            
            self.countryListTableView.estimatedRowHeight = 70
            self.countryListTableView.rowHeight = UITableViewAutomaticDimension
            self.countryListTableView.keyboardDismissMode = .onDrag
            self.countryListTableView.sectionIndexColor = UIColor.handstandGreen()
        }
    }
    
    var countryList:HSCountryCodeHelper?
    var filteredList:HSCountryCodeHelper?
    public var delegate:countryPicker?
    var _navBarType:navBarType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let nType = _navBarType {
            HSNavigationBarManager.shared.applyProperties(key: nType, viewController: self, titleView: self.titleView())
        }else {
            HSNavigationBarManager.shared.applyProperties(key: .type_4, viewController: self, titleView: self.titleView())
        }
    }
    //MARK: - Private functions
    func titleView()->UILabel {
        let titleLabel = UILabel.init()
        titleLabel.text = "SELECT A COUNTRY"
        titleLabel.font = HSFontUtilities.avenirNextMedium(size: 17)
        titleLabel.sizeToFit()
        if _navBarType != nil {
            titleLabel.textColor = UIColor.handstandGreen()
        }else {
            titleLabel.textColor = UIColor.white
        }
        titleLabel.textAlignment = .center
        titleLabel.addKernAttribute()
        return titleLabel
    }
}

extension CountryCodeSelectionViewController:UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    //MARK: - UITableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 0
        if searchBar.isEmpty() {
            sections = (countryList?.titles.count)!
        }else {
            sections = filteredList?.titles.count ?? 0
        }
        if sections == 0 {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: countryListTableView.bounds.size.width, height: countryListTableView.bounds.size.height))
            noDataLabel.text = "No country available"
            noDataLabel.font = UIFont.init(name: "AvenirNext-Regular", size: 20)
            noDataLabel.textColor = UIColor.lightGray
            noDataLabel.textAlignment = .center
            countryListTableView.backgroundView  = noDataLabel
        }else {
            countryListTableView.backgroundView = nil
        }
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.isEmpty() {
            let key = countryList?.titles[section]
            return countryList!.countryList[key!]?.count ?? 0
        }else{
            if let key = filteredList?.titles[section] {
                return filteredList?.countryList[key]?.count ?? 0
            }else {
                return 0
            }
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchBar.isEmpty() {
            return countryList?.titles
        }else{
            return filteredList?.titles
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchBar.isEmpty() {
            return countryList?.titles[section]
        }else {
            return filteredList?.titles[section]
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CountrySelectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: CountrySelectionTableViewCell.reuseIdentifier(), for: indexPath) as! CountrySelectionTableViewCell
        cell.selectionStyle = .none
        if searchBar.isEmpty() {
            let key = countryList?.titles[indexPath.section]
            if let countries = countryList?.countryList[key!] {
                let country:HSCountryModel = countries[indexPath.row]
                cell.feedCountry(info: country)
            }
        }else {
            let key = filteredList?.titles[indexPath.section]
            if let countries = filteredList?.countryList[key!] {
                let country:HSCountryModel = countries[indexPath.row]
                cell.feedCountry(info: country)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchBar.isEmpty() {
            let key = countryList?.titles[indexPath.section]
            if let countries = countryList?.countryList[key!] {
                let country:HSCountryModel = countries[indexPath.row]
                self.delegate?.didPickCountry(model: country)
            }
        }else {
            let key = filteredList?.titles[indexPath.section]
            if let countries = filteredList?.countryList[key!] {
                let country:HSCountryModel = countries[indexPath.row]
                self.delegate?.didPickCountry(model: country)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == true {
            countryListTableView.reloadData()
        }else {
            let countries = countryList?.countries.filter { ($0.name?.hasPrefix(searchText))! || ($0.iso2Cc?.hasPrefix(searchText))! || ($0.e164Cc?.hasPrefix(searchText))!}
            filteredList = HSCountryCodeHelper.init()
            filteredList?.manipulateData(with: countries!)
            countryListTableView.reloadData()
        }
    }
}

extension UISearchBar {
    func isEmpty()->Bool {
        return (self.text?.isEmpty)!
    }
}

