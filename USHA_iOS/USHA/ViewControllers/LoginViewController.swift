//
//  ViewController.swift
 
//
//  Created by Apple.Inc on 18/05/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import AACarousel
import Crashlytics


public class AppCredential: NSObject
{
    var appVersion: String!
    var mobileNumber: String!
    var isIMEIExit: Bool!
    var status: String!
    var userCode: String!
    var userStatus: String!
    var usertype: String!
    var isVerify:String!
    var actionType: String!
    var deviceType: String!
    var isForceUpdate:String!
    var playStoreAppVersion:String!
}

class LoginViewController: UIViewController
{

    @IBOutlet weak var btn_Login: UIButton!
    @IBOutlet weak var btn_RegLogin: UIButton!
    @IBOutlet weak var lbl_welcomeLogin: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageCtrl: UIPageControl!

    @IBOutlet weak var txt_mobile_no: SkyFloatingLabelTextField!
    @IBOutlet weak var lbl_appVersion: UILabel!
    @IBOutlet weak var passwordTxtView: UIView!

    
    var alertTag = 0
    var keyLang:String = ""
    var pathArray : [String] = []
    var bannerData : [BannerModelElementElement] = []
           var timer: Timer?
           var counter = 0
           var flag : String = ""
    
    let arrImg = [UIImage.init(named: "img1.jpeg"), UIImage.init(named: "img2.jpeg"),UIImage.init(named: "img3.jpeg"),UIImage.init(named: "img4.jpeg"),UIImage.init(named: "img5.jpeg"),UIImage.init(named: "img6.jpeg"),UIImage.init(named: "img7.jpeg")] as! [UIImage]


    var appCredential:AppCredential!

    override func viewDidLoad() {
        super.viewDidLoad()
        
         setUpStautusBar()
        
         LanguageChanged(strLan:keyLang)
        // Do any additional setup after loading the view, typically from a nib.
        
        txt_mobile_no.delegate = self
        txt_mobile_no.title = "PASSWORD"
        txt_mobile_no.placeholder = "MOBILE NUMBER"
        txt_mobile_no.updateLengthValidationMsg(MessageAndError.enterMobileNumber)
        txt_mobile_no.addRegx(mobileRegEx, withMsg: MessageAndError.enterValidMobileNumber)
        
        txt_mobile_no.lineHeight = 1.0 // bottom line height in points
        txt_mobile_no.selectedLineHeight = 2.0
        
        addReginTapGesture()
        //txt_mobile_no.keyboardType = .asciiCapableNumberPad

        
        
        
          lbl_appVersion.text = "APP VERSION : \(short_version)"
        
                 //pageCtrl.hidesForSinglePage = true
                 pageCtrl.pageIndicatorTintColor = UIColor.lightGray
                 pageCtrl.currentPageIndicatorTintColor = UIColor.red
                self.pageCtrl.currentPage = 0
        
        
        setUpDesign()
        
     
    }
    
