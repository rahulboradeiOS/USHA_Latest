//
//  RadioTableViewCell.swift
 
//
//  Created by Kav Interactive on 29/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class RadioTableViewCell: UITableViewCell {
  
    @IBOutlet var bttn1:UIButton!
    @IBOutlet var lbbl1:UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bttn1.clipsToBounds = true
        self.bttn1.layer.cornerRadius = 15
        self.bttn1.layer.borderWidth = 1
        self.bttn1.layer.borderColor = UIColor.black.cgColor
       
    }

}
