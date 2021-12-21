//
//  Global.swift
//
//
//  Created by New on 22/11/17.
//  Copyright © 2017 FoxSolution. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

//MARK:- UAT-----------------------------------------
//let mainUrl = "https://retailerwebapiqa.usha.com:5065/"

let mainUrl = "https://retailerwebapiqa.usha.com:5065/"

//let mainUrl = "https://retailerwebapi.usha.com/" //MARK: New URL
//Live
//let mainUrl = "https://retailerwebapiqa.usha.com:5065/"
let productionUrl = "https://ushajoyqa.usha.com:5054/"

//let baseUrl = "https://retailerwebapiqa.usha.com:5065/api/"

let baseUrl = mainUrl + "api/"


//let mainUrlPowerPlus = "https://retailer.usha.com/"
let mainUrlPowerPlus = "https://retailerqa.usha.com:5064" //UPDATED NEW URL FOR IMAGES


let aboutSampark =  mainUrlPowerPlus + "Authorize/AboutSampark"

let samparkWeb = mainUrlPowerPlus
let RedImages = mainUrlPowerPlus + "CommanFiles/RedImages/"
let profile = mainUrlPowerPlus + "EmployeeUser/CreateEditUserRegistrationMob?MobileNo="

let notificationFile = mainUrlPowerPlus + "NotificationUpload/%@"

let scheme_result_url = mainUrlPowerPlus + "Notificationupload/SSBFINAL.jpg"

let getBannerLink = mainUrl + "api/Dashboard/GetBannerList?enquirydate="

let headers = ["Content-Type" : "application/json", "Clientid" : "qBd/jix0ctU=", "SecretId" : "7Whc1QzyT1Pfrtm88ArNaQ==" ]
let schemeCode = "SCPM0021"
let UserType_UTC0001 = "UTC0001"
let UserType_UTC0002 = "UTC0002"
let UserType_UTC0003 = "UTC0003"
let UserType_UTC0070 = "UTC0070"
let UserType_UTC0072 = "UTC0072"
let UserType_UTC0073 = "UTC0073"
let UserType_UTC0074 = "UTC0074"

//-->Select Scheme change - rahul
let staticSchemeCode = "SCPM0021"
let staticSchemeName = "RETAILER_APP"
//<--

var selectedCatlogueID = ""

let ProductCode = "REDP00319"
let ProductName = "Yes Bank"
let ProductQuantity = "1"
let RedeemType = "YesBankTransfer"
let RedeemTypeV = "Details"
let Source = "MOV"
let SourceE = "MOVE"
let messageOTP = "RETAILER APP LOGIN"
let messageResetPassword = "Password Reset thorugh Retailer App"
let messageBankTransfer = "Bank Transfer through Retailer App"
let dbName = "SAMPARK.db"
var retailerCategory : String = ""
var selectedRetailerCategory : String = ""
let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
let ifscRegEx = "[A-Z|a-z]{4}0[A-Z|a-z|0-9]{6}" //"^[A-Za-z]{4}\\d{7}$" //"^[A-Za-z]{4}[a-zA-Z0-9]{7}$" //
let accountNoRegEx = "[0-9]{10,25}" //"[1-9][0-9]{9,24}"
let mobileRegEx = "[0-9]{10}"
let pinCodeRegEx = "^[0-9]{6}$"
let panCardRegEx = "[a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}"//"/^([a-zA-Z]){5}([0-9]){4}([a-zA-Z]){1}?$/"//"^[A-Za-z]{5}[0-9]{4}[A-Za-z]$"
let aadherRegEx = "[0-9]{12}"
let gstRegEx = "^[0-9]{2}[a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[a-z1-9A-Z]{1}[a-zA-Z][0-9A-Z]{1}$"

//let deviceID = UIDevice.current.identifierForVendor!.uuidString

let systemVersion = UIDevice.current.systemVersion

let short_version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String

let appName = Bundle.main.infoDictionary?["CFBundleName"] as! String

let helpNo = "18002660077"

extension Date {
    func getGMTDate ()-> Date {
        let newDate = self.addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()))
        return newDate
    }
}


class ColorConstants: NSObject
{
    static let appRed = UIColor.red
    static let selectedBlue  = UIColor(red: 81.0/255.0, green: 158/255.0, blue: 211.0/255.0, alpha: 1)
    static let Navigation_Color: UIColor = #colorLiteral(red: 0.9253342748, green: 0.1854941547, blue: 0.2087527215, alpha: 1)
}


func setUserDefaults(value:Any, key: String)
{
    UserDefaults.standard.setValue(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func removeUserDefaults(key: String)
{
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
}

func getUserDefaults(key: String) -> Any
{
    return UserDefaults.standard.object(forKey: key) ?? ""
}


class NavController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

class TabBarController: UITabBarController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

struct defaultsKeys
{
    static let mobile = "mobile"
    static let login = "login"
    static let password = "password"
    static let lastBalnceSyncDate = "lastBalnceSyncDate"
    static let lastDashboardSyncDate = "lastDashboardSyncDate"
    static let lastNotificationSyncDate = "lastNotificationSyncDate"
    static let paswwordDate = "paswwordDate"
    static let isVerify = "isVerify"
}

struct OTPType
{
    static let Login = "Login"
    static let ForgotPassword = "ForgotPassword"
}


func setAppSession(data:[String:Any])
{
    setUserDefaults(value: data[defaultsKeys.mobile] ?? "", key: defaultsKeys.mobile)
    setUserDefaults(value: data[defaultsKeys.login] ?? "", key: defaultsKeys.login)
    setUserDefaults(value: data[defaultsKeys.password] ?? "", key: defaultsKeys.password)
}

func removeAppSession()
{
    UserDefaults.standard.removeObject(forKey: defaultsKeys.login)
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

//aadhar validation
class Aadhar_VerhoeffAlgorithm
{
    
    // From https://en.wikibooks.org/wiki/Algorithm_Implementation/Checksums/Verhoeff_Algorithm
    // based on the "C" implementation
    
    // The multiplication table
    static let verhoeff_d : [[ Int ]] = [
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
        [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
        [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
        [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
        [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
        [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
        [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
        [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
        [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
        [9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
        ];
    
    // The permutation table
    static let verhoeff_p : [[Int]] = [
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
        [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
        [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
        [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
        [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
        [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
        [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
        [7, 0, 4, 6, 9, 1, 3, 2, 5, 8],
        ];
    
    //Validates that an entered number is Verhoeff compliant.  The check digit must be the last one.
    static func ValidateVerhoeff(num : String) -> Bool
    {
        var c : Int = 0;
        let ll : Int = num.count
        for i in 0..<ll {
            c = verhoeff_d[c][verhoeff_p[(i % 8)][(num[ll-i-1]).integerValue]]
        }
        return (c == 0);
    }
}
