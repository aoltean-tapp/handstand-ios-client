//
//  HSBaseTabBarController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/23/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSBaseTabBarController: UITabBarController {
    
    //MARK: - iVars
    lazy var homeController = HSHomeTileController()
    lazy var workoutController = HSMyWorkoutController()
    lazy var favoritesController = HSFavoritesController()
    lazy var profileController = HSProfileViewController()
    
    //MARK: - Overriden functions
    override func viewDidLoad() {
        super.viewDidLoad()
        observeAdditionalflows()
        configureTabBarItems()
    }
    
    //MARK: - Private functions
    private func configureTabBarItems() {
        let homeNC = HSBaseNavigationController.init(rootViewController: homeController)
        homeNC.navigationBar.isTranslucent = false
        let workoutNC = HSBaseNavigationController.init(rootViewController: workoutController)
        let favoritesNC = HSBaseNavigationController.init(rootViewController: favoritesController)
        let profileNC = HSBaseNavigationController.init(rootViewController: profileController)
        
        UITabBar.appearance().backgroundColor = UIColor.rgb(0xF8F8F8)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:HSColorUtility.tabBarTextColor()], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.handstandGreen()], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName:HSFontUtilities.avenirNextRegular(size: 10)], for: .normal)
        
        homeController.tabBarItem = UITabBarItem(
            title: "Home",
            image: #imageLiteral(resourceName: "icHomeTabInActive").withRenderingMode(UIImageRenderingMode.alwaysOriginal),
            selectedImage:#imageLiteral(resourceName: "icHomeTabActive").withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        workoutController.tabBarItem = UITabBarItem(
            title: "Workouts",
            image: #imageLiteral(resourceName: "icMyWorkoutsTabInActive").withRenderingMode(UIImageRenderingMode.alwaysOriginal),
            selectedImage: #imageLiteral(resourceName: "icMyWorkoutsTabActive").withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        favoritesController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: #imageLiteral(resourceName: "icFavoritesTabInActive").withRenderingMode(UIImageRenderingMode.alwaysOriginal),
            selectedImage: #imageLiteral(resourceName: "icFavoritesTabActive").withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        profileController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: #imageLiteral(resourceName: "icMyProfileTabInActive").withRenderingMode(UIImageRenderingMode.alwaysOriginal),
             selectedImage: #imageLiteral(resourceName: "icMyProfileTabActive").withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        
        viewControllers = [homeNC, workoutNC,favoritesNC, profileNC]
    }
    private func observeAdditionalflows() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(HSBaseTabBarController.pushWorkoutScreen), name: NSNotification.Name(rawValue: "Notification.showMyWorkout"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(HSMainViewController.didSetHomeScreen), name: NSNotification.Name(rawValue: "Notification.showHomeScreen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HSBaseTabBarController.showBookSession), name: NSNotification.Name(rawValue: "Notification.findTrainer"), object: nil)
    }
    
    //MARK: - Selectors
    func pushWorkoutScreen() {
        HSAnalytics.setEventForTypes(withLog: HSA.myWorkouts)
        self.selectedIndex = 1
        let workoutController = self.tabBarController?.selectedViewController as? HSMyWorkoutController
        workoutController?.upcomingButton.isSelected = true
        workoutController?.fetchWorkouts(true)
    }
    
    func showBookSession()  {
        HSAnalytics.setEventForTypes(withLog: HSA.bookTrainerTileClick)
        let homeCntrl = HSHomeController()
        homeCntrl.hidesBottomBarWhenPushed = true
        let nc = self.selectedViewController as? UINavigationController
        nc?.pushViewController(homeCntrl, animated: true)
    }
}
