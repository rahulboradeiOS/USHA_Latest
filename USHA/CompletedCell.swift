//
//  CompletedCell.swift
 
//
//  Created by Naveen on 28/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class CompletedCell: UITableViewCell {

    @IBOutlet weak var img_Completed_Survery: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
