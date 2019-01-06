//
//  MyTableViewCell.swift
//  My Quotes
//
//  Created by FarouK on 04/01/2019.
//  Copyright © 2019 FarouK. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var customBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customBackgroundView.layer.shadowOpacity = 1
        customBackgroundView.layer.shadowOffset = CGSize.zero
        customBackgroundView.layer.shadowColor = UIColor.darkGray.cgColor
        customBackgroundView.layer.cornerRadius = 10
        
    }


}
