//
//  DashboardViewController.swift
 
//
//  Created by Apple.Inc on 21/05/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import SQLite
import Alamofire
import SlideMenuControllerSwift
import DropDown
import MIBadgeButton_Swift


enum HomeViewControllerAction: String
{
    case DASHBOARD
    case PROFILE
    case ACCUMULATION
    case REDEMPTION
    case BANKDETAILS
    case TRANSACTIONHISTORY
    case PRICELIST
    case PROFOLIO
    case SWITCHSCHEME
    case SAMPARKWEB
    case SHAREAPP
    case SCHEMERESULT
    case NOTIFICATION
    case ORDER
    case DMSBILLING
    case SURVEY
    case CONTACTUS
    case SERVICEREQUEST
    case POSM
    case KINGSCLUBSCHEME
    case ABOUTLOYALTY
    case PRODUCTREGISTRATION
    case SCHEMEINTIMATION
    case CHANGELANGUAGE
    case LOGOUT
    case SYNC
    case none
    case GALLERY
    case SOCIAL
     case ANNOUNCEMENT
}

class HomeViewController: BaseViewController
{
  
    @IBOutlet weak var collectionView_dashboard: UICollectionView!
  
    @IBOutlet weak var lbl_totalbalance: UILabel!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var btn_NewNotification: MIBadgeButton!

    
    
    let dateFormatter = DateFormatter()
    var lastDashboardSyncDate : String = ""
    
    var action:HomeViewControllerAction = .none

    let totalBalanceDropDown = DropDown()
    var arrSchemeName = [String]()
   // var arrScheme = [Scheme]()
     var data_array = [[String:Any]]()
    var isEplusLogin : Bool = false
    var strLan:String = ""
    var alertTag = 0
    var keyLang:String = ""
    var accessToken = ""

