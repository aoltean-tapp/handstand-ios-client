//
//  HSPrimaryLaunchScreen.swift
//  Handstand
//
//  Created by science on 8/3/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

fileprivate let launchScreenItems:CGFloat = 5.0

class HSPrimaryLaunchScreen: HSBaseController,UIScrollViewDelegate {
    
    @IBOutlet weak var loaderView: UIView!
    var animeIterationCount : Int = 0
    var noOfIteration:Int = 3
    
    @IBOutlet var hIconImage: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var timer : Timer! = nil
    var currentPage : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.screenName = HSA.getStartedScreen
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * launchScreenItems, height:self.scrollView.frame.height)
        self.automaticallyAdjustsScrollViewInsets = false
        
        fetchClassTypesWithAppVersion()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func fetchClassTypesWithAppVersion() {
        self.startAnimation()
        HSSystemNetworkHandler().fetchClassTypes { (success, error) in
            self.stopAnimation()
            let nc = HSBaseNavigationController.init(rootViewController: HSEntryScreenController())
            appDelegate.window?.rootViewController = nc
            if error?.code == eErrorType.invalidAppVersion {
                HSApp().alertUserToForceDownloadNewVersion((error?.message!)!)
            }
            else{
                if error?.code == eErrorType.updateAppVersion {
                    HSApp().alertUserToDownloadNewVersion((error?.message)!)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if animeIterationCount == noOfIteration {
            createTimer()
        }
        HSAnalytics.setEventForTypes(withLog: HSA.getStartedSlide1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        invalidateTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Timer for slideshow
    func createTimer()  {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.updatePage), userInfo: nil, repeats: true)
        }
    }
    
    func invalidateTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    func updatePage() {
        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * launchScreenItems
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        if  contentOffset + pageWidth == maxWidth {
            slideToX = 0
        }
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
        
        if currentPage == launchScreenItems-1 {
            currentPage = 0
        }else {
            currentPage += 1
        }
        self.pageControl.currentPage = Int(currentPage)
        self.trackEvent()
    }
    
    func trackEvent() {
        let pagecount = self.pageControl.currentPage+1
        let constant = "Get_Started_Slide_"+"\(pagecount)"
        HSAnalytics.setEventForTypes(withLog: constant)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        self.currentPage = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage)
        self.trackEvent()
    }
    
    //MARK: - Button Actions
    @IBAction func didTapGetStarted(_ sender: Any) {
        self.navigationController?.pushViewController(HSSignupController(), animated: true)
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        self.navigationController?.pushViewController(HSLoginController(), animated: true)
    }
    
    func startAnimation()  {
        if animeIterationCount == noOfIteration {
            self.loaderView.alpha = 0.4
            UIView.animate(withDuration: 0.5, animations: {
                self.loaderView.alpha = 0.0
            }, completion: { (done) in
                self.loaderView.removeFromSuperview()
                self.createTimer()
            })
            return
        }
        UIView.animate(withDuration: 0.6,
                       animations: {
                        self.hIconImage.alpha = 0.3
                        self.hIconImage.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6,
                                       animations: {
                                        self.hIconImage.alpha = 1.0
                                        self.hIconImage.transform = CGAffineTransform.identity
                        },
                                       completion: { _ in
                                       // self.animeIterationCount = self.animeIterationCount + 1
                                        self.startAnimation()
                        })
        })
    }
    
    func stopAnimation () {
        animeIterationCount = noOfIteration
    }
    
}

