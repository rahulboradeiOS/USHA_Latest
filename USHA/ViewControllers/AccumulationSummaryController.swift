//
//  AccumulationSummaryController.swift
//  DemoApp
//
//  Created by omkar khandekar on 04/11/17.
//  Copyright © 2017 omkar khandekar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AccumulationSummaryController: BaseViewController
{
    var statusArray = [PinAccumulationStatus]()
    var optionArray   =  [Summary]()
    var pinList:String!
    
    var persistanceClass = DataProvider.sharedInstance
    
    let dateFormatter = DateFormatter()

    var sendMsg:String = ""
    var totalBonusPoints : Int = 0
    var totalAmount : Int = 0
    var totalPointsEarned: Int = 0
    var totalPins: Int = 0
    var totalSussPins: Int = 0
    var totalConsumePins: Int = 0
    var totalNotInSysPins: Int = 0
    var totalInterPins: Int = 0
    var totalNotPermitedPins: Int = 0
    var totalExpiredPins: Int = 0
    var totalHandlingCharges: Int = 0
    var dateTime:String!
    
    var balance:String!
    
    var attrs = [
        NSAttributedStringKey.font.rawValue : UIFont.systemFont(ofSize: 15.0),
        NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.9556024671, green: 0.1993225217, blue: 0.4539164305, alpha: 1),
        NSAttributedStringKey.underlineStyle : 1] as [AnyHashable : Any]
    
    var isEplusLogin : Bool = false
    var isFromPending : Bool = false

    @IBOutlet weak var btn_share: UIButton!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var summartTableView: UITableView!
    //Accumulation Date:
    @IBOutlet weak var lbl_accumulationDate: UILabel!
    
    @IBOutlet weak var btn_continue: UIButton!
    @IBOutlet weak var btn_home: UIButton!
    @IBOutlet weak var btn_sendsms: UIButton!
   // @IBOutlet weak var btn_sendsms_height: NSLayoutConstraint!
   // @IBOutlet weak var btn_sendsms_top: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_handling_bottom: NSLayoutConstraint!
    @IBOutlet weak var lbl_handling: UILabel!
    
    @IBOutlet weak var lbl_userBalance: UILabel!

    @IBOutlet weak var btn_view: UIButton!
    
    @IBOutlet weak var lbl_accumilationAction: UILabel!
    
    @IBOutlet weak var lbl_NoteAccS: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         LanguageChanged(strLan:keyLang)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        persistanceClass.myOrientation = .portrait
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey:"orientation")
        
        //setBackButton(target: self, selector: #selector(self.onBackButtonPressed(_:)))

