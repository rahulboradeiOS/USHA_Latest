//
//  RechargeViewController.swift
//  ELECTRICIAN
//
//  Created by Apple.Inc on 04/12/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import DropDown
import SQLite
import Alamofire

class RechargeViewController: BaseViewController
{
    @IBOutlet weak var balanceView: BalanceView!
    @IBOutlet weak var balanceView_height: NSLayoutConstraint!
    
//    @IBOutlet weak var view_totalBalance: UIView!
//    @IBOutlet weak var lbl_totalBalance: UILabel!
//    @IBOutlet weak var view_schemeBalance: UIView!
//    @IBOutlet weak var lbl_schemeBalance: UILabel!
//    @IBOutlet weak var lbl_lastSyncDate: UILabel!
//    
//    @IBOutlet weak var balanceView_height: NSLayoutConstraint!
//    @IBOutlet weak var btn_totalBalance: UIButton!
//    @IBOutlet weak var lbl_schemeName: UILabel!
//    @IBOutlet weak var btn_syncBalance: UIButton!
//    @IBOutlet weak var view_syncDate: UIView!
    
    @IBOutlet weak var txt_mobileNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_selectOpretor: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_select: UIButton!
    @IBOutlet weak var txt_point: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btn_submit: UIButton!
    
    let dateFormatter = DateFormatter()
    var lastDashboardSyncDate : String = ""
    
    var action:RedeemtionViewControllerAction = .none
    let selectOpretorDropDown = DropDown()
    var selectedOpretorName = ""
//
//    var arrAccountNumber = [String]()
    

    var arrOpretor = ["BSNL", "AIRTEL", "Vodafone", "Aircel", "Idea", "DOCOMO", "Reliance", "MTS", "Telenor", "MTNL", "TATA WALKY", "Tata Indicom", "T24", ]
    
    var redemMsg = ""
    
    var alertTag = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txt_selectOpretor.delegate = self
        
