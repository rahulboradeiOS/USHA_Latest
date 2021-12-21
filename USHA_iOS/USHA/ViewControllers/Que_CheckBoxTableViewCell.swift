//
//  Que_CheckBoxTableViewCell.swift
//  SAMPARK
//
//  Created by Naveen on 28/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class Que_CheckBoxTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_Que_Checkbox: UILabel!
    
    @IBOutlet weak var btn_Que_Checkbox: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
