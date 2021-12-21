//
//  BalanceView.swift
//  ELECTRICIAN
//
//  Created by Apple.Inc on 04/02/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class BalanceView: UIView
{
    @IBOutlet var custumView: UIView!
    @IBOutlet weak var balanceView: UIView!
    
    @IBOutlet weak var view_totalBalance: UIView!
    @IBOutlet weak var lbl_totalBalance_text: UILabel!
    @IBOutlet weak var lbl_totalBalance: UILabel!
    @IBOutlet weak var view_schemeBalance: UIView!
    @IBOutlet weak var lbl_schemeBalance: UILabel!
    @IBOutlet weak var lbl_lastSyncDate: UILabel!
    @IBOutlet weak var lbl_lastSyncTime: UILabel!
    
    @IBOutlet weak var btn_syncBalance: UIButton!
    
    @IBOutlet weak var lbl_schemeName: UILabel!
    @IBOutlet weak var btn_totalBalance: UIButton!
    @IBOutlet weak var btn_totalBalance_width: NSLayoutConstraint!
    @IBOutlet weak var btn_viewTotalBalanceDetails: UIButton!
    
    var viewController: UIViewController!
    
    //MARK: - UIView Overided methods
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
    func configureXIB()
    {
        custumView = configureNib()
        
        // use bounds not frame or it'll be offset
        custumView.frame = bounds
        
        // Make the flexible view
        custumView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(custumView)
    }
    
    func configureNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "BalanceView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    func configBalance()
    {
        if DataProvider.sharedInstance.userDetails == nil
        {
            viewController!.getUserDetail()
        }
        
        if DataProvider.sharedInstance.selectedScehme == nil
        {
            viewController!.getScheme()
        }

        setBalance()
        configSyncDateTime()
    }
    
    func setBalance()
    {
        //Total Balance
        let att_str_total = NSAttributedString(string: "TOTAL", attributes:
            [.foregroundColor : ColorConstants.appRed])
        
        let att_str_balance = NSAttributedString(string: " BAL", attributes:[.foregroundColor : UIColor.gray])

        let att_str_totalBalance = NSMutableAttributedString()
        att_str_totalBalance.append(att_str_total)
        att_str_totalBalance.append(att_str_balance)
        lbl_totalBalance_text.attributedText = att_str_totalBalance
        
        let totalBalance = "\(DataProvider.sharedInstance.userDetails.d_Balance!)"
        lbl_totalBalance.attributedText = NSAttributedString(string: totalBalance, attributes:
            [.underlineStyle: NSUnderlineStyle.styleDouble.rawValue])
        
        //Scheme Balance
        let att_str_schemeBalance = NSMutableAttributedString()

        let schemeName = staticSchemeName.uppercased()
        let att_str_schemeName = NSAttributedString(string: schemeName, attributes:[.foregroundColor : ColorConstants.appRed])
        
        att_str_schemeBalance.append(att_str_schemeName)
        att_str_schemeBalance.append(att_str_balance)
        lbl_schemeName.attributedText = att_str_schemeBalance
        
        let totalSchemeBalance = "\(DataProvider.sharedInstance.selectedScehme.d_Balance!)"
        lbl_schemeBalance.attributedText = NSAttributedString(string: totalSchemeBalance, attributes:
            [.underlineStyle: NSUnderlineStyle.styleDouble.rawValue])

    }
    
    func configSyncDateTime()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        if  let d = getUserDefaults(key: defaultsKeys.lastBalnceSyncDate) as? Date,
            let t = getUserDefaults(key: defaultsKeys.lastBalnceSyncDate) as? Date
        {
            let dstr = dateFormatter.string(from: d)
            let tstr = timeFormatter.string(from: t)
            
            lbl_lastSyncDate.text = "\(dstr)"
            lbl_lastSyncTime.text = "\(tstr)"
        }
        else
        {
            lbl_lastSyncDate.text = "--"
            lbl_lastSyncTime.text = "--"
        }
    }
    
    @IBAction func btn_btn_syncBalance_pressed(_ sender: UIButton)
    {
        if (Connectivity.isConnectedToInternet())
        {
            if let hVc = viewController as? HomeViewController
            {
                hVc.action = .SYNC
                viewController!.checkIMEI()
            }
        }
        else
        {
            viewController!.showAlert(msg: "noInternetConnection_REFRESHBALANCE".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
    }
    
    @IBAction func btn_totalBalance_pressed(_ sender: UIButton)
    {
        let balanceAlert = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.BalanceDetailPopupViewController) as! BalanceDetailPopupViewController
        balanceAlert.providesPresentationContextTransitionStyle = true
        balanceAlert.definesPresentationContext = true
        balanceAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        balanceAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        guard let db = DataProvider.getDBConnection() else {
            print("db connection not found")
            return
        }
        do {
            let itExists = try db.scalar(tblScheme.exists)
            if itExists
            {
                let sum = try db.scalar(tblScheme.select(c_d_Balance.sum))
                
                if let total = sum  {
                    DataProvider.sharedInstance.userDetails.d_Balance = total
                }
                
                for scheme in try db.prepare(tblScheme.select(c_s_SchemePromName, c_d_Balance)) {
                    let dic = ["key": "\(scheme[c_s_SchemePromName])", "value":"\(scheme[c_d_Balance])"]
                    balanceAlert.arrKeyValue.append(dic)
                    
                }
            }
            else
            {
                print("Scheme Not Found")
                balanceAlert.arrKeyValue = []
            }
        }catch  {
            print("Error info: \(error)")
            print("Scheme Not Found")
            balanceAlert.arrKeyValue = []
        }
        
        viewController!.present(balanceAlert, animated: true, completion: nil)
        balanceAlert.lbl_header.text = "SCHEME WISE DETAILS AVAILABLE FROM 16th AUG 2018 ONWARDS"
    }
    
    func getScheme()
    {
        if let db = DataProvider.getDBConnection()
        {
            db.trace { (error) in
                print("trace error \(error)")
            }
            do {
                for user in try db.prepare(tblScheme)
                {
                    let scheme = Scheme()
                    //scheme.Pk_UserID = user[c_Pk_UserID]
                    scheme.d_Balance = user[c_d_Balance]
                    scheme.s_SchemePromCode = user[c_s_SchemePromCode]
                    scheme.s_SchemePromName = user[c_s_SchemePromName]
                    DataProvider.sharedInstance.selectedScehme = scheme
                }
            } catch  {
                print("error query")
                print("Error info: \(error)")
            }
        }
        else
        {
            print("Error db connection")
        }
    }
    
    func getUserDetail()
    {
        if let db = DataProvider.getDBConnection()
        {
            db.trace { (error) in
                print("trace error \(error)")
            }
            do {
                for user in try db.prepare(tblUser)
                {
                    let userDetail = UserDetails()
                    userDetail.Pk_UserID = user[c_Pk_UserID]
                    userDetail.s_UserTypeCode = user[c_s_UserTypeCode]
                    userDetail.s_UserCode = user[c_s_UserCode]
                    userDetail.s_FirmCode = user[c_s_FirmCode]
                    userDetail.s_MobileNo = user[c_s_MobileNo]
                    userDetail.s_FullName = user[c_s_FullName]
                    userDetail.d_DOB = user[c_d_DOB]
                    userDetail.s_EmailID = user[c_s_EmailID]
                    userDetail.s_Education = user[c_s_Education]
                    userDetail.s_Education = user[c_s_ShopName]
                    userDetail.s_ShopAddress1 = user[c_s_ShopAddress1]
                    userDetail.s_ShopAddress2 = user[c_s_ShopAddress2]
                    userDetail.s_ShopName = user[c_s_ShopName]
                    userDetail.s_ShopGEOID = user[c_s_ShopGEOID]
                    userDetail.b_IsActive = user[c_b_IsActive]
                    userDetail.s_CreatedSource = user[c_s_CreatedSource]
                    userDetail.s_CreatedBy = user[c_s_CreatedBy]
                    userDetail.d_Balance = user[c_d_Balance]
                    userDetail.s_RoleName = user[c_s_RoleName]
                    userDetail.s_UserTypeName = user[c_s_UserTypeName]
                    userDetail.TotalBalance = user[c_TotalBalance]
                    userDetail.SchemeAllow = user[c_SchemeAllow]
                    DataProvider.sharedInstance.userDetails = userDetail
                }
            } catch  {
                print("error query")
                print("Error info: \(error)")
            }
        }
        else
        {
            print("Error db connection")
        }
        
    }
}
