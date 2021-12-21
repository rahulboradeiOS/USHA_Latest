//
//  CustomUIView.swift
//  AGCustomViewBy_XIB
//
//  Created by Aman Gupta on 11/10/17.
//  Copyright © 2017 aman19ish. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift
import SQLite

class NavigationUIView: UIView
{
    //MARK: - IBOutlets
    @IBOutlet var custumView: UIView!
    @IBOutlet weak var view_bar: UIView!
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var btn_dashboard: UIButton!
    @IBOutlet weak var btn_dashbord_width: NSLayoutConstraint!
    @IBOutlet weak var btn_notification: MIBadgeButton!
    @IBOutlet weak var btn_notification_width: NSLayoutConstraint!
    @IBOutlet weak var img_logo_width: NSLayoutConstraint!
    
    @IBOutlet weak var btn_menu: UIButton!
    @IBOutlet weak var view_balance: UIView!
    @IBOutlet weak var lbl_point: UILabel!
    @IBOutlet weak var lbl_mobile: UILabel!
    @IBOutlet weak var lbl_code: UILabel!
    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var btn_back_width: NSLayoutConstraint!
    @IBOutlet weak var lbl_shopName: UILabel!
    @IBOutlet weak var lbl_mobNo: UILabel!
    
    @IBOutlet weak var img_small: UIImageView!
    //MARK: - UIView Overided methods
    @IBOutlet weak var img_smallWidth: NSLayoutConstraint!
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    override init(frame: CGRect) {
        // Call super init
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        configureXIB()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        configureXIB()
    }
    
    //MARK: - Custom Methods
    func configureXIB() {
        custumView = configureNib()
        
        // use bounds not frame or it'll be offset
        custumView.frame = bounds
        
        // Make the flexible view
        custumView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(custumView)
        
        getNotificationCountFromDB()
    }
    
    func configureNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NavigationUIView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
   
    func getNotificationCountFromDB()
    {
//        guard let db = DataProvider.getDBConnection() else { print("DB Error in notification get from db"); return}
//        let status = Expression<String>("ReadStatus")
//        let readStatus = "unread"
//        do{
//            let all = Array(try db.prepare(NotificationTable.filter(status == readStatus)))
//            btn_notification.badgeFont = UIFont.boldSystemFont(ofSize: 12)
//            btn_notification.badgeString = "\(all.count)"
//            btn_notification.badgeEdgeInsets = UIEdgeInsetsMake(20, 15, 0, 25)
//            btn_notification.badgeBackgroundColor = #colorLiteral(red: 0.737254902, green: 0.07450980392, blue: 0.1607843137, alpha: 1)
          
//            let application = UIApplication.shared
//            application.applicationIconBadgeNumber = all.count
//        }catch
//        {
//            print("Error : \(error.localizedDescription)")
//        }
    }
}
