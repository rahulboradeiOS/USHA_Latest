//
//  AccumulationSummaryDetailTableViewCell.swift
//  DemoApp
//
//  Created by New on 19/11/17.
//  Copyright © 2017 omkar khandekar. All rights reserved.
//

import UIKit

class AccumulationSummaryDetailTableViewCell: UITableViewCell
{
    @IBOutlet weak var lbl_pin: UILabel!
    @IBOutlet weak var lbl_amount: UILabel!
    @IBOutlet weak var lbl_status: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
