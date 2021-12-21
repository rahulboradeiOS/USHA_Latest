//
//  GalleryTableViewCell.swift
 
//
//  Created by apple on 02/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblMesssage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