        btn_submit.layer.cornerRadius = 20
        btn_submit.layer.masksToBounds = true
        commoninit()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.configBalanceView()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupDropDown()
    }
    
    func configBalanceView()
    {
        balanceView.configBalance()
        balanceView.viewController = self
        layoutBalanceView()
        balanceView.btn_syncBalance.isHidden = true
        balanceView.btn_totalBalance.isHidden = true
        balanceView.btn_viewTotalBalanceDetails.isHidden = true
    }
    
    func layoutBalanceView()
    {
        balanceView.layoutSubviews()
        balanceView.layoutIfNeeded()
        let height = balanceView.balanceView.frame.size.height
        balanceView_height.constant = height
    }
    
    func commoninit()
    {
        txt_mobileNumber.text = DataProvider.sharedInstance.userDetails.s_MobileNo!
        txt_mobileNumber.isEnabled = false
    }
    
    @IBAction func onBackBttnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setupDropDown()
    {
        selectOpretorDropDown.dismissMode = .automatic
        selectOpretorDropDown.tag = 101
        selectOpretorDropDown.width = txt_selectOpretor.frame.size.width
        selectOpretorDropDown.bottomOffset = CGPoint(x: 0, y: txt_selectOpretor.bounds.height)
        selectOpretorDropDown.anchorView = txt_selectOpretor
        selectOpretorDropDown.direction = .bottom
        selectOpretorDropDown.cellHeight = 40
        selectOpretorDropDown.backgroundColor = .white
        // Action triggered on selection
        selectOpretorDropDown.selectionAction = {(index, item) in
            self.txt_selectOpretor.text = item
            self.selectedOpretorName = item
        }
    }
    
    
    @IBAction func btn_totalBalance_pressed(_ sender: UIButton)
    {
    }

    @IBAction func btn_btn_syncBalance_pressed(_ sender: UIButton)
    {
    }
    
    @IBAction func btn_submit_pressed(_ sender: UIButton)
    {
        if(selectedOpretorName == "")
        {
            showAlert(msg: "selectOpretor".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
        else if txt_point.validate()
        {
            if let point = Double(txt_point.text!)
            {
                let balance = DataProvider.sharedInstance.selectedScehme.d_Balance!
                if point > balance
                {
                    showAlert(msg: "lessbalance".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                }
                else if point < 1.00 || point > 1000.00
                {
                    showAlert(msg: "rechargeAmountBetween".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                }
                else
                {
                    if Connectivity.isConnectedToInternet()
                    {
                        checkIMEI()
                        redeemRecharge()
                    }
                    else
                    {
                        showAlert(msg: "noInternetConnection_MOBILETOPUP".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
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
    
    @IBAction func btn_select_pressed(_ sender: UIButton)
    {
        _ = txt_selectOpretor.becomeFirstResponder()
    }
}

extension RechargeViewController:UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == txt_selectOpretor
        {
            selectOpretorDropDown.dataSource = arrOpretor
            selectOpretorDropDown.show()
            return false
        }
        else
        {
            return true
        }
    }
}

extension RechargeViewController //: ParserDelegate
{
    func getBalanceByUserCode(userCode:String)
    {
        let parameters:Parameters = [Key.UserCode : userCode]
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.GetBalanceByUserCode, parameters: parameters, viewcontroller: self, actionType: API.GetBalanceByUserCode)
    }
    
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
                for row in try db.prepare(alice)
                {
                    DataProvider.sharedInstance.selectedScehme.d_Balance = row[c_d_Balance]
                }
                
                let sum = try db.scalar(tblScheme.select(c_d_Balance.sum))
                if let total = sum  {
                    DataProvider.sharedInstance.userDetails.d_Balance = total
                }
                
            }catch  {
                print("error DB Insert")
                print("Error info: \(error)")
            }
            
            setUserDefaults(value: Date(), key: defaultsKeys.lastBalnceSyncDate)
            configBalanceView()
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
//            if parser.responseCode == 01
//            {
//                showAlert(msg: "\(redemMsg)!".uppercased())
//            }
//            else
//            {
                txt_point.text = ""
                self.getBalanceByUserCode(userCode: DataProvider.sharedInstance.userDetails.s_UserCode!)
//            }
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
                print("no scheme data!".uppercased())
            }
        }
    }
    
    func didRecivedAppCredentailFali(msg: String)
    {
        alertTag = -1
        showAlert(msg: msg)
    }
    
     func didRecived_AppCredentail(appCredentail: AppCredential)
    {
        if appCredentail.actionType == ActionType.CheckIMEI
        {
            if (appCredentail.isIMEIExit)
            {
                let userStatus = Parser.checkUsertType(usertype: appCredentail.usertype, userStatus: appCredentail.userStatus, viewController: self)
                if (userStatus.0)
                {
                    if(action == .SYNC)
                    {
                        getBalanceByUserCode(userCode:appCredentail.userCode)
                    }
                    else
                    {
                        redeemRecharge()
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
    
    func redeemRecharge()
    {
        
        let reddet:Parameters = [Key.ProductCode: "REDP00243",
                                 Key.ProductQuantity: 1,
                                 Key.ProductPrice: txt_point.text!]
        
        let arr_reddet = [reddet]
        print("DataProvider.sharedInstance.userDetails.s_UserCode! = \(DataProvider.sharedInstance.userDetails.s_UserCode!)")
        
        let parameters:Parameters = [Key.reddet:arr_reddet,
                                     Key.RedeemType: "Recharge",
//                                     Key.RechargeType: "Mobile Topup",
//                                     Key.OperatorName: selectedOpretorName,
                                     Key.MobileNo: DataProvider.sharedInstance.userDetails.s_MobileNo!,
                                     Key.SchemeName: staticSchemeCode,
                                     Key.RedemmValue: txt_point.text!,
//                                     Key.TotalQuantity: 0.0,
//                                     Key.balance: txt_point.text!,
//                                     Key.ParentCategoryCode: "REDC000004",
                                     Key.UserCode: DataProvider.sharedInstance.userDetails.s_UserCode!,
                                     Key.UserTypeCode: UserType_UTC0003,
                                     Key.Source: Source,
                                     Key.CreatedBy: DataProvider.sharedInstance.userDetails.s_UserCode!,
                                     Key.OTP: ""]
        
        print(parameters)
        
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.Redeemption, parameters: parameters, viewcontroller: self, actionType: API.Redeemption)
        
    }
    
    
    override func onOkPressed(alert: UIAlertAction!)
    {
        if alertTag == 1
        {
            //createMenuView()
            self.navigationController?.popToRootViewController(animated: true)
            //self.navigationController?.popViewController(animated: true)
            
        }
        else if alertTag == -1
        {
//            goToPasswordViewController(isRemoveAppSession: true)
        }
        else if alertTag == 2
        {
            //exit(0)
//            goToPasswordViewController(isRemoveAppSession: true)
        }
    }
}
