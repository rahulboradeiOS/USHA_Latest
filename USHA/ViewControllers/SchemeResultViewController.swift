//
//  SchemeResultViewController.swift
 
//
//  Created by Apple.Inc on 18/08/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
class SchemeResultViewController: BaseViewController
{
    
    @IBOutlet weak var lbl_ssbSchemeResult: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var lbl_netPoints: UILabel!
    @IBOutlet weak var lbl_noteText: UILabel!
   
    @IBOutlet weak var btn_download: UIButton!
    
    @IBOutlet weak var btn_ok: UIButton!
    
    var alertTag = 0
    var action:String = ""
    let schemeResultCity = ["AHMEDABAD".lowercased(), "SURAT".lowercased(), "RAJKOT".lowercased(), "VADODRA".lowercased()]

    var noteText = ""
    var netPointMsg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //btn_download.isHidden = true
        
        lbl_netPoints.text = netPointMsg
        lbl_noteText.text = noteText
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
      
//        if(Connectivity.isConnectedToInternet())
//        {
//            GetschemeDetailsByMobile()
//        }
//        else
//        {
//            alertTag = 1
//            showAlert(msg: MessageAndError.noInternetConnection_SyncNotification)
//        }
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 8
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
    
    override func onBackButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func GetschemeDetailsByMobile()
    {
        let parameters:Parameters = [Key.MobileNo: DataProvider.sharedInstance.userDetails.s_MobileNo!,
                                     Key.ActionType: ActionType.GetSchemeDetails,
                                     Key.RuleCode:"RUL0162"]
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.GetschemeDetailsByMobile, parameters: parameters, viewcontroller: self, actionType: API.GetschemeDetailsByMobile)
        
//        let parameters:Parameters = [Key.ActionType : ActionType.GetRuleDetails]
//        let parser = Parser()
//        parser.delegate = self
//        parser.callAPI(api: API.GetschemeDetailsByMobile, parameters: parameters, viewcontroller: self, actionType: API.GetschemeDetailsByMobile)
    }
    
    @IBAction func btn_ok_pressed(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_download(_ sender: UIButton) {
        
        if (Connectivity.isConnectedToInternet())
        {
            if let url = URL(string: scheme_result_url)
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
            showAlert(msg: "noInternetConnection_SCEHEMERESULT_DOWNLOAD".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onOkPressed(alert: UIAlertAction!)
    {
        if alertTag == 1
        {
            self.dismiss(animated: true, completion: nil)
            //self.navigationController?.popViewController(animated: true)
        }
    }
}

extension SchemeResultViewController
{
    func didRecivedGetschemeDetailsByMobile(responseData:[[String:Any]])
    {
        if(action == ActionType.GetRuleDetails)
        {
            action = ActionType.GetSchemeDetails
            let RuleCodeDic = responseData[0]
            let RuleCode = RuleCodeDic[Key.RuleCode]
            
//            let parameters:Parameters = [Key.MobileNo: "8800206904", Key.ActionType: ActionType.GetSchemeDetails, Key.RuleCode:"RUL0160"]
            let parameters:Parameters = [Key.MobileNo: DataProvider.sharedInstance.userDetails.s_MobileNo!, Key.ActionType: ActionType.GetSchemeDetails, Key.RuleCode:"RUL0062"]

            let parser = Parser()
            parser.delegate = self
            parser.callAPI(api: API.GetschemeDetailsByMobile, parameters: parameters, viewcontroller: self, actionType: API.GetschemeDetailsByMobile)
        }
        else
        {
            if(responseData.count > 0)
            {
                btn_download.isHidden = false
                if  let NetPoints = responseData[0]["Net_Sampark_Point_Under_SSB_Scheme"] as? Double,
                    let BranchName = responseData[0]["BranchName"] as? String
                {
                    var msg = ""
                    var eligibility:Double = 0.0
                    if(schemeResultCity.contains(BranchName.lowercased()))
                    {
                        eligibility = 1000.00
                    }
                    else
                    {
                        eligibility = 1500.00
                    }
                    
                    if(NetPoints > eligibility)
                    {
                        msg = "Your Net Points Under SSB Scheme after Redemption is – \(NetPoints)\n\nCongratulations!! You are now eligible for Sampark Travel Bonanza Scheme."
                        lbl_noteText.text = "(SCHEME QUALIFICATION IS SUBJECTED TO REDEMPTION UNDER THE SCHEME PERIOD 1st jul'18 to 31st dec'18)".uppercased()
                    }
                    else
                    {
                        msg = "Your Net Points Under SSB Scheme after Redemption is \(NetPoints)\n\nAccumulate more points before 31st July'19 to qualify in Sampark Summer Bonanza Scheme."
                        lbl_noteText.text = ""
                    }
                    lbl_netPoints.text = msg.uppercased()
                }
            }
            else
            {
                alertTag = 1
                showAlert(msg: "schemeResultDataNotFound".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
        }
    }
}

