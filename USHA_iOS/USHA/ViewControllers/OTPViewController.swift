//
//  OTPViewController.swift
 
//
//  Created by Apple.Inc on 19/05/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import AACarousel

class OTPViewController: UIViewController {
    
    @IBOutlet weak var btn_resendOtp: UIButton!
    
    @IBOutlet weak var btn_verifyOtp: UIButton!
    @IBOutlet weak var txt_mobile_no: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_verify_otp: SkyFloatingLabelTextField!
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var lbl_appVersion: UILabel!
   @IBOutlet weak var pageCtrl: UIPageControl!
    @IBOutlet weak var lbl_welcomeOtpController: UILabel!
    @IBOutlet weak var mobileTxtView: UIView!
    @IBOutlet weak var otpTxtView: UIView!
    @IBOutlet weak var lbl_time: UILabel!

    
    var strLan:String = ""

    var timerIsOn = false
    var alertTag = 0
    var timer: Timer?
    var counter = 0
    var secondsLeft: Int = 300
    var mobile:String!
    var flag : String = ""
    
    var bannerData : [BannerModelElementElement] = []
          var pathArray : [String] = []
    
    
    let arrImg = [UIImage.init(named: "img1.jpeg"), UIImage.init(named: "img2.jpeg"),UIImage.init(named: "img3.jpeg"),UIImage.init(named: "img4.jpeg"),UIImage.init(named: "img5.jpeg"),UIImage.init(named: "img6.jpeg"),UIImage.init(named: "img7.jpeg")] as! [UIImage]

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addReginTapGesture()
        LanguageChanged(strLan:keyLang)
        txt_verify_otp.updateLengthValidationMsg(MessageAndError.enterOtp)

        txt_mobile_no.isEnabled = false
        if let mobile = DataProvider.sharedInstance.mobile
        {
            self.mobile = mobile
            txt_mobile_no.text = mobile
        }
        else if let mobile = getUserDefaults(key: defaultsKeys.mobile) as? String
        {
            self.mobile = mobile
            DataProvider.sharedInstance.mobile = mobile
            txt_mobile_no.text = mobile
        }
        
        let last2 = self.mobile.suffix(2)
         lbl_time.text = "OTP HAS SEND To: ********\(last2)"
        
        txt_verify_otp.delegate = self
        
        btn_resendOtp.isEnabled = true
    
            //self.lbl_appVersion.text = "APP VERSION : \(short_version)"
        
                //pageCtrl.hidesForSinglePage = true
                 pageCtrl.pageIndicatorTintColor = UIColor.lightGray
                 pageCtrl.currentPageIndicatorTintColor = UIColor.red
        
