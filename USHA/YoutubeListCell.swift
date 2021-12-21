//
//  YoutubeListCell.swift
 
//
//  Created by Kav Interactive on 14/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class YoutubeListCell: UITableViewCell {

    @IBOutlet var imageVew:UIImageView!
    @IBOutlet var titleLabel:UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
