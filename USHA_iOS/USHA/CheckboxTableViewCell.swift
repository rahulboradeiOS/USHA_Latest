//
//  CheckboxTableViewCell.swift
 
//
//  Created by Kav Interactive on 29/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit
protocol CheckboxTableViewCellDelegate:class {
    func checkboxBtnPressed()
}
class CheckboxTableViewCell: UITableViewCell {

    
     @IBOutlet var btn1:UIButton!
    @IBOutlet var lbl1:UILabel!
    
     weak  var delegate : CheckboxTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btn1.clipsToBounds = true
        self.btn1.layer.cornerRadius = 5
        self.btn1.layer.borderWidth = 0.5
        self.btn1.layer.borderColor = UIColor.black.cgColor
        
    }
}