    var dashboard_menus = [
//        ["menu": "dashboard_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "icon_dash.jpg", "action":HomeViewControllerAction.DASHBOARD],
                          ["menu":"profile_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "profile_img.png", "action": HomeViewControllerAction.PROFILE],
        //MARK: HIDE ACCUMALATION AND REDEMPTION : 09/08/2021 - RAHUL
        //MARK: ENABLED AGAIN 3/12/20 RAHUL
                          ["menu":"accumulation_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "acc_img.png", "action": HomeViewControllerAction.ACCUMULATION],
                          ["menu":"redemption_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "reed_img.png", "action": HomeViewControllerAction.REDEMPTION],
//                      ["menu":"bank_details_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "icon_bank.jpg", "action": HomeViewControllerAction.BANKDETAILS],
        //MARK: ENABLED TRANSACTION HISTORY 4/12/20 RAHUL
                          ["menu":"transaction_history_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "icon_transaction.jpg", "action": HomeViewControllerAction.TRANSACTIONHISTORY],
                          ["menu":"place_order".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "order_img.png", "action": HomeViewControllerAction.ORDER],
//                          ["menu":"serviceRequest".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "ic_service_req.png", "action": HomeViewControllerAction.SERVICEREQUEST],
                          ["menu":"price_list_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "product_catalogue_img.png", "action": HomeViewControllerAction.PRICELIST],
        //MARK: HIDE SHARE APP ON 10 DEC 21 R
                     //["menu":"share_app_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "share_img.png", "action": HomeViewControllerAction.SHAREAPP],
//                      ["menu":"aboutLoyalty".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "icon_aboutLoyal.jpg", "action": HomeViewControllerAction.ABOUTLOYALTY],
                    ["menu":"gallery".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "gallery_img.png", "action": HomeViewControllerAction.GALLERY],
        
                    ["menu":"social_networking".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "social_networking_img.png", "action": HomeViewControllerAction.SOCIAL],
                    ["menu":"ANNOUNCEMENT".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "announcement.png", "action": HomeViewControllerAction.ANNOUNCEMENT],
        
                          ["menu":"contactUs".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "contact_img.jpg", "action": HomeViewControllerAction.CONTACTUS],
                    
        
                         
    ]
    
    //["menu": Menu.SyncAll, "img": "m_sync_all.png"]]

    let schemeResultCity = ["Ahmedabad", "Surat", "Rajkot", "Vadodra"]
 
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

      
        setUpStautusBar()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        menuItem()
        
        collectionView_dashboard.delegate = self
        collectionView_dashboard.dataSource = self
        

        
     //   setupDropDown()
//        let application = UIApplication.shared
//        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil))
//        application.registerForRemoteNotifications()
        
    }
    
     func getNotificationCountFromDB()
        {
            guard let db = DataProvider.getDBConnection() else { print("DB Error in notification get from db"); return}
            let status = Expression<String>("ReadStatus")
            let readStatus = "unread"
            do{
                let all = Array(try db.prepare(NotificationTable.filter(status == readStatus)))
                //commented for getting error
//                btn_NewNotification.badgeFont = UIFont.boldSystemFont(ofSize: 12)
//                btn_NewNotification.badgeString = "\(all.count)"
//                btn_NewNotification.badgeEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 5)//(20, 15, 0, 25)
//                btn_NewNotification.badgeBackgroundColor = #colorLiteral(red: 0.737254902, green: 0.07450980392, blue: 0.1607843137, alpha: 1)
              
                let application = UIApplication.shared
                application.applicationIconBadgeNumber = all.count
            }catch
            {
                print("Error : \(error.localizedDescription)")
            }
        }
    
    @IBAction func NotificationBtnTap(_ sender : UIButton){
        
        action = .NOTIFICATION
        goToNOTIFICATION()
    }
    
    @IBAction func UserProfileBtnTap(_ sender : UIButton){
        
      if Connectivity.isConnectedToInternet()
                    {
    
                        action = .PROFILE
                        checkIMEI()
                    }
                    else
                    {
                        showAlert(msg: "noInternetConnection_PROFILE".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
        
    }
    
    @IBAction func LogoutBtnTap(_ sender : UIButton){
        action = .LOGOUT
         logoutAlert()
    }
    
    override func setUpStautusBar(){
                     
                          if #available(iOS 13.0, *) {
                              let app = UIApplication.shared
                              let statusBarHeight: CGFloat = app.statusBarFrame.size.height
                              
                              let statusbarView = UIView()
                              statusbarView.backgroundColor = UIColor.black
                              view.addSubview(statusbarView)
                            
                              statusbarView.translatesAutoresizingMaskIntoConstraints = false
                              statusbarView.heightAnchor
                                  .constraint(equalToConstant: statusBarHeight).isActive = true
                              statusbarView.widthAnchor
                                  .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
                              statusbarView.topAnchor
                                  .constraint(equalTo: view.topAnchor).isActive = true
                              statusbarView.centerXAnchor
                                  .constraint(equalTo: view.centerXAnchor).isActive = true
                            
                          } else {
                              let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
                              statusBar?.backgroundColor = UIColor.black
                          }
                     
                 }
    
    
    func LanguageChanged(strLan:String){
      collectionView_dashboard.reloadData()
//        lbl_schemeName.text = "schemebalance".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
//       lbl_totalbalance.text = "TotalBalance".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
//        print(strLan)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView_dashboard.reloadData()
        
        //getNotificationCountFromDB()
       
    }
    
    override open func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
      
        self.lbl_UserName.text = "Welcome - \(DataProvider.sharedInstance.userDetails.s_ShopName ?? "")"
        self.lbl_totalbalance.text = "\u{20B9} "+"\(String(DataProvider.sharedInstance.userDetails.d_Balance!))"
//        DataProvider.sharedInstance.userDetails.d_Balance
    }
    
    func getScheme(userCode:String)
    {
        let parameters:Parameters = [Key.UserCode : userCode]
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.GetBalanceByUserCode, parameters: parameters, viewcontroller: self, actionType: API.GetBalanceByUserCode)
    }
    
    @IBAction func btn_close(_ sender: Any) {
//        backview.ishidden = true
        
    }
    @IBAction func btn_btn_syncBalance_pressed(_ sender: UIButton)
    {
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
    
    override func onOkPressed(alert: UIAlertAction!)
    {
        if alertTag == 1
        {
            removeAppSession()
            let setpassword = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.SetPasswordViewController) as! SetPasswordViewController
            setpassword.isForgotPassword = true
            self.present(setpassword, animated: true, completion: nil)
        }
        else if alertTag == -1
        {
            removeAppSession()
            _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PasswordViewController)
        }
        else if alertTag == 2
        {
            removeAppSession()
            _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PasswordViewController)
            //exit(0)
        }
    }
    
    func setupDropDown()
    {
        totalBalanceDropDown.dismissMode = .automatic
        totalBalanceDropDown.tag = 101
//        totalBalanceDropDown.width = view_totalBalance.frame.width
//        totalBalanceDropDown.bottomOffset = CGPoint(x: 0, y: btn_totalBalance.bounds.height)
//        totalBalanceDropDown.anchorView = view_totalBalance
        totalBalanceDropDown.direction = .bottom
        totalBalanceDropDown.cellHeight = 40
        totalBalanceDropDown.backgroundColor = .white
        
        // Action triggered on selection
        totalBalanceDropDown.selectionAction = {(index, item) in
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
                    //print("c_s_SchemePromName: \(scheme[c_s_SchemePromName])")
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
        
        self.present(balanceAlert, animated: true, completion: nil)
        balanceAlert.lbl_header.text = "SCHEME WISE DETAILS AVAILABLE FROM 16th AUG 2018 ONWARDS"
    }
    
    func dashboard()
    {
//        checkIMEI()
//        return
        
        let pref =  UserDefaults.standard
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDate = dateFormatter.string(from: Date())
        
        if let date = pref.string(forKey: defaultsKeys.lastDashboardSyncDate) {
            lastDashboardSyncDate = date
        }
        
        //lastDashboardSyncDate = ""
        if lastDashboardSyncDate != ""
        {
            if todayDate == lastDashboardSyncDate
            {
               // DataProvider.dropTable(table: tblDashboard)

                //checkIMEI()

                goToDASHBOARD()
            }
            else
            {
                if Connectivity.isConnectedToInternet()
                {
                    pref.set(todayDate, forKey: defaultsKeys.lastDashboardSyncDate)
                    pref.synchronize()
                    checkIMEI()
                }
                else
                {
                    goToDASHBOARD()
                }
            }
        }
        else
        {
            if Connectivity.isConnectedToInternet()
            {
                pref.set(todayDate, forKey: defaultsKeys.lastDashboardSyncDate)
                pref.synchronize()
                checkIMEI()
            }
            else
            {
                showAlert(msg: "noInternetConnection_DASHBOARD".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
        }
    }
    
    func getAccumulation(lastSyncDate:String)
    {
        guard let mobile = getUserDefaults(key: defaultsKeys.mobile) as? String else {
            print("mobile not found")
            return
        }
        
        let parameters:Parameters = [Key.MobileNo : mobile, Key.FromDate : lastSyncDate]
        
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.GetDashboardDataForApi, parameters: parameters, viewcontroller: self, actionType: API.GetDashboardDataForApi)
    }
    
    func getPendingTransactionFromDB()
    {
        guard let db = DataProvider.getDBConnection() else {return}
        
        db.trace { (error) in
            print(error)
        }
        do {
            let scheme = staticSchemeName
            let alice = PindingTransactionTable.filter(SchemeName == scheme)
            let row = Array(try db.prepare(alice))
            if row.count > 0
            {
                self.displayAlert(msg: "pendingPinToAccumulate".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!), btnArray: ["CANCEL".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!), "OK".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!)])
           //     DataProvider.sharedInstance.isPendinPopupShow = true
            }
        } catch  {
            print("error in DB")
        }
    }
  
