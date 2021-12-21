//
//  RedeemtionViewController.swift
 
//
//  Created by Apple.Inc on 08/06/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
import SQLite
enum RedeemtionViewControllerAction: Int
{
    case GetBankDetails = 0
    case Rrdeemtion
    case SYNC
    case none
}

struct AccountStatus
{
    static let Approved = "Approved"
    static let Pending = "Pending"
}

class RedeemtionViewController: BaseViewController
{
    @IBOutlet weak var lbl_schemered: UILabel!
    @IBOutlet weak var lbl_totalbalance: UILabel!
    @IBOutlet weak var view_totalBalance: UIView!
    @IBOutlet weak var lbl_totalBalance: UILabel!
    //@IBOutlet weak var btn_totalBalance: UIButton!
    @IBOutlet weak var view_schemeBalance: UIView!
    @IBOutlet weak var lbl_schemeBalance: UILabel!
    @IBOutlet weak var lbl_lastSyncDate: UILabel!
    @IBOutlet weak var balanceView_height: NSLayoutConstraint!
    @IBOutlet weak var btn_totalBalance: UIButton!
    @IBOutlet weak var lbl_schemeName: UILabel!

    @IBOutlet weak var btn_syncBalance: UIButton!

    @IBOutlet weak var view_syncDate: UIView!
    
    @IBOutlet weak var txt_bankAccount: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_select: UIButton!
    @IBOutlet weak var lbl_IFSCCode: UILabel!
    @IBOutlet weak var lbl_bankName: UILabel!
    @IBOutlet weak var txt_point: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_getOTP: UIButton!
    @IBOutlet weak var view_bankDetail: UIView!
    
    let dateFormatter = DateFormatter()
    var lastDashboardSyncDate : String = ""
    let totalBalanceDropDown = DropDown()
    var arrSchemeName = [String]()
    
    var action:RedeemtionViewControllerAction = .none

    let selectAccountDropDown = DropDown()
    
    var selectedBankDetail:BankDetails!
    
    var arrAccountNumber = [String]()
    var arrBankDetails = [BankDetails]()

    var redemMsg = ""
    
    var alertTag = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        menuItem()
        
        addReginTapGesture()
        setupDropDown()
        
        view_bankDetail.isHidden = true
        
        txt_bankAccount.delegate = self
        
