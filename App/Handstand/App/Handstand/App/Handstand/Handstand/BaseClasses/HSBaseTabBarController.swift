//
//  HSBaseTabBarController.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/23/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import UIKit

class HSBaseTabBarController: UITabBarController {
    
    lazy var homeController = HSHomeTileController()
    lazy var workoutController = HSMyWorkoutController()
    lazy var favoritesController = HSFavoritesController()
    lazy var profileController = HSProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeNC = HSBaseNavigationController.init(rootViewController: homeController)
        homeNC.navigationBar.isTranslucent = false
        let workoutNC = HSBaseNavigationController.init(rootViewController: workoutController)
        let favoritesNC = HSBaseNavigationController.init(rootViewController: favoritesController)
        let profileNC = HSBaseNavigationController.init(rootViewController: profileController)
        
        UITabBar.appearance().backgroundColor = UIColor.rgb(0xF8F8F8)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:HSColorUtility.tabBarTextColor()], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.handstandGreen()], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName:HSFontUtilities.avenirNextRegular(size: 10)], for: .normal)
        
        homeController.tabBarItem = UITabBarItem(title: "Home",
                                                 image: #imageLiteral(resourceName: "icHomeTabInActive").withRenderingMode(UIImageRenderingMode.alwaysOriginal),
                                                 selectedImage: #imageLiteral(resourceName: "icHomeTabActive").withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        workoutController.tabBarItem = UITabBarItem(title: "My Workouts",
                                                    image: #imageLiteral(resourceName: "icMyWorkoutsTabInActive").withRenderingMode(UIImageRenderingMode.alwaysOriginal),
                                                    selectedImage: #imageLiteral(resourceName: "icMyWorkoutsTabActive").withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        favoritesController.tabBarItem = UITabBarItem(title: "Favorites",
                                                      image: #imageLiteral(resourceName: "icFavoritesTabInActive").withRenderingMode(UIImageRenderingMode.alwaysOriginal),
                                                      selectedImage: #imageLiteral(resourceName: "icFavoritesTabActive").withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        profileController.tabBarItem = UITabBarItem(title: "Profile",
                                                    image: #imageLiteral(resourceName: "icMyProfileTabInActive").withRenderingMode(UIImageRenderingMode.alwaysOriginal),
                                                    selectedImage: #imageLiteral(resourceName: "icMyProfileTabActive").withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        
        viewControllers = [homeNC, workoutNC,favoritesNC, profileNC]
        
    }
    
}