    func displayAlert(msg:String, btnArray:[String])
    {
        let window :UIWindow = UIApplication.shared.keyWindow!
        let popup : MTPopUp  = MTPopUp(frame: (window.bounds))
        popup.viewManualHide = true
        popup.show(view: window, animationType: MTAnimation.ZoomIn_ZoomOut, strMessage:msg, btnArray:btnArray as NSArray , strTitle: "", themeColor: ColorConstants.Navigation_Color, buttonTextColor: UIColor.white, titleTextColor: UIColor.white, msgTextColor:UIColor.black, textAlignment: .left,complete: { (index) in
            print("INDEX : \(index)")
            if (index == 1)
            {
            }
            else
            {
                self.goToACCUMULATION()
            }
        })
    }
    
    func switchSchemeAlert()
    {
        let alert = UIAlertController(title: appName, message: "switchScheme".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "YES".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                      style: .default,
                                      handler: self.switchSchmeYesPressed)
        alert.addAction(actionYes)

        let actionNo = UIAlertAction(title: "N0".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                     style: .destructive,
                                     handler: self.switchSchmeNoPressed)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func switchSchmeYesPressed(alert: UIAlertAction!)
    {
        if Connectivity.isConnectedToInternet()
        {
            checkIMEI()
            // goToSWITCHSCHEME()
        }
        else
        {
            goToSWITCHSCHEME()
            //showAlert(msg: MessageAndError.noInternetConnection_POFILE)
        }
    }
    
    @objc func switchSchmeNoPressed(alert: UIAlertAction!)
    {
       
    }
    
    func schemeResultAlert(msg:String)
    {
        let alert = UIAlertController(title: "SCHEMERESULT", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "Download",
                                      style: .default,
                                      handler: self.schmeResultDownloadPressed)
        alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "Cancel",
                                     style: .destructive,
                                     handler: self.schmeResultCancelPressed)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func schmeResultDownloadPressed(alert: UIAlertAction!)
    {
        if (Connectivity.isConnectedToInternet())
        {
            if let url = URL(string: scheme_result_url)
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:])
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(url)
                }
            }
        }
        else
        {
            showAlert(msg: "noInternetConnection_SCEHEMERESULT_DOWNLOAD".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
    }
    
    @objc func schmeResultCancelPressed(alert: UIAlertAction!)
    {
        
    }
    
    func logoutAlert()
    {
        let alert = UIAlertController(title: appName, message: "doYouWantLogout".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "YES".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                      style: .default,
                                      handler: self.logoutYesPressed)
        alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "NO".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                     style: .destructive,
                                     handler: self.logoutNoPressed)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func logoutYesPressed(alert: UIAlertAction!)
    {
        removeAppSession()
        _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PasswordViewController)
    }
    
    @objc func logoutNoPressed(alert: UIAlertAction!)
    {
        
    }
    
    func goToDASHBOARD()
    {
        let perVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PerformanceViewController) as! PerformanceViewController
        self.navigationController?.pushViewController(perVC, animated: true)
    }
    func ServiceRequest(){
        
        let dic = ["UserCode":DataProvider.sharedInstance.userDetails.s_UserCode!]
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        let requestURL: String = "\(baseUrl)/Authorize/GenrateToken"
        manager.request(requestURL, method : .post, parameters : dic, encoding : JSONEncoding.default , headers : ["Content-Type":"application/json","Clientid":" qBd/jix0ctU= ","SecretId":"7Whc1QzyT1Pfrtm88ArNaQ=="]).responseJSON { response in
            DispatchQueue.main.async {
                print("URL : \(requestURL)\nRESPONSE : \(response)")
                let responsString = response.data?.toString()
                print(responsString!)
                let ndata = responsString?.data(using: String.Encoding.utf8)
                if let json = try? JSONSerialization.jsonObject(with: ndata!, options: []) as! [String:Any]
                {
                    print("Complete json = \(json)")
                    let Token = (json["ResponseData"] as? [String:Any])
                    print(Token!)
                    let AccessToken = Token!["AccessToken"] as? String
                    print(AccessToken!)
                    UserDefaults.standard.set(AccessToken!, forKey: "accessToken")
                    if (json["ResponseData"] as? [String:Any]) != nil{
                    }
                }
            }
        }
    }
    
    func goServiceRequest()
    {
        let requestVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.ServiceRequestUshaVC) as! ServiceRequestUshaVC
        self.navigationController?.pushViewController(requestVC, animated: true)
        
    }
    
    func goToPROFILE()
    {
        let registerVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.UserProfileViewController) as! UserProfileViewController
        registerVC.isRgistration = false
        self.navigationController?.pushViewController(registerVC, animated: true)
        
