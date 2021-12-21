//
//  EnterPasswordViewController.swift
//  SAMPARK
//
//  Created by Apple.Inc on 25/05/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import AACarousel
import Kingfisher
import FSPagerView
import SQLite


enum PasswordViewControllerAction: Int
{
    case Login = 0
    case ForgotPassword
}

class sliderCollectionCell : UICollectionViewCell{
    
   @IBOutlet weak var imgSlide : UIImageView!
    @IBOutlet weak var widthConst: NSLayoutConstraint!
    @IBOutlet weak var heightConst: NSLayoutConstraint!


}


// MARK: - BannerModelElementElement
struct BannerModelElementElement: Codable {
    let pkID: Int
    let image: String?
    let imagePath: String?
    let status, uploadDate: String

    enum CodingKeys: String, CodingKey {
        case pkID = "pk_ID"
        case image = "Image"
        case imagePath = "ImagePath"
        case status = "Status"
        case uploadDate = "UploadDate"
    }
}

typealias BannerModelElement = [BannerModelElementElement]

class PasswordViewController: UIViewController{

    @IBOutlet weak var txt_password: SkyFloatingLabelTextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbl_welcomeToSmpark: UILabel!
    @IBOutlet weak var btn_Forget: UIButton!
    @IBOutlet weak var btn_otp: UIButton!
    @IBOutlet weak var lbl_appVersion: UILabel!
    @IBOutlet weak var pageCtrl: UIPageControl!
    @IBOutlet weak var passwdTxtView: UIView!


    var strLan:String = ""
    var keyLang:String = ""
    var action:PasswordViewControllerAction = .Login
    var userCode = ""

    
    var arr_Scheme = [Scheme]()


        var bannerData : [BannerModelElementElement] = []
        var pathArray : [String] = []
        var titleArray = [String]()
        var timer: Timer?
        var alertTag = 0
        var counter = 0
        var flag : String = ""

        
        let arrImg = [UIImage.init(named: "img1.jpeg"), UIImage.init(named: "img2.jpeg"),UIImage.init(named: "img3.jpeg"),UIImage.init(named: "img4.jpeg"),UIImage.init(named: "img5.jpeg"),UIImage.init(named: "img6.jpeg"),UIImage.init(named: "img7.jpeg")] as! [UIImage]
//        let arrImg = [UIImage]()
        
        var appCredential:AppCredential!

        override func viewDidLoad()
        {
            super.viewDidLoad()
           // Do any additional setup after loading the view.
            
            addReginTapGesture()
            
            if DataProvider.sharedInstance.userDetails == nil
            {
                getUserDetail()
            }
            
            
            pageCtrl.hidesForSinglePage = true
            pageCtrl.currentPage = 0
            pageCtrl.pageIndicatorTintColor = UIColor.lightGray
            pageCtrl.currentPageIndicatorTintColor = UIColor.red

            self.txt_password.delegate = self
            self.txt_password.becomeFirstResponder()

            txt_password.updateLengthValidationMsg(MessageAndError.enterPassword)
            txt_password.addRegx(passwordRegEx, withMsg: MessageAndError.enterCorrectPassword)

            self.lbl_appVersion.text = "APP VERSION : \(short_version)"

            setUpDesign()
        }
    
    func setUpDesign(){
        
             passwdTxtView.layer.cornerRadius = 20
             passwdTxtView.layer.masksToBounds = true
            passwdTxtView.borderWidth  = 1.5
            passwdTxtView.borderColor = UIColor.lightGray
        
             btn_otp.layer.cornerRadius = 20
             btn_otp.layer.masksToBounds = true
    }
   
