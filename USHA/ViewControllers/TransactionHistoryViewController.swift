//
//  TransactionHistoryViewController.swift
 
//
//  Created by Apple.Inc on 30/05/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import IQKeyboardManagerSwift
import SQLite
class TransactionHistoryViewController: BaseViewController {

    @IBOutlet weak var lbl: UILabel!
    
    @IBOutlet weak var lbl_TransactionHistory: UILabel!
    @IBOutlet weak var lbl_schemeWise: UILabel!
    @IBOutlet weak var lbl_red_points: UILabel!
    @IBOutlet weak var lbl_acc_points: UILabel!
    @IBOutlet weak var lbl_youCenSelect: UILabel!
    @IBOutlet weak var txt_scheme: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_select: UIButton!
    @IBOutlet weak var viewStart: UIView!
    @IBOutlet weak var viewEnd: UIView!
    
    @IBOutlet weak var btn_startDate: UIButton!
    @IBOutlet weak var txt_strtDate: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btn_endDate: UIButton!
    @IBOutlet weak var txt_endDate: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btn_submit: UIButton!
    
    var datePickerView:UIDatePicker!// = UIDatePicker()

    
    var action = API.GetAccRedSaleReport
    
    let selectSchemeDropDown = DropDown()

    var arrSchemeName = [String]()
    var arrScheme = [Scheme]()
    
    var userCode = ""

    var schemeCode = ""
    
    var startDate:Date!
    var endDate:Date!
    
    var alertTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        navigationView.btn_back.isHidden = true
//        navigationView.btn_back_width.constant = 0
//        menuItem()
        
