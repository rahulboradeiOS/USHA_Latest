//
//  YouTubeTableViewCell.swift
 
//
//  Created by apple on 04/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class YouTubeTableViewCell: UITableViewCell {

    @IBOutlet weak var ImgChannel: UIImageView!
    @IBOutlet weak var lblChannelTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