    func setUpDesign(){
    
         passwordTxtView.layer.cornerRadius = 20
         passwordTxtView.layer.masksToBounds = true
         passwordTxtView.borderWidth  = 1.5
         passwordTxtView.borderColor = UIColor.lightGray
         

              btn_Login.layer.cornerRadius = 20
              btn_Login.layer.masksToBounds = true
              btn_Login.borderWidth  = 1.5
              btn_Login.backgroundColor = UIColor(red: 227/255, green: 6/255, blue: 19/255, alpha: 1.0)
              btn_Login.borderColor = UIColor(red: 242/255, green: 3/255, blue: 17/255, alpha: 1.0)
              btn_Login.setTitleColor(UIColor.white, for: .normal)

             
            btn_RegLogin.layer.cornerRadius = 20
            btn_RegLogin.layer.masksToBounds = true
            btn_RegLogin.borderWidth  = 1.5
            btn_RegLogin.borderColor = UIColor.lightGray
            btn_RegLogin.backgroundColor = UIColor.white
            btn_RegLogin.setTitleColor(UIColor(red: 242/255, green: 3/255, blue: 17/255, alpha: 1.0), for: .normal)
        
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
    
    func LanguageChanged(strLan:String){
        btn_Login.setTitle("GET OTP".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
        btn_RegLogin.setTitle("REGISTER".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
//        lbl_welcomeLogin.text = "WELCOMETOSAMPARKPROGRAM".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if Connectivity.isConnectedToInternet(){
            
            gettingBannerData()
            
//            self.flag = "LOCAL_IMAGES"
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
            //  self.showAlert(msg: "noInternetConnection".localizableString(loc:
            //      UserDefaults.standard.string(forKey: "keyLang")!))
            self.showAlert(msg: MessageAndError.noInternetConnection)
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
    
   func startScrolling(){
         
         timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
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
           // showAlert(msg:"noInternetConnection_ABOUT".localizableString(loc:
            //    UserDefaults.standard.string(forKey: "keyLang")!))
        }
        
        
//        let aboutVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.AboutViewController)
//        self.present(aboutVC, animated: true, completion: nil)
    }
    
    @IBAction func btn_contact_pressed(_ sender: UIButton) {
           callNumber(phoneNumber: helpNo)
       }
    
    @IBAction func btn_Login_pressed(_ sender: UIButton)
    {

            if (txt_mobile_no.text != "") // validate()
            {
                txt_mobile_no.endEditing(true)
                
                let numberTest = NSPredicate(format: "SELF MATCHES %@", mobileRegEx)
                if (numberTest.evaluate(with: txt_mobile_no.text) == true)
                {
                    if Connectivity.isConnectedToInternet()
                    {
                        setUserDefaults(value: txt_mobile_no.text!, key: defaultsKeys.mobile)
                        checkIMEI()
                    }
                    else
                    {
                     //   showAlert(msg:"noInternetConnection_OTP".localizableString(loc:
                        //    UserDefaults.standard.string(forKey: "keyLang")!))
                        showAlert(msg: MessageAndError.noInternetConnection_OTP)
                    }
                }
                else
                {
                  //  showAlert(msg:"enterValidMobileNumber".localizableString(loc:
                  //      UserDefaults.standard.string(forKey: "keyLang")!))
                    showAlert(msg: MessageAndError.enterValidMobileNumber)
                }
            }
            else
            {
              //  showAlert(msg: "enterMobileNumber".localizableString(loc:
//UserDefaults.standard.string(forKey: "keyLang")!))
                showAlert(msg: MessageAndError.enterMobileNumber)
            }
//        }
//        else
//        {
//            showAlert(msg: MessageAndError.noInternetConnection_OTP)
//        }
        
//        performSegue(withIdentifier: Segue.otp, sender: self)
        
//        let dash = getViewContoller(storyboardName: "Main", identifier: "DashboardViewController")
//        createMenuView(viewController: dash)
    }
    
    @IBAction func btn_register_pressed(_ sender: UIButton)
    {
        let registerVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.UserProfileViewController) as! UserProfileViewController
        registerVC.isRgistration = true
        self.present(registerVC, animated: true, completion: nil)
    }
    
    override func onYesPressed(alert: UIAlertAction!)
    {
        getUserCodeByMobileNo()
    }
  
    
    override func onOkPressed(alert: UIAlertAction!)
    {
        if (alertTag == 1)
        {
            let registerVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.UserProfileViewController) as! UserProfileViewController
            registerVC.enteredMobileNo = txt_mobile_no.text!
            registerVC.isRgistration = true
            
            self.present(registerVC, animated: true, completion: nil)
            
//            let webVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.UserProfileViewController) as! UserProfileViewController
//            self.present(webVC, animated: true, completion: nil)
            
        }
        else if (alertTag == 4)
        {
            exit(0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}

extension LoginViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

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
                               cell.imgSlide.image = UIImage.init(named: "usha3.jpg")
                       }
              }else{
                cell.imgSlide.image = self.arrImg[indexPath.row]
              }
               
                                cell.widthConst.constant = UIScreen.main.bounds.width
                                cell.heightConst.constant = collectionView.frame.size.height

                                      return cell
                               
                           }
                           
         func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
                               return CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.size.height)
              }
    

}