//        let webVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.ProfileViewController) as! ProfileViewController
        

        
//        webVC.loadUrl = profile
//        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    func goToACCUMULATION()
    {
        let accumulationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.AccumulationViewController)
        self.navigationController?.pushViewController(accumulationVC, animated: true)
    }
    
    func goToREDEMPTION()
    {
//        let acc = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.RedemptionTypeViewController)
//        self.navigationController?.pushViewController(acc, animated: true)
        let acc = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.VouchersViewController)
        self.navigationController?.pushViewController(acc, animated: true)
    }
    
    func goToBANKDETAILS()
    {
        let bankDetailVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.BankDetailViewController)
        self.navigationController?.pushViewController(bankDetailVC, animated: true)
    }
    
    func goToTRANSACTIONHISTORY()
    {
        let tVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.TransactionHistoryViewController)
        self.navigationController?.pushViewController(tVC, animated: true)
    }
    
    func goToPRICELIST()
    {
        
//        if let url = URL(string: "https://www.ushafans.com/sites/all/themes/ushafan/images/Ceiling%20Fans_Coloured%20Brochure.pdf")
//               {
//                   if #available(iOS 10.0, *) {
//                       UIApplication.shared.open(url, options: [:])
//                   } else {
//                       // Fallback on earlier versions
//                       UIApplication.shared.openURL(url)
//                   }
//               }
        let priceListVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PriceListViewController)
        self.navigationController?.pushViewController(priceListVC, animated: true)
    }
    
    func goToAboutLoyalty()
       {
            if let url = URL(string: "https://www.usha.com/")
                   {
                       if #available(iOS 10.0, *) {
                           UIApplication.shared.open(url, options: [:])
                       } else {
                           // Fallback on earlier versions
                           UIApplication.shared.openURL(url)
                       }
                   }
    }
    
    func goToSWITCHSCHEME()
    {
        let switchSchemeVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.SelectSchemeViewController) as! SelectSchemeViewController
        switchSchemeVC.isSwitchScheme = true
        self.navigationController?.pushViewController(switchSchemeVC, animated: true)
    }
    
    func goToNOTIFICATION()
    {
        let notificationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationViewController) as! NotificationViewController
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    func goToSURVEY()
    {
        let SurveryVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.SurveyViewController) as! SurveyViewController
        self.navigationController?.pushViewController(SurveryVC, animated: true)

    }
    func goToGALLERY()
    {
        let GalleryVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.GalleryViewController) as! GalleryViewController
        self.navigationController?.pushViewController(GalleryVC, animated: true)
    }
    
    func goToSocial()
    {
        //write socialviewcontroller link here
        
        let socialVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.SocialNetworkingViewController) as! SocialNetworkingViewController
        self.navigationController?.pushViewController(socialVC, animated: true)
    }
    
    func goToContactUs()
    {
        let wkVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.WKWebViewController) as! WKWebViewController
       // wkVC.loadUrl = "https://retailerqa.usha.com:5064/Authorize/Enquiry"
         wkVC.loadUrl = "https://retailer.usha.com/Authorize/Enquiry"
        wkVC.fromVC = "Contactus"

        self.navigationController?.pushViewController(wkVC, animated: true)
    }
    func goChangeLanguage()
    {
        let changeLanguageVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.Language) as! LanguageViewController
        self.navigationController?.pushViewController(changeLanguageVC, animated: true)
    }
    func goPOSM()
    {
        ServiceRequest()
        let registerVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.POSM) as! posmVC
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    func goDMSBILLING()
    {
//        let GalleryVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.DMSBillingViewController) as! DMSBillingViewController
//        self.navigationController?.pushViewController(GalleryVC, animated: true)
    }
    func goServiceRequestWebView()
    {
//        let webVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.ProfileViewController) as! ProfileViewController
//        print(UserDefaults.standard.string(forKey: "accessToken")!)
//        webVC.loadUrl = url
//        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    func goToSamparkWeb()
    {
        if (Connectivity.isConnectedToInternet())
        {
            if let url = URL(string: samparkWeb)
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:])
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(url)
                }
            }
            
           
        }
        else
        {
            showAlert(msg: "noInternetConnection_SAMPARKWEB".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
    }
    
    func goToShareApp()
    {
        let text = "Dear Usha Retailer! click below link to download USHA App.\n\n"
        let urlStrIOS1 = "https://retailer.usha.com/Mobile/ipa/Index.html"
        let urlStrAND2 = "https://retailer.usha.com/Mobile/APK/"

        let myWebsite1 = NSURL(string:urlStrIOS1)
         let myWebsite2 = NSURL(string: urlStrAND2)

        let shareAll = [text,"IOS : \(myWebsite1!)\n\n","ANDROID : \(myWebsite2!)"] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func goToSchemeResult()
    {
//        let parameters:Parameters = [Key.MobileNo: DataProvider.sharedInstance.userDetails.s_MobileNo!,
//                                     Key.ActionType: ActionType.GetSchemeDetails,
//                                     Key.RuleCode:"RUL0062"]
//        let parser = Parser()
//        parser.delegate = self
//        parser.callAPI(api: API.GetschemeDetailsByMobile, parameters: parameters, viewcontroller: self, actionType: API.GetschemeDetailsByMobile)
        
//        let schemeAlert = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.SchemeResultViewController) as! SchemeResultViewController
//        schemeAlert.providesPresentationContextTransitionStyle = true
//        schemeAlert.definesPresentationContext = true
//        schemeAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        schemeAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//        self.present(schemeAlert, animated: true, completion: nil)

                   let schemeResultsVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.SchemeResultsViewController) as! SchemeResultsViewController
                        self.navigationController?.pushViewController(schemeResultsVC, animated: true)
             
    }
    
    func goToORDER()
    {
        let orderVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.OrderViewController) as! OrderViewController
        self.navigationController?.pushViewController(orderVC, animated: true)
        
    }
    

    
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

