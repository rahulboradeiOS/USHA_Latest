//
//  SelectSchemeViewController.swift
 
//
//  Created by Apple.Inc on 19/05/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import SQLite
import SwiftyJSON

class SelectSchemeViewController: UIViewController {

    @IBOutlet weak var txt_scheme: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_select: UIButton!
    @IBOutlet weak var lbl_wellcome: UILabel!
    
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var btn_switchSchemeCancel: UIButton!
    @IBOutlet weak var btn_switchSchemeSubmit: UIButton!

    @IBOutlet weak var BTN_SUBMITSELCT: UIButton!
    @IBOutlet weak var LBL_SELECTS: UILabel!
    @IBOutlet weak var LBL_WELCOME: UILabel!
    var isSwitchScheme = false
    let selectSchemeDropDown = DropDown()
    
    //var arrSchemeName = [String]()
    var arr_Scheme = [Scheme]()

    var alertTag = 0
    var strLan:String = ""
    var userCode = ""
    var callAction = ""
    var UserCategoryName = ""
   
    var arrayJson = JSON()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
 //UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        // Do any additional setup after loading the view.
        
        setUpStautusBar()
        addReginTapGesture()
        setupDropDown()
        
        if DataProvider.sharedInstance.userDetails == nil
        {
            getUserDetail()
        }
        
        txt_scheme.delegate = self
        
        if DataProvider.sharedInstance.userDetails == nil
        {
            getUserDetail()
        }
        
        timeZone()
        
        btn_submit.isHidden = false
        btn_switchSchemeSubmit.isHidden = true
        btn_switchSchemeCancel.isHidden = true
        getEditUserRegistration()
        
