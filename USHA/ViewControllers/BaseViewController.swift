//
//  BaseViewController.swift
//  AutoTropic
//
//  Created by Apple.Inc on 17/01/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SlideMenuControllerSwift
import MIBadgeButton_Swift
class BaseViewController: UIViewController
{
    var btnBack : UIButton!
    var backButton : UIBarButtonItem!
    
//    var btnBell : UIButton!
//    var bellButton : UIBarButtonItem!

    var btnLogo : UIButton!
    var logoButton : UIBarButtonItem!
    var btnHome : UIButton!
    var homeButton : UIBarButtonItem!
    var menuButton: UIButton!
    
    @IBOutlet weak var navigationView: NavigationUIView!
    @IBOutlet weak var navigation_height: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    //UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    

        setNavigationBarTheam()
        
        //setTransperntNavigationBar()
        
        backItem()
        homeItem()
        logoItem()
        //menuItem()
        setUpStautusBar()
        
        addReginTapGesture()
        
        if (navigationView != nil)
        {
        //    navigationView.btn_menu.addTarget(self, action: #selector(SlideMenuController.toggleRight), for: .touchUpInside)

//            navigationView.btn_back.addTarget(self, action: #selector(self.onBackButtonPressed(_:)), for: .touchUpInside)
//
//            navigationView.btn_dashboard.addTarget(self, action: #selector(self.onHomeButtonPressed(_:)), for: .touchUpInside)
//
//            navigationView.btn_notification.addTarget(self, action: #selector(self.onBellButtonPressed(_:)), for: .touchUpInside)
//            let unc = UserDefaults.standard.string(forKey: "UserCategoryName") ?? ""
//            print(unc)
//            if unc == "Prince"{
//                navigationView.view_bar.backgroundColor = UIColor(red: 182/255, green: 106/255, blue: 65/255, alpha: 1.0)
//
//            }else if unc == "Kings"{
//                navigationView.view_bar.backgroundColor = UIColor(red: 157/255, green: 162/255, blue: 171/255, alpha: 1.0)
//            }else if unc == "Kings Premier"{
//                navigationView.view_bar.backgroundColor = UIColor(red: 183/255, green: 143/255, blue: 51/255, alpha: 1.0)
//            }else{
//
//                 navigationView.img_logo.isHidden = false
//            }

        }
        
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        if (navigationView != nil)
//        {
//            let unc = UserDefaults.standard.string(forKey: "UserCategoryName") ?? ""
//            print(unc)
//            if unc == "Prince"{
//                navigationView.view_bar.backgroundColor = UIColor(patternImage: UIImage(named: "silver")!)
//
//                navigationView.img_logo.isHidden = true
//            }else if unc == "Kings"{
//                navigationView.view_bar.backgroundColor = UIColor(patternImage: UIImage(named: "gold")!)
//
//                navigationView.img_logo.isHidden = true
//            }else if unc == "Kings Premier"{
//                navigationView.view_bar.backgroundColor = UIColor(patternImage: UIImage(named: "Silver-dark")!)
//                navigationView.img_logo.isHidden = true
//            }else{
//                 navigationView.img_logo.isHidden = false
//            }
//
//        }
        //setupDropDown()
//       self.txt_selectmonth.tintColor = .clear
//        self.txt_year.tintColor = .clear
//        self.txt_selectbrand.tintColor = .clear
//        self.txt_selectproperty.tintColor = .clear
        