//}
func showFlashMessage(data:[[String:Any]])
{
    let flashmsgAlert = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.AnnounmentViewController) as! AnnounmentViewController
//    flashmsgAlert.providesPresentationContextTransitionStyle = true
//    flashmsgAlert.definesPresentationContext = true
//    flashmsgAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//    flashmsgAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    flashmsgAlert.data_array = data
    flashmsgAlert.delegate = self
    
////    let perVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PerformanceViewController) as! PerformanceViewController
    self.navigationController?.pushViewController(flashmsgAlert, animated: true)
}
}
extension HomeViewController//:ParserDelegate
{
    func didRecivedGetFlashMessage(responseData: [[String : Any]])
    {
        if responseData.count > 0 {
            showFlashMessage(data: responseData)
        }else{
            showAlert(msg: "No Announcements")
        }
    }
    
    
    func didRecivedGetAllNotifications(responseData: [[String : Any]])
    {
        action = .none
        if responseData.count == 0
        {
            showAlert(msg: "NO SCHEME DETAILS AVAILABLE!")
        }
        else
        {
            if  let file = responseData[0]["FileUpload"] as? String,
                file != ""
            {
                let urlStr = String(format: notificationFile, file)
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
            else
            {
                showAlert(msg: "NO SCHEME DETAILS AVAILABLE!")
            }
        }
    }
    func didRecivedRespoance(api: String, parser: Parser, json: Any)
    {
        if let responseData = parser.responseData as? [String:Any]
        {
            if action == .DASHBOARD
            {
                if let listaccredtempdata = responseData[Key.listaccredtempdata] as? [Any]
                {
                    let dasboardParser = DashboardParser()
                    _ = dasboardParser.parseDashboard(json: listaccredtempdata, isSave: true)
                }
                else
                {
                    let dasboardParser = DashboardParser()
                    _ = dasboardParser.parseDashboard(json: [], isSave: true)
                }
                goToDASHBOARD()
            }
        }
        else if let json = parser.responseData as? [[String:Any]]
        {
            if action == .SYNC
            {
                if(api == API.GetBalanceByUserCode)
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
                        //lbl_totalBalance.attributedText = NSAttributedString(string: total_Balance, attributes:
                           // [.underlineStyle: NSUnderlineStyle.styleDouble.rawValue])
                        
                        let totalSchemeBalance = "\(DataProvider.sharedInstance.selectedScehme.d_Balance!)"
                       // lbl_schemeBalance.attributedText = NSAttributedString(string: totalSchemeBalance, attributes:
                        //    [.underlineStyle: NSUnderlineStyle.styleDouble.rawValue])
                        
                        setUserDefaults(value: Date(), key: defaultsKeys.lastBalnceSyncDate)
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yy hh:mm:ss"
                        if let d = getUserDefaults(key: defaultsKeys.lastBalnceSyncDate) as? Date
                        {
                            let dstr = dateFormatter.string(from: d)
                          //  lbl_lastSyncDate.text = "\(dstr)"
                        }
                        else
                        {
                            //let dstr = dateFormatter.string(from: Date())
                           // lbl_lastSyncDate.text = "--" //  \(dstr)"
                        }
                    }
                    else
                    {
                        print("no scheme data")
                    }
                }
                else
                {
                    print("no scheme data")
                }
            }
        }
    }
    
    func didRecivedGetDashboardDataForApi(){}
    
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
                    switch action
                    {
                    case .DASHBOARD:
                        getAccumulation(lastSyncDate:lastDashboardSyncDate)
                        //getAccumulation(lastSyncDate: "")
                    case .PROFILE:
                        goToPROFILE()
                        break
                    case .ACCUMULATION:
                        goToACCUMULATION()
                    case .REDEMPTION:
                        goToREDEMPTION()
                    case .BANKDETAILS:
                        goToBANKDETAILS()
                    case .TRANSACTIONHISTORY:
                        goToTRANSACTIONHISTORY()
                        break
                    case .SWITCHSCHEME:
                        goToSWITCHSCHEME()
                        break
                    case .PRICELIST:
                        goToPRICELIST()
                        break
                    case .NOTIFICATION:
                        break
                        case .ABOUTLOYALTY:
                            goToAboutLoyalty()
                                               break
                    case .SYNC:
                        getScheme(userCode:userCode)
                    case .LOGOUT:
                        break
                    case .none:
                        break
                    case .CHANGELANGUAGE:
                        break
                    case .SAMPARKWEB:
                        goToSamparkWeb()
                        break
                    case .SHAREAPP:
                        break
                    case .SCHEMERESULT:
                        goToSchemeResult()
                        break
                        
                    case .GALLERY:
                        goToGALLERY()
                        break
                        
                    case .SURVEY:
                        break
                
                    case .SERVICEREQUEST:
                        break
                    case .ORDER:
                        break
                    case .POSM:
                        break
                    case .DMSBILLING:
                        break
                    case .KINGSCLUBSCHEME:
                        break
                    case .PRODUCTREGISTRATION:
                        break
                    case .SCHEMEINTIMATION:
                        break
                    case .PROFOLIO:
                        action = .PROFOLIO
                        break
                        
                    case .CONTACTUS:
                        
                        goToContactUs()
                         break
                    case .SOCIAL:
                        //write gotofunction for social here
                        goToSocial()
                        break
                    case .ANNOUNCEMENT:
                        break
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
    
    
    func didRecivedGetschemeDetailsByMobile(responseData:[[String:Any]])
    {
        if(responseData.count > 0)
        {
            if  let NetPoints = responseData[0]["Net_Sampark_Point_Under_SSB_Scheme"] as? Double,
                let BranchName = responseData[0]["BranchName"] as? String
            {
                var msg = ""
                var noteText = ""
                var eligibility:Double = 0.0
                if(schemeResultCity.contains(BranchName.lowercased()))
                {
                    eligibility = 1000.00
                }
                else
                {
                    eligibility = 1500.00
                }
                
                if(NetPoints > eligibility)
                {
                    msg = "Your Net Points Under SSB Scheme after Redemption is \(NetPoints)\n\nCongratulations!! You are now eligible for Sampark Travel Bonanza Scheme."
                    noteText = "(SCHEME QUALIFICATION IS SUBJECTED TO REDEMPTION UNDER THE SCHEME PERIOD 1st jul'18 to 31st dec'18)".uppercased()
                }
                else
                {
//                    msg = "Your Net Points Under SSB Scheme after Redemption is \(NetPoints)\n\nAccumulate additional \(eligibility-NetPoints) points before 31st Dec'18 to qualify in Sampark Travel Bonanza Scheme."
                    msg = "Your Net Points Under SSB Scheme after Redemption is \(NetPoints)\n\nAccumulate more points before 31st July'19 to qualify in Sampark Summer Bonanza Scheme."
                    noteText = ""
                }
                
                //schemeAlert.lbl_netPoints.text = msg.uppercased()
                
                let schemeAlert = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.SchemeResultViewController) as! SchemeResultViewController
                schemeAlert.netPointMsg = msg
                schemeAlert.noteText = noteText
                schemeAlert.providesPresentationContextTransitionStyle = true
                schemeAlert.definesPresentationContext = true
                schemeAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                schemeAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.present(schemeAlert, animated: true, completion: nil)
            }
        }
        else
        {
            showAlert(msg: "schemeResultDataNotFound".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
    }

}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        if section == 0
//        {
//            return 2
//        }
        return dashboard_menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2",for: indexPath) as! DashboardCollectionViewCell
        let titleDic = dashboard_menus[indexPath.item]
        let img = UIImage.init(named: (titleDic["img"] as! String))
        
        cell.img_icon.image = img //?.withRenderingMode(.alwaysTemplate)
        let menu = titleDic["menu"] as! String
        cell.lbl_title.text = menu
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (collectionView.frame.size.width - 16) / 3
        
        let height = (collectionView.frame.size.height - 50) / 4.5
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
}

