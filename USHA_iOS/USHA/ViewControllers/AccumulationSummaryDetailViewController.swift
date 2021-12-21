//
//  AccumulationSummaryDetailViewController.swift
//  DemoApp
//
//  Created by New on 19/11/17.
//  Copyright © 2017 omkar khandekar. All rights reserved.
//

import UIKit
import Alamofire

class AccumulationSummaryDetailViewController: BaseViewController
{

    @IBOutlet weak var btn_share: UIButton!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var summartTableView: UITableView!
    //Mobile No:
    @IBOutlet weak var lbl_mobNo: UILabel!
    //User Balance:
    @IBOutlet weak var lbl_userBalance: UILabel!
    //Accumulation Date:
    @IBOutlet weak var lbl_accumulationDate: UILabel!
    @IBOutlet weak var lbl_accumilationAction: UILabel!
    
    @IBOutlet weak var btn_viewSummery: UIButton!
    @IBOutlet weak var btn_view: UIButton!
    
    var statusArray = [PinAccumulationStatus]()
    var fliterArray   =  [PinAccumulationStatus]()
    var myPinArray : [String] = []
    var myStatusArray : [String] = []
    var myFinalArray = [(pin: String, status: String)]()
    var isFromPending : Bool = false

    var persistanceClass = DataProvider.sharedInstance

    //var appdelegate = UIApplication.shared.delegate as! AppDelegate
    let dateFormatter = DateFormatter()
    var dateTime:String!
    var status:String!
    
