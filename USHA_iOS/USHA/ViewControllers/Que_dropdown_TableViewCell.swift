//
//  Que_dropdown_TableViewCell.swift
//  SAMPARK
//
//  Created by Naveen on 28/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class Que_dropdown_TableViewCell: UITableViewCell {

    @IBOutlet weak var btn_Que_dropdown: UIButton!
    @IBOutlet weak var textField_Que_dropdown: UITextField!
    @IBOutlet weak var lbl_Que_dropdown: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
