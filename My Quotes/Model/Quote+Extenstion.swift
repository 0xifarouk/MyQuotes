//
//  Quote+Extenstion.swift
//  My Quotes
//
//  Created by FarouK on 04/01/2019.
//  Copyright © 2019 FarouK. All rights reserved.
//

import Foundation

extension Quote {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}


