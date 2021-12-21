//
//  Parser.swift
//  Selp
//
//  Created by Apple.Inc on 06/04/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire

@objc protocol ParserDelegate: AnyObject
{
    @objc optional func didRecivedRespoance(api:String, parser:Parser, json:Any)
    @objc optional func didRecivedAppCredentail(parser:Parser, appVersion:String, mobileNumber:String, isIMEIExit:Bool, status:String, userCode:String, userStatus:String, usertype:String, actionType:String, isForceUpdate:String , isVerify:String)
    @objc optional func didRecived_AppCredentail(appCredentail:AppCredential)
    @objc optional func didRecivedGetUserCodeByMobileNo(json:[String:Any], actionType:String)
    @objc optional func didRecivedOTP(otp:String, action:String)
    @objc optional func didRecivedGetDashboardDataForApi()
    @objc optional func didRecivedGetBalanceByUserCode()
    @objc optional func didRecivedGetBankDetails(responseData:[[String:Any]])
    @objc optional func didRecivedVerifiedOTPStatus(status:Bool)
    @objc optional func didRecivedInsertUpdateUserBankDetails()
    @objc optional func didRecivedGetAccRedSaleReport(responseData:[[String:Any]])
    @objc optional func didRecivedAppCredentailFali(msg:String)
    @objc optional func didRecivedGetPinDetailSummeryMob(responseData:[[String:Any]])
    @objc optional func didRecivedGetAllNotifications(responseData:[[String:Any]])
    @objc optional func didRecivedGetFlashMessage(responseData:[[String:Any]])
    @objc optional func didRecivedGetschemeDetailsByMobile(responseData:[[String:Any]])
    @objc optional func didRecivedBannerData(responseData:[[String:Any]])
    @objc optional func didRecivedDMSProducts(responseData:Any)
    @objc optional func didRecivedInsertUpdateDMSGiftUser(responseData:Any)
    @objc optional func didRecivedGetGiftSlabUser(responseData:[[String:Any]])
    @objc optional func didRecivedStatusInsertUpdateGiftSlabUser(responseData:String)
}

class Parser: NSObject
{
    var isSuccess = false
    var responseMessage:String!
    var responseCode:Int!
    var responseData:Any!
    
    var delegate: ParserDelegate?

    func stringByRemovingControlCharacters2(string: String) -> String
    {
        let controlChars = NSCharacterSet.controlCharacters
        var range = string.rangeOfCharacter(from: controlChars)
        var mutable = string
        while let removeRange = range {
            mutable.removeSubrange(removeRange)
            range = mutable.rangeOfCharacter(from: controlChars)
        }
        return mutable
    }
    
    func isSuccess(result:[String:Any]) -> Bool
    {
        if let ResponseCode = result["ResponseCode"] as? String
        {
            responseCode = Int(ResponseCode)
            if responseCode == 00
            {
                isSuccess = true
            }
            else
            {
                isSuccess = false
            }
        }
        
        if let ResponseMessage = result["ResponseMessage"] as? String
        {
            responseMessage = ResponseMessage
        }
        else
        {
            responseMessage = "somethingWentWrong".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!)
        }
        
