//
//  AccumulationViewController.swift
 
//
//  Created by Apple.Inc on 06/06/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import BarcodeScanner
import SQLite

let PindingTransactionTable = Table("PindingTransaction")
let PK_AccID = Expression<Int>("PK_AccID")
let RET_MobileNo = Expression<String>("RET_MobileNo")
let Pin = Expression<String>("Pin")
let SchemeName = Expression<String>("SchemeName")

class PinAccumulationStatus: NSObject
{
    var MobileNumber : String = ""
    var Pin : String = ""
    var Amount : Int = 0
    var status : String = ""
    var Bonuspoints : String = ""
    var HandlingCharges : String = ""
    var RetMobileNumber : String = ""
    var ELeMobileNumber : String = ""
    var TransNo : String = ""
}

class Summary: NSObject
{
    var summaryTitle = ""
    var summaryValue = ""
    var summaryStatus = ""
    
    init(title:String, value : String, status: String) {
        summaryTitle = title
        summaryValue = value
        summaryStatus = status
    }
}

class AccumulationViewController: BaseViewController
{
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var electricianTextField: UITextField!
    //@IBOutlet weak var textFieldHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var btnScan: UIButton!

    @IBOutlet weak var unknownButton: UIButton!
    @IBOutlet weak var knownButton: UIButton!
    @IBOutlet weak var txt_ePlus_mobileNo: UITextField!
    @IBOutlet weak var ePlusView_Height: NSLayoutConstraint!
    @IBOutlet weak var ePlusView: UIView!

    @IBOutlet weak var lbl_noOfPins: UILabel!
    
    @IBOutlet weak var btn_submitAcc: UIButton!
    @IBOutlet weak var lbl_orAccumilation: UILabel!
    @IBOutlet weak var lbl_Action: UILabel!
    @IBOutlet weak var lbl_pins: UILabel!
    var pinArray = [String]()
    var selectedPendingTransactionID = 0

    var persistanceClass = DataProvider.sharedInstance
    
    var statusArray = [PinAccumulationStatus]()
    var summary_Array = [Summary]()
    var keyLang:String = ""

    var isEplusLogin : Bool = false
    
    var totalBonusPoints : Int = 0
    var totalAmount : Int = 0
    var totalPointsEarned : Int = 0
    var totalPins: Int = 0
    var totalSussPins: Int = 0
    var totalConsumePins: Int = 0
    var totalNotInSysPins: Int = 0
    var totalInterPins: Int = 0
    var totalNotPermitedPins: Int = 0
    var totalExpiredPins: Int = 0
    var totalHandlingCharges : Int = 0
    
    var alertTag = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //menuItem()
        lbl_noOfPins.text = "NO. OF PINS SCANNED : 0"

        if staticSchemeName == "EPLUS"
        {
            isEplusLogin = true
        }
        
