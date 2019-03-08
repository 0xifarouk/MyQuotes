//
//  MyTableViewCell.swift
//  My Quotes
//
//  Created by FarouK on 04/01/2019.
//  Copyright © 2019 FarouK. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var lightBackgroudView: UIView!
    @IBOutlet weak var customBackgroundView: UIView!
    @IBOutlet weak var deleteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customBackgroundView.layer.shadowOpacity = 1
        customBackgroundView.layer.shadowOffset = CGSize.zero
        customBackgroundView.layer.shadowColor = UIColor.darkGray.cgColor
        customBackgroundView.layer.cornerRadius = 10
    }
    
    func makeSwapAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.customBackgroundView.transform = CGAffineTransform(translationX: -65, y: 0)
            self.lightBackgroudView.transform = CGAffineTransform(translationX: -65, y: 0)
            self.lightBackgroudView.layer.cornerRadius = 5
            
        }) { (succes) in
            UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveLinear, animations: {
                self.customBackgroundView.transform = .identity
                self.lightBackgroudView.transform = .identity
                self.lightBackgroudView.layer.cornerRadius = 0
                
            })
        }
    }


}
