//
//  PersistenceStackClientProtocol.swift
//  My Quotes
//
//  Created by FarouK on 04/01/2019.
//  Copyright © 2019 FarouK. All rights reserved.
//

import Foundation
import CoreData


protocol PersistenceStackClient {
    
    func setStack(stack: DataController)
    
}