    func startScrolling(){
        
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
    }

        
         func LanguageChanged(strLan:String){
        
            btn_otp.setTitle("Submit".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
            btn_Forget.setTitle("Forget/reset".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
            print(keyLang)
        }
        
        override func viewWillAppear(_ animated: Bool)
        {
            super.viewWillAppear(true)
           LanguageChanged(strLan:keyLang)
            
        }
    
    @objc func changeImage(){
        
        if self.flag == "WEB_IMAGES"{
            if counter < pathArray.count{
                       let index = IndexPath.init(item: counter, section: 0)
                       self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                self.pageCtrl.currentPage = counter
                       counter += 1
                  
                   }else{
                       counter = 0
                       let index = IndexPath.init(item: counter, section: 0)
                                 self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                      self.pageCtrl.currentPage = counter
                   }
        }else{
            if counter < arrImg.count{
                       let index = IndexPath.init(item: counter, section: 0)
                       self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                self.pageCtrl.currentPage = counter
                       counter += 1
                   }else{
                       counter = 0
                       let index = IndexPath.init(item: counter, section: 0)
                                 self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
                self.pageCtrl.currentPage = counter
                   }
        }
        
       
        
        
    }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(true)
            if(checkPassword())
            {
                alertTag = 1
               showAlert(msg: "resetPassword".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            
            if Connectivity.isConnectedToInternet(){
                       
                    gettingBannerData()
//                self.flag = "LOCAL_IMAGES"
                self.collectionView.delegate = self
                  self.collectionView.dataSource = self
                         DispatchQueue.main.async {
                                          self.startScrolling()
                                           self.collectionView.reloadData()
                                    self.pageCtrl.numberOfPages = self.arrImg.count
                                      self.pageCtrl.currentPage = 0
                         }
                
                   }else{
            
                                 self.flag = "LOCAL_IMAGES"
                                 self.collectionView.delegate = self
                                 self.collectionView.dataSource = self
                            DispatchQueue.main.async {
                                                            self.startScrolling()
                                                             self.collectionView.reloadData()
                                self.pageCtrl.numberOfPages = self.arrImg.count
                                self.pageCtrl.currentPage = 0
                                                          }
                  self.showAlert(msg: "noInternetConnection".localizableString(loc:
                              UserDefaults.standard.string(forKey: "keyLang")!))
                               }
                         
              
        }
        
        func gettingBannerData(){
        
            WebAPIClient.shared.parsingBannerData(completionHandler:{ (result) in
                switch (result) {
                case .Success(let responseDict, _):
                    if responseDict.count > 0 {
                        let mydata  = "\(responseDict["ResponseData"])"
                        print("mydata Info : \(mydata)")
                        let data = mydata.data(using: .utf8)!
                        do {
                             let jsonArray = try  JSONSerialization.jsonObject(with: data, options :[])
                             let myJsonData = JSON(jsonArray)
                            
                            if myJsonData.count > 0{
                            
                            self.bannerData =  try JSONDecoder().decode([BannerModelElementElement].self, from: myJsonData.rawData())
                          
                                if self.bannerData.count >= 0{
                                  
                                  self.flag = "WEB_IMAGES"
                                        
                                        for data in self.bannerData{
                                            
                                            self.pathArray.append(data.imagePath ?? "")
                                        }
                                        
                                   print(self.pathArray)
                                        
                                    self.pageCtrl.numberOfPages = self.pathArray.count
                                    self.pageCtrl.currentPage = 0
                                }else{
                                  self.flag = "LOCAL_IMAGES"
                                  self.pageCtrl.numberOfPages = self.arrImg.count
                                    self.pageCtrl.currentPage = 0
                              }
                           
                            }else{
                                self.flag = "LOCAL_IMAGES"
                                self.pageCtrl.numberOfPages = self.arrImg.count
                                self.pageCtrl.currentPage = 0
                                
                            }
                                self.collectionView.delegate = self
                                self.collectionView.dataSource = self
                                                       
                          DispatchQueue.main.async {
                                          self.startScrolling()
                                          self.collectionView.reloadData()
                               }
                        } catch let error as NSError {
                            print(error)
                        }
                    }
             
                    else {
                        
                        let responseMessage = responseDict["Message"]
                        print("Response Message : \(responseMessage)")
                    }
                    
                case .Failure(let failureMessage, let statusCode):
                    print("Message : \(failureMessage)")
                    print("Status Code : \(statusCode)")
                    break
                }

              })
           
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
            else if alertTag == 4
            {
                exit(0)
            }
        }

        
        @IBAction func btn_contact_pressed(_ sender: UIButton)
        {
            callNumber(phoneNumber: helpNo)
        }
        
        @IBAction func btn_introapp_pressed(_ sender: UIButton) {
            if(Connectivity.isConnectedToInternet())
            {
               // let urlStr = "https://loyaltyuat.havells.com/Authorize/AboutSampark"
                //"https://Loyaltyservices.havells.com/Authorize/AboutSampark"

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
                showAlert(msg:"noInternetConnection_ABOUT".localizableString(loc:
                   UserDefaults.standard.string(forKey: "keyLang")!))
            }
   
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
            }
            let schemeNameArray:[String] = arr_Scheme.map{$0.s_SchemePromName!}
//            selectSchemeDropDown.dataSource = schemeNameArray
//            selectSchemeDropDown.show()
        }catch  {
            print("error DB Insert")
            print("Error info: \(error)")
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

        
        @IBAction func btn_submit_pressed(_ sender: UIButton)
        {
            if txt_password.validate()
            {
                if Connectivity.isConnectedToInternet()
                {
                    action = .Login
                    checkIMEI()
                }
                else
                {
                    if let password = getUserDefaults(key: defaultsKeys.password) as? String
                    {
                        if password == txt_password.text!
                        {
                            //change to homeviewcontroller
                            
                            if DataProvider.sharedInstance.userDetails == nil
                            {
                                getUserDetail()
                            }

                            setUserDefaults(value: true, key: defaultsKeys.login)
                            DataProvider.sharedInstance.isPendinPopupShow = false
                            DataProvider.sharedInstance.isFlashMessagePopupShow = false
                            createMenuView()

                         //   retrieveScheme()
                          //  DataProvider.sharedInstance.selectedScehme = arr_Scheme[0]
                           // performSegue(withIdentifier: Segue.selectscheme, sender: self)

                        }
                        else
                        {
                            self.showAlert(msg: "\(MessageAndError.loginFailed)\n\(MessageAndError.enterCorrectPassword)")
                            txt_password.text = ""
                        }
                    }
                    else
                    {
                        print("password not found")
                        self.showAlert(msg: "\(MessageAndError.loginFailed)\n\(MessageAndError.somethingWentWrong)")
                        txt_password.text = ""
                    }
                }
            }
           else
            {
                showAlert(msg: txt_password.strMsg)
                txt_password.text = ""
            }
        }
        
        @IBAction func btn_forgotpassword_pressed(_ sender: UIButton)
        {
            if Connectivity.isConnectedToInternet()
            {
                action = .ForgotPassword
                checkIMEI()
            }
            else
            {
              showAlert(msg: "noInternetConnection_RESETPASSWORD".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
           
            let setpassword = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.SetPasswordViewController) as! SetPasswordViewController
            setpassword.isForgotPassword = true
            self.present(setpassword, animated: true, completion: nil)

            //performSegue(withIdentifier: Segue.setpassword, sender: self)
        }

    }

    extension PasswordViewController:UITextFieldDelegate
    {
        func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool
        {
            if textField == txt_password
            {
                let currentCharacterCount = textField.text?.count ?? 0
                let newLength = currentCharacterCount + string.count - range.length
                return newLength <= 12
            }
            else
            {
                return true
            }
        }
        
        
    }

extension PasswordViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(self.flag)
        if self.flag == "WEB_IMAGES"
        {
            
            print(self.pathArray.count)
            return self.pathArray.count
        }else{
            return self.arrImg.count

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell : sliderCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as!  sliderCollectionCell
        
        if self.flag == "WEB_IMAGES"
              {
                
                let imageData = self.pathArray[indexPath.row]
                       if imageData.count != 0{
                           
                        cell.imgSlide.image = UIImage(url: URL(string: imageData))
                           
                       }else{
                        cell.imgSlide.image = UIImage.init(named: "komal_1.jpg")
                }
              }else{
                cell.imgSlide.image = self.arrImg[indexPath.row]
              }
               
               cell.widthConst.constant = UIScreen.main.bounds.width
               cell.heightConst.constant = collectionView.frame.size.height

               return cell
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        self.pageCtrl.currentPage = indexPath.item
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        pageCtrl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
//    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.size.height)
      }


    
}

    extension PasswordViewController//:ParserDelegate
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
            //change to homeviewcontroller
//            if api == API.LoginByOTP
//            {
//                if let json = parser.responseData as? [[String:Any]]
//                {
//                    if json.count > 0
//                    {
//                        let result = SchemeParser.parseScheme(json: json)
//                        saveSchme(schemes: result.1)
//                        if userCode != ""
//                        {
//                            getScheme(userCode: userCode)
//                        }
//                        else
//                        {
//                            showAlert(msg: "somethingWentWrong".localizableString(loc:
//                                                                                    UserDefaults.standard.string(forKey: "keyLang")!))
//                        }
//                    }
//                    else
//                    {
//                        showAlert(msg: "Scheme not found")
//                    }
//                }
//            }
//            else if api == API.GetBalanceByUserCode
//            {
//                if let json = parser.responseData as? [[String:Any]]
//                {
//                    if json.count > 0
//                    {
//                        let result_Balance = SchemeParser.parseScheme(json: json)
//
//                        guard let db = DataProvider.getDBConnection() else {
//                            print("db connection not found")
//                            return
//                        }
//
//                        do {
//
//                            let itExists = try db.scalar(tblScheme.exists)
//                            if itExists
//                            {
//                                for item in result_Balance.1
//                                {
//                                    let alice = tblScheme.filter(c_s_SchemePromName.like(item.s_SchemePromName!))
//
//                                    try db.run(alice.update(c_d_Balance <- item.d_Balance!))
//                                }
//                            }
//                            else
//                            {
//                                saveSchme(schemes: result_Balance.1)
//                            }
//
//                            let sum = try db.scalar(tblScheme.select(c_d_Balance.sum))
//
//                            if let total = sum  {
//                                DataProvider.sharedInstance.userDetails.d_Balance = total
//                            }
//
//                            self.arr_Scheme.removeAll()
//                            for scheme in try db.prepare(tblScheme)
//                            {
//                                let obj_scheme = Scheme()
//                                obj_scheme.d_Balance = scheme[c_d_Balance]
//                                obj_scheme.s_SchemePromCode = scheme[c_s_SchemePromCode]
//                                obj_scheme.s_SchemePromName = scheme[c_s_SchemePromName]
//
//                                self.arr_Scheme.append(obj_scheme)
//                            }
//
//                            if DataProvider.sharedInstance.userDetails == nil
//                            {
//                                getUserDetail()
//                            }
//
//                            setUserDefaults(value: true, key: defaultsKeys.login)
//                            DataProvider.sharedInstance.isPendinPopupShow = false
//                            DataProvider.sharedInstance.isFlashMessagePopupShow = false
//                            DataProvider.sharedInstance.selectedScehme = arr_Scheme[0]
//
//                            createMenuView()
//
//                            let schemeNameArray:[String] = arr_Scheme.map{$0.s_SchemePromName!}
//                            //                            selectSchemeDropDown.dataSource = schemeNameArray
//                            //                            selectSchemeDropDown.show()
//
//                        }catch  {
//                            print("error DB Insert")
//                            print("Error info: \(error)")
//                        }
//                    }
//                    else
//                    {
//                        parseAndshowSchemeDropDown(json: nil)
//                    }
//                }
//                else
//                {
//                    showAlert(msg: "Scheme not found")
//                }
//            }
            
        }
        
    //    func didRecivedOTP()
    //    {
    //        let otpVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.OTPViewController) as! OTPViewController
    //        //otpVC.otpType = OTPType.Login
    //        self.present(otpVC, animated: true, completion: nil)
    //    }
        
        func didRecived_AppCredentail(appCredentail: AppCredential)
        {
            self.appCredential = appCredentail
            if appCredential.actionType == ActionType.CheckIMEI
            {
                if(appCredentail.playStoreAppVersion == "TRUE")
                {
                    checkAppCredential()
                }
                else
                {
                    if(appCredentail.isForceUpdate == "YES")
                    {
                        showForceUpdtaeAlert()
                    }
                    else
                    {
                        showUpdtaeAlert()
                    }
                }
            }
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
                    self.userCode = userCode
                    //change to homeviewcontroller
//                    getScheme(userCode:userCode)
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
            else
            {
                if (status == Status.LoginFailed)
                {
                    self.showAlert(msg: "\(MessageAndError.loginFailed)\n\(MessageAndError.enterCorrectPassword)")
                    txt_password.text = ""
                }
                else
                {
                   //change to homeviewcontroller
                    if DataProvider.sharedInstance.userDetails == nil
                    {
                        getUserDetail()
                    }

                    setUserDefaults(value: true, key: defaultsKeys.login)
                    DataProvider.sharedInstance.isPendinPopupShow = false
                    DataProvider.sharedInstance.isFlashMessagePopupShow = false
                  //  retrieveScheme()
                   // DataProvider.sharedInstance.selectedScehme = 
                    createMenuView()

                    
              //      performSegue(withIdentifier: Segue.selectscheme, sender: self)
                }
            }
        }
        
        func didRecivedAppCredentailFali(msg: String)
        {
            showAlert(msg: msg)
        }
        
        
    //    func checkAppCredential()
    //    {
    //        if (appCredential != nil)
    //        {
    //            if(appCredential.status == Status.InvalidMobileNo)
    //            {
    //                alertTag = 1
    //                showAlert(msg: MessageAndError.notRetailer)
    //            }
    //            else
    //            {
    //                checkUsertType()
    //            }
    //        }
    //        else
    //        {
    //            showAlert(msg: MessageAndError.somethingWentWrong)
    //        }
    //    }
    //
    //    func checkUsertType()
    //    {
    //        let userStatus = Parser.checkUsertType(usertype: appCredential.usertype, userStatus: appCredential.userStatus, viewController: self)
    //
    //        if (userStatus.0)
    //        {
    //            if(appCredential.status == Status.Invalid)
    //            {
    //                getUserCodeByMobileNo()
    //            }
    //            else
    //            {
    //                if (appCredential.isIMEIExit)
    //                {
    //                    getUserCodeByMobileNo()
    //                }
    //                else
    //                {
    //                    showWrongUDIDLoginAlert()
    //                }
    //            }
    //        }
    //        else
    //        {
    //            alertTag = userStatus.1
    //        }
    //    }
        
        func checkAppCredential()
        {
            if (appCredential != nil)
            {
                if(appCredential.usertype == "")
                {
                    showAlert(msg: "userNotFound".localizableString(loc:
                     UserDefaults.standard.string(forKey: "keyLang")!))
                }
                else
                {
                    if (appCredential.isIMEIExit)
                    {
                        let userStatus = Parser.checkUsertType(usertype: appCredential.usertype, userStatus: appCredential.userStatus, viewController: self)
                        if (userStatus.0)
                        {
                            switch action
                            {
                            case .Login:
                                if let mobile = getUserDefaults(key: defaultsKeys.mobile) as? String
                                {
                                    let paraser = Parser()
                                    paraser.delegate = self
                                    paraser.callAPIAppCredentail(mobileNumber: mobile, password: txt_password.text!, actionType: ActionType.CheckLogin, viewcontroller: self)
                                }
                            case .ForgotPassword:
                                let setpassword = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.SetPasswordViewController) as! SetPasswordViewController
                                setpassword.isForgotPassword = true
                                self.present(setpassword, animated: true, completion: nil)
                                //sendOTP(action: ActionType.SetPassword, source: SourceResetPassword)
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
                        showWrongUDIDPaaswordAlert()
                    }
                }
            }
        }
        
        @objc override func cancelPressed(alert: UIAlertAction!)
        {
            checkAppCredential()
        }
    }