        txt_scheme.text = "ALL"
        txt_scheme.delegate = self
        txt_scheme.updateLengthValidationMsg("selectScheme".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!))

        txt_strtDate.delegate = self
        txt_strtDate.updateLengthValidationMsg("selectStartDate".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!))

        txt_endDate.delegate = self
        txt_endDate.updateLengthValidationMsg("selectEndDate".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!))
        
        setupDropDown()
        
        txt_strtDate.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))

        txt_endDate.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
    
         setUpDesign()
        
     }
           
            func setUpDesign(){
              
                   btn_submit.layer.cornerRadius = 20
                   btn_submit.layer.masksToBounds = true
                
                   viewStart.layer.cornerRadius = 20
                   viewStart.borderWidth  = 1.0
                   viewStart.borderColor = UIColor.lightGray
                
                    viewEnd.layer.cornerRadius = 20
                    viewEnd.borderWidth  = 1.0
                    viewEnd.borderColor = UIColor.lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LanguageChanged(strLan:keyLang)
    }
    func LanguageChanged(strLan:String){
        lbl.text = "NOTE".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_TransactionHistory.text = "TRANSACTION HISTORY".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_acc_points.text = "2. ACC:- POINTS ACCUMULATED".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_youCenSelect.text = "1. YOU CAN SELECT UPTO 31 DAYS HISTORY".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_schemeWise.text = "4. SCHEME WISE DETAILS AVAILABLE FROM 16th AUG 2018 ONWARDS".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_red_points.text = "3. RED:- POINTS REDEEMED THROUGH DIFFERENT MODES".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
        btn_submit.setTitle("VIEW".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
        
    }
    @objc func doneButtonClicked(_ sender: Any)
    {
        //your code when clicked on done
        handleDatePicker(sender: datePickerView)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {

        self.navigationController?.popViewController(animated: true)
    }
    
    func setupDropDown()
    {
        selectSchemeDropDown.dismissMode = .automatic
        selectSchemeDropDown.tag = 101
        selectSchemeDropDown.width = txt_scheme.frame.size.width
        selectSchemeDropDown.bottomOffset = CGPoint(x: 0, y: txt_scheme.bounds.height)
        selectSchemeDropDown.anchorView = txt_scheme
        selectSchemeDropDown.direction = .bottom
        selectSchemeDropDown.cellHeight = 40
        selectSchemeDropDown.backgroundColor = .white
        // Action triggered on selection
        selectSchemeDropDown.selectionAction = {(index, item) in
            self.txt_scheme.text = item
            if (index == 0)
            {
                self.schemeCode = ""
            }
            else
            {
                let scheme = self.arrScheme[index-1]
                self.schemeCode = scheme.s_SchemePromCode!
            }
        }
    }
    
    func retriveScheme()
    {
        if arrSchemeName.count == 0
        {
            guard let db = DataProvider.getDBConnection() else {
                print("db connection not found")
                return
            }
            do {
                let itExists = try db.scalar(tblScheme.exists)
                if itExists
                {
                    self.arrSchemeName.removeAll()
                    for scheme in try db.prepare(tblScheme.select(c_s_SchemePromName)) {
                        //print("c_s_SchemePromName: \(scheme[c_s_SchemePromName])")
                        self.arrSchemeName.append(scheme[c_s_SchemePromName])
                    }
                    
                    self.arrScheme.removeAll()
                    for scheme in try db.prepare(tblScheme)
                    {
                        let obj_scheme = Scheme()
                        obj_scheme.d_Balance = scheme[c_d_Balance]
                        obj_scheme.s_SchemePromCode = scheme[c_s_SchemePromCode]
                        obj_scheme.s_SchemePromName = scheme[c_s_SchemePromName]
                        
                        self.arrScheme.append(obj_scheme)
                    }
                    self.arrSchemeName.insert("ALL", at: 0)
                    selectSchemeDropDown.dataSource = arrSchemeName
                    selectSchemeDropDown.show()
                }
                else
                {
                    if Connectivity.isConnectedToInternet()
                    {
                        action = API.GetBalanceByUserCode
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
                    action = API.GetBalanceByUserCode
                    checkIMEI()
                }
                else
                {
                    showAlert(msg: "noInternetConnection".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                }
            }
        }
        else
        {
            selectSchemeDropDown.dataSource = arrSchemeName
            selectSchemeDropDown.show()
        }
    }
    
    @IBAction func btn_select_pressed(_ sender: UIButton)
    {
        retriveScheme()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DatePicker(sender:UITextField, tag:Int)
    {
        datePickerView = UIDatePicker()
        datePickerView.tag = tag
        datePickerView.datePickerMode = .date
    
        datePickerView.maximumDate = Date()
    
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yy"
        
        let calendar = Calendar.current

        var maxDateComponent = calendar.dateComponents([.day,.month,.year], from: Date())
        maxDateComponent.day = 01
        maxDateComponent.month = 01
        maxDateComponent.year = 2020
        
        let maxDate = calendar.date(from: maxDateComponent)
        print("max date : \(maxDate)")
        if sender.tag == 1
        {
            startDate = sender.date
            txt_strtDate.text = dateFormatter.string(from: sender.date)
        }
        else
        {
            endDate = sender.date
    //        sender.minimumDate = Date()
            txt_endDate.text = dateFormatter.string(from: sender.date)
        }
    }
    
    @IBAction func btn_startDate_pressed(_ sender: UIButton)
    {
        _ = txt_strtDate.becomeFirstResponder()
       //DatePicker(sender: txt_strtDate, tag: 1)
    }
    
    @IBAction func btn_endDate_pressed(_ sender: UIButton)
    {
        _ = txt_endDate.becomeFirstResponder()

        //DatePicker(sender: txt_endDate, tag: 2)
    }
    
    @IBAction func textMonthFieldEditing(_ sender: SkyFloatingLabelTextField) {
        DatePicker(sender: txt_strtDate, tag: 1)
    }
    
    @IBAction func textYearFieldEditing(_ sender: SkyFloatingLabelTextField) {
        DatePicker(sender: txt_endDate, tag: 2)
    }
    
    @IBAction func btn_submit_pressed(_ sender: UIButton)
    {
//        let transactionHistoryListViewController = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.TransactionHistoryListViewController)
//        self.navigationController?.pushViewController(transactionHistoryListViewController, animated: true)
        
        if (Connectivity.isConnectedToInternet())
        {
            if txt_scheme.validate()
            {
                if txt_strtDate.validate()
                {
                    if (startDate < Date())
                    {
                        if txt_endDate.validate()
                        {
                            if (endDate < Date())
                            {
                                if (endDate < startDate)
                                {
                                    showAlert(msg: "END DATE SHOULD BE GREATER THAN START DATE!")
                                }
                                else if (!daysBtwenDate(date1: startDate, date2: endDate))
                                {
                                    showAlert(msg: "YOU CAN VIEW UPTO 6 MONTHS HISTORY")
                                }
                                else
                                {
                                    //print("Done")
                                    action = API.GetAccRedSaleReport
                                    checkIMEI()
                                }
                            }
                            else
                            {
                                showAlert(msg: "END DATE SHOULD BE LESS THAN OR EQUAL TO CURRENT DATE")
                            }
                        }
                        else
                        {
                            showAlert(msg: txt_endDate.strMsg)
                        }
                    }
                    else
                    {
                        showAlert(msg: "START DATE SHOULD BE LESS THAN OR EQUAL TO CURRENT DATE")
                    }
                }
                else
                {
                    showAlert(msg: txt_strtDate.strMsg)
                }
            }
            else
            {
                showAlert(msg: txt_scheme.strMsg)
            }
        }
        else
        {
            showAlert(msg: "NEED INTERNET CONNECTIVITY TO VIEW TRANSACTION HISTORY")
        }
    }
    
    func daysBtwenDate(date1:Date, date2:Date) -> Bool
    {
        let calendar = NSCalendar.current
        
        // Replace the hour (time) of both dates with 00:00
//        let date1 = calendar.startOfDay(for: passwordDate)
//        let date2 = calendar.startOfDay(for: Date())
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        let day = components.day
        if day! <= 180
        {
            return true
        }
        return false
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

extension TransactionHistoryViewController: UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if (textField == txt_scheme)
        {
            retriveScheme()
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if (textField == txt_scheme)
        {
            
        }
        if (textField == txt_strtDate)
        {
            DatePicker(sender: textField, tag: 1)
        }
        else
        {
            DatePicker(sender: textField, tag: 2)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
//        handleDatePicker(sender: datePickerView)
//        if textField == txt_strtDate
//        {
//            handleDatePicker(sender: <#T##UIDatePicker#>)
//        }
//        else if textField == txt_endDate
//        {
//
//        }
    }
}

extension TransactionHistoryViewController
{
    
    func parseAndshowSchemeDropDown(json:[[String:Any]])
    {
        let result = SchemeParser.parseScheme(json: json)
        self.arrScheme = result.1
        self.arrSchemeName = result.0
        
        var totalBalance = 0.0
        for item in arrScheme
        {
            totalBalance = totalBalance + item.d_Balance!
        }
        DataProvider.sharedInstance.userDetails.d_Balance = totalBalance
        
        selectSchemeDropDown.dataSource = arrSchemeName
        selectSchemeDropDown.show()
    }
    
    
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
                            DataProvider.sharedInstance.selectedScehme.d_Balance = row[c_d_Balance]
                        }
                        
                        let sum = try db.scalar(tblScheme.select(c_d_Balance.sum))
                        if let total = sum  {
                            DataProvider.sharedInstance.userDetails.d_Balance = total
                        }
                        
                        self.arrSchemeName.removeAll()
                        for scheme in try db.prepare(tblScheme.select(c_s_SchemePromName)) {
                            //print("c_s_SchemePromName: \(scheme[c_s_SchemePromName])")
                            self.arrSchemeName.append(scheme[c_s_SchemePromName])
                        }
                        
                        self.arrScheme.removeAll()
                        for scheme in try db.prepare(tblScheme)
                        {
                            let obj_scheme = Scheme()
                            obj_scheme.d_Balance = scheme[c_d_Balance]
                            obj_scheme.s_SchemePromCode = scheme[c_s_SchemePromCode]
                            obj_scheme.s_SchemePromName = scheme[c_s_SchemePromName]
                            
                            self.arrScheme.append(obj_scheme)
                        }
                        
                        selectSchemeDropDown.dataSource = arrSchemeName
                        selectSchemeDropDown.show()

//                        setUserDefaults(value: Date(), key: defaultsKeys.lastBalnceSyncDate)
//
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
//                        if let d = getUserDefaults(key: defaultsKeys.lastBalnceSyncDate) as? Date
//                        {
//                            let dstr = dateFormatter.string(from: d)
//                            lbl_lastSyncDate.text = "\(dstr)"
//                        }
//                        else
//                        {
//                            //let dstr = dateFormatter.string(from: Date())
//                            lbl_lastSyncDate.text = "--" //  \(dstr)"
//                        }
                        
                    }catch  {
                        print("error DB Insert")
                        print("Error info: \(error)")
                    }
                }
                else
                {
                    showAlert(msg: "Scheme not found")
                }
            }
            else
            {
                showAlert(msg: "Scheme not found")
            }
        }
        else if api == API.GetAccRedSaleReport
        {
        }
    }
    
    func didRecivedGetAccRedSaleReport(responseData: [[String : Any]])
    {
        let dasboardParser = DashboardParser()
        let arr_dash = dasboardParser.parseDashboard(json: responseData, isSave: false)
        
        if arr_dash.count == 0
        {
            showAlert(msg: "noHistory".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
        else
        {
            let transactionHistoryListViewController = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.TransactionHistoryListViewController) as! TransactionHistoryListViewController
            transactionHistoryListViewController.arr_Transaction = arr_dash
            transactionHistoryListViewController.startDate = startDate
            transactionHistoryListViewController.endDate = endDate
            self.navigationController?.pushViewController(transactionHistoryListViewController, animated: true)
        }
    }
    
    func didRecivedAppCredentailFali(msg: String)
    {
        alertTag = -1
        showAlert(msg: msg)
    }
    
    override func didRecivedAppCredentail(parser:Parser, appVersion: String, mobileNumber: String, isIMEIExit: Bool, status: String, userCode: String, userStatus: String, usertype: String, actionType: String, isForceUpdate:String,isVerify : String)
    {
        
        if actionType == ActionType.CheckIMEI
        {
            if (isIMEIExit)
            {
                let userSatus = Parser.checkUsertType(usertype: usertype, userStatus: userStatus, viewController: self)
                if (userSatus.0)
                {
                    if action == API.GetBalanceByUserCode
                    {
                        getScheme(userCode:userCode)
                    }
                    else if action == API.GetAccRedSaleReport
                    {
                        self.userCode = userCode
                        GetAccRedSaleReport(userCode: userCode)
                    }
                }
                else
                {
                    alertTag = userSatus.1
                }
            }
            else
            {
                showWrongUDIDAlert()
            }
        }
    }
    
    func getScheme(userCode:String)
    {
        let parameters:Parameters = [Key.UserCode : userCode]
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.GetBalanceByUserCode, parameters: parameters, viewcontroller: self, actionType: API.GetBalanceByUserCode)
    }
    
    func GetAccRedSaleReport(userCode: String)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yy"
  
        let sDate =  dateFormatter.string(from: startDate)
        let eDate =  dateFormatter.string(from: endDate)
        
        let parameters:Parameters = [Key.ActionTypes : ActionType.ACC,  Key.FromDate : sDate, Key.ToDate : eDate, Key.UserCode : userCode, Key.SchemeCode : schemeCode, Key.MobileNo: DataProvider.sharedInstance.userDetails.s_MobileNo!] //:"7506940017"]
        
        print(parameters)
        
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.GetAccRedSaleReport, parameters: parameters, viewcontroller: self, actionType: API.GetAccRedSaleReport)
    }
    
    override func onOkPressed(alert: UIAlertAction!) {
        if alertTag == -1
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
    }
}
