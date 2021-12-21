//
//  BankDetailViewController.swift
 
//
//  Created by Apple.Inc on 09/06/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import CollieGallery
//import Haneke

enum BankDetailViewControllerAction: Int
{
    case GetBankDetails = 0
    // case Rrdeemtion
}

class BankDetailViewController: BaseViewController {

    @IBOutlet weak var lbl_bankName: UILabel!
    @IBOutlet weak var tableView_BankDetail: UITableView!
    
    @IBOutlet weak var btn_addNew: UIButton!
    
    var arr_bankDetails = [BankDetails]()
    
    var action:BankDetailViewControllerAction!

    var alertTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
                tableView_BankDetail.layer.cornerRadius = 10
                tableView_BankDetail.layer.masksToBounds = true
                tableView_BankDetail.layer.borderWidth = 2.0
                tableView_BankDetail.layer.borderColor = UIColor.init(hex: "e30613").cgColor
        
        
        tableView_BankDetail.isHidden = true
        
        btn_addNew.layer.cornerRadius = 20
        btn_addNew.layer.masksToBounds = true
        
        action = .GetBankDetails

        
        tableView_BankDetail.tableFooterView = UIView()
//        menuItem()
    }
    
    @IBAction func btn_Back_pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        checkIMEI()
    }
    func exitAlert()
    {
        let alert = UIAlertController(title: appName, message: MessageAndError.doYouWantExit, preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "YES",
                                      style: .default,
                                      handler: self.yesPressed)
        alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "No",
                                     style: .destructive,
                                     handler: self.noPressed)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
    override func onBellButtonPressed(_ sender : UIButton)
    {
        exitNotification()
        if (!(self.navigationController?.topViewController is NotificationViewController))
        {
            let notificationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationViewController) as! NotificationViewController
            self.navigationController?.pushViewController(notificationVC, animated: true)
        }
    }
    @objc func YESPRESSED(alert: UIAlertAction!)
    {
        let notificationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationViewController) as! NotificationViewController
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    func exitNotification()
    {
        let alert = UIAlertController(title: appName, message: MessageAndError.doYouWantExit, preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "YES",
                                      style: .default,
                                      handler: self.YESPRESSED)
        alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "No",
                                     style: .destructive,
                                     handler: self.noPressed)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
    @objc func yesPressed(alert: UIAlertAction!)
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func noPressed(alert: UIAlertAction!)
    {
        
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        //createMenuView()
        exitAlert()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func getGetBankDetails(userCode:String)
    {
        let parameters:Parameters = [Key.ActionTypes: ActionType.Select,  Key.UserCode : userCode]
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.GetBankDetails, parameters: parameters, viewcontroller: self, actionType: API.GetBankDetails)
    }
    
    @IBAction func btn_addNew_pressed(_ sender: UIButton)
    {
        let addBankVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.AddBankAccountViewController)
        self.navigationController?.pushViewController(addBankVC, animated: true)
    }
    
}

extension BankDetailViewController: UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arr_bankDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BankDetailListTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
//        if (indexPath.row % 2) == 0
//        {
//            cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        }
//        else
//        {
//            cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        }
        
        let bankDetail = arr_bankDetails[indexPath.row]
        cell.img_cheque.isUserInteractionEnabled = true
        cell.img_cheque.tag = indexPath.row
        
//        let URLString = "\(mainUrl)LoyaltyBankDocument/\(bankDetail.s_FileName!)"
//        let url = URL(string:URLString)!
//        //cell.img_cheque.hnk_setImageFromURL(url)
//        cell.img_cheque.downloadedFrom(url: url)
        
        addTapGesture(view:cell.img_cheque)
        cell.lbl_bankName.text = bankDetail.s_BankName
        cell.lbl_accountNo.text = bankDetail.s_BankAccountNo
        cell.lbl_IFSCCode.text = bankDetail.s_IFSCCode
        if (bankDetail.s_AccountStatus == AccountStatus.Approved)
        {
            cell.lbl_status.text = bankDetail.s_AccountStatus
            cell.lbl_status.textColor = UIColor.gray
        }
        else
        {
            cell.lbl_status.attributedText = NSAttributedString(string: bankDetail.s_AccountStatus!, attributes:
                [.underlineStyle: NSUnderlineStyle.styleDouble.rawValue,
                 .font : UIFont.systemFont(ofSize: 15.0),
                 .foregroundColor : #colorLiteral(red: 0.9253342748, green: 0.1854941547, blue: 0.2087527215, alpha: 1)])
        }
//        switch bankDetail.s_AccountStatus
//        {
//        case AccountStatus.Approved:
//            cell.lbl_status.text = bankDetail.s_AccountStatus
//            cell.lbl_status.textColor = UIColor.gray
//        case AccountStatus.Pending:
//            let attrs = [
//                NSAttributedStringKey.font.rawValue : UIFont.systemFont(ofSize: 15.0),
//                NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.9253342748, green: 0.1854941547, blue: 0.2087527215, alpha: 1),
//                NSAttributedStringKey.underlineStyle : 1] as [AnyHashable : Any]
//
//            let attributedText = NSMutableAttributedString(string:bankDetail.s_AccountStatus!, attributes:attrs as? [NSAttributedStringKey : Any])
//
//            cell.lbl_status.attributedText = attributedText
//
//        default:
//            break
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170//UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    
    func addTapGesture(view:UIImageView)
    {
        //add tapgesture
        let reginTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
        reginTapGesture.numberOfTapsRequired = 1
        //reginTapGesture.delegate = self
        view.addGestureRecognizer(reginTapGesture)
        reginTapGesture.cancelsTouchesInView = false
    }
    
    @objc func tapView(_ sender: UITapGestureRecognizer)
    {
        let view = sender.view
        let bankDetail = arr_bankDetails[(view?.tag)!]

        var pictures = [CollieGalleryPicture]()
        
        for i in 0 ..< 1 {
            //let url = "http://103.99.92.48:83/LoyaltyBankDocument/" + "\(bankDetail.s_FileName!)"
            
            let url = "\(mainUrl)LoyaltyBankDocument/\(bankDetail.s_FileName!)"
            let picture = CollieGalleryPicture(url: url, placeholder: nil, title: "Remote Image \(i)", caption: "")
            pictures.append(picture)
        }
        
//        for _ in 0 ..< 1 {
//            let image = UIImage(named: "slide03.png")!
//            let picture = CollieGalleryPicture(image: image)
//            pictures.append(picture)
//        }
        
        let options = CollieGalleryOptions()
//        options.customOptionsBlock = { [weak self] in
//            let alert = UIAlertController(title: "Hey",
//                                          message: "Custom handle block",
//                                          preferredStyle: .alert)
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in})
//            alert.addAction(cancelAction)
//            self?.presentedViewController?.present(alert, animated: true) {}
//            } as (() -> Void)
        
        let gallery = CollieGallery(pictures: pictures, options: options)
        gallery.presentInViewController(self, transitionType: CollieGalleryTransitionType.zoom(fromView: view!, zoomTransitionDelegate: self))
    }
}

