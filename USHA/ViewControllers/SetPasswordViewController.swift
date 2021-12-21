//
//  SetPasswordViewController.swift
 
//
//  Created by Apple.Inc on 19/05/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import SQLite



class SetPasswordViewController: UIViewController {

    @IBOutlet weak var txt_password: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_confirm_password: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btn_savePassword: UIButton!
    @IBOutlet weak var btn_setPasswordCancel: UIButton!
    @IBOutlet weak var btn_setPasswordSavePassword: UIButton!
    @IBOutlet weak var lbl_setPassword: UILabel!
    @IBOutlet weak var lbl_resetPassword: UILabel!
    @IBOutlet weak var lbl_password_policy: UILabel!
    @IBOutlet weak var lbl_shouldBe8To12: UILabel!
    @IBOutlet weak var lbl_oneNumaricSetPassword: UILabel!
    @IBOutlet weak var lbl_oneAlphaLog: UILabel!
    @IBOutlet weak var lbl_passwordExpLog: UILabel!
    var userCode = ""
    var arr_Scheme = [Scheme]()

    var keyLang:String = ""
    var isForgotPassword = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpStautusBar()
        addReginTapGesture()

        txt_password.updateLengthValidationMsg(MessageAndError.enterPassword)
        txt_password.addRegx(passwordRegEx, withMsg: MessageAndError.enterValidPassword)
        
        txt_confirm_password.updateLengthValidationMsg(MessageAndError.confirmPassword)
        txt_confirm_password.addRegx(passwordRegEx, withMsg: MessageAndError.enterValidPassword)
        txt_confirm_password.addConfirmValidationTo(txt_password, withMsg: MessageAndError.confirmPassword)
        
        if DataProvider.sharedInstance.userDetails == nil
        {
            getUserDetail()
        }
        
        if !isForgotPassword
        {
            removeUserDefaults(key: defaultsKeys.login)
            removeUserDefaults(key: defaultsKeys.password)
        }
        
        if isForgotPassword
        {
           // lbl_setPassword.text = "RESET PASSWORD"
//            lbl_resetPassword.isHidden = false
//            lbl_setPassword.isHidden = true
        }
        else
        {
           // lbl_setPassword.text = "SAVE PASSWORD"
//            lbl_resetPassword.isHidden = true
//            lbl_setPassword.isHidden = false
        }
        
//        if isForgotPassword
//        {
//            btn_savePassword.isHidden = true
//            btn_setPasswordCancel.isHidden = false
//            btn_setPasswordSavePassword.isHidden = false
//        }
//        else
//        {
            btn_savePassword.isHidden = false
            btn_setPasswordCancel.isHidden = true
            btn_setPasswordSavePassword.isHidden = true
//        }
        
        txt_password.delegate = self
        txt_confirm_password.delegate = self
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
    
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
         LanguageChanged(strLan:keyLang)
        
