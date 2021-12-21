//
//  OtpPopupViewController.swift
 
//
//  Created by Apple.Inc on 09/06/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit

@objc protocol OtpPopupViewDelegate: AnyObject
{
    @objc func didVeifyOtp(otp:String, action:String)
    @objc func sessionExpired()
}

class OtpPopupViewController: UIViewController
{
    @IBOutlet weak var txt_verify_otp: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lbl_time: UILabel!
    
    @IBOutlet weak var alertView: UIView!

    @IBOutlet weak var btn_cancel: UIButton!
    
    @IBOutlet weak var btn_verifyOtp: UIButton!
    @IBOutlet weak var btn_verifyOtp_red: UIButton!
    @IBOutlet weak var lbl_VerifyOtpPopUp: UILabel!
    
    
    
    var action:String!
    //var otp:String!
    //var otpType:String!
    
    var timerIsOn = false
    var timer = Timer()
    var alertTag = 0
    var flagRedemtion = 0
    var secondsLeft: Int = 90
    var mobile = ""
    
    var delegate: OtpPopupViewDelegate?

    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addReginTapGesture()
        
        txt_verify_otp.updateLengthValidationMsg("enterOtp".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!))
        
        if let mobile = getUserDefaults(key: defaultsKeys.mobile) as? String
        {
             self.mobile = mobile
        }
        
        txt_verify_otp.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let last2 = self.mobile.suffix(2)
        lbl_time.text = "OTP HAS SEND TO: ********\(last2)"
        
        if action == ActionType.Redeemtion
        {
            btn_cancel.isHidden = true
            btn_verifyOtp.isHidden = true
            btn_verifyOtp_red.isHidden = false
            self.timer  = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.runScheduledTask), userInfo: nil, repeats: true)
        }
        else
        {
            btn_cancel.isHidden = false
            btn_verifyOtp.isHidden = false
            btn_verifyOtp_red.isHidden = true
        }
        
        addReginTapGesture()

        txt_verify_otp.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
        
    }
    
    @objc func textFieldDidChange(_ textField:UITextField){
        
        if let text = textField.text{
            if (text.count > 4){
                
                if txt_verify_otp.validate()
                {
                    if action == ActionType.Redeemtion
                    {
                        self.dismiss(animated: true, completion: {
                            self.delegate?.didVeifyOtp(otp: self.txt_verify_otp.text!, action: self.action)
                        })
                    }
                    else
                    {
                        let paraser = Parser()
                        paraser.delegate = self
                        paraser.callAPILoginByOTP(mobileNumber: self.mobile, otp: txt_verify_otp.text!, loginType: "External", viewcontroller: self, action: ActionType.SignIn)
                    }
                }
                else
                {
                    self.showAlert(msg: MessageAndError.enterOtp)
                }
            }
        }
        
    }
    
    
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    @objc func runScheduledTask(_ runningTimer: Timer)
    {
        //var hour: Int
//        var minute: Int
//        var second: Int
        //var  day: Int
        secondsLeft -= 1
        
        if secondsLeft == 0  || secondsLeft < 0{
            timer.invalidate()
            alertTag = 1
            showAlert(msg: "sessionExpired".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
        else {
            //hour = secondsLeft / 3600
//            minute = (secondsLeft % 3600) / 60
//            second = (secondsLeft % 3600) % 60
            
//            day = ( secondsLeft / 3600) / 24
//            if(day > 0){
//                hour = (secondsLeft / 3600) % (day * 24)
//            }
            
            //let timeStr = "\(minute):\(second)"
            
            let last2 = self.mobile.suffix(2)
            lbl_time.text = "OTP HAS SEND To: ********\(last2) \n SESSION WILL EXPIRED IN \(secondsLeft)sec"
            
            
            // days.text = String(format: "%02d", day)
            // minutes.text = String(format: "%02d", minute)
            // seconds.text = String(format: "%02d", second)
            // hours.text = String(format: "%02d", hour)
        }
        
    }
    override func onOkPressed(alert: UIAlertAction!)
    {
        if alertTag == 1
        {
            self.dismiss(animated: true, completion: {
                self.delegate?.sessionExpired()
            })
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
//    @IBAction func btn_resetotp_pressed(_ sender: UIButton)
//    {
//        let paraser = Parser()
//        paraser.delegate = self
//        paraser.callAPIGetOTP(mobileNumber: txt_mobile_no.text!, viewcontroller: self)
//    }
    
    @IBAction func btn_cancel_pressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_verifyotp_pressed(_ sender: UIButton)
    {
        if txt_verify_otp.validate()
        {
            if action == ActionType.Redeemtion
            {
                self.dismiss(animated: true, completion: {
                    self.delegate?.didVeifyOtp(otp: self.txt_verify_otp.text!, action: self.action)
                })
            }
            else
            {
                let paraser = Parser()
                paraser.delegate = self
                paraser.callAPILoginByOTP(mobileNumber: self.mobile, otp: txt_verify_otp.text!, loginType: "External", viewcontroller: self, action: ActionType.SignIn)
            }
        }
        else
        {
            self.showAlert(msg: MessageAndError.enterOtp)
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

extension OtpPopupViewController: UITextFieldDelegate
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

extension OtpPopupViewController//:ParserDelegate
{
    func didRecivedVerifiedOTPStatus(status: Bool)
    {
        if status
        {
            
            self.dismiss(animated: true, completion: {
                self.delegate?.didVeifyOtp(otp: self.txt_verify_otp.text!, action: self.action)
            })
        }
        else
        {
            txt_verify_otp.text = ""
            self.showAlert(msg: MessageAndError.enterValidOtp)
           //exitAlert()
        }
        
    }
    
  
    func exitAlert()
    {
        let alert = UIAlertController(title: appName, message: "enterValidOtp".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "OK".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                      style: .default,
                                      handler: self.yesPressed)
        alert.addAction(actionYes)
    
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func yesPressed(alert: UIAlertAction!)
    {
        self.dismiss(animated: true, completion: {
            self.delegate?.sessionExpired()
        })
        
    }
}
