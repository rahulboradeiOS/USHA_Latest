// TableViewCell.swift
//  DemoApp
//
//  Created by omkar khandekar on 04/11/17.
//  Copyright © 2017 omkar khandekar. All rights reserved.
//

import UIKit

class SamparkTableViewCell: UITableViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