extension BankDetailViewController:CollieGalleryZoomTransitionDelegate, CollieGalleryDelegate
{
    func zoomTransitionContainerBounds() -> CGRect {
        return self.view.frame
    }
    
    func zoomTransitionViewToDismissForIndex(_ index: Int) -> UIView?
    {
        return self.view
    }
    
    func gallery(_ gallery: CollieGallery, indexChangedTo index: Int) {
        //print("Index changed to: \(index)")
    }
}

extension BankDetailViewController//: ParserDelegate
{
    func didRecivedRespoance(api: String, parser: Parser, json: Any)
    {
    }
    
    func didRecivedGetBankDetails(responseData:[[String:Any]])
    {
        saveToJsonFile(fileName:"Account.json", jsonArray: responseData)
        
        let result = BankDetailsParser.parseBankDetails(json: responseData)
        //let approveAcounts = getAproveBanckDetails(statusArray: result.1, status: AccountStatus.Approved)
        
        self.arr_bankDetails.removeAll()
        for item in result.1
        {
            if ((item.s_AccountStatus == AccountStatus.Approved) || (item.s_AccountStatus == AccountStatus.Pending))
            {
                self.arr_bankDetails.append(item)
            }
        }
        
        //self.arr_bankDetails = result.1
        if self.arr_bankDetails.count == 0
        {
            showAlert(msg: MessageAndError.noBankAccount)
        }
        else
        {
            tableView_BankDetail.isHidden = false
            self.tableView_BankDetail.reloadData()
        }
    }
    
    func getAproveBanckDetails(statusArray : [BankDetails] , status : String) -> ([BankDetails], [String])
    {
        var filterAccountNo = [String]()
        let filtredArray = statusArray.filter { (obj) -> Bool in
            if obj.s_AccountStatus == status
            {
                filterAccountNo.append(obj.s_BankAccountNo!)
                return true
            }
            return false
        }
        return (filtredArray, filterAccountNo)
    }
    
    func didRecivedAppCredentailFali(msg: String)
    {
        alertTag = -1
        showAlert(msg: msg)
    }
    
    override func didRecivedAppCredentail(parser:Parser, appVersion: String, mobileNumber: String, isIMEIExit: Bool, status: String, userCode: String, userStatus: String, usertype: String, actionType: String, isForceUpdate:String,isVerify : String)
    {
        if actionType == ActionType.CheckIMEI
        {
            if (isIMEIExit)
            {
                let userStatus = Parser.checkUsertType(usertype: usertype, userStatus: userStatus, viewController: self)
                if (userStatus.0)
                {
                    if let a = action
                    {
                        switch a
                        {
                        case .GetBankDetails:
                            getGetBankDetails(userCode:DataProvider.sharedInstance.userDetails.s_UserCode!)
                            break
                        }
                    }
                }
                else
                {
                    if(userStatus.1 != 1)
                    {
                        alertTag = userStatus.1
                    }
                }
            }
            else
            {
                showWrongUDIDAlert()
            }
        }
    }
    
    override func onOkPressed(alert: UIAlertAction!) {
        if alertTag == -1
        {
            removeAppSession()
            _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PasswordViewController)
        }
        else if alertTag == 2
        {
            //exit(0)
            removeAppSession()
            _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PasswordViewController)
        }
    }
}


class BankDetailListTableViewCell : UITableViewCell
{
    @IBOutlet weak var lbl_bankName: UILabel!
    @IBOutlet weak var lbl_IFSCCode: UILabel!
    @IBOutlet weak var lbl_accountNo: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var img_cheque: UIImageView!
    
//    override func prepareForReuse() {
//        img_cheque.image = UIImage.init(named: "slide01.png")
//    }
}

