//
//  ForthDisTableViewCell.swift
//  USHA Retailer
//
//  Created by Rahul on 25/03/21.
//  Copyright © 2021 Apple.Inc. All rights reserved.
//

import UIKit

class ForthDisTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedDistributorLbl: UILabel!
    @IBOutlet weak var removeselectedDistributorBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
