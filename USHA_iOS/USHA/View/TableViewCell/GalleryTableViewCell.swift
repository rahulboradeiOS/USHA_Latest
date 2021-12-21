//
//  GalleryTableViewCell.swift
//  SAMPARK
//
//  Created by apple on 01/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {

    @IBOutlet weak var Image_view: UIImageView!
    @IBOutlet weak var Title_view: UILabel!
    @IBOutlet weak var Messages: UILabel!
    
    
    var dist = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
