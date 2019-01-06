//
//  myCustomButton.swift
//  My Quotes
//
//  Created by FarouK on 05/01/2019.
//  Copyright © 2019 FarouK. All rights reserved.
//

import UIKit

class myCustomButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        layer.cornerRadius = frame.height / 2
        setTitleColor(UIColor.white, for: .normal)
    }

}
