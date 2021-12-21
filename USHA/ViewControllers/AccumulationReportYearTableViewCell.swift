//
//  AccumulationReportDetailTableViewCell.swift
//  DemoApp
//
//  Created by New on 27/11/17.
//  Copyright © 2017 omkar khandekar. All rights reserved.
//

import UIKit

class AccumulationReportYearTableViewCell: UITableViewCell
{

    @IBOutlet weak var lbl_schemeName: UILabel!
    @IBOutlet weak var lbl_divsion: UILabel!
   // @IBOutlet weak var lbl_category: UILabel!
    @IBOutlet weak var lbl_Points: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
