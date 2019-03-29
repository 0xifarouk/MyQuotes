//
//  AppDelegate.swift
//  My Quotes
//
//  Created by FarouK on 03/01/2019.
//  Copyright © 2019 FarouK. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let dataController = DataController(modelName: "Quotes")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        //        if let tab = window?.rootViewController as? UITabBarController {
        //            for child in tab.viewControllers ?? [] {
        //                if let top = child as? PersistenceStackClient {
        //                    top.setStack(stack: dataController)
        //                }
        //            }
        //        }
        
        dataController.load()
        let rootController = window?.rootViewController
        
        if rootController is UITabBarController {
            let firstTabItem = (rootController as! UITabBarController).viewControllers?[0]
            let seconedTabItem = (rootController as! UITabBarController).viewControllers?[1]
            
            if firstTabItem is UINavigationController {
                
                let firstController = (firstTabItem as! UINavigationController).viewControllers.first as! NewQuoteViewController
                firstController.dataController = dataController
            }
            if seconedTabItem is UINavigationController {
                
                let seconedController = (seconedTabItem as! UINavigationController).viewControllers.first as! MyQuotesTableViewController
                seconedController.dataController = dataController
            }
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveViewContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveViewContext()
    }
    
    func saveViewContext() {
        try? dataController.viewContext.save()
    }
}

