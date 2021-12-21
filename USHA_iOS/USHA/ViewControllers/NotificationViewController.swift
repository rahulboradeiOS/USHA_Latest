//
//  NotificationViewController.swift
 
//
//  Created by Apple.Inc on 23/07/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import SQLite
//import ActiveLabel
//import ExpandableLabel

let NotificationTable = Table("NotificationTable")
let PK_ID = Expression<Int>("PK_ID")
let NotificationMsg = Expression<String>("NotificationMsg")
let NotificationDate = Expression<String>("NotificationDate")
let Types = Expression<String>("Types")
let FileUpload = Expression<String>("FileUpload")
let ReadStatus = Expression<String>("ReadStatus")


class Notification: NSObject
{
    var Id:Int!
    var NotificationMsg:String!
    var NotificationDate:String!
    var Types:String!
    var FileUpload:String!
    var ReadStatus:String!
}

class NotificationViewController: BaseViewController
{
    var arr_notification = [Notification]()
    
    @IBOutlet weak var img_noNotification: UIImageView!
    @IBOutlet weak var tableView_Notification: UITableView!
    
    var alertTag = 0

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView_Notification.isHidden = true
        if(Connectivity.isConnectedToInternet())
        {
            GetAllNotifications()
        }
        else
        {
            alertTag = 1
            showAlert(msg: "noInternetConnection_SyncNotification".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(<#Bool#>)
//         tableView_Notification.isHidden = true
//               if(Connectivity.isConnectedToInternet())
//               {
//                   GetAllNotifications()
//               }
//               else
//               {
//                   alertTag = 1
//                   showAlert(msg: "noInternetConnection_SyncNotification".localizableString(loc:
//                       UserDefaults.standard.string(forKey: "keyLang")!))
//               }
//    }

    @IBAction func onBackBttnPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getNotificationFromDB()
    }
    
    
    func GetAllNotifications()
    {
        var lastSyncDate: String = ""
        let pref =  UserDefaults.standard
        if let date = pref.string(forKey: defaultsKeys.lastNotificationSyncDate) {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:MM:SS" //2018-07-04 19:24:21
            lastSyncDate = date //dateFormatter.string(from: date)
        }
        
        
//        jsonTabNumber.put("ActionType","GetAll");
//        jsonTabNumber.put("Types","Notification");
//        jsonTabNumber.put("StartDate","");
        
        let parameters:Parameters = [Key.ActionType : ActionType.GetAll,  Key.Types : "Notification", Key.StartDate :""]
        
        print(parameters)
        
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.GetAllNotifications, parameters: parameters, viewcontroller: self, actionType: API.GetAllNotifications)
    }
    
    func addSeeMore(str: String, maxLength: Int) -> NSAttributedString
    {
        var attributedString = NSMutableAttributedString()
//        let font = UIFont.boldSystemFont(ofSize: 14)
        
//        NSMutableAttributedString(string:"...See More" , attributes:[.font: font, .underlineStyle: NSUnderlineStyle.styleDouble.rawValue, .foregroundColor: #colorLiteral(red: 0.7215686275, green: 0.09411764706, blue: 0.1450980392, alpha: 1)])
        
        let index: String.Index = str.index(str.startIndex, offsetBy: maxLength)
        let font1 = UIFont.boldSystemFont(ofSize: 14)
        let editedText = String(str.prefix(upTo: index)) + "...See More"
        //attributedString = NSAttributedString(string: editedText)
        

        attributedString = NSMutableAttributedString(string:editedText , attributes:[.font: font1, .underlineStyle: NSUnderlineStyle.styleDouble.rawValue, .foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        
        return attributedString
    }
    
    @IBAction func btn_readMore_pressed(_ sender: UIButton)
    {
        let notificationDetailVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationDetailViewController) as! NotificationDetailViewController
        notificationDetailVC.notification = arr_notification[sender.tag]
        self.navigationController?.pushViewController(notificationDetailVC, animated: true)
    }
    
}

extension NotificationViewController
{
    func didRecivedGetAllNotifications(responseData: [[String : Any]])
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:MM:SS" //2018-07-04 19:24:21
        let dStr = dateFormatter.string(from: Date())
        setUserDefaults(value: dStr, key: defaultsKeys.lastNotificationSyncDate)
        
        guard let db = DataProvider.getDBConnection() else { print("DB Error in notification save"); return}

        var arrNotification = [[String:Any]]()
        for var item in responseData
        {
            item["ReadStatus"] = "unread"
            arrNotification.append(item)
            do
            {
                let itExists = try db.scalar(NotificationTable.exists)
                if itExists {
                    //Do stuff
                    insert(item: item, database: db)
                }
                else
                {
                    if(createTable(database: db))
                    {
                        insert(item: item, database: db)
                    }
                    else
                    {
                        print("Error to create NotificationTable")
                    }
                }
            } catch {
                print("Error in notification doesn't exit NotificationTable")
                print(error)
                if(createTable(database: db))
                {
                    insert(item: item, database: db)
                }
                else
                {
                    print("Error to create NotificationTable")
                }
            }
        }
        getNotificationFromDB()
        
        let viewNotifVC = HomeViewController()
        viewNotifVC.getNotificationCountFromDB()

    }
    
    func createTable(database:Connection) -> Bool
    {
        do
        {
            try database.run(NotificationTable.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { t in
                t.column(PK_ID, primaryKey: true)
                t.column(NotificationMsg)
                t.column(NotificationDate)
                t.column(Types)
                t.column(FileUpload)
                t.column(ReadStatus)
            }))
            return true
        } catch {
            print("Error in notification table create")
            print(error)
            return false
        }
    }
    