extension UILabel {

    func startBlink() {
        UIView.animate(withDuration: 0.4,
              delay:0.0,
              options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
              animations: { self.alpha = 0 },
              completion: nil)
    }

    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}

extension UIFont {
  var bold: UIFont {
    return with(traits: .traitBold)
  } // bold

  var italic: UIFont {
    return with(traits: .traitItalic)
  } // italic

  var boldItalic: UIFont {
    return with(traits: [.traitBold, .traitItalic])
  } // boldItalic


  func with(traits: UIFontDescriptorSymbolicTraits) -> UIFont {
    guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
      return self
    } // guard

    return UIFont(descriptor: descriptor, size: 0)
  } // with(traits:)
} //

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let titleDic = dashboard_menus[indexPath.item]
        if let menu = titleDic["action"] as? HomeViewControllerAction
        {
            didSelect(menu: menu)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableCell") as! HomeTableCell
        DispatchQueue.main.async {
            let item = self.data_array[indexPath.row]
        cell.toptitle.text = item["s_Titile"] as? String
        cell.notificationLabel.text = item["s_TextMessage"] as? String
        }
        return cell
    }
    
    
}


extension HomeViewController: SlideMenuControllerDelegate, LeftMenuProtocol
{
    func changeViewController(_ menu: HomeViewControllerAction)
    {
        closeLeft()
        didSelect(menu: menu)
    }
    
