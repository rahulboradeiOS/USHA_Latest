//
//  SelectedAnsTableViewCell.swift
 
//
//  Created by Naveen on 08/08/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class SelectedAnsTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_Qun: UILabel!
    @IBOutlet weak var lbl_Ans: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