    func insert(item:[String:Any], database:Connection)
    {
        let insert = NotificationTable.insert(
            PK_ID <- item["Id"] as? Int ?? 0,
            NotificationMsg <- item["NotificationMsg"] as? String ?? "",
            NotificationDate <- item["NotificationDate"] as? String ?? "",
            Types <- item["Types"] as? String ?? "",
            FileUpload <- item["FileUpload"] as? String ?? "",
            ReadStatus <- item["ReadStatus"] as? String ?? ""
        )
        
        do
        {
            let rowid = try database.run(insert)
            print(rowid)
        } catch {
            print("Error in insert to notification item")
            print(error)
        }
    }
    
    func getNotificationFromDB()
    {
        guard let db = DataProvider.getDBConnection() else { print("DB Error in notification get from db"); return}

        do{
            var arrNotifications = [Notification]()
            for notification in try db.prepare(NotificationTable)
            {
                let noti = Notification()
                noti.Id = notification[PK_ID]
                noti.NotificationMsg = notification[NotificationMsg]
                noti.NotificationDate = notification[NotificationDate]
                noti.FileUpload = notification[FileUpload]
                noti.Types = notification[Types]
                noti.ReadStatus = notification[ReadStatus]
                arrNotifications.append(noti)
            }
            self.arr_notification = arrNotifications
            if(self.arr_notification.count > 0)
            {
                tableView_Notification.isHidden = false
                img_noNotification.isHidden = true
                tableView_Notification.reloadData()
            }
            else
            {
                tableView_Notification.isHidden = true
                img_noNotification.isHidden = false
            }
        }catch
        {
            print("error in featch notification from db")
            print(db)
        }
    }
    
    override func onOkPressed(alert: UIAlertAction!)
    {
        if alertTag == 1
        {
            getNotificationFromDB()
        }
    }
}

extension NotificationViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_notification.count
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
//        headerView.backgroundColor = .white
//        let headerCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AccumulationSummaryDetailTableViewCell
//        headerCell.lbl_pin.text = "Pin"
//        headerCell.lbl_amount.text = "Point"
//        headerCell.lbl_status.text = "Status"
//        headerView.addSubview(headerCell)
//        headerCell.frame = headerView.frame
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? NotificationTableViewCell {
            cell.selectionStyle = .none
            //cell.bg_view.setShadow()
            let noti = arr_notification[indexPath.row]
            
            
            cell.lbl_notificationMsg.numberOfLines = 1

            cell.lbl_notificationMsg.text = noti.NotificationMsg
            cell.lalDate.text = noti.NotificationDate
            let readmoreFont = UIFont.boldSystemFont(ofSize: 14)
            let readmoreFontColor = #colorLiteral(red: 0.7725490196, green: 0.2, blue: 0.262745098, alpha: 1)
//            DispatchQueue.main.async {
//                cell.lbl_notificationMsg.addTrailing(with: " ", moreText: "...Read More", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
//            }
//            cell.imageView?.frame = CGRect(x: 8, y: 20, width: 35, height: 35)
//            view.addSubview(view)
            if(noti.ReadStatus == "unread")
            {
                cell.bg_view.backgroundColor = UIColor.white
                cell.lalDate.backgroundColor = UIColor.white
                cell.imageView?.image = UIImage(named: "ic_unread.png")
                //cell.Noti_View.borderColor = UIColor.lightGray
            }
            else
            {
                cell.bg_view.backgroundColor = .white
                cell.lalDate.backgroundColor = .white
                cell.Noti_View.borderColor = .white
                cell.imageView?.image = UIImage(named: "ic_survey_complited.png")
                
            }
           
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            let getString = noti.NotificationDate
            let passString = getString?.prefix(19)
            print(passString!)
            
            
            if let d = dateFormatter.date(from: "\(passString!)")
            {
                dateFormatter.dateFormat = "dd MMM,yyyy | hh:mm a "
                let dstr = dateFormatter.string(from: d)
                cell.lalDate.text = dstr
            }

            
            cell.borderColor = UIColor.lightGray
            cell.borderWidth = 3
            
            return cell
        }
        return UITableViewCell()
    }
    

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let notificationDetailVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationDetailViewController) as! NotificationDetailViewController
        notificationDetailVC.notification = arr_notification[indexPath.row]
        self.navigationController?.pushViewController(notificationDetailVC, animated: true)
    }
    
}



class NotificationTableViewCell : UITableViewCell
{
//    @IBOutlet weak var lbl_notificationMsg: ExpandableLabel!
    
//    @IBOutlet weak var lbl_notificationMsg: ActiveLabel!
    @IBOutlet weak var lalDate:UILabel!
    @IBOutlet weak var lbl_notificationMsg: UILabel!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var image_read_change: NSLayoutConstraint!
    @IBOutlet weak var Noti_View: UIView!
    @IBOutlet weak var btn_readMore: UIButton!
}

extension UILabel {
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        
        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        
        var location = ((trimmedString?.count ?? 0) - readMoreLength) - 5
        
        var trimmedForReadMore: String!
        if location < 0
        {
            location = (trimmedString?.count)!
            trimmedForReadMore = trimmedString! + trailingText
        }
        else
        {
            trimmedForReadMore = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: (location), length: readMoreLength), with: "") + trailingText
        }
        
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedStringKey.font: self.font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedStringKey.font: moreTextFont, NSAttributedStringKey.foregroundColor: moreTextColor, .underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }
    
    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSAttributedStringKey.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedStringKey : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedStringKey : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}
