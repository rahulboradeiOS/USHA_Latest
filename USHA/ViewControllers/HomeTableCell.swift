//
//  HomeTableCell.swift
 
//
//  Created by Kav Interactive on 10/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class HomeTableCell: UITableViewCell {

    @IBOutlet var backkgroundView:UIView!
    @IBOutlet var toptitle:UILabel!
    @IBOutlet var notificationLabel:UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backkgroundView.layer.borderWidth = 1
        self.backkgroundView.layer.borderColor = UIColor.gray.cgColor
        self.backkgroundView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
