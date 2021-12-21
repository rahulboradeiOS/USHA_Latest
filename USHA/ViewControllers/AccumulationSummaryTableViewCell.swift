//
//  AccumulationSummaryTableCellTableViewCell.swift
//  DemoApp
//
//  Created by New on 19/11/17.
//  Copyright © 2017 omkar khandekar. All rights reserved.
//

import UIKit

class AccumulationSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