        setUpDesign()
 
         }
    
     func setUpDesign(){
       
            mobileTxtView.layer.cornerRadius = 20
            mobileTxtView.layer.masksToBounds = true
            mobileTxtView.borderWidth  = 1.5
            mobileTxtView.borderColor = UIColor.lightGray
        
                    otpTxtView.layer.cornerRadius = 20
                   otpTxtView.layer.masksToBounds = true
                   otpTxtView.borderWidth  = 1.5
                   otpTxtView.borderColor = UIColor.lightGray
       

                 btn_resendOtp.layer.cornerRadius = 20
                 btn_resendOtp.layer.masksToBounds = true
                 btn_resendOtp.borderWidth  = 1.5
                 btn_resendOtp.backgroundColor = UIColor(red: 227/255, green: 6/255, blue: 19/255, alpha: 1.0)
                 btn_resendOtp.borderColor = UIColor(red: 242/255, green: 3/255, blue: 17/255, alpha: 1.0)
                 btn_resendOtp.setTitleColor(UIColor.white, for: .normal)

                
               btn_verifyOtp.layer.cornerRadius = 20
               btn_verifyOtp.layer.masksToBounds = true
               btn_verifyOtp.borderWidth  = 1.5
               btn_verifyOtp.borderColor = UIColor(red: 242/255, green: 3/255, blue: 17/255, alpha: 1.0)
               btn_verifyOtp.backgroundColor = UIColor(red: 227/255, green: 6/255, blue: 19/255, alpha: 1.0)//UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
               btn_verifyOtp.setTitleColor(UIColor.white, for: .normal)
           
    

       }
    
         
          func startScrolling(){
              
              timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
          }

    func LanguageChanged(strLan:String){
        btn_resendOtp.setTitle("RESEND OTP".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
        btn_verifyOtp.setTitle("Verify OTP".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
       // lbl_welcomeOtpController.text = "WELCOMETOSAMPARKPROGRAM".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)

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
    
    override func viewDidAppear(_ animated: Bool)
    {
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
                     
                 }else
                            {
    
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
                            
                                  if self.bannerData.count > 0{
                                    
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
    
  

    @objc func runScheduledTask(_ runningTimer: Timer)
    {
        btn_resendOtp.isEnabled = true
//        //var hour: Int
//        var minute: Int
//        var second: Int
//        //var  day: Int
//        secondsLeft -= 1
//
//        if secondsLeft == 0  || secondsLeft < 0{
//            timer.invalidate()
//            alertTag = 1
//            showAlert(msg: MessageAndError.sessionExpired)
//        }
//        else {
//            //hour = secondsLeft / 3600
//            minute = (secondsLeft % 3600) / 60
//            second = (secondsLeft % 3600) % 60
////            day = ( secondsLeft / 3600) / 24
////            if(day > 0){
////                hour = (secondsLeft / 3600) % (day * 24)
////            }
//
//            let timeStr = "\(minute):\(second)"
//
//                let last2 = self.mobile.suffix(2)
//                lbl_time.text = "OTP HAS SEND To: ********\(last2) \n SESSION WILL EXPIRED IN \(timeStr)"
//
//
//            // days.text = String(format: "%02d", day)
//            // minutes.text = String(format: "%02d", minute)
//            // seconds.text = String(format: "%02d", second)
//            // hours.text = String(format: "%02d", hour)
//        }
        
    }
    override func onOkPressed(alert: UIAlertAction!) {
        if alertTag == 1
        {
            self.dismiss(animated: true, completion: nil)
            return
        }
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
            showAlert(msg: MessageAndError.noInternetConnection_ABOUT)
        }

    }
    
    @IBAction func btn_resetotp_pressed(_ sender: UIButton)
    {
        if(Connectivity.isConnectedToInternet())
        {
            sendOTP(action: ActionType.Resend, message:messageOTP)
        }
        else
        {
            showAlert(msg: MessageAndError.noInternetConnection_OTP)
        }
    }
    
    @IBAction func btn_verifyotp_pressed(_ sender: UIButton)
    {
        if(Connectivity.isConnectedToInternet())
        {
            if txt_verify_otp.validate()
            {
                let paraser = Parser()
                paraser.delegate = self
                paraser.callAPILoginByOTP(mobileNumber: txt_mobile_no.text!, otp: txt_verify_otp.text!, loginType: "External", viewcontroller: self, action: ActionType.SignIn)
            }
            else
            {
                self.showAlert(msg: MessageAndError.enterOtp)
            }
        }
        else
        {
         
            showAlert(msg: "noInternetConnection_SUBMITOTP".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
    }
   
   

}

extension OTPViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

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
                       
                       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
                           return CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.size.height)
                         }

}

extension OTPViewController:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool
    {
        if textField == txt_verify_otp
        {
            let currentCharacterCount = textField.text?.count ?? 0
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 5
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
extension OTPViewController
{
    func didRecivedVerifiedOTPStatus(status:Bool)
    {
        if status
        {
            let setpassword = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.SetPasswordViewController) as! SetPasswordViewController
            setpassword.isForgotPassword = false
            self.present(setpassword, animated: true, completion: nil)
           // performSegue(withIdentifier: Segue.setpassword, sender: self)
        }
        else
        {
            txt_verify_otp.text = ""
            self.showAlert(msg: MessageAndError.enterValidOtp)
        }
    }

    override func didRecivedOTP(otp: String, action: String)
    {
        if action == ActionType.Resend
        {
            //self.otp = otp
        }
        else
        {
            super.didRecivedOTP(otp: otp, action: action)
        }
    }
}
