//
//  parseTableViewCell.swift
//  Agora iOS Voice Tutorial
//
//  Created by Apple on 02/03/19.
//  Copyright © 2019 Agora. All rights reserved.
//

import UIKit

class parseTableViewCell: UITableViewCell {
    
    
    @IBOutlet var imgProfile: UIImageViewX!
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