    func leftDidClose()
    {
        
    }
    
    func didSelect(menu:HomeViewControllerAction)
    {
        switch menu
        {
        case .DASHBOARD:
            action = .DASHBOARD
            dashboard()
        case .PROFILE:
            if Connectivity.isConnectedToInternet()
            {
//                if action == .PROFILE
//                {
//                    return
//                }
                action = .PROFILE
                checkIMEI()
            }
            else
            {
                showAlert(msg: "noInternetConnection_PROFILE".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            
            break
        case .ACCUMULATION:
            if Connectivity.isConnectedToInternet()
            {
//                if action == .ACCUMULATION
//                {
//                    return
//                }
                action = .ACCUMULATION
                checkIMEI()
            }
            else
            {
                goToACCUMULATION()
            }
            break
        case .REDEMPTION:
            if Connectivity.isConnectedToInternet()
            {
//                if action == .REDEMPTION
//                {
//                    return
//                }
                action = .REDEMPTION
                checkIMEI()
            }
            else
            {
                showAlert(msg: "noInternetConnection_REDEMPTION".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            break
        case .BANKDETAILS:
            if Connectivity.isConnectedToInternet()
            {
//                if action == .BANKDETAILS
//                {
//                    return
//                }
                action = .BANKDETAILS
                checkIMEI()
            }
            else
            {
                showAlert(msg: "noInternetConnection_BANKDETAILS".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            break
        case .TRANSACTIONHISTORY:
            if Connectivity.isConnectedToInternet()
            {
//                if action == .TRANSACTIONHISTORY
//                {
//                    return
//                }
                action = .TRANSACTIONHISTORY
                checkIMEI()
            }
            else
            {
                showAlert(msg: "noInternetConnection_TRANSACTIONHISTORY".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            break
        case .PRICELIST:
            if Connectivity.isConnectedToInternet()
            {
//                if action == .PRICELIST
//                {
//                    return
//                }
                action = .PRICELIST
                //checkIMEI()
                goToPRICELIST()
            }
            else
            {
                showAlert(msg: "noInternetConnection_PRICELIST".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            break
             case .ABOUTLOYALTY:
                        if Connectivity.isConnectedToInternet()
                        {
           
                            action = .ABOUTLOYALTY
                            //checkIMEI()
                            goToAboutLoyalty()
                        }
                        else
                        {
                            showAlert(msg: "noInternetConnection_ABOUTLOYALTY".localizableString(loc:
                                UserDefaults.standard.string(forKey: "keyLang")!))
                        }
                        break
        case .SWITCHSCHEME:
            action = .SWITCHSCHEME
            switchSchemeAlert()
            break
        case .NOTIFICATION:
//            if action == .NOTIFICATION
//            {
//                return
//            }
            action = .NOTIFICATION
            goToNOTIFICATION()
            break
        case .LOGOUT:
            logoutAlert()
            break
        case .SYNC:
            break
        case .none:
            break
        case .SAMPARKWEB:
            if Connectivity.isConnectedToInternet()
            {
                action = .SAMPARKWEB
                goToSamparkWeb()
            }
            else
            {
                showAlert(msg: "noInternetConnection_SAMPARKWEB".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            break
        case .SHAREAPP:
            
            action = .SHAREAPP
            goToShareApp()
            
            break
        case .SCHEMERESULT:
            if Connectivity.isConnectedToInternet()
            {
                if action == .SCHEMERESULT
                {
                    return
                }
                action = .SCHEMERESULT
                checkIMEI()
            }
            else
            {
                showAlert(msg: "noInternetConnection_SCEHEMERESULT".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            break
        case .ORDER:
            if Connectivity.isConnectedToInternet()
            {
//                if action == .ORDER
//                {
//                    return
//                }
                action = .ORDER
                checkIMEI()
                goToORDER()
            }
            else
            {
                showAlert(msg: "noInternetConnection_ORDER".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            break
        case .SURVEY:
            if Connectivity.isConnectedToInternet()
            {
                if action == .SURVEY
                {
                    return
                }
                action = .SURVEY
                goToSURVEY()
            }
            else
            {
                showAlert(msg: "noInternetConnection_SUAREY".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            break

        case .CHANGELANGUAGE:
//            if Connectivity.isConnectedToInternet()
//            {
                if action == .CHANGELANGUAGE
                {
                    return
                }
                action = .CHANGELANGUAGE
                goChangeLanguage()
//            }
//            else
//            {
//                showAlert(msg: "noInternetConnection_CHANGELANGUAGE".localizableString(loc:
//                    UserDefaults.standard.string(forKey: "keyLang")!))
//            }
            break
        case .SERVICEREQUEST:
            if Connectivity.isConnectedToInternet()
            {
//                if action == .SERVICEREQUEST
//                {
//                    return
//                }
                action = .SERVICEREQUEST
                
                checkIMEI()
                goServiceRequest()
                
            }
            else
            {
                showAlert(msg: "noInternetConnection_SERVICEREQUEST".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            break
        case .CONTACTUS:
            if Connectivity.isConnectedToInternet()
            {
//                if action == .PRICELIST
//                {
//                    return
//                }
                action = .CONTACTUS
                //checkIMEI()
                goToContactUs()
            }
            else
            {
                showAlert(msg: "noInternetConnection_CONTACTUS".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
                
            break
            case .ANNOUNCEMENT:
                        if (Connectivity.isConnectedToInternet())
                        {
//                            if !DataProvider.sharedInstance.isFlashMessagePopupShow
//                            {
//                                DataProvider.sharedInstance.isFlashMessagePopupShow = true

                                let parameters:Parameters = [Key.UserCode : DataProvider.sharedInstance.userDetails.s_UserCode!, Key.SchemeCode: "SCPM0021"]
                                let parser = Parser()
                                parser.delegate = self
                                parser.callAPI(api: API.GetFlashMessage, parameters: parameters, viewcontroller: self, actionType: API.GetFlashMessage)
//                            }
                        }
                        else
                        {
                          //  DataProvider.sharedInstance.isFlashMessagePopupShow = true
                            if !DataProvider.sharedInstance.isPendinPopupShow
                            {
                                getPendingTransactionFromDB()
                            }
                        }
                            
                        break
        case .POSM:
            if Connectivity.isConnectedToInternet()
            {
                if action == .POSM
                {
                    return
                }
                action = .POSM
                goPOSM()
                
            }
            else
            {
                showAlert(msg: "noInternetConnection_CHANGELANGUAGE".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            break
         case .DMSBILLING:
            if Connectivity.isConnectedToInternet()
            {
                if action == .DMSBILLING
                {
                    return
                }
                action = .DMSBILLING
                goDMSBILLING()
                
            }
            else
            {
                showAlert(msg: "noInternetConnection_DMSBILLING".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            break
        case .KINGSCLUBSCHEME:
            if Connectivity.isConnectedToInternet()
            {
                if action == .KINGSCLUBSCHEME
                {
                    return
                }
                action = .KINGSCLUBSCHEME
                //                goPOSM()
                
            }
            else
            {
                showAlert(msg: "noInternetConnection_DMSBILLING".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            break
        case .PRODUCTREGISTRATION:
            if Connectivity.isConnectedToInternet()
            {
                if action == .PRODUCTREGISTRATION
                {
                    return
                }
                action = .PRODUCTREGISTRATION
                //                goPOSM()
                
            }
            else
            {
                showAlert(msg: "noInternetConnection_DMSBILLING".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            break
        case .SCHEMEINTIMATION:
            if Connectivity.isConnectedToInternet()
            {
                if action == .SCHEMEINTIMATION
                {
                    return
                }
                action = .SCHEMEINTIMATION
                //                goPOSM()
                
            }
            else
            {
                showAlert(msg: "noInternetConnection_DMSBILLING".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            break

        case .PROFOLIO:
             break
        case .GALLERY:
            
            if Connectivity.isConnectedToInternet()
            {
//                if action == .TRANSACTIONHISTORY
//                {
//                    return
//                }
                action = .GALLERY
                checkIMEI()
            }
            else
            {
                showAlert(msg: "noInternetConnection_GALLERY".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            break
        case .SOCIAL:
            //write social checkimei here
            if Connectivity.isConnectedToInternet()
            {
//                if action == .TRANSACTIONHISTORY
//                {
//                    return
//                }
                action = .SOCIAL
                checkIMEI()
            }
            else
            {
                showAlert(msg: "noInternetConnection_SOCIAL".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            break
        break
        }
    }
}
extension HomeViewController:AnnouncementDelegate
{
    func didColseFlashMessage()
    {
        //DataProvider.sharedInstance.isFlashMessagePopupShow = true
        if !DataProvider.sharedInstance.isPendinPopupShow
        {
            getPendingTransactionFromDB()
        }
    }
    
    func didPressedViewMore(file:String)
    {
        let urlStr = String(format: notificationFile, file)
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
}
