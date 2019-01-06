//
//  DataController.swift
//  My Quotes
//
//  Created by FarouK on 04/01/2019.
//  Copyright © 2019 FarouK. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext(interval: 30)
            completion?()
        }
    }
}

extension DataController {
    
    func autoSaveViewContext(interval: TimeInterval = 30) {
        print("auto saving :)")
        guard interval > 0 else {
            print("cannot save negative time interval for saving!")
            return
        }
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
