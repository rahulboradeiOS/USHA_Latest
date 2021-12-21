//
//  NotificationDetailViewController.swift
 
//
//  Created by Apple.Inc on 23/07/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import SQLite
class NotificationDetailViewController: BaseViewController {
   
    
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var lbl_notificationMsg: UILabel!
    
    @IBOutlet weak var lbl_notificationDetail: UILabel!
    @IBOutlet weak var lbl_notificationDate: UILabel!
    
    @IBOutlet weak var btn_viewMore: UIButton!
    
    @IBOutlet weak var btn_share: UIButton!
    var notification:Notification!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lbl_notificationMsg.text = notification.NotificationMsg
        lbl_notificationDetail.text = notification.NotificationMsg
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //"yyyy-MM-ddTHH:mm:ss.SSS" //"yyyy-mm-ddTHH:mm:ss.S"
  
        if let d = dateFormatter.date(from: notification.NotificationDate)
        {
            dateFormatter.dateFormat = "dd MMM,yyyy | hh:mm a "
            let dstr = dateFormatter.string(from: d)
            lbl_notificationDate.text = dstr
        }
        else
        {
            lbl_notificationDate.text = notification.NotificationDate
        }
        updateReadStatus()
    }

    @IBAction func btn_share_pressed(_ sender: UIButton)
    {
        let msg = notification.NotificationMsg!
        //let image = UIImage(named: "Image")

        let urlStr = mainUrlPowerPlus + "notificationupload/\(notification.FileUpload!)"
        //String(format: notificationFile, notification.FileUpload!)
    
        let myWebsite = NSURL(string:urlStr)
        let shareAll = [msg, myWebsite!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func btn_viewMore_pressed(_ sender: UIButton)
    {
       
        if (notification.FileUpload! == "")
        {
            showAlert(msg: "notificationNoAttachment".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
            return
        }
        
        let myURL = mainUrlPowerPlus + "notificationupload/"
        
        let urlStr = myURL + "\(notification.FileUpload!)"//String(format: myURL, notification.FileUpload!)

        if let url = URL(string: urlStr)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func updateReadStatus()
    {
        guard let db = DataProvider.getDBConnection() else { print("DB Error in notification get from db"); return}
        do{
            
            //try db.run(NotificationTable.update(ReadStatus <- "unread"))
            let alice = NotificationTable.where(PK_ID == notification.Id)
            try db.run(alice.update(ReadStatus <- "read"))
        }catch
        {
            print("error in update notification from db")
            print(db)
        }
    }
    
    @IBAction func onBackBttnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