        if (isPendingTransaction())
        {
            if(isEplusLogin)
            {
                unknownButtonTapped(unknownButton)
//                knownButton.isSelected = false
//                unknownButton.isSelected = true
//                txt_ePlus_mobileNo.text = "1234567890"
//                txt_ePlus_mobileNo.isEnabled = false
            }
            else
            {
                ePlusView_Height.constant = 0
                ePlusView.isHidden = true
                pinTextField.isEnabled = true
                btnScan.isEnabled = true
            }
        }
        else
        {
            if isEplusLogin
            {
                ePlusView_Height.constant = 81
                ePlusView.isHidden = false
                pinTextField.isEnabled = false
                btnScan.isEnabled = false
                txt_ePlus_mobileNo.isEnabled = false
                txt_ePlus_mobileNo.delegate = self
                txt_ePlus_mobileNo.addTarget(self, action: #selector(ePlusTextFieldTextChanged(sender:)), for: UIControlEvents.editingChanged)
                knownButtonTapped(knownButton)
            }
            else
            {
                ePlusView_Height.constant = 0
                ePlusView.isHidden = true
                pinTextField.isEnabled = true
                btnScan.isEnabled = true
            }
        }
        
        
        let bundle = Bundle(for: SamparkTableViewCell.self)
        self.tableView.register(UINib(nibName: "SamparkTableViewCell", bundle: bundle), forCellReuseIdentifier: "cell")
        
        
        pinTextField.delegate = self
        
        pinTextField.addTarget(self, action: #selector(pingTextFieldTextChanged(sender:)), for: UIControlEvents.editingChanged)
       
        addReginTapGesture()
        
        btn_submitAcc.layer.cornerRadius = 20
        btn_submitAcc.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        LanguageChanged(strLan:keyLang)
        if let UserCurrentBalance =  persistanceClass.userDetails.d_Balance
        {
            currentBalanceLabel.text = "Current Balance: " + "\(UserCurrentBalance)"
        }
    }
    func LanguageChanged(strLan:String){
         lbl_noOfPins.text = "NO. OF PINS SCANNED".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
         lbl_Action.text = "Action".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
         lbl_pins.text = "Pins".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!)
         btn_submitAcc.setTitle("Submit".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
         btnScan.setTitle("SCAN".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
    }
    override func onHomeButtonPressed(_ sender: UIButton) {
        if pinArray.count == 0
        {
            //createMenuView()
            self.navigationController?.popToRootViewController(animated: true)

            //self.navigationController?.popViewController(animated: true)
            return
        }
        
        displayAlert(msg: "pendingPinsToAccumulate".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), btnArray: ["YES".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), "NO".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!)])
    }
    override func onBellButtonPressed(_ sender : UIButton)
    {
        if pinArray.count == 0
        {
            let notificationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationViewController) as! NotificationViewController
            self.navigationController?.pushViewController(notificationVC, animated: true)
        }else{
        
        displayAlert1(msg: "pendingPinsToAccumulate".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), btnArray: ["YES".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), "NO".localizableString(loc:
                       UserDefaults.standard.string(forKey: "keyLang")!)])
        }
        }
    
    @IBAction func onBackBttnPressed(_ sender: UIButton)
    {
        if pinArray.count == 0
        {
            //createMenuView()
            self.navigationController?.popToRootViewController(animated: true)

            //self.navigationController?.popViewController(animated: true)
            return
        }
        
        displayAlert(msg:"pendingPinsToAccumulate".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), btnArray: ["YES".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), "NO".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!)])
    }
    
    @IBAction func knownButtonTapped(_ sender: Any)
    {
//        if(unknownButton.isSelected)
//        {
//            return
//        }
        pinTextField.isEnabled = false
        btnScan.isEnabled = false
        knownButton.isSelected = true
        unknownButton.isSelected = false
        txt_ePlus_mobileNo.text = ""
        txt_ePlus_mobileNo.isEnabled = true
        txt_ePlus_mobileNo.becomeFirstResponder()
    }
    
    @IBAction func unknownButtonTapped(_ sender: Any)
    {
//        if(knownButton.isSelected)
//        {
//            return
//        }
        
        pinTextField.isEnabled = false
        btnScan.isEnabled = false
        knownButton.isSelected = false
        knownButton.isUserInteractionEnabled = false
        unknownButton.isSelected = true
        txt_ePlus_mobileNo.text = "1234567890"
        txt_ePlus_mobileNo.isEnabled = false
        
       
            if(Connectivity.isConnectedToInternet())
            {
                getUserCodeByMobileNo(mobile: txt_ePlus_mobileNo.text!, schemeCode: staticSchemeCode, actionType: ActionType.EPLUS)
            }
            else
            {
                let userDetail = UserDetails()
                userDetail.s_MobileNo = txt_ePlus_mobileNo.text
                persistanceClass.ePlusUserDetails = userDetail
                //showAlert(msg: MessageAndError.noInternetConnection)
                pinTextField.isEnabled = true
                btnScan.isEnabled = true
            }
        
    }
    
    @IBAction func btn_scanPressed(_ sender: UIButton)
    {
        Title.text = ""
        CloseButton.text = "Close"
        SettingsButton.text = "Setting"
        Info.settingsText = "In order to scan barcodes you have to allow camera under your settings."
        Info.loadingText = "Looking for your code..."
        Info.notFoundText = "Not found"
        Info.text = "Place the barcode within the window to scan."
        
        // comment the line in BarcodeScannerController (headerView.isHidden = !isBeingPresented)
        
        let controller = BarcodeScannerController()
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self
        controller.isOneTimeSearch = false
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any)
    {
        if isEplusLogin
        {
            if (txt_ePlus_mobileNo.text == "")
            {
                showAlert(msg:  "enterElectricalMobileNo".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
                return
            }
            else if ((txt_ePlus_mobileNo.text?.count)! < 10)
            {
                showAlert(msg: "enterValidElectricalMobileNo".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
                return
            }
        }
        
        if (pinArray.count == 0)
        {
            showAlert(msg: "enterPin".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
            return
        }
        if Connectivity.isConnectedToInternet()
        {
            // do some tasks..
            checkIMEI()
        }
        else
        {
            showAlert(msg: "savePendingTransaction".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
            alertTag = 1
            //self.view.makeToast(message: "No Internet! Accumlation save in Pnding Transaction")
        }
        //getAccumulation()
    }
    
    override func onOkPressed(alert: UIAlertAction!)
    {
        if alertTag == 1
        {
            if Connectivity.isConnectedToInternet()
            {
                checkIMEI()
            }
            else
            {
                saveAccumulation()
                //createMenuView()
                self.navigationController?.popToRootViewController(animated: true)

            }
        }
        else if alertTag == -1
        {
            removeAppSession()
            _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PasswordViewController)
        }
        else if alertTag == 2
        {
            //exit(0)
            removeAppSession()
            _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PasswordViewController)
        }
        else if alertTag == 3
        {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func isPendingTransaction() -> Bool
    {
        if let db = DataProvider.getDBConnection()
        {
            db.trace { (error) in
                print(error)
            }
            do {
                
                let scheme = staticSchemeName
                let alice = PindingTransactionTable.filter(SchemeName == scheme)
                
                for row in try db.prepare(alice)
                {
                    print("Pin = \(row[Pin])\nScheme = \(row[SchemeName])")
                    pinArray.append(row[Pin])
                }
                
                if(pinArray.count>0)
                {
                    lbl_noOfPins.text = "NO. OF PINS SCANNED : \(pinArray.count)"
                    tableView.reloadData()
                    return true
                }
                
            } catch  {
                print("error in DB")
            }
            return false
        }
        else
        {
            return false
        }
    }
    
    func saveAccumulation()
    {
        let retailerMobileNumber = persistanceClass.userDetails?.s_MobileNo ?? ""
        for pin in pinArray
        {
            let pendingTransaction = PendingTransaction()
            pendingTransaction.RET_MobileNo = retailerMobileNumber
            pendingTransaction.SchemeName = staticSchemeName
            pendingTransaction.Pin = pin
            savePindingTransacton(object: pendingTransaction)
        }
    }
    
    func savePindingTransacton(object :PendingTransaction)
    {
        guard let db = DataProvider.getDBConnection() else { print("DB Error in Accumulation save"); return}

        do
        {
            let itExists = try db.scalar(PindingTransactionTable.exists)
            if itExists {
                insert(item: object, database: db)
            }
            else
            {
                if(createTable(database: db))
                {
                    insert(item: object, database: db)
                }
                else
                {
                    print("Error to create pendingtable")
                }
            }
        } catch {
            print("Error in accumulation doesn't exit pendingtable")
            print(error)
            if(createTable(database: db))
            {
                insert(item: object, database: db)
            }
            else
            {
                print("Error to create pendintable")
            }
        }
    }
    
    func createTable(database:Connection) -> Bool
    {
        do
        {
            try database.run(PindingTransactionTable.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { t in
                t.column(PK_AccID, primaryKey: true)
                t.column(RET_MobileNo)
                t.column(Pin, unique: true)
                t.column(SchemeName)
            }))
            return true
        } catch {
            print("Error in pending table create")
            print(error)
            return false
        }
    }
    
    func insert(item:PendingTransaction, database:Connection)
    {
        let insert = PindingTransactionTable.insert(
            RET_MobileNo <- item.RET_MobileNo ?? "",
            Pin <- item.Pin ?? "",
            SchemeName <- item.SchemeName ?? ""
        )
        do
        {
            let rowid = try database.run(insert)
            print(rowid)
        } catch {
            print("Error in insert to pending table item")
            print(error)
        }
    }
    
    func delete(deletePin:String, scheme:String)
    {
        guard let db = DataProvider.getDBConnection() else { print("DB Error in Accumulation delete"); return}

        let alice = PindingTransactionTable.filter((Pin == deletePin) && (SchemeName == scheme))
        do {
            if try db.run(alice.delete()) > 0 {
                print("deleted alice")
            } else {
                print("alice not found")
            }
        } catch {
            print("delete failed: \(error)")
        }
    }
    
    func delete(scheme:String)
    {
        guard let db = DataProvider.getDBConnection() else { print("DB Error in Accumulation delete"); return}
        
        let alice = PindingTransactionTable.filter(SchemeName == scheme)
        do {
            if try db.run(alice.delete()) > 0 {
                print("deleted alice")
            } else {
                print("alice not found")
            }
        } catch {
            print("delete failed: \(error)")
        }
    }
    
    func pinAccumulation()
    {
       // guard let s_SchemePromCode = staticSchemeCode else { return }
        guard let s_CreatedBy = persistanceClass.userDetails?.s_CreatedBy else { return }
        let completeUrl = baseUrl + "Transction/Accumulation"
        var parameters: Parameters = [
            "Source": Source
            ]
        parameters["PINss"] = ""
        parameters["SchemePromCode"] = staticSchemeCode
        parameters["s_CreatedBy"] = s_CreatedBy //"EMP00060"
        parameters["s_FileCode"] = ""
        if isEplusLogin
        {
            guard let retailerMobileNumber = persistanceClass.userDetails?.s_MobileNo else { return }
            guard let eMobileNumber = persistanceClass.ePlusUserDetails?.s_MobileNo else { return }
            
            var pin_Array = [Any]()
            for item in pinArray
            {
                let vDic:Parameters = ["Pin":item]
                pin_Array.append(vDic)
            }
            
            parameters["MobileNo"] = eMobileNumber
            parameters["SupportMobileNo"] = retailerMobileNumber
            parameters["SchemePromName"] = staticSchemeName
            parameters["PinList"] = pin_Array
        }
        else
        {
            guard let retailerMobileNumber = persistanceClass.userDetails?.s_MobileNo else { return }
            var pin_Array = [Any]()
            for item in pinArray
            {
                let vDic:Parameters = ["Pin":item]
                pin_Array.append(vDic)
            }
            parameters["MobileNo"] = retailerMobileNumber
            parameters["PinList"] = pin_Array
            parameters["HiddenAction"] = ""
            parameters["ActionType"] = ""
            parameters["s_ModifyBy"] = ""
            parameters["SchemePromName"] = staticSchemeName
        }
        
        self.view.makeToastActivity(message: "Processing...")
        Alamofire.request(completeUrl, method : .post, parameters : parameters, encoding : JSONEncoding.default , headers : headers).responseData {  response in
            //self.view.hideToastActivity()
            switch response.result {
            case .success:
                print("Validation Successful")
            case .failure(let error):
                print(error)
                self.view.hideToastActivity()
                switch (response.error!._code){
                case NSURLErrorTimedOut:
                    //Manager your time out error
                    self.displayAlert(msg: error.localizedDescription, btnArray: ["OK".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!)])
                    break
                case NSURLErrorNotConnectedToInternet:
                    //Manager your not connected to internet error
                    self.saveAccumulation()
                    break
                default:
                    //manager your default case
                    self.displayAlert(msg: error.localizedDescription, btnArray: ["OK".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!)])
                }
                //self.view.makeToast(message: error.localizedDescription)
            }
            } .responseJSON { [weak self ] (response) in
                
                if let json = response.result.value as? [String:AnyObject] {
                    
                    if let ResponseCode = json["ResponseCode"] as? String {
                        
                        if ResponseCode == "00"
                        {
                            //let PindingTransaction = Table("PindingTransaction")
                            //DataProvider.dropTable(table: PindingTransactionTable)
                            
                            self?.delete(scheme: staticSchemeName)
                            
                            if let data = json["ResponseData"] as? String
                            {
                            if  let array = self?.parseAccumulationResponse(dataString: data)
                            {
                                self?.summary_Array = array
                                self?.view.hideToastActivity()
                            //    self?.pushAccumulationController(summaryArray: array)
                                self?.getBalanceByUserCode(userCode: (self?.persistanceClass.userDetails.s_UserCode!)!)
                            }
                            }
                            else
                            {
                                self?.showAlert(msg: "somethingWentWrong".localizableString(loc:
                                    UserDefaults.standard.string(forKey: "keyLang")!))
                            }
                            
                            
                            
//                            if (self?.isEplusLogin)!
//                            {
//                                guard let eMobileNumber = self?.persistanceClass.ePlusUserDetails?.s_MobileNo else { return }
//                                self?.getUserStatus(mobileNumber:eMobileNumber, schemeCode: schemeCode, UserType: "E", block: {[weak self ] () -> (Void) in
//
//                                    guard let retailerMobileNumber = self?.persistanceClass.userDetails?.s_MobileNo else { return }
//                                    self?.getUserStatus(mobileNumber:retailerMobileNumber, schemeCode: schemeCode, UserType: "R", block: {[weak self ] () -> (Void) in
//                                        if let data = json["ResponseData"] as? String
//                                        {
//                                            if  let array = self?.parseAccumulationResponse(dataString: data)
//                                            {
//                                                self?.view.hideToastActivity()
//                                                self?.pushAccumulationController(summaryArray: array)
//                                            }
//                                        }
//
//                                    })
//                                })
//                            }
//                            else
//                            {
//                                guard let retailerMobileNumber = self?.persistanceClass.userDetails?.s_MobileNo else { return }
//                                self?.getUserStatus(mobileNumber:retailerMobileNumber, schemeCode: schemeCode, UserType: "R", block: {[weak self ] () -> (Void) in
//                                    if let data = json["ResponseData"] as? String
//                                    {
//                                        if  let array = self?.parseAccumulationResponse(dataString: data)
//                                        {
//                                            self?.view.hideToastActivity()
//                                            self?.pushAccumulationController(summaryArray: array)
//                                        }
//                                    }
//                                })
//                            }
                        }
                        else
                        {
                            self?.view.hideToastActivity()
                            
                            if let responseMessage = json["ResponseMessage"] as? String
                            {
                                self?.alertTag = 3
                                self?.delete(scheme: staticSchemeName)

                                self?.showAlert(msg: responseMessage)
                                //let PindingTransaction = Table("PindingTransaction")
                                //DataProvider.dropTable(table: PindingTransactionTable)
                                //self?.displayAlert(msg: responseMessage, btnArray: ["OK"])
                            }
                            else
                            {
                                self?.alertTag = 3
                                self?.showAlert(msg: "somethingWentWrong".localizableString(loc:
                                    UserDefaults.standard.string(forKey: "keyLang")!))
                            }
                        }
                    }
                }
        }
    }
    
    func getBalanceByUserCode(userCode:String)
    {
        let parameters:Parameters = [Key.UserCode : userCode]
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.GetBalanceByUserCode, parameters: parameters, viewcontroller: self, actionType: API.GetBalanceByUserCode)
    }
    
    func getUserStatus(mobileNumber:String, schemeCode:String, UserType:String, block : @escaping () ->(Void))
    {
        let completeUrl = baseUrl + "Common/GetUserCodeByMobileNo" //"UserStatus"
        let parameters: Parameters = [
            "MobileNo":mobileNumber,
            "SchemeCode":schemeCode
        ]
        
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
                        
                        if ResponseCode == "00"
                        {
                            if let dataString = json["ResponseData"] as? String
                            {
                                if let dataFromString = dataString.data(using: .utf8, allowLossyConversion: false) {
                                    
                                    do {
                                        let json =  try JSON(data: dataFromString)
                                        
                                        for (key,subJson):(String, JSON) in json
                                        {
                                            if key == "d_Balance"
                                            {
                                                print(subJson)
                                                
                                                if UserType == "E" //isEplusLogin
                                                {
                                                    self?.persistanceClass.ePlusUserDetails?.d_Balance = subJson.doubleValue
                                                }
                                                else
                                                {
                                                    self?.persistanceClass.userDetails?.d_Balance = subJson.doubleValue
                                                }
                                                
                                                if (self?.persistanceClass.userDetails.d_Balance) != nil
                                                {
                                                    //self?.currentBalanceLabel.text = "Current Balance: " + "\(UserCurrentBalance)"
                                                }
                                            }
                                        }
                                        
                                    }catch {
                                        print("err")
                                    }
                                }
                            }
                        }
                        else
                        {
                            if let responseMessage = json["ResponseMessage"] as? String
                            {
                                self?.displayAlert(msg: responseMessage, btnArray: ["OK".localizableString(loc:
                                    UserDefaults.standard.string(forKey: "keyLang")!)])
                            }
                        }
                    }
                }
                block()
        }
    }
    
    func displayAlert(msg:String, btnArray:[String])
    {
        let window :UIWindow = UIApplication.shared.keyWindow!
        
        let popup : MTPopUp  = MTPopUp(frame: (window.bounds))
        popup.viewManualHide = true
        popup.show(view: window, animationType: MTAnimation.ZoomIn_ZoomOut, strMessage:msg, btnArray:btnArray as NSArray , strTitle: "", themeColor: ColorConstants.Navigation_Color, buttonTextColor: UIColor.white, titleTextColor: UIColor.white, msgTextColor:UIColor.black, textAlignment: .left,complete: { (index) in
            print("INDEX : \(index)")
            if (index == 2)
            {
                //createMenuView()
                self.navigationController?.popToRootViewController(animated: true)

                //self.navigationController?.popViewController(animated: true)
            }
        })
    }
    func displayAlert1(msg:String, btnArray:[String])
    {
        let window :UIWindow = UIApplication.shared.keyWindow!
        
        let popup : MTPopUp  = MTPopUp(frame: (window.bounds))
        popup.viewManualHide = true
        popup.show(view: window, animationType: MTAnimation.ZoomIn_ZoomOut, strMessage:msg, btnArray:btnArray as NSArray , strTitle: "", themeColor: ColorConstants.Navigation_Color, buttonTextColor: UIColor.white, titleTextColor: UIColor.white, msgTextColor:UIColor.black, textAlignment: .left,complete: { (index) in
            print("INDEX : \(index)")
            if (index == 2)
            {
                //createMenuView()
                let notificationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationViewController) as! NotificationViewController
                self.navigationController?.pushViewController(notificationVC, animated: true)
            
            }
        })
    }
    func pushAccumulationController(summaryArray : [Summary])
    {
        let PinList = pinArray.joined(separator: ",")

        pinArray.removeAll()
        tableView.reloadData()
        pinTextField.text = ""
        
        let controller = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.AccumulationSummaryController) as! AccumulationSummaryController
        