   //     if (navigationView != nil)
//        {
//            if DataProvider.sharedInstance.userDetails != nil
//            {
//                navigationView.lbl_shopName.text = "Home" //DataProvider.sharedInstance.userDetails.s_ShopName
//            //    navigationView.lbl_mobNo.text = DataProvider.sharedInstance.userDetails.s_MobileNo
//            }
//            else
//            {
//                navigationView.lbl_shopName.text = "Home"
//               // navigationView.lbl_mobNo.text = ""
//            }
//            navigationView.layoutSubviews()
//            navigationView.layoutIfNeeded()
//
//
//            navigationView.getNotificationCountFromDB()
//        }
    }
    
    @objc func btn_menu_pressed(_ sender: UIButton)
    {
        
    }

    func addRightBarButtonItems(items:[UIBarButtonItem])
    {
        self.navigationItem.rightBarButtonItems = items
    }
    
    func addLeftBarButtonItems(items:[UIBarButtonItem])
    {
        self.navigationItem.leftBarButtonItems = items
    }
    
    func backItem()
    {
        btnBack = UIButton(type: .custom)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 30)
        btnBack.setImage(UIImage(named: "icon-back"), for: .normal)
        btnBack.imageView?.contentMode = .scaleAspectFit
        btnBack.imageView?.tintColor = .white
        btnBack.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
        btnBack.addTarget(self, action: #selector(self.onBackButtonPressed(_:)), for: UIControlEvents.touchUpInside);
        backButton = UIBarButtonItem(customView: btnBack)
        backButton.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
    }
    
    func menuItem()
    {
        menuButton = UIButton(type: .custom)
        menuButton.frame = CGRect(x: 8, y: self.view.frame.size.height-48, width: 40, height: 40)
        menuButton.setImage(UIImage(named: "menu"), for: .normal)
        menuButton.imageView?.contentMode = .scaleAspectFit
        menuButton.addTarget(self, action: #selector(SlideMenuController.toggleLeft), for: UIControlEvents.touchUpInside);
        self.view.addSubview(menuButton)
        self.view.bringSubview(toFront: menuButton)
    }
    func NavigationBarTheam() {
       
        
    }
    func homeItem()
    {
        btnHome = UIButton(type: .custom)
        btnHome.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnHome.setImage(UIImage(named: "icon_dash.jpg"), for: .normal)
        btnHome.imageView?.contentMode = .scaleAspectFit
        btnHome.tintColor = UIColor.white
        btnHome.addTarget(self, action: #selector(self.onHomeButtonPressed(_:)), for: UIControlEvents.touchUpInside);
        homeButton = UIBarButtonItem(customView: btnHome)
        homeButton.tintColor = UIColor.white
    }
    
    func logoItem()
    {
        let v = UIView(frame: CGRect(x: -30, y: 0, width: 50, height: 40))
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: v.frame.size.width, height: v.frame.size.height))
        img.image = UIImage.init(named: "logo-1.png")
        v.addSubview(img)
//        btnLogo = UIButton(type: .custom)
//        btnLogo.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
//        btnLogo.setImage(UIImage(named: "logo-1.png"), for: .normal)
//        btnLogo.imageEdgeInsets =  UIEdgeInsetsMake(-80, 0, -80, 0)
//        btnLogo.imageView?.contentMode = .scaleAspectFit
//        btnLogo.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        btnLogo.addTarget(self, action: #selector(BaseViewController.onLogoButtonPressed(_:)), for: UIControlEvents.touchUpInside);
        logoButton = UIBarButtonItem(customView: v)
        
        logoButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

    
    @objc func onBackButtonPressed(_ sender : UIButton)
    {
    }
    
    
    @objc func onHomeButtonPressed(_ sender : UIButton)
    {
        //let dash = getViewContoller(storyboardName: "Main", identifier: "DashboardViewController")
        createMenuView()//viewController: dash)
    }
    
    @objc func onBellButtonPressed(_ sender : UIButton)
    {
        if (!(self.navigationController?.topViewController is NotificationViewController))
        {
            let notificationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationViewController) as! NotificationViewController
            self.navigationController?.pushViewController(notificationVC, animated: true)
        }
    }
    
    @objc func onLogoButtonPressed(_ sender : UIButton)
    {
    }

    func setTransperntNavigationBar()
    {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true;
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
    func getMonthNumber(monthName:String) -> Int
    {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        _ = NSDateComponents()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let aDate = formatter.date(from: monthName)
        let components1 = calendar!.components(.month , from: aDate!)
        let monthInt = components1.month
        return monthInt!
    }
    
    func getWidth(text: String) -> CGFloat
    {
        let txtField = UITextField(frame: .zero)
        txtField.text = text
        txtField.sizeToFit()
        return txtField.frame.size.width
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

}

