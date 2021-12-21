//
//  SurveyPendingTableViewCell.swift
 
//
//  Created by Naveen on 27/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class SurveyPendingTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_msg_servery: UILabel!
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var img_servey: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