//        let bundle = Bundle(for: AccumulationSummaryController.self)
//        let controller = AccumulationSummaryController(nibName: "AccumulationSummaryController", bundle: bundle)
        
        controller.optionArray.append(contentsOf: summaryArray)
        controller.statusArray.append(contentsOf: statusArray)
        controller.totalBonusPoints =  Int(totalBonusPoints)
        controller.totalAmount = Int(totalAmount) 
        controller.totalPointsEarned = Int(totalPointsEarned)
        controller.totalSussPins = totalSussPins
        controller.totalPins = totalPins
        controller.totalExpiredPins = totalExpiredPins
        controller.totalNotPermitedPins = totalNotPermitedPins
        controller.totalInterPins = totalInterPins
        controller.totalConsumePins = totalConsumePins
        controller.totalNotInSysPins = totalNotInSysPins
        controller.isEplusLogin = isEplusLogin
        controller.totalHandlingCharges = Int(totalHandlingCharges)
        
        controller.pinList =  PinList
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func parseAccumulationResponse(dataString : String) -> [Summary] {
        
        var summaryArray = [Summary]()
        
        if let dataFromString = dataString.data(using: .utf8, allowLossyConversion: false) {
            

            do {
                let json =  try JSON(data: dataFromString)
                if let resultDictArray = json.arrayObject as? [[String : Any]] {
                    
                    print(resultDictArray)

                    totalBonusPoints = 0
                    totalPointsEarned = 0
                    totalAmount = 0
                    totalHandlingCharges = 0
                    
                    statusArray.removeAll()
                    
                    resultDictArray.forEach { (resultDict) in
                        let status = PinAccumulationStatus()
                        status.status = resultDict["Statuss"] as? String ?? ""
                        status.Amount = resultDict["ActualPoints"] as? Int ?? 0
                        status.Pin = resultDict["Pins"] as? String ?? ""
                        if let BonusPoints = resultDict["BonusPoints"] as? String
                        {
                            status.Bonuspoints = BonusPoints
                        }
                        else if let BonusPoints = resultDict["BonusPoints"] as? Double
                        {
                            let myDoubleString = String(BonusPoints)   // "1.5"
                            print("myDoubleString = \(myDoubleString)")
                            status.Bonuspoints = String(myDoubleString)
                        }
                        //status.Bonuspoints = resultDict["BonusPoints"] as? String ?? ""
                        status.MobileNumber = resultDict["MobileNo"] as? String ?? ""
                        status.TransNo = resultDict["TransNo"] as? String ?? ""
                        statusArray.append(status)

                        if let HandlingCharges = resultDict["HandlingCharges"] as? Int
                        {
                            status.HandlingCharges = "\(HandlingCharges)"
                        }
                        
                        if let Bonuspoints = Int(status.Bonuspoints) {
                            totalBonusPoints = totalBonusPoints + Bonuspoints
                        }
                        print("totalBonusPoints = \(totalBonusPoints)")
//                        if let Amount = status.Amount as? Double
//                        {
                            totalAmount = totalAmount + status.Amount //Amount
//                        }
                        
                        if let HandlingCharges = Int(status.HandlingCharges){
                            totalHandlingCharges = totalHandlingCharges + HandlingCharges
                        }
                    }
                    
                    totalPointsEarned = totalAmount + totalBonusPoints + totalHandlingCharges
                    
                    totalPins = statusArray.count
                    
                    let pinScanned = Summary(title: "total_pins_scanned".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!), value: String(statusArray.count), status: "")
                    summaryArray.append(pinScanned)
                    
                    let pointsEarned = Summary(title: "total_points_earned".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!), value: String(totalPointsEarned), status: "")
                    summaryArray.append(pointsEarned)
                    
                    //CONSUMED, SUCCESS, NOT IN SYSTEM, INTERCHANGED, Expired, Not Permitted
                    
                    let notInSystemPins_Count = AccumulationViewController.getFilteredSummary(statusArray: statusArray, status: "NOT IN SYSTEM").count
                    totalNotInSysPins = notInSystemPins_Count
                    
                    let successPins_Count = AccumulationViewController.getFilteredSummary(statusArray: statusArray, status: "SUCCESS").count
                    totalSussPins = successPins_Count
                    
                    let consumedPins_Count = AccumulationViewController.getFilteredSummary(statusArray: statusArray, status: "CONSUMED").count
                    totalConsumePins = consumedPins_Count
                    
                    let interchangePins_Count = AccumulationViewController.getFilteredSummary(statusArray: statusArray, status: "INTERCHANGED").count
                    totalInterPins = interchangePins_Count
                    
                    let notPermittedAsDistribution_Count = AccumulationViewController.getFilteredSummary(statusArray: statusArray, status: "Not Permitted").count
                    totalNotPermitedPins = notPermittedAsDistribution_Count
                    
                    let expiredPin_Count = AccumulationViewController.getFilteredSummary(statusArray: statusArray, status: "Expired").count
                    totalExpiredPins = expiredPin_Count
                    
                    let successPins = Summary(title: "success_pins".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!), value: String(successPins_Count), status: "SUCCESS")
                    summaryArray.append(successPins)
                    
                    let consumePins = Summary(title: "consume_pins".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!), value: String(consumedPins_Count), status: "CONSUMED")
                    summaryArray.append(consumePins)
                    
                    let notInSystemPins = Summary(title: "not_in_system_pins".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!), value: String(notInSystemPins_Count), status: "NOT IN SYSTEM")
                    summaryArray.append(notInSystemPins)
                    
                    let interchangePins = Summary(title: "other_scheme_pins".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!), value: String(interchangePins_Count), status: "INTERCHANGED")
                    summaryArray.append(interchangePins)
                    
                    let notPermittedAsDistribution = Summary(title: "not_permitted_as_distribution_pins".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!), value: String(notPermittedAsDistribution_Count), status: "Not Permitted")
                    summaryArray.append(notPermittedAsDistribution)
                    
                    let expiredPin = Summary(title: "expired_pins".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!), value: String(expiredPin_Count), status: "Expired")
                    summaryArray.append(expiredPin)
                    
                    
                }
            }catch {
                print("err")
            }
        }
        return summaryArray
    }
    
    
    class func getFilteredSummary(statusArray : [PinAccumulationStatus] , status : String) -> [PinAccumulationStatus]  {
        
        let filtredArray = statusArray.filter { (obj) -> Bool in
            return obj.status == status
        }
        return filtredArray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AccumulationViewController:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool
    {
        if textField == txt_ePlus_mobileNo
        {
            pinTextField.isEnabled = false
            btnScan.isEnabled = false
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
    
    @objc func ePlusTextFieldTextChanged(sender:UITextField)
    {
        if let text  = sender.text
        {
            pinTextField.isEnabled = false
            btnScan.isEnabled = false
            if text.count == 10
            {
                txt_ePlus_mobileNo.resignFirstResponder()
                if (txt_ePlus_mobileNo.text == "")
                {
                    self.view.makeToast(message: "Enter electrical mobile No.".uppercased())
                    return
                }
                else if ((txt_ePlus_mobileNo.text?.count)! < 10)
                {
                    self.view.makeToast(message: "Enter valid electrical mobile No.".uppercased())
                    return
                }
                
                
                    if(Connectivity.isConnectedToInternet())
                    {
                        getUserCodeByMobileNo(mobile: txt_ePlus_mobileNo.text!, schemeCode: staticSchemeCode, actionType: ActionType.EPLUS)
                        txt_ePlus_mobileNo.text = ""
                    }
                    else
                    {
                        showAlert(msg: "noInternetConnection".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                        txt_ePlus_mobileNo.text = ""
                    }
                
            }
        }
    }
    
    @objc func pingTextFieldTextChanged(sender:UITextField)
    {
       
            if let text  = sender.text
            {
                if text.count == 10 // change 12 to 10
                {
                    pinTextField.text = ""
                    if pinArray.contains(text)
                    {
                        return
                    }
                    pinArray.append(text)
                    self.tableView.insertRows(at: [IndexPath(item: pinArray.count - 1 , section: 0)], with: .top)
                    lbl_noOfPins.text = "NO. OF PINS SCANNED : \(pinArray.count)"
                }
            }
    }
    
    func getUserCodeByMobileNo(mobile:String, schemeCode:String, actionType:String)
    {
        let paraser = Parser()
        paraser.delegate = self
        let parameters:Parameters = [Key.MobileNo: mobile, Key.SchemeCode: schemeCode]
        paraser.callAPI(api: API.GetUserCodeByMobileNo, parameters: parameters, viewcontroller: self, actionType: actionType)
    }
}

extension AccumulationViewController
{
    func didRecivedRespoance(api: String, parser: Parser, json: Any)
    {
        if api == API.GetBalanceByUserCode
        {
            if let json = parser.responseData as? [[String:Any]]
            {
                if json.count > 0
                {
                    let result_Balance = SchemeParser.parseScheme(json: json)
                    
                    guard let db = DataProvider.getDBConnection() else {
                        print("db connection not found")
                        return
                    }
                    
                    do {
                        
                        let itExists = try db.scalar(tblScheme.exists)
                        if itExists
                        {
                            for item in result_Balance.1
                            {
                                let alice = tblScheme.filter(c_s_SchemePromName.like(item.s_SchemePromName!))
                                print(tblScheme)
                                print(alice)
                                try db.run(alice.update(c_d_Balance <- item.d_Balance!))
                            }
                        }
                        else
                        {
                            DataProvider.dropTable(table: tblScheme)
                            for item in result_Balance.1
                            {
                                SchemeParser.saveSchemeData(scheme: item)
                            }
                        }
                        
                        let sScheme = staticSchemeName
                        let alice = tblScheme.filter(c_s_SchemePromName.like(sScheme))
                        
                        for row in try db.prepare(alice)
                        {
                            print("row[c_d_Balance] = \(row[c_s_SchemePromName])")
                            DataProvider.sharedInstance.userDetails.d_Balance = row[c_d_Balance]
                        }
                        
                        let sum = try db.scalar(tblScheme.select(c_d_Balance.sum))
                        if let total = sum  {
                            DataProvider.sharedInstance.userDetails.d_Balance = total
                        }
                        
                        setUserDefaults(value: Date(), key: defaultsKeys.lastBalnceSyncDate)
            
                    }catch  {
                        print("error DB Insert")
                        print("Error info: \(error)")
                    }
                }
                else
                {
                    showAlert(msg: "Scheme not found")
                }
              
                self.pushAccumulationController(summaryArray: summary_Array)
            }
        }
       
    }
    
    func didRecivedGetUserCodeByMobileNo(json: [String : Any], actionType: String)
    {
        UserDetailParser.parseUserDetail(json: json, actionType:actionType)
        //getPendingTransactionFromDB()
        pinTextField.isEnabled = true
        btnScan.isEnabled = true
    }
    
    func didRecivedAppCredentailFali(msg: String)
    {
        alertTag = -1
        showAlert(msg: msg)
    }
    
    override func didRecivedAppCredentail(parser:Parser ,appVersion: String, mobileNumber: String, isIMEIExit: Bool, status: String, userCode: String, userStatus: String, usertype: String, actionType: String, isForceUpdate:String,isVerify : String)
    {
        if (isIMEIExit)
        {
            let userStatus = Parser.checkUsertType(usertype: usertype, userStatus: userStatus, viewController: self)
            if usertype == UserType_UTC0074{
                showRDMsg(msg: "YOU ARE ALREADY REGISTERED AS RURAL DISTRIBUTOR!")
            }
            if (userStatus.0)
            {
                pinAccumulation()
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
    func showRDMsg(msg : String)
       {
           let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
           let actionYes = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: self.onYesPresseed)
           alert.addAction(actionYes)
        
           
           self.present(alert, animated: true, completion: nil)
       }
    
           @objc  func onYesPresseed(alert: UIAlertAction!)
       {
               removeAppSession()
             _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PasswordViewController)
       }
}

extension AccumulationViewController: BarcodeScannerCodeDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String)
    {
        if !(pinArray.contains(code))
        {
            if (code.count == 10) // change 12 to 10
            {
                print(code)
                pinArray.append(code)
            }
            else
            {
            }
        }
        else
        {
        }
    }
}


extension AccumulationViewController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

extension AccumulationViewController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
        tableView.reloadData()
        print(pinArray.count)
        lbl_noOfPins.text = "No. of Pins Scanned : \(pinArray.count)"
    }
}

