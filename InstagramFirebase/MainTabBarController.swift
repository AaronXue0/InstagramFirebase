//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Aaron Xue on 2019/10/26.
//  Copyright © 2019 Aaron Xue. All rights reserved.
//

import UIKit

class MainTabBarControlle: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController =  UserProfileController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController:
            userProfileController)
        
        let profile_unselected = UIImage(named: "profile_unselected")
        navController.tabBarItem.image = profile_unselected
        let profile_selected = UIImage(named: "profile_selected")
        navController.tabBarItem.selectedImage = profile_selected
        
        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
    }
}
