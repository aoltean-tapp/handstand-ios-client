//
//  HSWhyHandstandViewController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/19/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSWhyHandstandViewController: HSBaseController {
    
    //MARK: - iVars
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(HSWhyHandstandCell.nib(), forCellReuseIdentifier: HSWhyHandstandCell.reuseIdentifier())
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.dropShadow()
        }
    }
    
    @IBOutlet weak var continueButton: UIButton! {
        didSet {
            continueButton.layer.cornerRadius = 4.0
        }
    }
    fileprivate var dataSource:HSWhyHandstandGetResponse?
    
    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        HSNavigationBarManager.shared.applyProperties(key: .type_0, viewController: self, titleView: getTitleView())
        getHandstandQueries()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Private functions
    private func getHandstandQueries() {
        continueButton.isHidden = true
        HSLoadingView.standardLoading().startLoading()
        HSPlanQuizDataCenter.init().getWhyHandstandQueries { (result) in
            HSLoadingView.standardLoading().stopLoading()
            switch result {
            case .success(let plans):
                DispatchQueue.main.async {
                    self.continueButton.isHidden = false
                    let response = plans
                    self.dataSource = response
                    self.tableView.reloadData()
                }
                break
            case .failure(let error):
                HSUtility.showMessage(string: error?.message, title: "Error")
                break
            }
        }
    }
    
    private func postHandstandQuery(query:HSWhyHandstandDataMeta) {
        HSLoadingView.standardLoading().startLoading()
        HSPlanQuizDataCenter.init().postWhyHandstandQuery(with: query) { (result) in
            HSLoadingView.standardLoading().stopLoading()
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    //Navigate him to next screen
                }
                break
            case .failure(let error):
                HSUtility.showMessage(string: error?.message, title: "Error")
                break
            }
        }
    }
    
    //MARK: - Button functions
    @IBAction private func didTapContinue(_ sender: Any) {
        let selectedQueries = self.dataSource?.data.filter({q in q.isSelected == true})
        if (selectedQueries?.count == 0) {
            HSUtility.showMessage(string: "Please pick your reason!", title: AppCons.APPNAME)
        }else {
            let selectedQuery = selectedQueries?.first
            self.postHandstandQuery(query:selectedQuery!)
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension HSWhyHandstandViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.data.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HSWhyHandstandCell.reuseIdentifier()) as! HSWhyHandstandCell
        if let query = self.dataSource?.data[indexPath.row] {
            cell.populate(query: query)
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let copyQueries = self.dataSource?.data,
            let query = self.dataSource?.data[indexPath.row]{
            copyQueries.forEach({ q in
                if query == q {
                    q.isSelected = true
                }else {
                    q.isSelected = false
                }
            })
            self.dataSource?.data = copyQueries
            self.tableView.reloadData()
        }
    }
}
