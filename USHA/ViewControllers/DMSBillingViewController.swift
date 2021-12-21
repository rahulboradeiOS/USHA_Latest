//
//  DMSBillingViewController.swift
 
//
//  Created by Naveen on 22/07/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DMSBillingViewController: BaseViewController {
    @IBOutlet weak var dmstableview: UITableView!
    
    @IBOutlet weak var lbl_selectDate: UILabel!
     @IBOutlet weak var lbl_DIS_CODE: UILabel!
     @IBOutlet weak var lbl_DIVISION_NAME: UILabel!
     @IBOutlet weak var lbl_INVOICE_DATE: UILabel!
     @IBOutlet weak var lbl_QUANTITY: UILabel!
     @IBOutlet weak var lbl_GROSS_AMT: UILabel!
     @IBOutlet weak var lbl_INVOICE_STATUS: UILabel!
    
    @IBOutlet weak var lbl_date: UILabel!
    
    @IBOutlet weak var lbl_dmsSaleDate: UILabel!
    @IBOutlet weak var btn_startDate: UIButton!
    @IBOutlet weak var btn_endDate: UIButton!
    @IBOutlet weak var btn_view: UIButton!
    @IBOutlet weak var txt_endDate: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_startdate: SkyFloatingLabelTextField!
    @IBOutlet weak var view_selectDate: UIView!
    
    var arrayJson = JSON()
    var responsedata = JSON()
    var datePickerView:UIDatePicker!// = UIDatePicker()
    var startDate:Date!
    var endDate:Date!
 
    var Fromdate:String = ""
    var Todate:String = ""


    
    override func viewDidLoad() {
        super.viewDidLoad()
        view_selectDate.isHidden = true
        
        dmstableview.dataSource = self
        dmstableview.delegate = self
        txt_startdate.delegate = self
        txt_startdate.updateLengthValidationMsg("selectStartDate".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!))
        
        txt_endDate.delegate = self
        txt_endDate.updateLengthValidationMsg("selectEndDate".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!))
        
        txt_startdate.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        
        txt_endDate.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        
        let calendar = Calendar.current

                let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let d = getUserDefaults(key: defaultsKeys.lastBalnceSyncDate) as? Date
        {
            let nintyDaysFromNow = calendar.date(byAdding: .day, value: -90, to: d)
            let dstr1 = dateFormatter.string(from: nintyDaysFromNow!)
            let dstr = dateFormatter.string(from: d)
            txt_endDate.text = "\(dstr)"
            txt_startdate.text = "\(dstr1)"
            lbl_date.text = "\(dstr1)-\(dstr)"
        }
        else
        {
            //let dstr = dateFormatter.string(from: Date())
            txt_endDate.text = "--" //"\(dstr)"
            txt_startdate.text = "--" //"\(dstr)"
        }
        lbl_date.text = "\(txt_startdate.text!)-\(txt_endDate.text!)"

        DMSRequest()
    
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        LanguageChanged(strLan:keyLang)
    }
    
    func LanguageChanged(strLan:String){
        lbl_dmsSaleDate.text = "DMS_SALE_DETAILS".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_DIS_CODE.text = "DIS_CODE".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
//        lbl_DIVISION_NAME.text = "DIVISION_NAME".localizableString(loc:
//            UserDefaults.standard.string(forKey: "keyLang")!)
//        lbl_INVOICE_DATE.text = "INVOICE_DATE".localizableString(loc:
//            UserDefaults.standard.string(forKey: "keyLang")!)
//        lbl_QUANTITY.text = "QUANTITY".localizableString(loc:
//            UserDefaults.standard.string(forKey: "keyLang")!)
//        lbl_GROSS_AMT.text = "GROSS_AMT".localizableString(loc:
//            UserDefaults.standard.string(forKey: "keyLang")!)
//        lbl_INVOICE_STATUS.text = "INVOICE_STATUS".localizableString(loc:
//            UserDefaults.standard.string(forKey: "keyLang")!)
        lbl_selectDate.text = "SELECT_DATE".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
        btn_endDate.setTitle("END_DATE".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
        btn_startDate.setTitle("START_DATE".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
        btn_view.setTitle("VIEW".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @objc func doneButtonClicked(_ sender: Any)
    {
        //your code when clicked on done
        handleDatePicker1(sender: datePickerView)
    }
    
    @IBAction func btn_selectdateClose(_ sender: Any) {
        view_selectDate.isHidden = true
    }
    @IBAction func btn_SalectDate(_ sender: Any) {
      view_selectDate.isHidden = false
        txt_endDate.text = ""
        txt_startdate.text = ""

    }
  
    @IBAction func btn_viewPressed(_ sender: Any) {
      
        if (Connectivity.isConnectedToInternet())
        {
            if txt_startdate.validate()
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
                                    showAlert(msg: "YOU CAN VIEW UPTO 90 DAYS HISTORY")
                                }
                                else
                                {
                                    print("Done")
                                    DMSRequest()
                                    view_selectDate.isHidden = true
                                    
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
                    showAlert(msg: txt_startdate.strMsg)
                }
        
        }
        else
        {
            showAlert(msg: "NEED INTERNET CONNECTIVITY TO VIEW TRANSACTION HISTORY")
        }
    }
    @IBAction func btn_startdatePressed(_ sender: Any) {
         _ = txt_startdate.becomeFirstResponder()
    }
    
    @IBAction func btn_endDatePressed(_ sender: Any) {
         _ = txt_endDate.becomeFirstResponder()
    }
    func DatePicker(sender:UITextField, tag:Int)
    {
        datePickerView = UIDatePicker()
        datePickerView.tag = tag
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker1(sender:)), for: .valueChanged)
    }
    func daysBtwenDate(date1:Date, date2:Date) -> Bool
    {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        let day = components.day
        if day! <= 90
        {
            return true
        }
        return false
    }
    var tenDaysfromNow: Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: -90, to: Date(), options: [])!
    }
    
    @objc func handleDatePicker1(sender: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMyyyy"
        if sender.tag == 1
        {
            startDate = sender.date
            txt_startdate.text = dateFormatter.string(from: sender.date)
        }
        else
        {
            endDate = sender.date
            txt_endDate.text = dateFormatter.string(from: sender.date)
        }
      

    }

    func  DMSRequest(){
        
        
        let startDate = txt_startdate.text!
        let endDate = txt_endDate.text!
        
//        let a = startDate.substring(3)
//        let b = endDate.substring(3)
//        print(a)
//        print(b)
        
      
        
        let dic = ["UserCode":DataProvider.sharedInstance.userDetails.s_UserCode, "FromDate":startDate,"ToDate":endDate]
        
        print(dic)
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        let requestURL: String =
        "\(mainUrl)api/Report/GetDmsSalesReport"
        manager.request(requestURL, method : .post, parameters : dic as Parameters, encoding : JSONEncoding.default , headers : ["Content-Type":"application/json","Clientid":" qBd/jix0ctU= ","SecretId":"7Whc1QzyT1Pfrtm88ArNaQ=="]).responseJSON { response in
            DispatchQueue.main.async {
                print("URL : \(requestURL)\nRESPONSE : \(response)")
                let responsString = response.data?.toString()
                print(responsString!)
                let data = responsString!.data(using: .utf8)!
                do {
                    
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    self.arrayJson = JSON(json!)
                    print(self.arrayJson)
                    self.responsedata = self.arrayJson["ResponseData"]
                    print("my responce data\(self.responsedata)")
                  self.dmstableview.reloadData()
                }
            }
        }
    }
    
}
extension DMSBillingViewController :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.responsedata.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let data = self.responsedata
            let cell = tableView.dequeueReusableCell(withIdentifier: "DMSBillingTableViewCell", for: indexPath) as! DMSBillingTableViewCell
        
        print(data)
        
            cell.lbl_distCode.text = data[indexPath.row]["s_DistrCode"].stringValue
            cell.lbl_divisionName.text = data[indexPath.row]["s_Division"].stringValue
            cell.lbl_month.text = data[indexPath.row]["s_monthYear"].stringValue
            cell.lbl_quantity.text = data[indexPath.row]["n_InvoiceQty"].stringValue
            cell.lbl_netSales.text = data[indexPath.row]["n_NetSales"].stringValue
        
            return cell
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
}
extension DMSBillingViewController: UITextFieldDelegate
{
    private func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
    
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if (textField == txt_startdate)
        {
            DatePicker(sender: textField, tag: 1)
        }
        else
        {
            DatePicker(sender: textField, tag: 2)
        }
    }
    
    private func textFieldDidEndEditing(_ textField: UITextField)
    {
  
    }
}
