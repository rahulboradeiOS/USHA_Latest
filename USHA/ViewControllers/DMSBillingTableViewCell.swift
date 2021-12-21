//
//  DMSBillingTableViewCell.swift
 
//
//  Created by Naveen on 22/07/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class DMSBillingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var lbl_distCode: UILabel!
    @IBOutlet weak var lbl_divisionName: UILabel!
    @IBOutlet weak var lbl_netSales: UILabel!
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var lbl_month: UILabel!
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
