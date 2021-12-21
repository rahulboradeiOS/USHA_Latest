//
//  LeftMenuViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

var keyLang:String = ""
var lantag:String = ""
enum LeftMenu: Int
{
    case Dashboard = 0
    case UserProfile
    case Accumulate
    case Redeem
    case BanckDetails
    case TransactionHistory
    case PriceList
    case Notification
    case SwitchScheme
    case SchemeResult
    case ChangeLanguage
    case Logout
}
struct Menu
{
    static let DASHBOARD = "dashboard_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
    static let PROFILE = "profile_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
    static let ACCUMULATION = "accumulation_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
    static let REDEMPTION = "redemption_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
    static let BANKDETAILS = "bank_details_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
    static let TRANSACTIONHISTORY =  "transaction_history_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
    static let ORDER = "place_order".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)

    static let PRICELIST = "price_list_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
    static let SHAREAPP = "share_app_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)

    static let ABOUTLOYALTY = "aboutLoyalty".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!) 
    static let CONTACT = "contactUs".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
   
//==============
    
//    static let SCHEMERESULT = "sbt_scheme_result_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!) //"SCHEME RESULT"
//    
//     static let GALLERY = "GALLERY".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
//    
//    
//    
    static let NOTIFICATION = "notification_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
//    static let PRODUCTREGISTRATION = "product_reg".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
//    static let SCHEMEINTIMATION = "scheme_intimation".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
//    static let DMSBILLING = "dms_billing".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
//    static let KINGSCLUBSCHEME = "kings_club".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
//    static let SURVEY = "survey_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
    static let CHANGELANGUAGE = "change_language_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
//   
//    static let SERVICEREQUEST = "serviceRequest".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
//    static let POSM = "posm_serviceRequest".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
//    static let LOGOUT = "logout_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!)
}
protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: HomeViewControllerAction)
}

class LeftMenuViewController : UIViewController //, LeftMenuProtocol
{
    
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var btn_close: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view_top: UIView!
    
    var delegate: LeftMenuProtocol?
    
