//
//  DashboardCollectionViewCell.swift
 
//
//  Created by Apple.Inc on 28/05/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {
    
    //Dashboard
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_value: UILabel!
    @IBOutlet weak var img_icon: UIImageView!
    
    @IBOutlet weak var lbl_line_left: UILabel!
    @IBOutlet weak var lbl_line_top: UILabel!
    @IBOutlet weak var lbl_line_right: UILabel!
    @IBOutlet weak var lbl_line_bottom: UILabel!
    
    //Performance
    @IBOutlet weak var lbl_points: UILabel!
    @IBOutlet weak var view_bg: UIView!
    
    //Calender
    @IBOutlet weak var lbl_monthName: UILabel!
    @IBOutlet weak var lbl_dayName: UILabel!
    @IBOutlet weak var lbl_day: UILabel!
    
}
