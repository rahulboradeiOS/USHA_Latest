//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit
import SQLite

extension UIViewController : ParserDelegate, OtpPopupViewDelegate
{
    
    
    
    func setNavigationBarTheam()
    {
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "logo-with-bg.png")!, for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage(color: #colorLiteral(red: 0.3927825093, green: 0.2011265457, blue: 0.4004649222, alpha: 1))
        self.navigationController?.navigationBar.isTranslucent = false;
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
    }
    
    func setLogo()
    {
        let logo = UIImage(named: "logo_nav.png")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
    
//    func setNavigationBarItem() {
//        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp.png")!)
//        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
//        self.slideMenuController()?.removeLeftGestures()
//        self.slideMenuController()?.removeRightGestures()
//        self.slideMenuController()?.addLeftGestures()
//        self.slideMenuController()?.addRightGestures()
//    }
//    
//    func removeNavigationBarItem() {
//        self.navigationItem.leftBarButtonItem = nil
//        self.navigationItem.rightBarButtonItem = nil
//        self.slideMenuController()?.removeLeftGestures()
//        self.slideMenuController()?.removeRightGestures()
//    }
    
    func addReginTapGesture()
    {
        //add tapgesture
        let reginTapGesture = UITapGestureRecognizer(target: self, action: #selector(reginTapView(_:)))
        reginTapGesture.numberOfTapsRequired = 1
        //reginTapGesture.delegate = self
        view.addGestureRecognizer(reginTapGesture)
        reginTapGesture.cancelsTouchesInView = false
    }
    
    @objc func reginTapView(_ sender: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }
    
    func showAlert(msg:String)
    {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        //We add buttons to the alert controller by creating UIAlertActions:
        let actionOk = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: self.onOkPressed)
        //You can use a block here to handle a press on this button
        
        alertController.addAction(actionOk)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func onOkPressed(alert: UIAlertAction!)
    {
         
    }
    
    func showWrongUDIDPaaswordAlert()
    {
        let alert = UIAlertController(title: appName, message: "uididNotMatchPassword".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
        //        let actionYes = UIAlertAction(title: "YES",
        //                                     style: .default,
        //                                     handler: self.onYesPressed)
        //        alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "OK".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                     style: .default,
                                     handler: self.onNoPressed)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showWrongUDIDAlert()
    {
        let alert = UIAlertController(title: appName, message: "uididNotMatch".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
//        let actionYes = UIAlertAction(title: "YES",
//                                     style: .default,
//                                     handler: self.onYesPressed)
//        alert.addAction(actionYes)

        let actionNo = UIAlertAction(title: "OK".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                     style: .default,
                                     handler: self.onNoPressed)
        alert.addAction(actionNo)

        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onYesPressed(alert: UIAlertAction!)
    {
        sendOTP(action: ActionType.CheckLogin, message: messageOTP)
    }
    
    @objc func onNoPressed(alert: UIAlertAction!)
    {
        removeAppSession()
        exit(0)

        //UIControl().sendAction(#selector(NSXPCConnection.suspend),
             //                  to: UIApplication.shared, for: nil)
    }
    
    func checkIMEI()
    {
        if let mobile = getUserDefaults(key: defaultsKeys.mobile) as? String
        {
            let paraser = Parser()
            paraser.delegate = self
            paraser.callAPIAppCredentail(mobileNumber: mobile, password: "", actionType: ActionType.CheckIMEI, viewcontroller: self)
        }
    }
    
    func didRecivedAppCredentail(parser: Parser, appVersion: String, mobileNumber: String, isIMEIExit: Bool, status: String, userCode: String, userStatus: String, usertype: String, actionType: String, isForceUpdate: String,isVerify : String) {
    }
    
    func sendOTP(action:String, message:String)
    {
        if let mobile = getUserDefaults(key: defaultsKeys.mobile) as? String
        {
            let paraser = Parser()
            paraser.delegate = self
            paraser.callAPIGetOTP(mobileNumber: mobile, viewcontroller: self, action:action, message: message)
        }
    }
    
    func didRecivedOTP(otp: String, action:String)
    {
        let otpAlert = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.OtpPopupViewController) as! OtpPopupViewController
        otpAlert.providesPresentationContextTransitionStyle = true
        otpAlert.definesPresentationContext = true
        otpAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        otpAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        otpAlert.delegate = self
        otpAlert.action = action
        self.present(otpAlert, animated: true, completion: nil)
        //otpAlert.otp = otp
        //otpAlert.timer  = Timer.scheduledTimer(timeInterval: 1.0, target: otpAlert, selector: #selector(otpAlert.runScheduledTask), userInfo: nil, repeats: true)
    }
    
    func didVeifyOtp(otp:String, action:String)
    {
        let setpassword = getViewContoller(storyboardName: "Main", identifier: "SetPasswordViewController") as! SetPasswordViewController
        setpassword.isForgotPassword = false
        self.present(setpassword, animated: true, completion: nil)
    }
    
    func sessionExpired() {
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
    
    func saveToJsonFile(fileName:String, jsonArray:[Any])
    {
        // Get the url of Persons.json in document directory
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("documentsDirectoryUrl error")
            return }
        
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName)
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
            try data.write(to: fileUrl, options: [])
        } catch {
            print(error)
        }
    }
    
    func retrieveFromJsonFile(fileName:String) -> [Any]?
    {
        // Get the url of Persons.json in document directory
        if let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        {
            let fileUrl = documentsDirectoryUrl.appendingPathComponent(fileName)//("Account.json")
            
            // Read data from .json file and transform data into an array
            do {
                let data = try Data(contentsOf: fileUrl, options: [])
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
                {
                    print(jsonArray)
                    return jsonArray
                }
                else {
                    print("json not found")
                }
                
            } catch {
                print(error)
            }
        }
        else {
            print("documentsDirectoryUrl error")
        }
        return nil
    }
    
    
    func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *)
                {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(phoneCallURL)
                }
            }
        }
    }
    
    func checkPassword() -> Bool
    {
        if let passwordDate = getUserDefaults(key: defaultsKeys.paswwordDate) as? Date
        {
            let calendar = NSCalendar.current
            
            // Replace the hour (time) of both dates with 00:00
            let date1 = calendar.startOfDay(for: passwordDate)
            let date2 = calendar.startOfDay(for: Date())
            
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            
            let day = components.day
            if day! >= 90
            {
                return true
            }
        }
        return false
    }
    
    func showForceUpdtaeAlert()
    {
        let alert = UIAlertController(title: appName, message: MessageAndError.appUpdate, preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "UPDATE",
                                      style: .default,
                                      handler: self.updatePressed)
        alert.addAction(actionYes)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showUpdtaeAlert()
    {
        let alert = UIAlertController(title: appName, message: MessageAndError.appUpdate, preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "UPDATE",
                                      style: .default,
                                      handler: self.updatePressed)
        alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "CANCEL",
                                     style: .default,
                                     handler: self.cancelPressed)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func updatePressed(alert: UIAlertAction!)
    {
        let urlStr = "https://itunes.apple.com/in/app/sampark/id1257644761?mt=8"
        
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
    
    @objc func cancelPressed(alert: UIAlertAction!)
    {
    }
}