    var menus = [
         ["menu":"change_language_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "icon_price.jpg", "action": HomeViewControllerAction.CHANGELANGUAGE],
//            ["menu": "dashboard_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "icon_dash.jpg", "action":                                       HomeViewControllerAction.DASHBOARD],
                              ["menu":"profile_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "profile_img.png", "action": HomeViewControllerAction.PROFILE],
                              ["menu":"accumulation_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "acc_img.png", "action": HomeViewControllerAction.ACCUMULATION],
                              ["menu":"redemption_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "reed_img.png", "action": HomeViewControllerAction.REDEMPTION],
                           
//                              ["menu":"bank_details_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "icon_bank.jpg", "action": HomeViewControllerAction.BANKDETAILS],
//                              ["menu":"transaction_history_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "icon_transaction.jpg", "action": HomeViewControllerAction.TRANSACTIONHISTORY],
                              ["menu":"place_order".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "order_img.png", "action": HomeViewControllerAction.ORDER],
//                               ["menu":"serviceRequest".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "ic_service_req.png", "action": HomeViewControllerAction.SERVICEREQUEST],
                              ["menu":"price_list_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "product_catalogue_img.png", "action": HomeViewControllerAction.PRICELIST],//CATALOG
//                              ["menu":"aboutLoyalty".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "icon_aboutLoyal.jpg", "action": HomeViewControllerAction.ABOUTLOYALTY],
                         ["menu":"share_app_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "share_img.png", "action": HomeViewControllerAction.SHAREAPP],
        
                        ["menu":"gallery".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "gallery_img.png", "action": HomeViewControllerAction.GALLERY],
        
                        ["menu":"social_networking".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "social_networking_img.png", "action": HomeViewControllerAction.SOCIAL],
                        ["menu":"ANNOUNCEMENT".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "announcement.png", "action": HomeViewControllerAction.ANNOUNCEMENT],
        
                        ["menu":"contactUs".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "contact_img.jpg", "action": HomeViewControllerAction.CONTACTUS],
                            
                               ["menu":"notification_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "notification_img.png", "action": HomeViewControllerAction.NOTIFICATION],
            
                              ["menu":"logout_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "logout_img.png", "action": HomeViewControllerAction.LOGOUT]
        ]


    
    var dashboardViewController: UIViewController!
    var transactionHistoryViewController: UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func viewDidLoad()
    {
        super.viewDidLoad()

         let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))

        let dashboardViewController = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.HomeViewController)
        self.dashboardViewController = UINavigationController(rootViewController: dashboardViewController)
        
        let transactionHistoryViewController = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.TransactionHistoryViewController)
        self.transactionHistoryViewController = UINavigationController(rootViewController: transactionHistoryViewController)
//
//        let topReferringDomainsViewController = storyboard.instantiateViewController(withIdentifier: "TopReferringDomainsViewController") as! TopReferringDomainsViewController
//        self.topReferringDomainsViewController = UINavigationController(rootViewController: topReferringDomainsViewController)
//
//        let channelMixViewController = storyboard.instantiateViewController(withIdentifier: "ChannelMixViewController") as! ChannelMixViewController
//        self.channelMixViewController = UINavigationController(rootViewController: channelMixViewController)
        
        view_top.setShadow()
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        self.tableView.tableFooterView = customView
        //self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)

//        self.imageHeaderView = ImageHeaderView.loadNib()
//        self.view.addSubview(self.imageHeaderView)
        
//        if let name = DataProvider.sharedInstance.userDetails.s_FullName
//        {
//            lbl_name.text = name
//        }
        
       
    }
    
  
  
//    if UserDefaults.standard.string(forKey: "keyLan")! == "hi"{
//
//    struct Menu
//{
//    static let DASHBOARD = "डैशबोर्ड"
//    static let PROFILE = "शख्सियत"
//    static let ACCUMULATION = "संचय"
//    static let REDEMPTION = "मोचन"
//    static let BANKDETAILS = "बैंक_विवरण"
//    static let TRANSACTIONHISTORY = "लेनदेन_का_इतिहास"
//    static let PRICELIST = "मूल्य_सूची"
//    static let SWITCHSCHEME = "चुनें_स्कीम" //"SWITCH SCHEME"
//    static let SAMPARKWEB = "SAMPARK WEB"
//    static let SHAREAPP = "ऐप_शेयर_करें"
//    static let SCHEMERESULT = "एसएसबी_स्कीम_परिणाम" //"SCHEME RESULT"
//    static let NOTIFICATION = "अधिसूचना"
//    static let ORDER = "ORDER"
//    static let SURVEY = "SURVEY"
//    static let CHANGELANGUAGE = "भाषा_बदलो"
//    static let GALLERY = "GALLERY"
//    static let LOGOUT = "लोग_आउट"
//      }
//    }else{
//    struct Menu
//{
//
//    static let DASHBOARD = "DASHBOARD"
//    static let PROFILE = "PROFILE"
//    static let ACCUMULATION = "ACCUMULATION"
//    static let REDEMPTION = "REDEMPTION"
//    static let BANKDETAILS = "BANK DETAILS"
//    static let TRANSACTIONHISTORY = "TRANSACTION HISTORY"
//    static let PRICELIST = "PRICE LIST"
//    static let SWITCHSCHEME = "SELECT SCHEME" //"SWITCH SCHEME"
//    static let SAMPARKWEB = "SAMPARK WEB"
//    static let SHAREAPP = "SHARE APP"
//    static let SCHEMERESULT = "SSB SCHEME RESULT" //"SCHEME RESULT"
//    static let NOTIFICATION = "NOTIFICATION"
//    static let ORDER = "ORDER"
//    static let SURVEY = "SURVEY"
//    static let CHANGELANGUAGE = "CHANGELANGUAGE"
//    static let GALLERY = "GALLERY"
//    static let LOGOUT = "LOGOUT"
//    }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       //UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        setUpStautusBar()
//        if DataProvider.sharedInstance.userDetails != nil
//        {
//            lbl_name.text = DataProvider.sharedInstance.userDetails.s_FullName
//        }
//        else
//        {
//            lbl_name.text = ""
//        }
    }
    
    func setUpStautusBar(){
                  
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
   
    @IBAction func btn_profilePressed(_ sender: UIButton) {
//        self.slideMenuController()?.changeMainViewController(self.profileViewController, close: true)
    }
    
    @IBAction func btn_closePressed(_ sender: UIButton)
    {
        self.slideMenuController()?.closeLeft()
    }
}

extension LeftMenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return  BaseTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let menu = menus[indexPath.row]
        if let menu = menu["action"] as? HomeViewControllerAction
        {
            delegate?.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftMenuViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! BaseTableViewCell
         DispatchQueue.main.async {
            let menu = self.menus[indexPath.row]
            cell.lbl_menu.text = menu["menu"] as? String
            cell.img_icon.image = UIImage.init(named: (menu["img"] as! String))
           
        }
        return cell
    }
}