extension LoginViewController:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool
    {
        if textField == txt_mobile_no
        {
            let currentCharacterCount = textField.text?.count ?? 0
            if (currentCharacterCount == 0)
            {
                if (string == "0")
                {
                    return false
                }
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 10
        }
        else
        {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        _ = textField.resignFirstResponder()
        return true
    }
    
}

extension LoginViewController
{
    func didRecivedRespoance(api: String, parser: Parser, json: Any) {
        
    }
    
    func didRecivedGetUserCodeByMobileNo(json: [String : Any], actionType: String)
    {
        UserDetailParser.parseUserDetail(json: json, actionType:actionType)
        setUserDefaults(value: Date(), key: defaultsKeys.lastBalnceSyncDate)
        sendOTP(action: ActionType.CheckLogin, message:messageOTP)
    }
    
    func didRecived_AppCredentail(appCredentail: AppCredential)
    {
        self.appCredential = appCredentail
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
    
    override func didRecivedAppCredentail(parser:Parser, appVersion: String, mobileNumber: String, isIMEIExit: Bool, status: String, userCode: String, userStatus: String, usertype: String, actionType: String, isForceUpdate:String,isVerify : String)
    {

    }
    
    func checkAppCredential()
    {
        if (appCredential != nil)
        {
            if(appCredential.status == Status.InvalidMobileNo)
            {
                alertTag = 1
             //   showAlert(msg: "notRetailer".localizableString(loc:
               //     UserDefaults.standard.string(forKey: "keyLang")!))
                self.showAlert(msg: MessageAndError.notRetailer)

            }
            else
            {
                checkUsertType()
            }
        }
        else
        {
          //  showAlert(msg: "somethingWentWrong".localizableString(loc:
          //      UserDefaults.standard.string(forKey: "keyLang")!))
            self.showAlert(msg: MessageAndError.somethingWentWrong)

        }
    }
    
    func checkUsertType()
    {
        let userStatus = Parser.checkUsertType(usertype: appCredential.usertype, userStatus: appCredential.userStatus, viewController: self)
        
        if (userStatus.0)
        {
            if(appCredential.status == Status.Invalid)
            {
                getUserCodeByMobileNo()
            }
            else
            {
                if (appCredential.isIMEIExit)
                {
                    getUserCodeByMobileNo()
                }
                else
                {
                    showWrongUDIDLoginAlert()
                }
            }
        }
        else
        {
            alertTag = userStatus.1
        }
    }
    
    func getUserCodeByMobileNo()
    {
        let paraser = Parser()
        paraser.delegate = self
        let parameters:Parameters = [Key.MobileNo: txt_mobile_no.text!, Key.SchemeCode: schemeCode]
        paraser.callAPI(api: API.GetUserCodeByMobileNo, parameters: parameters, viewcontroller: self, actionType: "")
    }
    
    override func didRecivedOTP(otp: String, action:String)
    {
        let otpVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.OTPViewController) as! OTPViewController
        //otpVC.otp = otp
        self.present(otpVC, animated: true, completion: nil)
    }
    
    func showWrongUDIDLoginAlert()
    {
        let alert = UIAlertController(title: appName, message: MessageAndError.noAlreadyOnAnotherDevice, preferredStyle: UIAlertControllerStyle.alert)
                let actionYes = UIAlertAction(title: "YES",
                                             style: .default,
                                             handler: self.onYesPressed)
                alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "No",
                                     style: .default,
                                     handler: self.onNoPressed)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func yesPressed(alert: UIAlertAction!)
    {
        sendOTP(action: ActionType.CheckLogin, message: messageOTP)
    }
    
    @objc func noPressed(alert: UIAlertAction!)
    {
        removeAppSession()
        exit(0)
    }
    
    
//    func showForceUpdtaeAlert()
//    {
//        let alert = UIAlertController(title: appName, message: MessageAndError.appUpdate, preferredStyle: UIAlertControllerStyle.alert)
//        let actionYes = UIAlertAction(title: "UPDATE",
//                                      style: .default,
//                                      handler: self.updatePressed)
//        alert.addAction(actionYes)
//
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func showUpdtaeAlert()
//    {
//        let alert = UIAlertController(title: appName, message: MessageAndError.appUpdate, preferredStyle: UIAlertControllerStyle.alert)
//        let actionYes = UIAlertAction(title: "UPDATE",
//                                      style: .default,
//                                      handler: self.updatePressed)
//        alert.addAction(actionYes)
//
//        let actionNo = UIAlertAction(title: "CANCEL",
//                                     style: .default,
//                                     handler: self.cancelPressed)
//        alert.addAction(actionNo)
//
//        self.present(alert, animated: true, completion: nil)
//    }
    
//    @objc func updatePressed(alert: UIAlertAction!)
//    {
//        let urlStr = "https://itunes.apple.com/in/app/sampark/id1257644761?mt=8"
//
//        if let url = URL(string: urlStr)
//        {
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url, options: [:])
//            } else {
//                // Fallback on earlier versions
//                UIApplication.shared.openURL(url)
//            }
//        }
//    }
    
    @objc override func cancelPressed(alert: UIAlertAction!)
    {
        checkAppCredential()
    }
    
//    func didRecivedOTP()
//    {
//        DataProvider.sharedInstance.mobile = txt_mobile_no.text!
//        let otpVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.OTPViewController) as! OTPViewController
//        //otpVC.otpType = OTPType.Login
//        self.present(otpVC, animated: true, completion: nil)
//        //self.performSegue(withIdentifier: "otp", sender: self)
//    }
    
}