        if let ResponseData = result["ResponseData"]
        {
            responseData = ResponseData
        }
        else
        {
            responseData = ""
        }
        return isSuccess
    }
    
    func GetUserCodeByMobileNo(mobileNumber:String, schemeCode:String, viewcontroller:UIViewController)
    {
        let parameters:Parameters = [Key.MobileNo: mobileNumber, Key.SchemeCode: schemeCode]
        self.callAPI(api: API.GetUserCodeByMobileNo, parameters: parameters, viewcontroller: viewcontroller, actionType: API.GetUserCodeByMobileNo)
    }
    
    func callAPIGetOTP(mobileNumber:String, viewcontroller:UIViewController, action:String, message:String)
    {
        let parameters:Parameters = [Key.MobileNo : mobileNumber, Key.ISRLM : "Y", Key.Source : Source, Key.Messege:message]
        self.callAPI(api: API.GetOTP, parameters: parameters, viewcontroller: viewcontroller, actionType: action)
    }
    
    func callAPILoginByOTP(mobileNumber:String, otp:String, loginType:String, viewcontroller:UIViewController, action:String)
    {
        let parameters:Parameters = [Key.MobileNo : mobileNumber, Key.LoginType : loginType, Key.OTP : otp, Key.actionType : action]
        self.callAPI(api: API.LoginByOTP, parameters: parameters, viewcontroller: viewcontroller, actionType: action)
    }
    
    func callAPIAppCredentail(mobileNumber:String, password:String, actionType:String, viewcontroller:UIViewController)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let parameters:Parameters = [Key.MobileNumber: mobileNumber, Key.Password: password, Key.IMEI: appDelegate.deviceUDID, Key.OSVersion: systemVersion, Key.AppVersion: short_version, Key.ActionType: actionType,Key.DeviceType:"IOS"]
        self.callAPI(api: API.AppCredentail, parameters: parameters, viewcontroller: viewcontroller, actionType: actionType)
    }
    
    func callAPI(api:String, parameters:Parameters, viewcontroller:UIViewController, actionType:String)
    {
         let url = baseUrl + api
        viewcontroller.view.makeToastActivity(message: "Processing...")
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 10
    
    print("url:\(url)")
    print("headers:\(headers)")
    print("parameters:\(headers)")
        
        manager.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default , headers : headers).responseJSON { response in
            
            DispatchQueue.main.async {
                print("URL : \(url)\nRESPONSE : \(response)")

                switch response.result
                {
                case .success:
                    if let json = response.result.value as? [Any]
                    {
                        //respoance
                        self.delegate?.didRecivedRespoance?(api: api, parser: self, json: json)
                    }
                    else
                    {
                        if let jsonString = response.result.value as? String
                        {
                            if let json = jsonString.parseJSONString
                            {
                                print(actionType)
                                self.parseRespoance(api: api, json: json, viewcontroller: viewcontroller, actionType: actionType)
                            }
                            else
                            {
                                viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                                    UserDefaults.standard.string(forKey: "keyLang")!))
                            }
                        }
                        else if let json = response.result.value as? [String:Any]
                        {
                            print(actionType)
                            self.parseRespoance(api: api, json: json, viewcontroller: viewcontroller, actionType: actionType)
                        }
                        else
                        {
                            viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                                UserDefaults.standard.string(forKey: "keyLang")!))
                        }
                        //respoance delegate
                        print(api)
                        print(response.result.value!)
                        DispatchQueue.main.async {
                        self.delegate?.didRecivedRespoance?(api: api, parser: self, json: response.result.value!)
                        }
                    }
                    break
                case .failure(let error):
                    print(error)
                    switch (response.error!._code)
                    {
                    case NSURLErrorTimedOut:
                        viewcontroller.showAlert(msg: MessageAndError.server_is_Busy)
                        break
                    case NSURLErrorNotConnectedToInternet:
                        viewcontroller.showAlert(msg: MessageAndError.server_is_Busy)
                        break
                    default:
                        viewcontroller.showAlert(msg: "serviceUnavailable".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                }
                viewcontroller.view.hideToastActivity()
            }
        }
    }
    
    func callHTTPDataAPI(api:String, postData:Data?, viewcontroller:UIViewController)
    {
        let url = baseUrl + api
        viewcontroller.view.makeToastActivity(message: "Processing...")
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("qBd/jix0ctU=", forHTTPHeaderField: "Clientid")
        request.setValue("7Whc1QzyT1Pfrtm88ArNaQ==", forHTTPHeaderField: "SecretId")
        request.timeoutInterval = 60
        request.httpBody = postData
        Alamofire.request(request).responseJSON { response in
                DispatchQueue.main.async {
                    print("URL : \(url)\nRESPONSE : \(response)")
                    switch response.result
                    {
                    case .success:
                        //respoance delegate
                        self.delegate?.didRecivedRespoance?(api: api, parser: self, json: response.result.value!)
                    case .failure(let error):
                        print(error)
                        switch (response.error!._code)
                        {
                        case NSURLErrorTimedOut:
                            viewcontroller.showAlert(msg: "server_is_Busy".localizableString(loc:
                                UserDefaults.standard.string(forKey: "keyLang")!))
                            break
                        case NSURLErrorNotConnectedToInternet:
                            viewcontroller.showAlert(msg: error.localizedDescription)
                            break
                        default:
                            viewcontroller.showAlert(msg: "serviceUnavailable".localizableString(loc:
                                UserDefaults.standard.string(forKey: "keyLang")!))
                        }
                    }
                    viewcontroller.view.hideToastActivity()
                }
        }
    }
    
    
    func parseRespoance(api:String, json:Any, viewcontroller:UIViewController, actionType:String)
    {
        
        print("JSON: \(json)") // serialized json response
        
        //let parser = Parser()
        if(self.isSuccess(result: json as! [String : Any]))
        {
            switch api
            {
            case API.AppCredentail:
                if let responseData = self.responseData as? [Any]
                {
                    if let appCredentail = responseData[0] as? [String:Any]
                    {
                        var appVersion = ""
                        var isIMEI = false
                        var mobileNumber = ""
                        var status = ""
                        var userCode = ""
                        var isVerify = ""
                        var userStatus = ""
                        var usertype = ""
                        var devicetype = ""
                        var isForceUpdate = ""
                        var playStoreAppVersion = ""
                        
                        if let AppVersion = appCredentail[Key.AppVersion] as? String
                        {
                            appVersion = AppVersion
                        }
                        if let imei = appCredentail[Key.IMEI] as? String
                        {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate

                            if imei == appDelegate.deviceUDID
                            {
                                isIMEI = true
                            }
                            else
                            {
                                isIMEI = false
                            }
                        }
                        if let MobileNumber = appCredentail[Key.MobileNumber] as? String
                        {
                            mobileNumber = MobileNumber
                        }
                        if let Status = appCredentail[Key.Status] as? String
                        {
                            status = Status
                        }
                        if let UserCode = appCredentail[Key.UserCode] as? String
                        {
                            userCode = UserCode
                        }
                        if let UserStatus = appCredentail[Key.UserStatus] as? String
                        {
                            userStatus = UserStatus
                        
                        }
                        if let Usertype = appCredentail[Key.Usertype] as? String
                        {
                            usertype = Usertype
                        }
                        
                        if let IsForceUpdate = appCredentail[Key.IsForceUpdate] as? String
                        {
                            isForceUpdate = IsForceUpdate
                        }
                        
                        if let PlayStoreAppVersion = appCredentail[Key.PlayStoreAppVersion] as? String
                        {
                            playStoreAppVersion = PlayStoreAppVersion
                        }
                        if let IsVerify = appCredentail[Key.IsVerify] as? String
                        {
                            isVerify = IsVerify
                        }
                        
                        if let DeviceType = appCredentail[Key.DeviceType] as? String
                        {
                            devicetype = DeviceType
                        }
//                        if actionType != ActionType.SetPassword
//                        {
//                            if userStatus == "ACTIVE"
//                            {
//                                if usertype != UserTypeCode
//                                {
//                                    viewcontroller.showAlert(msg: MessageAndError.notRetailer)
//                                    
//                                    //delegate?.didRecivedAppCredentailFali?(msg:MessageAndError.userNotRetailer)
//                                    return
//                                }
//                            }
//                            else
//                            {
//                                //viewcontroller.showAlert(msg: MessageAndError.userNotActive)
//                                delegate?.didRecivedAppCredentailFali?(msg:MessageAndError.userNotActive)
//                                return
//                            }
//                        }
                       
                        let appCredential = AppCredential()
                        appCredential.appVersion = appVersion
                        appCredential.mobileNumber = mobileNumber
                        appCredential.isIMEIExit = isIMEI
                        appCredential.status = status
                        appCredential.userCode = userCode
                        appCredential.userStatus = userStatus
                        appCredential.usertype = usertype
                        appCredential.actionType = actionType
                        appCredential.isForceUpdate = isForceUpdate
                        appCredential.playStoreAppVersion = playStoreAppVersion
                        appCredential.isVerify = isVerify
                        appCredential.deviceType = devicetype
                        
                        delegate?.didRecived_AppCredentail?(appCredentail: appCredential)
                        
                        delegate?.didRecivedAppCredentail?(parser: self, appVersion: appVersion, mobileNumber: mobileNumber, isIMEIExit:isIMEI, status: status, userCode: userCode, userStatus: userStatus, usertype: usertype, actionType: actionType, isForceUpdate: isForceUpdate, isVerify: isVerify)
                    }
                    else
                    {
                        viewcontroller.showAlert(msg: "credentailStatusNotFound".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                }
                else
                {
                    viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                }
                break
            case API.GetUserCodeByMobileNo:
                //self.showAlert(msg: parser.responseMessage)
                if let responseData = self.responseData as? String
                {
                    if let json = responseData.parseJSONString as? [String:Any]
                    {
                        if let s_UserTypeCode = json[Key.s_UserTypeCode] as? String
                        {
                            var userCode = ""
                            if actionType == ActionType.EPLUS
                            {
                                userCode = UserType_UTC0003
                            }
                            else
                            {
                                userCode = UserType_UTC0002
                            }
                            
                            if s_UserTypeCode == userCode
                            {
                                if let b_IsActive = json[Key.b_IsActive] as? Bool
                                {
                                    if b_IsActive
                                    {
//                                        UserDetailParser.parseUserDetail(json: json, actionType:actionType)
                                        delegate?.didRecivedGetUserCodeByMobileNo?(json: json, actionType: actionType)
                                    }
                                    else
                                    {
//                                        if let vc = viewcontroller as? LoginViewController
//                                        {
//                                            vc.alertTag = 2
//                                        }
                                        viewcontroller.showAlert(msg: MessageAndError.notElectrician)
                                    }
                                }
                            }
                            else
                            {
//                                if let vc = viewcontroller as? LoginViewController
//                                {
//                                    vc.alertTag = 2
//                                }
                                
                                if actionType == ActionType.EPLUS
                                {
                                    viewcontroller.showAlert(msg: MessageAndError.notElectrician)
                                }
                                else
                                {
                                   // viewcontroller.showAlert(msg: "notRetailer".localizableString(loc:
                                      //  UserDefaults.standard.string(forKey: "keyLang")!))
                                    viewcontroller.showAlert(msg: MessageAndError.notElectrician)

                                }
                            }
                        }
                    }
                    else
                    {
                        viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                }
                else
                {
                    viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                }
                break
            case API.GetFlashMessage:
                if let responseData = self.responseData as? String
                {
                    if let json = responseData.parseJSONString as? [[String:Any]]
                    {
                        delegate?.didRecivedGetFlashMessage?(responseData: json)
                    }
                    else
                    {
                        viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                }
                break
                
            case API.GetOTP:
                if let otp = self.responseData as? String
                {
                    presentWindow?.makeToast(message: self.responseMessage)
                    delegate?.didRecivedOTP?(otp: otp, action: actionType)
                }
                break
            case API.GetDashboardDataForApi:
                delegate?.didRecivedGetDashboardDataForApi?()
                break
            case API.GetBalanceByUserCode:
                delegate?.didRecivedGetBalanceByUserCode?()
                break
            case API.GetBankDetails:
                if let responseData = self.responseData as? String
                {
                    if let json = responseData.parseJSONString as? [[String:Any]]
                    {
                        delegate?.didRecivedGetBankDetails?(responseData:json)
                    }
                    else
                    {
                        viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                }
                break
            case API.LoginByOTP:
                if let responseData = self.responseData as? [[String:Any]]
                {
                    if responseData.count != 0
                    {
                        delegate?.didRecivedVerifiedOTPStatus?(status: true)
                    }
                    else
                    {
                        delegate?.didRecivedVerifiedOTPStatus?(status: false)
                    }
                }
                break
            case API.InsertUpdateUserBankDetails:
                delegate?.didRecivedInsertUpdateUserBankDetails?()
                break
            case API.GetAccRedSaleReport:
                if let responseData = self.responseData as? String
                {
                    if let json = responseData.parseJSONString as? [[String:Any]]
                    {
                        delegate?.didRecivedGetAccRedSaleReport?(responseData:json)
                    }
                    else
                    {
                        viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                }
                break
            case API.GetPinDetailSummeryMob:
                if let responseData = self.responseData as? String
                {
                    if let json = responseData.parseJSONString as? [[String:Any]]
                    {
                        delegate?.didRecivedGetPinDetailSummeryMob?(responseData:json)
                    }
                    else
                    {
                        viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                }
                break
            case API.GetAllNotifications:
                if let responseData = self.responseData as? String
                {
                    if let json = responseData.parseJSONString as? [[String:Any]]
                    {
                        delegate?.didRecivedGetAllNotifications?(responseData:json)
                    }
                    else
                    {
                        viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                }
                break
            case API.GetschemeDetailsByMobile:
                if let responseData = self.responseData as? String
                {
                    if let json = responseData.parseJSONString as? [[String:Any]]
                    {
                        delegate?.didRecivedGetschemeDetailsByMobile?(responseData: json)
                    }
                    else
                    {
                        viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                }
                break
            case API.GetSchemeGiftSlabUser:
                if let responseData = self.responseData as? String
                {
                    if let json = responseData.parseJSONString as? [[String:Any]]
                    {
                        delegate?.didRecivedGetGiftSlabUser?(responseData: json)
                    }
                    else
                    {
                        viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                }
                break
            case API.InsertUpdateGiftSlabUser:
                if let responseData = self.responseMessage
                {
                  
                        delegate?.didRecivedStatusInsertUpdateGiftSlabUser?(responseData: responseData)
              
                }
                break
                case API.GetBannerList:
                               if let responseData = self.responseData as? String
                               {
                                   if let json = responseData.parseJSONString as? [[String:Any]]
                                   {
                                       delegate?.didRecivedBannerData?(responseData: json)
                                   }
                                   else
                                   {
                                       viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                                           UserDefaults.standard.string(forKey: "keyLang")!))
                                   }
                               }
                               break
                
                case API.GetDMSProducts:
                    
                 let responseData = self.responseData
                 if responseData != nil{
                    delegate?.didRecivedDMSProducts?(responseData: responseData)
                 } else
                    {
                                        viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
            
             //   {
//                    if let json = (responseData as AnyObject).parseJSONString as? [[String:Any]]
//                    {
                  //
                  //  }
                   
      //         }
                break
                case API.InsertUpdateDMSGiftUser:
                    let responseData = self.responseData
                    
                    if responseData != nil{
                     delegate?.didRecivedInsertUpdateDMSGiftUser?(responseData: responseData)
                      } else
                        {
                           viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                          UserDefaults.standard.string(forKey: "keyLang")!))
                        }
                                             
                                             break
            default:
                break
            }
        }
        else
        {
            if let msg = self.responseMessage
            {
                if api == API.GetUserCodeByMobileNo
                {
                    if actionType == ActionType.EPLUS
                    {
                        viewcontroller.showAlert(msg: "notElectrician".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                    else
                    {
                        viewcontroller.showAlert(msg: "notRetailer".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                    // viewcontroller.showAlert(msg: "userNotFound".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!))
                }
                else if (api == API.GetAllNotifications)
                {
                    
                }
                else
                {
                    viewcontroller.showAlert(msg: msg)
                }
            }
            else
            {
                viewcontroller.showAlert(msg: "somethingWentWrong".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
        }
    }
    
    class func checkUsertType(usertype:String, userStatus:String, viewController:UIViewController) -> (Bool, Int)
    {
        if(usertype == UserType_UTC0002) //UserType.equals("UTC0002"))
        {
            if(userStatus == Status.ACTIVE)
            {
                return (true, 0)
            }
            else
            {
                if((viewController is LoginViewController) || viewController is PasswordViewController)
                {
                    viewController.showAlert(msg: "userNotActive".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                    return (false, 4)
                }
                else
                {
                    viewController.showAlert(msg: "userNotActive".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                    return (false, 2)
                }
            }
        }
        else if(usertype == UserType_UTC0001)
        {
            if((viewController is LoginViewController) || viewController is PasswordViewController)
            {
                viewController.showAlert(msg: "alreadyDeler".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
                return (false, 4)
            }
            else
            {
                viewController.showAlert(msg: "alreadyDeler".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            return (false, 2)
            }
        }
            
        else if(usertype == UserType_UTC0003)
        {
            if((viewController is LoginViewController) || viewController is PasswordViewController)
            {
                viewController.showAlert(msg:  "alreadyElectrician".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
                return (false, 4)
            }
            else
            {
                viewController.showAlert(msg:  "alreadyElectrician".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            return (false, 2)
            }
        }else if(usertype == UserType_UTC0070)
        {
            if((viewController is LoginViewController) || viewController is PasswordViewController)
            {
                viewController.showAlert(msg: MessageAndError.alreadyOFFICE)
                return (false, 4)
            }
            else
            {
                viewController.showAlert(msg: MessageAndError.alreadyOFFICE)
                return (false, 2)
            }
        }
        else if(usertype == UserType_UTC0072)
        {
            if((viewController is LoginViewController) || viewController is PasswordViewController)
            {
                viewController.showAlert(msg: MessageAndError.alreadyWAREHOUSE)
                return (false, 4)
            }
            else
            {
                viewController.showAlert(msg: MessageAndError.alreadyWAREHOUSE)
                return (false, 2)
            }
        }
        else if(usertype == UserType_UTC0073)
        {
            if((viewController is LoginViewController) || viewController is PasswordViewController)
            {
                viewController.showAlert(msg: MessageAndError.alreadyHEADOFFICE)
                return (false, 4)
            }
            else
            {
                viewController.showAlert(msg: MessageAndError.alreadyHEADOFFICE)
                return (false, 2)
            }
        }
            
        else if(usertype == UserType_UTC0074)
        {
            if((viewController is LoginViewController) || viewController is PasswordViewController)
            {
                viewController.showAlert(msg: MessageAndError.alreadyRURALDISTRIBUTOR)
                return (false, 4)
            }
            else
            {
                viewController.showAlert(msg: MessageAndError.alreadyRURALDISTRIBUTOR)
                return (false, 2)
            }
        }

        else
        {
            viewController.showAlert(msg: "userNotFound".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
            return (false, 1)
        }
    }
    class func checkUsertType(appCredentail: AppCredential, viewController:UIViewController) -> (Bool, Int)
    {
        if(appCredentail.usertype == UserType_UTC0002) //UserType.equals("UTC0002"))
        {
            if (appCredentail.isVerify.uppercased() == "Y")
            {
                if(appCredentail.userStatus == Status.ACTIVE)
                {
                    return (true, 0)
                }
                else
                {
                    if((viewController is LoginViewController) || viewController is PasswordViewController)
                    {
                        viewController.showAlert(msg: "userNotActive".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                        return (false, 4)
                    }
                    else
                    {
                        viewController.showAlert(msg: "userNotActive".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                        return (false, 2)
                    }
                }
            }
            else
            {
                if((viewController is LoginViewController) || viewController is PasswordViewController)
                {
                    viewController.showAlert(msg: "userNotVerified".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                    return (false, 4)
                }
                else
                {
                    viewController.showAlert(msg: "userNotVerified".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                    return (false, 2)
                }
            }
        }
            
        else if(appCredentail.usertype == UserType_UTC0001)
        {
            if((viewController is LoginViewController) || viewController is PasswordViewController)
            {
                viewController.showAlert(msg: "alreadyDeler".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
                return (false, 4)
            }
            else
            {
                viewController.showAlert(msg: "alreadyDeler".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
                return (false, 2)
            }
        }
        else if(appCredentail.usertype == UserType_UTC0002)
        {
            if((viewController is LoginViewController) || viewController is PasswordViewController)
            {
                viewController.showAlert(msg: "alreadyRetailer".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
                return (false, 4)
            }
            else
            {
                viewController.showAlert(msg: "alreadyRetailer".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
                return (false, 2)
            }
        }
        else
        {
            viewController.showAlert(msg: "userNotFound".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
            return (false, 1)
        }
    }
}

extension Data
{
    func toString() -> String
    {
        return String(data: self, encoding: .utf8)!
    }
}

struct API
{
    static let GetUserCodeByMobileNo = "Common/GetUserCodeByMobileNo"
    static let GetOTP = "Authorize/GetOTP"
    static let AppCredentail = "Authorize/AppCredentailNEW"
    static let TopRefDomain = "TopRefDomain"
    static let GetAccRedSaleReport = "Report/GetAccRedSaleReport"
    static let GetDashboardDataForApi = "Dashboard/GetDashboardDataForApi"
    static let GetBalanceByUserCode = "Authorize/GetBalanceByUserCode"
    static let GetBankDetails = "EmployeeUser/GetBankDetails"
    static let Redeemption = "Transction/Redeemption"
    static let LoginByOTP = "Authorize/LoginByOTP"
    static let InsertUpdateUserBankDetails = "EmployeeUser/InsertUpdateUserBankDetails"
    static let GetPinDetailSummeryMob = "Transction/GetPinDetailSummeryMob"
    static let LoginbyOTP = "Authorize/LoginbyOTP"
    static let GetAllNotifications = "Authorize/GetAllNotifications"
    static let GetschemeDetailsByMobile = "Report/GetschemeDetailsByMobile"
    static let GetGalleryDetailList = "AdminMaster/GetGalleryDetailList"
    static let GetFlashMessage = "Dashboard/GetFlashMessage"
    static let GetSchemeGiftSlabUser = "Report/GetSchemeGiftSlabUser"
    static let  InsertUpdateGiftSlabUser = "Report/InsertUpdateGiftSlabUser"
    static let GetBannerList = "Dashboard/GetBannerList"
    static let GetDMSProducts = "Report/GetDMSProducts"
    static let InsertUpdateDMSGiftUser = "Report/InsertUpdateDMSGiftUser"
    
    
    //Order
    static let GetUserDrpCode = "base/GetUserDrpCode"
    static let GetProductByCatSubCat = "Transction/GetProductByCatSubCat"
    static let EditUserRegistration = "/EmployeeUser/EditUserRegistration"
    static let GetLastOrderNo = "/Transction/GetLastOrderNo"
    static let GetRDDMDetailsmapping = "/Transction/GetRDDMDetailsmapping"
    static let InsUpdSKUProductDetails = "Transction/InsUpdSKUProductDetails"
    static let GetMaterialCode = "Transction/GetMaterialCode"
    
    //Regitration
    static let GetUserRetailerCategory = "GEO/GetAllGEOCodeDetails"
    static let GetUserRetailerType = "GEO/GetAllGEOCodeDetailsWeb"
    static let GetUserDropdownCode = "GEO/GetUserDropdownCode"
    static let GetAllDetailsByPindoc = "GEO/GetAllDetailsByPindoc"
    static let GetOtherDetailsByArea = "/GEO/GetOtherDetailsByArea"
    static let ChkAllDuplicate = "EmployeeUser/ChkAllDuplicate"
    static let InsertUpdateUserRegistration = "EmployeeUser/InsertUpdateUserRegistration"
    static let GetMDMGSTState = "EmployeeUser/GetMDMGSTState?"
}

struct UserTypeName
{
    static let RETAILER = "RETAILER"
}

struct Status
{
    static let Valid = "Valid"
    static let Invalid = "Invalid"
    static let InvalidMobileNo = "Invalid MobileNumber/UserName"
    static let PasswordSet = "Password Set"
    static let PasswordChange = "Password Change"
    static let LoginFailed  = "Login Failed"
    static let isVerified = "Y"
    static let ACTIVE = "ACTIVE"
}

struct ActionType
{
    static let CheckLogin = "CheckLogin"
    static let CheckIMEI = "CheckIMEI"
    static let SetPassword = "SetPassword"
    static let ACC = ""
    static let EPLUS = "EPLUS"
    static let Select = "Select"
    static let Redeemtion = "Reseemtion"
    static let Resend = "Resend"
    static let SignIn = "Sign In"
    static let Insert = "Insert"
    static let GetPinDetailsByTranNo = "GetPinDetailsByTranNo"
    static let GetPinDetailsByPinNo = "GetPinDetailsByPinNo"
    static let GetAll = "GetAll"
    static let GetRuleDetails = "GetRuleDetails"
    static let GetSchemeDetails = "GetSchemeDetails"
    static let GetSelectedGift = "GetSelectedGift"
    static let GetGalleryDetailsByMobile = "GetGalleryDetailsByMobile"
    static let InsertSelectedGift = "InsertSelectedGift"
    
    //order
    static let SKUCategory = "SKUCategory"
    static let SKUSubCategory = "SKUSubCategory"
    static let SKUMaterialType = "SKUMaterialType"
    static let SKUCatType = "SKUCatType"
    static let GetProductByMaterialType = "GetProductByMaterialType"
    static let GetProduct = "GetProduct"
    static let Edit = "Edit"
    static let GetOrderNo = "GetOrderNo"
    static let GetDealerCode = "GetDealerCode"
    static let GetProductByMatCode = "GetProductByMatCode"
    static let GetProductByCode = "GetProductByCode"
    static let ProductProfile = "ProductProfile"
    
    //Regitration
    static let FrmType = "FrmType"
    static let State = "State"
    static let DistrictByStateCode = "DistrictByStateCode"
    static let CityByDistrict = "CityByDistrict"
    static let AreaByCity = "AreaByCity"
    static let GetOtherDetailsByArea = "GetOtherDetailsByArea"
    static let DetailsByPinNo = "DetailsByPinNo"
    static let MobileNo = "MobileNo"
    static let PanNo = "PanNo"
    static let GstNo = "GstNo"
    static let AdharNo = "AdharNo"
    static let EditUser = "ApproveEditUser"
    static let RetailerType = "SubUserType"
    static let RetailerCategory = "GetRetailerCategory"
}

struct Key
{
    
    //Parameters key
    static let MobileNumber = "MobileNumber"
    static let Password = "Password"
    static let IMEI = "IMEI"
    static let OSVersion = "OSVersion"
    static let AppVersion = "AppVersion"
    static let ActionType = "ActionType"
    static let DeviceType = "DeviceType"
    static let MobileNo = "MobileNo"
    static let SchemeCode = "SchemeCode"
    static let ISRLM = "ISRLM"
    static let Source = "Source"
    static let RuleName = "RuleName"
    static let EmpCode = "EmpCode"
    static let FromDate = "FromDate"
    static let ToDate = "ToDate"
    static let UserCode = "UserCode"
    static let Months = "Months"
    static let LoginType = "LoginType"
    static let actionType = "actionType"
     static let Years = "Years"
    static let PinDetail = "PinDetail"
    static let SalesOffice = "SalesOffice"
    static let Messege = "Messege"
    static let PKSlab_ID = "pkSlabID"
    static let EarnedPoints = "EarnedPoint"
    
    static let Types = "Types"
    
    static let StartDate = "StartDate"
    static let Category = "Category"
    static let ItemQty = "ItemQty"
    static let BranchName = "BranchName"
    static let DMSProductCode = "ProductCode"
    
    static let PageNumber = "PageNumber"
    
    //Parse key
    //AppCredentail
    static let Status = "Status"
    static let Usertype = "Usertype"
    static let UserStatus = "UserStatus"
    static let IsForceUpdate = "IsForceUpdate"
    static let PlayStoreAppVersion = "PlayStoreAppVersion"
    static let IsVerify = "IsVerify"
    
    //GetUserCodeByMobileNo
    static let Pk_UserID = "Pk_UserID"
    static let s_MobileNo = "s_MobileNo"
    static let s_UserTypeCode = "s_UserTypeCode"
    static let s_UserCode = "s_UserCode"
    static let s_FirmCode = "s_FirmCode"
    static let s_FullName = "s_FullName"
    static let s_EmailID = "s_EmailID"
    static let s_ShopName = "s_ShopName"
    static let s_ShopAddress1 = "s_ShopAddress1"
    static let s_ShopGEOID = "s_ShopGEOID"
    static let d_Balance = "d_Balance"
    static let TotalBalance = "TotalBalance"
    static let SchemeAllow = "SchemeAllow"
    static let b_IsActive = "b_IsActive"
    
    //Redeemption
    static let RedeemType = "RedeemType"
    static let AccountNo = "AccountNo"
    static let IFSCCode = "IFSCCode"
    static let BankName = "BankName"
    static let SchemeName = "SchemeName"
    static let RedemmValue = "RedemmValue"
    static let OTP = "OTP"
    static let reddet = "reddet"
    static let ProductCode = "ProductCode"
    static let ProductName = "ProductName"
    static let ProductPrice = "ProductPrice"
    //static let SchemeCode = "SchemeCode"
    static let ProductQuantity = "ProductQuantity"
    static let CreatedBy = "CreatedBy"
    //static let Source = "Source"

    static let listaccredtempdata = "listaccredtempdata"
 
    //add bank account
    static let ActionTypes = "ActionTypes"
    static let DocCode = "DocCode"
    static let CodeType = "CodeType"
    //static let UserCode = "UserCode"
    //static let CreatedBy = "CreatedBy"
    static let BankAccNo = "BankAccNo"
    //static let BankAccNo = "BankAccNo"
    //static let IFSCCode = "IFSCCode"
    //static let BankName = "BankName"
    static let BankAddress = "BankAddress"
    static let SourceName = "SourceName"
    static let NomeOf_AccHolder = "NomeOf_AccHolder"
    
    static let s_PIN = "s_PIN"
    static let s_Status = "s_Status"
    
    static let RuleCode = "RuleCode"
    
    //order
    static let SKUCode = "SKUCode"
    static let SkuCategory = "SkuCategory"
    static let SkuSubCategory = "SkuSubCategory"
    static let SKUSubCode = "SKUSubCode"
    static let SalesOfficeCode = "SalesOfficeCode"
    static let MaterialCode = "MaterialCode"
    
    //regitration
    static let State = "State"
    static let District = "District"
    static let City = "City"
    static let Pincode = "Pincode"
    static let CheckType = "Type"
    static let DuplicateNo = "DuplicateNo"
    static let UserTypeCode = "UserTypeCode"
    static let UserType = "UserType"
    static let UserSubType = "UserSubType"
    static let UserCategoryCode = "Retailercategory"
    static let FirmName = "FirmName"
    static let FirmCode = "FirmCode"
    static let FullName = "FullName"
    static let EmailId = "EmailId"
    static let GSTOption = "GSTOption"
    static let GSTNo = "GSTNo"
    static let Aadhar = "s_DocumnetNo"
    static let ParentChildStatus = "ParentChildStatus"
    static let ParentMobileNo = "ParentMobileNo"
    static let ShopImage = "ShopImage"
    static let ShopAddress1 = "ShopAddress1"
    static let ShopAddress2 = "ShopAddress2"
    static let ShopAddress3 = "ShopAddress3"
    static let Area = "Area"
    static let RegionName = "RegionName"
    static let ShopGEOId = "ShopGEOId"
    static let SectionName = "SectionName"
    static let ForwordTo = "ForwordTo"
    static let WeeklyOff = "WeeklyOff"
    static let Productprofiledetail = "Products"
    //static let Status = "Status"
    static let UserCurrentStatus = "UserCurrentStatus"
    static let IsActive = "IsActive"
    static let CreatedSource = "CreatedSource"
    static let UserDocCode = "UserDocCode"
    static let files = "files"
    static let fileName = "fileName"
    static let documentName = "documentName"
    static let documentNo = "documentNo"
    //Vouchers
    static let TypeV = "Type"
    static let SubCategoryCode = "SubCategoryCode"
    
    //static let s_UserCode = "s_UserCode"
    static let s_EmployeeCode = "s_EmployeeCode"
    static let s_ProductCode = "s_ProductCode"
    static let UserCategoryName = "UserCategoryName"
    
}
