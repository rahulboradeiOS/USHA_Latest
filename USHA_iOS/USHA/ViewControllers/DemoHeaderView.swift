//
//  DemoHeaderView.swift
//  CustomHeaderDemo
//
//  Created by Macintosh HD on 11/24/17.
//  Copyright © 2017 iOS-Tutorial. All rights reserved.
//

import UIKit

class DemoHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var lbl_oderName: UILabel!
    @IBOutlet weak var lbl_qty: UILabel!
    @IBOutlet weak var lbl_amount: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


class SchemeHeaderTableViewCell : UITableViewCell{
    
    @IBOutlet weak var lbl_schemeName: UILabel!
    @IBOutlet weak var lbl_StartDate: UILabel!
    @IBOutlet weak var lbl_EndDate: UILabel!
    @IBOutlet weak var lbl_Status: UILabel!
    @IBOutlet weak var lbl_Download: UILabel!
    
}