      setUpDesign()
   }
           
            func setUpDesign(){
              
                btn_submit.layer.cornerRadius = 20
                btn_submit.layer.masksToBounds = true
                btn_switchSchemeSubmit.layer.cornerRadius = 20
                btn_switchSchemeSubmit.layer.masksToBounds = true
                btn_switchSchemeCancel.layer.cornerRadius = 20
                btn_switchSchemeCancel.layer.masksToBounds = true
                
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
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
       // LanguageChanged(strLan:keyLang)
//        retrieveScheme()
//        loginbyOTPScheme()

//        DataProvider.sharedInstance.selectedScehme = arr_Scheme[0]
//        setUserDefaults(value: true, key: defaultsKeys.login)
//        DataProvider.sharedInstance.isPendinPopupShow = false
//        DataProvider.sharedInstance.isFlashMessagePopupShow = false
//        createMenuView()
        
    }
    func LanguageChanged(strLan:String){
        LBL_WELCOME.text = "welcome".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
        //LBL_SELECTS.text = "selectScheme".localizableString(loc:
            //UserDefaults.standard.string(forKey: "keyLang")!)
        LBL_SELECTS.text = "selectSchemes".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
        btn_submit.setTitle("Submit".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
    }
    func timeZone()
    {
        let gregorian = Calendar(identifier: .gregorian)
        let dateComponents = gregorian.dateComponents([.hour], from: Date())
        let hour = dateComponents.hour!
        //let minute = dateComponents.minute!

        if (hour < 12)
        {
            // Morning
            lbl_wellcome.text = "GOOD MORNING ! \n\(DataProvider.sharedInstance.userDetails.s_FullName!.uppercased())"
        }
        else if (hour >= 12 && hour <= 15)
        {
            // Afternoon
            lbl_wellcome.text = "GOOD AFTERNOON ! \n\(DataProvider.sharedInstance.userDetails.s_FullName!.uppercased())"

        }
        else
        {
            // Night
            lbl_wellcome.text = "GOOD EVENING ! \n\(DataProvider.sharedInstance.userDetails.s_FullName!.uppercased())"
        }

    }
   
    
    func loginbyOTPScheme()
    {
        if let mobile = getUserDefaults(key: defaultsKeys.mobile) as? String
        {
            let parameters:Parameters = [Key.MobileNo : mobile, Key.LoginType : "Mobile"]
            let parser = Parser()
            parser.delegate = self
            parser.callAPI(api: API.LoginByOTP, parameters: parameters, viewcontroller: self, actionType: API.LoginByOTP)
        }
    }
    
    func getScheme(userCode:String)
    {
        let parameters:Parameters = [Key.UserCode : userCode]
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.GetBalanceByUserCode, parameters: parameters, viewcontroller: self, actionType: API.GetBalanceByUserCode)
    }
    
    func setupDropDown()
    {
        selectSchemeDropDown.dismissMode = .automatic
        selectSchemeDropDown.tag = 101
        selectSchemeDropDown.width = txt_scheme.frame.size.width
        selectSchemeDropDown.bottomOffset = CGPoint(x: 0, y: txt_scheme.bounds.height)
        selectSchemeDropDown.anchorView = txt_scheme
        selectSchemeDropDown.direction = .bottom
        selectSchemeDropDown.cellHeight = 40
        selectSchemeDropDown.backgroundColor = .white
        
        // Action triggered on selection
        selectSchemeDropDown.selectionAction = {(index, item) in
            self.txt_scheme.text = item
            let scheme = self.arr_Scheme.filter{$0.s_SchemePromName?.lowercased() == item.lowercased()}
            DataProvider.sharedInstance.selectedScehme = scheme[0]
            setUserDefaults(value: Date(), key: defaultsKeys.lastBalnceSyncDate)
        }
    }
    
    @IBAction func btn_contact_pressed(_ sender: UIButton) {
        callNumber(phoneNumber: helpNo)
    }

    @IBAction func btn_introapp_pressed(_ sender: UIButton)
    {
        if(Connectivity.isConnectedToInternet())
        {
            if let url = URL(string: aboutSampark)
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
            showAlert(msg: "noInternetConnection_ABOUT".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
    }
    
    @IBAction func btn_cancel_pressed(_ sender: UIButton)
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btn_select_pressed(_ sender: UIButton)
    {
        if (arr_Scheme.count == 0)
        {
            retrieveScheme()
        }
        else
        {
            let schemeNameArray:[String] = arr_Scheme.map{$0.s_SchemePromName!}
            selectSchemeDropDown.dataSource = schemeNameArray
            selectSchemeDropDown.show()
        }
    }
    
    @IBAction func btn_enter_pressed(_ sender: UIButton)
    {
        if txt_scheme.text == ""
        {
            showAlert(msg: "selectScheme".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
            return
        }
//        SurveyIsManditary()
        setUserDefaults(value: true, key: defaultsKeys.login)
        DataProvider.sharedInstance.isPendinPopupShow = false
        DataProvider.sharedInstance.isFlashMessagePopupShow = false
        createMenuView()//viewController: dash)
        
    }
    func getEditUserRegistration()
    {
        if Connectivity.isConnectedToInternet()
        {
        let dic = ["UserCode":DataProvider.sharedInstance.userDetails.s_UserCode,"ActionTypes":"Edit"]
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        let requestURL: String = "\(mainUrl)api/EmployeeUser/EditUserRegistration"
        manager.request(requestURL, method : .post, parameters : dic as Parameters, encoding : JSONEncoding.default , headers : ["Content-Type":"application/json","Clientid":" qBd/jix0ctU= ","SecretId":"7Whc1QzyT1Pfrtm88ArNaQ=="]).responseJSON { response in
            DispatchQueue.main.async {
                print("URL : \(requestURL)\nRESPONSE : \(response)")
                let myData = JSON(response.result.value!)
                print(myData)
                
                let mydata1 = "\(myData["ResponseData"])"
                print("mydata Info : \(mydata1)")
                
                let data = mydata1.data(using: .utf8)!
                
                do {
                    
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    self.arrayJson = JSON(json!)
                    
                    let userCategoryName = self.arrayJson["UserCategoryName"].stringValue
                    print(userCategoryName)
                    UserDefaults.standard.set(userCategoryName, forKey: "UserCategoryName")
                    let ucn = UserDefaults.standard.string(forKey: "UserCategoryName")
                    print(ucn!)
                }
            }
        }
        }else{
            showAlert(msg: "noInternetConnection".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
}
    func SurveyIsManditary()
    {
        let alert = UIAlertController(title: appName, message: "pendingsurvey".localizableString(loc:
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
    
  
    @objc func YESPRESSED(alert: UIAlertAction!)
    {
        let notificationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.SurveyViewController) as! SurveyViewController
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @objc func noPressed(alert: UIAlertAction!)
    {
        
    }
    @IBAction func selectSchemeEditingBegin(_ sender: SkyFloatingLabelTextField)
    {

    }
    
    func retrieveScheme()
    {
        guard let db = DataProvider.getDBConnection() else {
            print("db connection not found")
            return
        }
        do {
            let itExists = try db.scalar(tblScheme.exists)
            if itExists
            {
                //Do stuff
                if Connectivity.isConnectedToInternet()
                {
                    checkIMEI()
                }
                else
                {
                    parseAndshowSchemeDropDown(json: nil)
                }
            }
            else
            {
                if Connectivity.isConnectedToInternet()
                {
                    checkIMEI()
                }
                else
                {
                    showAlert(msg: "noInternetConnection".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                }
            }
        }catch  {
            print("Error info: \(error)")
            if Connectivity.isConnectedToInternet()
            {
                checkIMEI()
            }
            else
            {
                showAlert(msg: "noInternetConnection".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
        }
        
    }
    
    func parseAndshowSchemeDropDown(json:[[String:Any]]?)
    {
        guard let db = DataProvider.getDBConnection() else {
            print("db connection not found")
            return
        }
        do {
            let sum = try db.scalar(tblScheme.select(c_d_Balance.sum))
            print(sum)
            if let total = sum  {
                print(total)
                DataProvider.sharedInstance.userDetails.d_Balance = total
            }
       
            self.arr_Scheme.removeAll()
            for scheme in try db.prepare(tblScheme)
            {
                let obj_scheme = Scheme()
                obj_scheme.d_Balance = scheme[c_d_Balance]
                obj_scheme.s_SchemePromCode = scheme[c_s_SchemePromCode]
                obj_scheme.s_SchemePromName = scheme[c_s_SchemePromName]
                self.arr_Scheme.append(obj_scheme)
            }
            let schemeNameArray:[String] = arr_Scheme.map{$0.s_SchemePromName!}
            selectSchemeDropDown.dataSource = schemeNameArray
            selectSchemeDropDown.show()
        }catch  {
            print("error DB Insert")
            print("Error info: \(error)")
        }
        
        
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
extension SelectSchemeViewController : UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if (arr_Scheme.count == 0)
        {
            retrieveScheme()
        }
        else
        {
            let schemeNameArray:[String] = arr_Scheme.map{$0.s_SchemePromName!}
            selectSchemeDropDown.dataSource = schemeNameArray
            selectSchemeDropDown.show()
        }
        return false
    }
}
extension SelectSchemeViewController//: ParserDelegate
{
    
    
    func saveSchme(schemes:[Scheme])
    {
        DataProvider.dropTable(table: tblScheme)
        for item in schemes
        {
            SchemeParser.saveSchemeData(scheme: item)
        }
    }
    
    func didRecivedRespoance(api: String, parser: Parser, json: Any)
    {
        if api == API.LoginByOTP
        {
            if let json = parser.responseData as? [[String:Any]]
            {
                if json.count > 0
                {
                    let result = SchemeParser.parseScheme(json: json)
                    saveSchme(schemes: result.1)
                    if userCode != ""
                    {
                        getScheme(userCode: userCode)
                    }
                    else
                    {
                        showAlert(msg: "somethingWentWrong".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                }
                else
                {
                    showAlert(msg: "Scheme not found")
                }
            }
        }
        else if api == API.GetBalanceByUserCode
        {
            if let json = parser.responseData as? [[String:Any]]
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
                            saveSchme(schemes: result_Balance.1)
                        }
       
                        let sum = try db.scalar(tblScheme.select(c_d_Balance.sum))

                        if let total = sum  {
                            DataProvider.sharedInstance.userDetails.d_Balance = total
                        }
                       
                        self.arr_Scheme.removeAll()
                        for scheme in try db.prepare(tblScheme)
                        {
                            let obj_scheme = Scheme()
                            obj_scheme.d_Balance = scheme[c_d_Balance]
                            obj_scheme.s_SchemePromCode = scheme[c_s_SchemePromCode]
                            obj_scheme.s_SchemePromName = scheme[c_s_SchemePromName]
                            
                            self.arr_Scheme.append(obj_scheme)
                            
                            //go to homeviewp
//                            DataProvider.sharedInstance.selectedScehme = arr_Scheme[0]
//                            setUserDefaults(value: true, key: defaultsKeys.login)
//                            DataProvider.sharedInstance.isPendinPopupShow = false
//                            DataProvider.sharedInstance.isFlashMessagePopupShow = false
//                            createMenuView()
                            
                        }
                        
                        let schemeNameArray:[String] = arr_Scheme.map{$0.s_SchemePromName!}
                        selectSchemeDropDown.dataSource = schemeNameArray
                        selectSchemeDropDown.show()
                        
                    }catch  {
                        print("error DB Insert")
                        print("Error info: \(error)")
                    }
                }
                else
                {
                    parseAndshowSchemeDropDown(json: nil)
                }
            }
            else
            {
                showAlert(msg: "Scheme not found")
            }
        }
    }
    
    func didRecivedAppCredentailFali(msg: String)
    {
        alertTag = -1
        self.showAlert(msg: msg)
    }

    
    override func didRecivedAppCredentail(parser:Parser, appVersion: String, mobileNumber: String, isIMEIExit: Bool, status: String, userCode: String, userStatus: String, usertype: String, actionType: String,isForceUpdate:String,isVerify : String)
    {
        if actionType == ActionType.CheckIMEI
        {
            if (isIMEIExit)
            {
                let userStatus = Parser.checkUsertType(usertype: usertype, userStatus: userStatus, viewController: self)
                if (userStatus.0)
                {
                self.userCode = userCode
                //getScheme(userCode:userCode)
                loginbyOTPScheme()
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
    
    override func onOkPressed(alert: UIAlertAction!)
    {
        if alertTag == -1
        {
            removeAppSession()
            _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PasswordViewController)
        }
        else if (alertTag == 2)
        {
            exit(0)
        }
    }
}