    var viewTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setBackButton(target: self, selector: #selector(self.onBackButtonPressed(_:)))
        if let name = persistanceClass.userDetails?.s_MobileNo
        {
            //self.title = "User:-\(name)"
          //  lbl_mobNo.text = "Mobile No: " + name
        }
        
        if let UserCurrentBalance =  persistanceClass.userDetails.d_Balance
        {
            currentBalanceLabel.text = "Current Balance: " + "\(UserCurrentBalance)"
        }
        
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        self.dateTime = dateFormatter.string(from: Date())
        
        let dateStr =  "ACCUMULATION DATE: " + "\(self.dateTime!)"
        let font = UIFont.boldSystemFont(ofSize: 14)

        lbl_accumulationDate.attributedText =  NSMutableAttributedString(string:dateStr , attributes:[.font : font, .underlineStyle: NSUnderlineStyle.styleDouble.rawValue, .foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])

        //btn_view.isHidden = true
        if (status != nil || status != "")
        {
            fliterArray = AccumulationViewController.getFilteredSummary(statusArray: statusArray, status: status)
            if fliterArray.count > 0
            {
                let t_status = fliterArray[0]
                let tIdStr = "TRANSACTION ID : " + "\(t_status.TransNo)"
                lbl_userBalance.attributedText = NSMutableAttributedString(string:tIdStr , attributes:[.font : font, .underlineStyle: NSUnderlineStyle.styleDouble.rawValue, .foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
                if (t_status.status == "NOT IN SYSTEM")
                {
                    viewTag = 0
                    GetPinDetailSummeryMob(ActionType: ActionType.GetPinDetailsByTranNo, PinDetail: t_status.TransNo)
                }
            }
        }
        
        let bundle = Bundle(for: AccumulationSummaryDetailTableViewCell.self)
        self.summartTableView.register(UINib(nibName: "AccumulationSummaryDetailTableViewCell", bundle: bundle), forCellReuseIdentifier: "cell")
        
        //addLeftBarButtonWith(title: "Back", target: self, selector: #selector(btn_backPressed(_:)))

        //addLeftBarButtonWith(title: "Logout", target: self, selector: #selector(btn_logoutClick(_:)))
        
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(btn_backPressed(_:)))

        // Do any additional setup after loading the view.
        
        btn_viewSummery.layer.cornerRadius = 21
        btn_viewSummery.layer.masksToBounds = true
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LanguageChanged(strLan:keyLang)
    }
    func LanguageChanged(strLan:String){
        lbl_accumilationAction.text = "PINWISE SUMMARY".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
        //lbl_accumulationDate.text = "ACCUMULATION DATE :".localizableString(loc:
       //     UserDefaults.standard.string(forKey: "keyLang")!) + "\(self.dateTime!)"
       // lbl_userBalance.text = "TRANSACTION ID:".localizableString(loc:
          //  UserDefaults.standard.string(forKey: "keyLang")!)
        btn_viewSummery.setTitle("continue".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
      
        
    }
   
    override func onHomeButtonPressed(_ sender: UIButton) {
       exitAlert1()
    }

    @IBAction func onBackBttnPressed(_ sender: UIButton) {
        exitAlert2()
    }
    
    override func onBellButtonPressed(_ sender: UIButton) {
       exitAlert3()
    }
  
    func exitAlert1()
    {
        let alert = UIAlertController(title: "", message: "sendSMS".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "YES".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                      style: .default,
                                      handler: self.yesPressed)
        alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "NO".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                     style: .destructive,
                                     handler: self.noPressed)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func yesPressed(alert: UIAlertAction!)
    {
        self.navigationController?.popToRootViewController(animated: true)

    }
    
    @objc func noPressed(alert: UIAlertAction!)
    {
        
    }
    
    func exitAlert2()
    {
        let alert = UIAlertController(title: "", message: "sendSMS".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "YES".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                      style: .default,
                                      handler: self.yesPressed2)
        alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "NO".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                     style: .destructive,
                                     handler: self.noPressed2)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func yesPressed2(alert: UIAlertAction!)
    {
       self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func noPressed2(alert: UIAlertAction!)
    {
        
    }
    
    func exitAlert3()
    {
        let alert = UIAlertController(title: "", message: "sendSMS".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "YES".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                      style: .default,
                                      handler: self.yesPressed3)
        alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "NO".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                     style: .destructive,
                                     handler: self.noPressed3)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func yesPressed3(alert: UIAlertAction!)
    {
        let notificationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationViewController) as! NotificationViewController
        self.navigationController?.pushViewController(notificationVC, animated: true)    }
    
    @objc func noPressed3(alert: UIAlertAction!)
    {
        
    }
    
//    override func onHomeButtonPressed(_ sender: UIButton) {
//
//
//        displayAlert(type: "C")
//    }
//
//    override func onBackButtonPressed(_ sender: UIButton) {
//
//        displayAlert(type: "C")
//    }
//
//    override func onBellButtonPressed(_ sender: UIButton) {
//
//        displayAlert(type: "C")
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
    
    func addLeftBarButtonWith(title: String, target: AnyObject, selector: Selector)
    {
        let customBarItem : UIBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        self.navigationItem.leftBarButtonItem = customBarItem;
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    func btn_backPressed(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
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
        // image to share
        
        var myString : String = ""
        
        for index in fliterArray{
            
            print("\n\(index.Pin) \t"    +    "\(index.status)")
            
            myString  = myString + "\n\(index.Pin) \t\t"    +    "\(index.status)"
        }
        
        let text3 = "     PIN    \t\t"   +  "                STATUS \n \(myString))"
        print("\(text3)")
        
      
         let text1 = "\(lbl_userBalance.text!) \n" + "\(lbl_accumulationDate.text!)\n\n" + "\(text3)"
      
        let shareAll = [text1] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)

    }
    
    @IBAction func btn_viewSummaryPressed(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
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
extension AccumulationSummaryDetailViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fliterArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        headerView.backgroundColor = .white
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AccumulationSummaryDetailTableViewCell
        headerCell.lbl_pin.text = "PIN"
        headerCell.lbl_pin.textAlignment = .center
        headerCell.lbl_amount.text = "POINTS"
        headerCell.lbl_status.text = "STATUS"
        headerView.addSubview(headerCell)
        headerCell.frame = headerView.frame
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? AccumulationSummaryDetailTableViewCell {
            cell.selectionStyle = .none
            let currentOption = fliterArray[indexPath.row]
            cell.lbl_pin.text = currentOption.Pin
            cell.lbl_amount.text = "\(currentOption.Amount)"
            cell.lbl_status.attributedText = NSMutableAttributedString(string:currentOption.status, attributes:[.underlineStyle: NSUnderlineStyle.styleDouble.rawValue, .foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
//                currentOption.status
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let currentOption = fliterArray[indexPath.row]

        if (currentOption.status == "NOT IN SYSTEM")
        {
            viewTag = 1
            GetPinDetailSummeryMob(ActionType: ActionType.GetPinDetailsByPinNo, PinDetail: currentOption.Pin)
        }
    }
    func optionButtonPressed(sender: UIButton?)
    {
        
    }
}

extension AccumulationSummaryDetailViewController
{
    func didRecivedRespoance(api: String, parser: Parser, json: Any)
    {
        
    }
    
    func didRecivedGetPinDetailSummeryMob(responseData:[[String:Any]])
    {
        if viewTag == 0
        {
            var arr = [PinAccumulationStatus]()
            for item in responseData
            {
                let status = PinAccumulationStatus()
                status.Amount = 0
                status.Pin = (item[Key.s_PIN] as? String)!
                status.status = ((item[Key.s_Status] as? String)?.uppercased())!
                arr.append(status)
            }
            fliterArray = arr
            summartTableView.reloadData()
        }
        else
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
}