                   btn_savePassword.layer.cornerRadius = 21
                   btn_savePassword.layer.masksToBounds = true
                    btn_savePassword.backgroundColor = UIColor(red: 227/255, green: 6/255, blue: 19/255, alpha: 1.0)

    }
    
    
    func LanguageChanged(strLan:String){
        btn_savePassword.setTitle("SET PASSWORD".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
        
        btn_setPasswordCancel.setTitle("CANCEL".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
        btn_setPasswordSavePassword.setTitle("SAVE PASSWORD".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
        
//        lbl_setPassword.text = "SET PASSWORD".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
//        lbl_resetPassword.text = "RESET PASSWORD".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_password_policy.text = "PASSWORD POLICY".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_oneNumaricSetPassword.text = "ONE NUMERICAL CHARACTER COMPULSORY (0-9).".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_oneAlphaLog.text = "ONE ALPHABET CHARACTER COMPULSORY (A-Z, a-z).".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_shouldBe8To12.text = "SHOULD BE 8 - 12 CHARACTERS.".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_passwordExpLog.text = "PASSWORD EXPIRES IN 90 DAYS.".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btn_contact_pressed(_ sender: UIButton) {
        callNumber(phoneNumber: helpNo)
    }
    
    @IBAction func btn_introapp_pressed(_ sender: UIButton)
    {
        if(Connectivity.isConnectedToInternet())
        {
           
            let urlStr = aboutSampark

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
            showAlert(msg: "noInternetConnection_ABOUT".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
//        let aboutVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.AboutViewController)
//        self.present(aboutVC, animated: true, completion: nil)
    }
    
    @IBAction func btn_cancel_pressed(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_savepassword_pressed(_ sender: UIButton)
    {
        if Connectivity.isConnectedToInternet()
        {
            if txt_password.validate()
            {
                if txt_confirm_password.validate()
                {
                    if isForgotPassword
                    {
                        if Connectivity.isConnectedToInternet()
                        {
                            checkIMEI()
                            //sendOTP(action: ActionType.SetPassword, source: SourceResetPassword)
                        }
                        else
                        {
                            showAlert(msg: MessageAndError.noInternetConnection)
                        }
                    }
                    else
                    {
                        setPassword()
                    }
                }
                else
                {
                    showAlert(msg: txt_confirm_password.strMsg)
                }
                
            }
            else
            {
                showAlert(msg: txt_password.strMsg)
            }
        }
        else
        {
            if isForgotPassword
            {
                showAlert(msg: MessageAndError.noInternetConnection_RESETPASSWORD)
            }
            else
            {
                showAlert(msg: MessageAndError.noInternetConnection_SETPASSWORD)
            }
        }
    }
    
    func setPassword()
    {
        if let mobile = getUserDefaults(key: defaultsKeys.mobile) as? String
        {
            let paraser = Parser()
            paraser.delegate = self
            paraser.callAPIAppCredentail(mobileNumber: mobile, password: txt_password.text!, actionType: ActionType.SetPassword, viewcontroller: self)
        }
    }
    
    override func didVeifyOtp(otp: String, action:String)
    {
        if (action == ActionType.SetPassword)
        {
            setPassword()
        }
        else
        {
            super.didVeifyOtp(otp: otp, action: action)
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
//            selectSchemeDropDown.dataSource = schemeNameArray
//            selectSchemeDropDown.show()
        }catch  {
            print("error DB Insert")
            print("Error info: \(error)")
        }
        
        
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

extension SetPasswordViewController:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool
    {
        if textField == txt_password || textField == txt_confirm_password
        {
            let currentCharacterCount = textField.text?.count ?? 0
            let newLength = currentCharacterCount + string.count - range.length
            
            let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
            let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
            return (string == filtered && newLength <= 12)
        }
        else
        {
            return true
        }
    }
    
}

extension SetPasswordViewController
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
                    print(result_Balance)
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
                       // selectSchemeDropDown.dataSource = schemeNameArray
                        //selectSchemeDropDown.show()
                        
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
      //  alertTag = -1
       // self.showAlert(msg: msg)
    }
//    func didRecivedRespoance(api: String, parser: Parser, json: Any)
//    {
//        print("\n\(api)")
//
//        print("\n\(parser)")
//
//    }
    
    override func didRecivedAppCredentail(parser:Parser, appVersion: String, mobileNumber: String, isIMEIExit: Bool, status: String, userCode: String, userStatus: String, usertype: String, actionType: String, isForceUpdate:String,isVerify : String)
    {
        if actionType == ActionType.CheckIMEI
        {
            sendOTP(action: ActionType.SetPassword, message: messageResetPassword)
            
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
                      //  alertTag = userStatus.1
                    }
                }
            }
        }
        else
        {
            if status == Status.PasswordSet || status == Status.PasswordChange
            {
                //et yesterday = Calendar.current.date(byAdding: .day, value: -30, to: Date())
                setUserDefaults(value: Date(), key: defaultsKeys.paswwordDate)
                setUserDefaults(value: txt_password.text!, key: defaultsKeys.password)
                print(DataProvider.sharedInstance.userDetails.d_Balance!)
                
//                let selectSchemeVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.SelectSchemeViewController) as! SelectSchemeViewController
//                selectSchemeVC.isSwitchScheme = false
//                self.present(selectSchemeVC, animated: true, completion: nil)
                
                //MARK:- CHANGED HERE FOR HOME
                //MARK:-
                
                      setUserDefaults(value: true, key: defaultsKeys.login)
                      DataProvider.sharedInstance.isPendinPopupShow = false
                      DataProvider.sharedInstance.isFlashMessagePopupShow = false
                      createMenuView()//viewController: dash)
//
                
                
//                performSegue(withIdentifier: Segue.selectscheme, sender: self)
            }
        }
    }
    
}
