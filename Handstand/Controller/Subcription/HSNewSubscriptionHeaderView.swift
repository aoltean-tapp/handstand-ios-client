//
//  HSNewSubscriptionHeaderView.swift
//  Handstand
//
//  Created by Ranjith Kumar on 1/10/18.
//  Copyright © 2018 Handstand. All rights reserved.
//

import UIKit

protocol SubscriptionHeaderViewProtocol:class {
    func didChangePlan()
}

class HSNewSubscriptionHeaderView: UIView {

    //MARK: - iVars
    @IBOutlet weak var subscribeLbl:UILabel! {
        didSet{
            let attributedString = NSMutableAttributedString(string: "SUBSCRIBE TODAY AND GET YOUR", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
            attributedString.append(NSAttributedString(string:"\n"))
            attributedString.append(NSAttributedString(string: "EXCLUSIVE CONTENT", attributes: [NSForegroundColorAttributeName: UIColor.handstandGreen()]))
            subscribeLbl.attributedText = attributedString
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(HSNewSubscriptionHeaderCell.nib(), forCellWithReuseIdentifier: HSNewSubscriptionHeaderCell.reuseIdentifier())
            collectionView.delegate = self
            collectionView.dataSource = self
            let layout = UPCarouselFlowLayout.init()
            layout.itemSize = CGSize(width:UIScreen.main.bounds.width-(2*30),height:collectionView.frame.height-20)
            layout.sideItemScale = 1.0
            layout.sideItemAlpha = 0.8
            layout.scrollDirection = .horizontal
            layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 20)
            collectionView.setCollectionViewLayout(layout, animated: false)
        }
    }
    @IBOutlet weak var pageControl: UIPageControl!
    fileprivate var currentPage: Int = 0
    public weak var delegate:SubscriptionHeaderViewProtocol?
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        return pageSize
    }

    public var dataSource:HSGetNewSubscriptionsResponse? {
        didSet {
            pageControl.numberOfPages = dataSource?.data?.plans?.count ?? 0
            self.collectionView.reloadData()
        }
    }

    //MARK: - Public functions
    public class func getHeight(with d_count:Int) -> CGFloat {
        return d_count>0 ? 330 : 310
    }
}

//MARK: - Extension:UICollectionViewDelegate
extension HSNewSubscriptionHeaderView:UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource?.data?.plans?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HSNewSubscriptionHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: HSNewSubscriptionHeaderCell.reuseIdentifier(), for: indexPath) as! HSNewSubscriptionHeaderCell
        let plan = self.dataSource?.data?.plans![indexPath.row]
        cell.populate(data: plan!)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        self.pageControl.currentPage = currentPage
        self.dataSource?.data?.plans?.forEach({ (plan) in
            plan.isSelected = false
        })
        let planData = self.dataSource?.data?.plans![currentPage]
        planData?.isSelected = true
        self.delegate?.didChangePlan()
    }
}