//        if let name = persistanceClass.dealerDetails?.Username
//        {
//            self.title = "User:-\(name)"
//        }
        
        //lbl_handling.text = "Total Handling Charges against successful pins are \(totalHandlingCharges) points".uppercased()
        
        if let UserCurrentBalance =  persistanceClass.userDetails?.d_Balance
        {
            currentBalanceLabel.text = "Current Balance: " + "\(UserCurrentBalance)"
            balance = "\(UserCurrentBalance)"
        }
        
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        dateTime = dateFormatter.string(from: Date())
       // lbl_accumulationDate.text =  "Accumulation Date: " + "\(dateTime!)"

        let font = UIFont.boldSystemFont(ofSize: 14)
        let dateStr =  "ACCUMULATION DATE: " + "\(dateTime!)"
        lbl_accumulationDate.attributedText =  NSMutableAttributedString(string:dateStr , attributes:[.font : font, .underlineStyle: NSUnderlineStyle.styleDouble.rawValue, .foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])

        print(statusArray)
        if statusArray.count > 0
        {
            let t_status = statusArray[0]
            let tIdStr = "TRANSACTION ID : " + "\(t_status.TransNo)"
            lbl_userBalance.attributedText = NSMutableAttributedString(string:tIdStr , attributes:[.font : font, .underlineStyle: NSUnderlineStyle.styleDouble.rawValue, .foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        }
        else
        {
            lbl_userBalance.isHidden = true
        }
     
        //let bundle = Bundle(for: AccumulationSummaryTableViewCell.self)
        self.summartTableView.register(UINib(nibName: "AccumulationSummaryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        if isEplusLogin
        {
//            btn_continue.setTitle("HOME", for: .normal)
//            btn_home.setTitle("SEND SMS", for: .normal)
//            btn_sendsms.isHidden = true
//            btn_sendsms_top.constant = 0
//            btn_sendsms_height.constant = 0
            lbl_handling.text = "Total Handling Charges against successful pins are \(totalHandlingCharges) points".uppercased()
        }
        else
        {
            lbl_handling.text = "NOTE:- CLICK ACCUMULATION STATUS TO GET PINWISE DETAILS";
            lbl_handling_bottom.constant = 0
        }
        
        //addLeftBarButtonWith(title: "Back", target: self, selector: #selector(btn_backPressed(_:)))

        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(btn_backPressed(_:)))

        btn_sendsms.layer.cornerRadius = 15
        btn_sendsms.layer.masksToBounds = true
    }
    func LanguageChanged(strLan:String){
        lbl_accumilationAction.text = "ACCUMULATION STATUS".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
     //   lbl_accumulationDate.text = "ACCUMULATION DATE:".localizableString(loc:
       //     UserDefaults.standard.string(forKey: "keyLang")!)  + "\(dateTime!)"
       // lbl_userBalance.text = "TRANSACTION ID:".localizableString(loc:
           // UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_NoteAccS.text = "Note:pinStatus".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
        //btn_continue.setTitle("continue".localizableString(loc:
            //UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
        btn_sendsms.setTitle("sendsms".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
   
    }
    override func onHomeButtonPressed(_ sender: UIButton) {
        if isFromPending
        {
            displayAlert(type: "H")
            return
        }
        displayAlert(type: "C")
    }
    
    @IBAction func onBackBttnPressed(_ sender: UIButton) {
        if isFromPending
        {
            displayAlert(type: "H")
            return
        }
        displayAlert(type: "C")
    }
    
    override func onBellButtonPressed(_ sender: UIButton) {
        if isFromPending
        {
            displayAlert(type: "H")
            return
        }
        displayAlert(type: "C")
    }
    
    func addLeftBarButtonWith(title: String, target: AnyObject, selector: Selector)
    {
        let customBarItem : UIBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        self.navigationItem.leftBarButtonItem = customBarItem;
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    func btn_backPressed(_ sender : UIButton)
    {
       displayAlert(type: "C")
    }

    func GetPinDetailSummeryMob(ActionType: String, PinDetail:String)
    {
        let parameters:Parameters = [Key.ActionType : ActionType,  Key.PinDetail : PinDetail]
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.GetPinDetailSummeryMob, parameters: parameters, viewcontroller: self, actionType: API.GetPinDetailSummeryMob)
    }
    
    @IBAction func btn_view_pressed(_ sender: UIButton)
    {
        let t_status = statusArray[0]
        GetPinDetailSummeryMob(ActionType: ActionType.GetPinDetailsByTranNo, PinDetail: t_status.TransNo)
    }
    
    @IBAction func btn_sharePressed(_ sender: UIButton)
    {
        print("totalBonusPoints = \(totalBonusPoints)")
        
     
        if(totalBonusPoints > 0)
        {
            sendMsg = "Accumulation Status  \(dateTime!) Pins: \(pinList!). Total points Earned: \(totalPointsEarned) ( \(totalAmount) bonuspoints \(totalBonusPoints) )  Points Balance: \(balance!)  Total Coupons: \(totalPins)  Successful: \(totalSussPins)  Already Consumed: \(totalConsumePins)  Not in Sys: \(totalNotInSysPins)  Interchange Pin: \(totalInterPins)  Expired pins: \(totalExpiredPins)  Not Permitted as Distribution: \(totalNotPermitedPins)"
        }
        else
        {
            sendMsg = "Accumulation Status  \(dateTime!) Pins: \(pinList!). Total points Earned: \(totalPointsEarned)  Points Balance: \(balance!)   Total Coupons: \(totalPins)  Successful: \(totalSussPins)  Already Consumed: \(totalConsumePins)  Not in Sys: \(totalNotInSysPins)  Interchange Pin: \(totalInterPins)  Expired pins: \(totalExpiredPins)  Not  Permitted as Distribution:   \(totalNotPermitedPins)"
        }
        
        
        
        
        // image to share
        if let image = UIApplication.shared.screenShot
        {
            // set up activity view controller
            //let imageToShare = [image, sendMsg]
            
            let myDate = Date().string(format: "E, d MMM yyyy HH:mm:ss Z") // Sat, 21 Oct 2017 03:31:40 +0000

            let activityViewController = UIActivityViewController(activityItems: [myDate, image], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func btn_continuePressed(_ sender: UIButton)
    {
        displayAlert(type: "C")
    }
    
    @IBAction func btn_HomePressed(_ sender: UIButton)
    {
        displayAlert(type: "H")
    }
    
    @IBAction func btn_sendSMSPressed(_ sender: UIButton)
    {
        print("totalBonusPoints = \(totalBonusPoints)")

        let t_status = statusArray[0]

        if isEplusLogin
        {
//            if(totalBonusPoints > 0)
//            {
//
//                sendMsg = "Accumulation Status -\(dateTime!), Total points Earned: \(totalPointsEarned) (\(totalAmount)+\(totalBonusPoints) Bonus Points + \(totalHandlingCharges) Handling Charges), Scheme Balance \(persistanceClass.selectedScehme.d_Balance!) Points(Total Balance: \(balance!) Points), Total Coupons: \(totalPins), Successful: \(totalSussPins),  Already Consumed: \(totalConsumePins),  Unsuccesful Pin: \(totalNotInSysPins)  Other Scheme Pin: \(totalInterPins),  Not Permitted as Distribution Product Pin: \(totalNotPermitedPins). Check Unscusseful Pin Status through WEB/App. for Transaction ID \(t_status.TransNo)";
//
//
//            }
//            else
//            {
//
//                sendMsg = "Accumulation Status -\(dateTime!), Total points Earned: \(totalPointsEarned), Scheme Balance \(persistanceClass.selectedScehme.d_Balance!) Points(Total Balance: \(balance!) Points), Total Coupons: \(totalPins), Successful: \(totalSussPins),  Already Consumed: \(totalConsumePins),  Unsuccesful Pin: \(totalNotInSysPins)  Other Scheme Pin: \(totalInterPins),  Not Permitted as Distribution Product Pin: \(totalNotPermitedPins). Check Unscusseful Pin Status through WEB/App. for Transaction ID \(t_status.TransNo)";
//
//            }Accumulation Status {p1} Total Points Earned {p2} Total Balance:{p3} Points, Total Coupon {p4} ,Successful:{p5}, Already Consumed:{p6}, Unsuccessful Pin:{p7}. for TRANSACTION ID:{p8}

            //MARK: UPDATED NEW MSG - 1 JULY 2021 - R
            sendMsg = "Accumulation Status \(dateTime!) Total Points Earned \(totalPointsEarned) Total Balance:\(balance!) Points, Total Coupon \(totalPins) ,Successful:\(totalSussPins), Already Consumed:\(totalConsumePins), Unsuccessful Pin:\(totalNotInSysPins). for TRANSACTION ID:\(t_status.TransNo)"
            
            sendSMS(msg: sendMsg)
        }
        else
        {
//            Accumulation Status SAMPARK Scheme(App.)-5/2/2018 11:48:36 AM, Total Points Earned:85(80+5 Bonus Points), Scheme Balance 200 Points(Total Balance 632.00 Points), Total Coupon :2, Successful :1,Already Consumed : 0, Unsuccesful Pin :1, Other Scheme Pin :0,Period Laps for EPLUS Scheme :0,Not Permitted as Distribution Product Pin : 0. Check Unscusseful Pin Status through WEB/App. for Transaction ID ACCM00001738

//            if(totalBonusPoints > 0)
//            {
//                //sendMsg = "Accumulation Status  \(dateTime!)  Total points Earned: \(totalPointsEarned) ( \(totalAmount) bonuspoints \(totalBonusPoints) )  Points Balance: \(balance!)  Total Coupons: \(totalPins)  Successful: \(totalSussPins)  Already Consumed: \(totalConsumePins)  Not in Sys: \(totalNotInSysPins)  Interchange Pin: \(totalInterPins)  Expired pins: \(totalExpiredPins)  Not Permitted as Distribution: \(totalNotPermitedPins)";
//
//                sendMsg = "Accumulation Status -\(dateTime!), Total points Earned: \(totalPointsEarned) (\(totalAmount)+\(totalBonusPoints) Bonus Points), Scheme Balance \(persistanceClass.selectedScehme.d_Balance!) Points(Total Balance: \(balance!) Points), Total Coupons: \(totalPins), Successful: \(totalSussPins),  Already Consumed: \(totalConsumePins),  Unsuccesful Pin: \(totalNotInSysPins)  Other Scheme Pin: \(totalInterPins), Not Permitted as Distribution Product Pin: \(totalNotPermitedPins). Check Unscusseful Pin Status through WEB/App. for Transaction ID \(t_status.TransNo)";
//            }
//            else
//            {
//               // sendMsg = "Accumulation Status  \(dateTime!)  Total points Earned: \(totalPointsEarned)  Points Balance: \(balance!)   Total Coupons: \(totalPins)  Successful: \(totalSussPins)  Already Consumed: \(totalConsumePins)  Not in Sys: \(totalNotInSysPins)  Interchange Pin: \(totalInterPins)  Expired pins: \(totalExpiredPins)  Not  Permitted as Distribution:   \(totalNotPermitedPins)"
//
//                sendMsg = "Accumulation Status -\(dateTime!), Total points Earned: \(totalPointsEarned), Scheme Balance \(persistanceClass.selectedScehme.d_Balance!) Points(Total Balance: \(balance!) Points), Total Coupons: \(totalPins), Successful: \(totalSussPins),  Already Consumed: \(totalConsumePins),  Unsuccesful Pin: \(totalNotInSysPins)  Other Scheme Pin: \(totalInterPins),  Not Permitted as Distribution Product Pin: \(totalNotPermitedPins). Check Unscusseful Pin Status through WEB/App. for Transaction ID \(t_status.TransNo)";
//            }
            
            //MARK: UPDATED NEW MSG - 1 JULY 2021 - R
            sendMsg = "Accumulation Status \(dateTime!) Total Points Earned \(totalPointsEarned) Total Balance:\(balance!) Points, Total Coupon \(totalPins) ,Successful:\(totalSussPins), Already Consumed:\(totalConsumePins), Unsuccessful Pin:\(totalNotInSysPins). for TRANSACTION ID:\(t_status.TransNo)"
            
            sendSMS(msg: sendMsg)
        }
    }
    
    func sendSMS(msg:String)
    {
        let completeUrl = baseUrl + "Common/SendSMSACL"

        let schemeCode = staticSchemeCode
        
        var parameters: Parameters = [
            "message":msg,
            "MsgType":"SMS",
            "MsgContentType":"Accumulation",
            "SchemeCode":"\(staticSchemeCode)",
            "Source": Source
            ]

        if isEplusLogin
        {
            guard let mobileNumber = persistanceClass.userDetails.s_MobileNo else {
                return
            }
            parameters["mobileNumber"] = mobileNumber
        }
        else
        {
            guard let mobileNumber = persistanceClass.userDetails.s_MobileNo else {
                return
            }
            parameters["mobileNumber"] = mobileNumber
        }
//        let parameters: Parameters = [
//            "MobileNumber":userName,
//            "Message":msg,
//            ]
        
        self.view.makeToastActivity(message: "Processing...")
        Alamofire.request(completeUrl, method : .post, parameters : parameters, encoding : JSONEncoding.default , headers : headers).responseData {  response in
                self.view.hideToastActivity()
                switch response.result {
                case .success:
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
                    self.view.makeToast(message: error.localizedDescription)
                }
            } .responseJSON { [weak self ] (response) in
                
                if let json = response.result.value as? [String:AnyObject] {
                    
                    if let ResponseCode = json["ResponseCode"] as? String {
                        
                        if ResponseCode == "00" {
                            if let dataString = json["ResponseData"] as? String {
                                print(dataString)
                                self?.view.makeToast(message: "Send successfully")
                            }
                        }
                    else
                    {
                        self?.view.makeToast(message: "SMS Send Failed.")
                    }
                        
                    }
                    
                    print("JSON: \(json)") // serialized json response
                }
        }
    }

//    func parseSummaryOptions() {
//        
//        let option1 = Summary(title: "Total Pins Scaned", value: "1")
//        let option2 = Summary(title: "Total Pins Scaned", value: "1")
//        
//        optionArray.append(contentsOf: [option1,option2])
//    }

    func displayAlert(type:String)
    {
        let window :UIWindow = UIApplication.shared.keyWindow!

        let popup : MTPopUp  = MTPopUp(frame: (window.bounds))
        popup.viewManualHide = true
        popup.show(view: window, animationType: MTAnimation.ZoomIn_ZoomOut, strMessage:"sendSMS".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!) , btnArray: ["No","YES"], strTitle: "", themeColor: ColorConstants.Navigation_Color, buttonTextColor: UIColor.white, titleTextColor: UIColor.white, msgTextColor:UIColor.black, textAlignment: .left,complete: { (index) in
            print("INDEX : \(index)")
            if (index == 2)
            {
                if (type == "C")
                {
                   self.navigationController?.popViewController(animated: true)
                }
                else
                {
//                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers
//                        for aViewController in (viewControllers).reversed()
//                        {
//                        if aViewController is OptionViewController {
//                            self.navigationController!.popToViewController(aViewController, animated: true)
//                            return
//                        }
//                    }
//                    if self.isEplusLogin
//                    {
//                        // Get the previous Controller.
//                        let targetController: UIViewController = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 3]
//                        // And go to that Controller
//                        self.navigationController?.popToViewController(targetController, animated: true)
//                    }
//                    else
//                    {
                        self.navigationController?.popToRootViewController(animated: true)
//                    }
                }
            }
        })
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

extension AccumulationSummaryController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? AccumulationSummaryTableViewCell
        {
            cell.selectionStyle = .none
            let currentOption = optionArray[indexPath.row]
            cell.titleLabel.text = currentOption.summaryTitle.uppercased()
            let value = currentOption.summaryValue
            let status = currentOption.summaryStatus
            
            print("\(currentOption.summaryTitle) \(currentOption.summaryValue) \(currentOption.summaryStatus)")
            cell.optionButton.tag = indexPath.row
//            if indexPath.row == 0 || indexPath.row == 1
//            {
//                cell.optionButton.setTitle(currentOption.summaryValue, for: .normal)
//            }
//            else
//            {
            let buttonTitleStr = NSMutableAttributedString(string:currentOption.summaryValue, attributes:[.underlineStyle: NSUnderlineStyle.styleDouble.rawValue, .foregroundColor: #colorLiteral(red: 0.9450980392, green: 0.168627451, blue: 0.2274509804, alpha: 1)])
                cell.optionButton.setAttributedTitle(buttonTitleStr, for: .normal)
//            }
            cell.optionButton.addTarget(self, action: #selector(self.optionButtonPressed(sender:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0 || indexPath.row == 1
        {
            return
        }
        let currentOption = optionArray[indexPath.row]
        if Int(currentOption.summaryValue) == 0
        {
            self.view.makeToast(message: "Empty")
            return
        }
        if(currentOption.summaryStatus == "NOT IN SYSTEM")
        {
            if(Connectivity.isConnectedToInternet())
            {
              
                pushAccumulationSummaryDetailController(statusArray: statusArray, status:currentOption.summaryStatus)
            }
            else
            {
                showAlert(msg: "noInternetConnection_ViewNotInSystem".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
        }
        else
        {
            pushAccumulationSummaryDetailController(statusArray: statusArray, status:currentOption.summaryStatus)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }

    @objc func optionButtonPressed(sender: UIButton!)
    {
        if sender.tag == 0 || sender.tag == 1
        {
            return
        }
        let currentOption = optionArray[sender.tag]
        if Int(currentOption.summaryValue) == 0
        {
            self.view.makeToast(message: "Empty")
            return
        }
        
        if(currentOption.summaryStatus == "NOT IN SYSTEM")
        {
            if(Connectivity.isConnectedToInternet())
            {
                pushAccumulationSummaryDetailController(statusArray: statusArray, status:currentOption.summaryStatus)
            }
            else
            {
                showAlert(msg: "noInternetConnection_ViewNotInSystem".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
        }
        else
        {
            pushAccumulationSummaryDetailController(statusArray: statusArray, status:currentOption.summaryStatus)
        }
    }
    
    func pushAccumulationSummaryDetailController(statusArray : [PinAccumulationStatus], status:String)
    {
        //let bundle = Bundle(for: AccumulationSummaryDetailViewController.self)
        let controller = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.AccumulationSummaryDetailViewController) as! AccumulationSummaryDetailViewController
        //let controller = AccumulationSummaryDetailViewController(nibName: "AccumulationSummaryDetailViewController", bundle: nil)
        controller.statusArray.append(contentsOf: statusArray)
        controller.status = status
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension AccumulationSummaryController
{
    func didRecivedRespoance(api: String, parser: Parser, json: Any)
    {
        
    }
    
    func didRecivedGetPinDetailSummeryMob(responseData:[[String:Any]])
    {
        let balanceAlert = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotInSystemTransactionPopup) as! NotInSystemTransactionPopup
        balanceAlert.providesPresentationContextTransitionStyle = true
        balanceAlert.definesPresentationContext = true
        balanceAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        balanceAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        for item in responseData
        {
            let  s_PIN = item[Key.s_PIN] as? String
            let  s_Status = item[Key.s_Status] as? String
            let dic = ["key": s_PIN!, "value":s_Status!]
            balanceAlert.arrKeyValue.append(dic)
        }
        
        self.present(balanceAlert, animated: true, completion: nil)
        
        balanceAlert.lbl_coloum1.text = "PIN_NO"
        balanceAlert.lbl_coloum2.text = "PIN_STATUS"
        balanceAlert.lbl_header.text = ""
    }
}


extension UIApplication {
    
    var screenShot: UIImage?  {
        
        if let rootViewController = keyWindow?.rootViewController {
            let scale = UIScreen.main.scale
            let bounds = rootViewController.view.bounds
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale);
            if let _ = UIGraphicsGetCurrentContext() {
                rootViewController.view.drawHierarchy(in: bounds, afterScreenUpdates: true)
                let screenshot = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return screenshot
            }
        }
        return nil
    }
}


extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
