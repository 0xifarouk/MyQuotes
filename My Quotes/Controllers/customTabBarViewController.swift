//
//  customTabBarViewController.swift
//  My Quotes
//
//  Created by FarouK on 04/01/2019.
//  Copyright © 2019 FarouK. All rights reserved.
//

import UIKit


class customTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    let selectedTabIndexKey = "selectedTabIndex"
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.5215686275, green: 0.5019607843, blue: 0.6588235294, alpha: 1)
        generator.prepare()
        if UserDefaults.standard.object(forKey: self.selectedTabIndexKey) != nil {
            self.selectedIndex = UserDefaults.standard.integer(forKey: self.selectedTabIndexKey)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        UserDefaults.standard.set(self.selectedIndex, forKey: self.selectedTabIndexKey)
        UserDefaults.standard.synchronize()
        generator.impactOccurred()
    }
}