        txt_point.updateLengthValidationMsg("pointRedeem".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!))
        
       // btn_syncBalance.isHidden = true
        //lbl_lastSyncDate.isHidden = true
        //view_syncDate.isHidden = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"

        if let d = getUserDefaults(key: defaultsKeys.lastBalnceSyncDate) as? Date
        {
            let dstr = dateFormatter.string(from: d)
            lbl_lastSyncDate.text = "\(dstr)"
        }
        else
        {
            //let dstr = dateFormatter.string(from: Date())
            lbl_lastSyncDate.text = "--" //"\(dstr)"
        }
        
        if DataProvider.sharedInstance.userDetails == nil
        {
            getUserDetail()
            let totalBalance = "\(DataProvider.sharedInstance.userDetails.d_Balance!)"
            lbl_totalBalance.attributedText = NSAttributedString(string: totalBalance, attributes:
                [.underlineStyle: NSUnderlineStyle.styleDouble.rawValue])
        }
        else
        {
            let totalBalance = "\(DataProvider.sharedInstance.userDetails.d_Balance!)"
            lbl_totalBalance.attributedText = NSAttributedString(string: totalBalance, attributes:
                [.underlineStyle: NSUnderlineStyle.styleDouble.rawValue])
        }
        
        if DataProvider.sharedInstance.selectedScehme == nil
        {
            getScheme()
            
            lbl_schemeName.text = "\(staticSchemeName) BALANCE"

            let totalSchemeBalance = "\(DataProvider.sharedInstance.selectedScehme.d_Balance!)"
            lbl_schemeBalance.attributedText = NSAttributedString(string: totalSchemeBalance, attributes:
                [.underlineStyle: NSUnderlineStyle.styleDouble.rawValue])
        }
        else
        {
            lbl_schemeName.text = "\(staticSchemeName) BALANCE"

            let totalSchemeBalance = "\(DataProvider.sharedInstance.selectedScehme.d_Balance!)"
            lbl_schemeBalance.attributedText = NSAttributedString(string: totalSchemeBalance, attributes:
                [.underlineStyle: NSUnderlineStyle.styleDouble.rawValue])
        }
        
        btn_getOTP.layer.cornerRadius = 20
        btn_getOTP.layer.masksToBounds = true
        
        setupDropDownAccountDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)

        if (Connectivity.isConnectedToInternet())
        {
            action = .SYNC
            checkIMEI()
        }
        else
        {
            showAlert(msg: "noInternetConnection_REFRESHBALANCE".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
    }
    @IBAction func onBackBttnPressed(_ sender: UIButton)
    {
        exitAlert()
      
    }
    
    override func onHomeButtonPressed(_ sender: UIButton) {
        exitAlert()
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
  
    func exitNotification()
    {
        let alert = UIAlertController(title: appName, message: "doYouWantExit".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "YES".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                      style: .default,
                                      handler: self.YESPRESSED)
        alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "NO".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                     style: .destructive,
                                     handler: self.noPressed)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
    func exitAlert()
    {
        let alert = UIAlertController(title: appName, message: "doYouWantExit".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "YES".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                      style: .default,
                                      handler: self.yesPressed)
        alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "NO".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                     style: .destructive,
                                     handler: self.noPressed)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func yesPressed(alert: UIAlertAction!)
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func YESPRESSED(alert: UIAlertAction!)
    {
        let notificationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationViewController) as! NotificationViewController
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @objc func noPressed(alert: UIAlertAction!)
    {
        
    }
    @IBAction func btn_btn_syncBalance_pressed(_ sender: UIButton) {
    }
    
    func setupDropDown()
    {
        totalBalanceDropDown.dismissMode = .automatic
        totalBalanceDropDown.tag = 101
        totalBalanceDropDown.width = view_totalBalance.frame.width
        totalBalanceDropDown.bottomOffset = CGPoint(x: 0, y: btn_totalBalance.bounds.height)
        totalBalanceDropDown.anchorView = view_totalBalance
        totalBalanceDropDown.direction = .bottom
        totalBalanceDropDown.cellHeight = 40
        totalBalanceDropDown.backgroundColor = .white
        
        // Action triggered on selection
        totalBalanceDropDown.selectionAction = {(index, item) in
        }
    }
    
    @IBAction func btn_totalBalance_pressed(_ sender: UIButton)
    {
    }

    
    func getGetBankDetails(userCode:String)
    {
        let parameters:Parameters = ["ActionTypes": ActionType.Select,  Key.UserCode : userCode]
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.GetBankDetails, parameters: parameters, viewcontroller: self, actionType: API.GetBankDetails)
    }
    
    func setupDropDownAccountDropDown()
    {
        selectAccountDropDown.dismissMode = .automatic
        selectAccountDropDown.tag = 101
        selectAccountDropDown.width = txt_bankAccount.frame.size.width
        selectAccountDropDown.bottomOffset = CGPoint(x: 0, y: txt_bankAccount.bounds.height)
        selectAccountDropDown.anchorView = txt_bankAccount
        selectAccountDropDown.direction = .bottom
        selectAccountDropDown.cellHeight = 40
        selectAccountDropDown.backgroundColor = .white
        
        //        selectSchemeDropDown.dataSource = arrSchemeName //["Smpark", "EPlus"]
        
        // Action triggered on selection
        selectAccountDropDown.selectionAction = {(index, item) in
            self.txt_bankAccount.text = item
            self.view_bankDetail.isHidden = false
            self.selectedBankDetail = self.arrBankDetails[index]
            self.lbl_IFSCCode.text = self.selectedBankDetail.s_IFSCCode
            self.lbl_bankName.text = self.selectedBankDetail.s_BankName

//            DataProvider.sharedInstance.selectedScehme = self.arrScheme[index]
//            SchemeParser.saveSchemeData(scheme: self.arrScheme[index])
        }
    }
    
    @IBAction func btn_select_pressed(_ sender: UIButton)
    {
        action = .GetBankDetails
        if arrAccountNumber.count == 0
        {
            checkIMEI()
        }
        else
        {
            selectAccountDropDown.dataSource = arrAccountNumber
            selectAccountDropDown.show()
        }
        
//        if let json = retrieveFromJsonFile() as? [[String:Any]]
//        {
//            let result = SchemeParser.parseScheme(json: json)
//            self.arrScheme = result.1
//            self.arrSchemeName = result.0
//            selectAccountDropDown.dataSource = arrSchemeName
//            selectAccountDropDown.show()
//        }
//        else
//        {
//            checkIMEI()
//        }
    }
    
    @IBAction func selectSchemeEditingBegin(_ sender: SkyFloatingLabelTextField)
    {
       
    }
    
    @IBAction func btn_getOTP_pressed(_ sender: UIButton)
    {
        if txt_point.validate()
        {
            if let point = Double(txt_point.text!)
            {
                let balance = DataProvider.sharedInstance.selectedScehme.d_Balance!
//                    DataProvider.sharedInstance.userDetails.d_Balance!
                if point > balance
                {
                    showAlert(msg: "lessbalance".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                }
                else if point < 10.00 || point > 10000.00
                {
                    showAlert(msg: "amountbetween".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                }
                else
                {
                    if Connectivity.isConnectedToInternet()
                    {
                        sendOTP(action: ActionType.Redeemtion, message: messageBankTransfer)
                    }
                    else
                    {
                        showAlert(msg: MessageAndError.noInternetConnection_BANKTRANSFER)
                    }
                }
            }
        }
        else
        {
            showAlert(msg: "pointRedeem".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
    }
    
    func getBalanceByUserCode(userCode:String)
    {
        let parameters:Parameters = [Key.UserCode : userCode]
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.GetBalanceByUserCode, parameters: parameters, viewcontroller: self, actionType: API.GetBalanceByUserCode)
    }
    
//    func getScheme(userCode:String)
//    {
//        let parameters:Parameters = [Key.UserCode : userCode]
//        let parser = Parser()
//        parser.delegate = self
//        parser.callAPI(api: API.GetBalanceByUserCode, parameters: parameters, viewcontroller: self, actionType: API.GetBalanceByUserCode)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RedeemtionViewController:UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == txt_bankAccount
        {
            action = .GetBankDetails
            if arrAccountNumber.count == 0
            {
                checkIMEI()
            }
            else
            {
                selectAccountDropDown.dataSource = arrAccountNumber
                selectAccountDropDown.show()
            }
            
            //        if let json = retrieveFromJsonFile() as? [[String:Any]]
            //        {
            //            let result = SchemeParser.parseScheme(json: json)
            //            self.arrScheme = result.1
            //            self.arrSchemeName = result.0
            //            selectAccountDropDown.dataSource = arrSchemeName
            //            selectAccountDropDown.show()
            //        }
            //        else
            //        {
            //            checkIMEI()
            //        }
            
            return false
        }
        else
        {
            return true
        }
    }
}

extension RedeemtionViewController//: ParserDelegate
{
    func updateBalance(json:[[String:Any]])
    {
        if json.count > 0
        {
            let result_Balance = SchemeParser.parseScheme(json: json)
            
            guard let db = DataProvider.getDBConnection() else {
                print("db connection not found")
                return
            }
            
            do {
                
                let itExists = try db.scalar(tblScheme.exists)
                if itExists
                {
                    for item in result_Balance.1
                    {
                        let alice = tblScheme.filter(c_s_SchemePromName.like(item.s_SchemePromName!))
                        try db.run(alice.update(c_d_Balance <- item.d_Balance!))
                    }
                }
                else
                {
                    DataProvider.dropTable(table: tblScheme)
                    for item in result_Balance.1
                    {
                        SchemeParser.saveSchemeData(scheme: item)
                    }
                }
                
                let sScheme = staticSchemeName
                let alice = tblScheme.filter(c_s_SchemePromName.like(sScheme))
                
                print(alice.count)
                
                for row in try db.prepare(alice)
                {
                    print("row[c_d_Balance] = \(row[c_s_SchemePromName])")
                    DataProvider.sharedInstance.selectedScehme.d_Balance = row[c_d_Balance]
                }
                
                let sum = try db.scalar(tblScheme.select(c_d_Balance.sum))
                if let total = sum  {
                    DataProvider.sharedInstance.userDetails.d_Balance = total
                }
                
                for scheme in try db.prepare(tblScheme.select(c_s_SchemePromName)) {
                    //print("c_s_SchemePromName: \(scheme[c_s_SchemePromName])")
                    self.arrSchemeName.append(scheme[c_s_SchemePromName])
                }
                
            }catch  {
                print("error DB Insert")
                print("Error info: \(error)")
            }
            let total_Balance = "\(DataProvider.sharedInstance.userDetails.d_Balance!)"
            lbl_totalBalance.attributedText = NSAttributedString(string: total_Balance, attributes:
                [.underlineStyle: NSUnderlineStyle.styleDouble.rawValue])
            
            let totalSchemeBalance = "\(DataProvider.sharedInstance.selectedScehme.d_Balance!)"
            lbl_schemeBalance.attributedText = NSAttributedString(string: totalSchemeBalance, attributes:
                [.underlineStyle: NSUnderlineStyle.styleDouble.rawValue])
            
            setUserDefaults(value: Date(), key: defaultsKeys.lastBalnceSyncDate)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
            if let d = getUserDefaults(key: defaultsKeys.lastBalnceSyncDate) as? Date
            {
                let dstr = dateFormatter.string(from: d)
                lbl_lastSyncDate.text = "\(dstr)"
            }
            else
            {
                //let dstr = dateFormatter.string(from: Date())
                lbl_lastSyncDate.text = "--" //  \(dstr)"
            }
        }
        else
        {
            print("no scheme data")
        }
    }
    
    func didRecivedRespoance(api: String, parser: Parser, json: Any)
    {
        if api == API.Redeemption
        {
            redemMsg = parser.responseMessage
            txt_point.text = ""
            self.getBalanceByUserCode(userCode: DataProvider.sharedInstance.userDetails.s_UserCode!)
        }
        else if api == API.GetBalanceByUserCode
        {
            if let json = parser.responseData as? [[String:Any]]
            {
                if action == .SYNC
                {
                    updateBalance(json: json)
                }
                else
                {
                    updateBalance(json: json)
                    alertTag = 1
                    showAlert(msg: redemMsg)
                }
            }
            else
            {
                print("no scheme data")
            }
        }
    }
    
    func didRecivedGetBankDetails(responseData:[[String:Any]])
    {
        if (responseData.count == 0)
        {
            showAlert1(msg: "noBankAccount".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
        else
        {
            saveToJsonFile(fileName:"Account.json", jsonArray: responseData)
            
            let result = BankDetailsParser.parseBankDetails(json: responseData)
            let accounts = getAproveBanckDetails(statusArray: result.1, status: AccountStatus.Approved)
            self.arrBankDetails = accounts.0
            self.arrAccountNumber = accounts.1
            if(self.arrAccountNumber.count != 0)
            {
                selectAccountDropDown.dataSource = arrAccountNumber
                selectAccountDropDown.show()
            }
            else
            {
                showAlert(msg:  "noApprovedBankAccount".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
        }
    }
    
    func showAlert1(msg:String)
    {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        //We add buttons to the alert controller by creating UIAlertActions:
        let actionOk = UIAlertAction(title: "OK".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                     style: .default,
                                     handler: self.onOkPress)
        //You can use a block here to handle a press on this button
        
        alertController.addAction(actionOk)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func onOkPress(alert: UIAlertAction!)
    {
        self.navigationController?.popToRootViewController(animated: true)
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
                let userStatus = Parser.checkUsertType(usertype: usertype, userStatus: userStatus,viewController: self)
                if (userStatus.0)
                {
//                    if let a = action
//                    {
                        switch action
                        {
                        case .GetBankDetails:
                            getGetBankDetails(userCode:DataProvider.sharedInstance.userDetails.s_UserCode!)
                            break
                        case .SYNC:
                            getBalanceByUserCode(userCode:userCode)

                            break
                        case .Rrdeemtion:
                            break
                        case .none:
                            break
                        }
//                    }
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
    
    override func didVeifyOtp(otp:String, action:String)
    {
        //http://10.200.4.201:83/api/Transction/Redeemption
//        {"RedeemType":"YesBankTransfer","MobileNo":"7506940017","AccountNo":"955445441515145","IFSCCode":"SBIN0000433","BankName":"SBI"  ,"SchemeName":"SCPM0021","RedemmValue":50.0,"OTP":"40528","reddet":  [{"ProductCode":"REDP00319","ProductName":"Yes Bank","SchemeCode":null,"ProductQuantity":1,"ProductPrice":50.0}],"CreatedBy":"EMP00060","Source":"MOB"}
        
       // {"reddet":[{"ProductCode":"REDP00319","ProductName":"Yes Bank","ProductQuantity":"1","ProductPrice":"25"}],"RedeemType":"YesBankTransfer","MobileNo":"9867289138","SchemeName":"SCPM0021","OTP":"92038","RedemmValue":"25","AccountNo":"687678678678656","BankName":"SBI","IFSCCode":"SBIN0034435","Source":"MOV","CreatedBy":"EMP00072"}
        
        if (action == ActionType.Redeemtion)
        {
            let reddet:Parameters = [Key.ProductCode: ProductCode,
                                     Key.ProductName : ProductName,
                                     Key.ProductQuantity: ProductQuantity,
                                     Key.ProductPrice: txt_point.text!]
        
            let arr_reddet = [reddet]

            let parameters:Parameters = [Key.reddet:arr_reddet,
                                         Key.RedeemType: RedeemType, Key.MobileNo: DataProvider.sharedInstance.userDetails.s_MobileNo!,
                                         Key.SchemeName: staticSchemeCode,
                                         Key.OTP: otp,
                                         Key.RedemmValue: txt_point.text!,
                                         Key.AccountNo: selectedBankDetail.s_BankAccountNo!,
                                         Key.BankName: selectedBankDetail.s_BankName!,
                                         Key.IFSCCode: selectedBankDetail.s_IFSCCode!,
                                         Key.Source: Source,
                                         //Key.Messege: messageBankTransfer,
                                         Key.CreatedBy: DataProvider.sharedInstance.userDetails.s_MobileNo!]
            
            print(parameters)
            
            let parser = Parser()
            parser.delegate = self
            parser.callAPI(api: API.Redeemption, parameters: parameters, viewcontroller: self, actionType: API.Redeemption)
        }
        else
        {
            //checkIMEI()
            super.didVeifyOtp(otp: otp, action: action)
        }
    }
    
    override func sessionExpired() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func onOkPressed(alert: UIAlertAction!)
    {
        if alertTag == 1
        {
            //createMenuView()
            self.navigationController?.popToRootViewController(animated: true)

        }
        else if alertTag == -1
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