extension AccumulationViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pinArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SamparkTableViewCell
        {
            cell.selectionStyle = .none
            let pin = pinArray[indexPath.row]
            print(pin)
            cell.titleLabel?.text = pin
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(self.deletePressed(sender:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    @objc func deletePressed(sender: UIButton?)
    {
        
        delete(deletePin: pinArray[(sender?.tag)!], scheme: staticSchemeName)
        pinArray.remove(at: (sender?.tag)!)

//        do
//        {
//            if let db = DataProvider.getDBConnection()
//            {
//                let itExists = try db.scalar(PindingTransactionTable.exists)
//                if itExists
//                {
//                    if(pinArray.count != 0)
//                    {
//                        do {
//                            let all = Array(try db.prepare(PindingTransactionTable))
//                            if all.count>0
//                            {
//                                saveAccumulation()
//                            }
//                        } catch  {
//                            print("error = \(error)")
//                        }
//                    }
//                    else
//                    {
//                        DataProvider.dropTable(table: PindingTransactionTable)
//                    }
//                }
//                else
//                {
//                }
//            }
//            else {
//                print("Db not found in accumulation")
//            }
//
//        } catch {
//            print("Error in accumulation doesn't exit PindingTransactionTable")
//            print(error)
//        }
    
        self.tableView.deleteRows(at: [IndexPath(item: (sender?.tag)! , section: 0)], with: .top)
        lbl_noOfPins.text = "NO. OF PINS SCANNED : \(pinArray.count)"
        tableView.reloadData()
    }
}


