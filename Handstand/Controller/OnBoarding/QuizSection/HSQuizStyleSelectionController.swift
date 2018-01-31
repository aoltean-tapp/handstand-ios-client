//
//  HSQuizStyleSelectionController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 12/11/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSQuizStyleSelectionController: HSBaseController {
    
    //MARK: - iVars
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(HSQuizStyleSelectionCell.nib(),
                                    forCellWithReuseIdentifier: HSQuizStyleSelectionCell.reuseIdentifier())
            
            let layout = UPCarouselFlowLayout.init()
            layout.itemSize = CGSize(width:collectionView.frame.width-(2*30),height:collectionView.frame.height)
            layout.sideItemScale = 0.8
            layout.sideItemAlpha = 0.8
            layout.scrollDirection = .horizontal
            layout.spacingMode = .fixed(spacing: 20)
            collectionView.setCollectionViewLayout(layout, animated: false)
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    fileprivate var dataSource:HSQuizGetResponse?
    fileprivate var selectedQuiz:HSQuiz?
    public var selectedPlan:HSFirstPlanListResponse?
    public var navType:navBarType = .type_15
    
    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        HSNavigationBarManager.shared.applyProperties(key: navType, viewController: self, titleView: getTitleView())
        getQuizzes()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem?.customView?.alpha = 0.5

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Private functions
   private func getQuizzes() {
        HSLoadingView.standardLoading().startLoading()
        HSPlanQuizDataCenter.init().getQuizzes { (result) in
            switch result {
            case .success(let quizzes):
                DispatchQueue.main.async {
                    HSLoadingView.standardLoading().stopLoading()
                    let response = quizzes
                    self.dataSource = response
                    self.collectionView.reloadData()
                }
                break
            case .failure(let error):
                HSLoadingView.standardLoading().stopLoading()
                HSUtility.showMessage(string: error?.message, title: "Error")
                break
            }
        }
    }
    
   fileprivate func postQuiz(quiz:HSQuiz) {
        HSLoadingView.standardLoading().startLoading()
        HSPlanQuizDataCenter.init().postQuiz(with: quiz) { (result) in
            switch result {
            case .success(let quizResponse):
                DispatchQueue.main.async {
                    HSLoadingView.standardLoading().stopLoading()
                    let whyHandstandScreen = HSWhyHandstandViewController()
                    whyHandstandScreen.handpickedQuiz = quizResponse
                    whyHandstandScreen.selectedPlan = self.selectedPlan
                    self.navigationController?.pushViewController(whyHandstandScreen, animated: true)
                }
                break
            case .failure(let error):
                HSLoadingView.standardLoading().stopLoading()
                HSUtility.showMessage(string: error?.message, title: "Error")
                break
            }
        }
    }
    //MARK: - Button Actions
    func didTapNextButton() {
        if let s_quiz = self.selectedQuiz {
            self.postQuiz(quiz: s_quiz)
        }
    }
}

//MARK: - Extension:UICollectionViewDelegate
extension HSQuizStyleSelectionController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.quiz?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 20, 0, 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HSQuizStyleSelectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: HSQuizStyleSelectionCell.reuseIdentifier(), for: indexPath) as! HSQuizStyleSelectionCell
        //why+1, coz. index starts with 0
        cell.populate(data:(self.dataSource?.quiz![indexPath.row])!,index:indexPath.row+1)
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width-(2*30),height:collectionView.frame.height)
    }
    
}

//MARK: - Extension:HSQuizStyleSelectionCellProtocol
extension HSQuizStyleSelectionController:HSQuizStyleSelectionCellProtocol {
    func didTapChooseThisStyle(quiz: HSQuiz) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.customView?.alpha = 1.0
        
        self.dataSource?.quiz?.forEach({ q in
            q.isSelected = false
        })
        quiz.isSelected = true
        selectedQuiz = quiz
        self.collectionView.reloadData()
        
      /*  let alertController = UIAlertController.init(title: AppCons.APPNAME, message: "Are you confirm with '\(quiz.client?.header ?? "")' Quiz?", preferredStyle: .actionSheet)
        
        let okayAction = UIAlertAction.init(title: "Confirm", style: .default, handler: { tapped in
            self.postQuiz(quiz: quiz)
        })
        alertController.addAction(okayAction)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: {tapped in
            sender.btnType = .typeC
        })
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)*/
    }
}
