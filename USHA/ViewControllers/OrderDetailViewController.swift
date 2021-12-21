//
//  OrderDetailViewController.swift
 
//
//  Created by Apple.Inc on 19/12/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import NotificationCenter
import CoreData

//@objc protocol OrderDoneDelegate: AnyObject
//{
//    @objc func didOrderDone()
//}

class OrderDetailViewController: BaseViewController
{
    
    @IBOutlet weak var btn_submitOrderDone: UIButton!
    @IBOutlet weak var lbl_pleaseSelect: UILabel!
    @IBOutlet weak var lbl_orderNumber: UILabel!
    @IBOutlet weak var lbl_division: UILabel!
    @IBOutlet weak var tableview_Order: UITableView!
    @IBOutlet weak var tableview_order_height: NSLayoutConstraint!
    
    @IBOutlet weak var view_selectOption: UIView!
    @IBOutlet weak var txt_selectOption: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_selectOption: UIButton!
    @IBOutlet weak var btn_addMore: UIButton!
    @IBOutlet weak var txt_dealerName: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_dealerMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_delarNameHeight: NSLayoutConstraint!
    @IBOutlet weak var txt_delarMobileNoHeight: NSLayoutConstraint!
    @IBOutlet weak var txt_delarMobileTop: NSLayoutConstraint!
    
    @IBOutlet weak var txt_expectedDate: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_delerNameTop: NSLayoutConstraint!
    @IBOutlet weak var txt_remark: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lbl_ttlSku: UILabel!
    @IBOutlet weak var lbl_ttlQty: UILabel!
    @IBOutlet weak var lbl_ttlAmt: UILabel!
    
    
    var txt_responder:SkyFloatingLabelTextField!
    let selectDropDown = DropDown()
    var datePickerView:UIDatePicker!
    
    var arr_DealerCode:[Dealer]!
    var arr_ProductList:[Product]!
    var arr_Updated_ProductList:[Product] = []
    var arr_Duplicates_ProductList:[Product] = []
    var callAction = ""
    var SkuCategory:Division!
    var SkuSubCategory:Division!
    var dealer:Dealer!
    var alertTag = 0
    
    var MDM_CODE = ""
    var saleOffice_CODE = ""
    var lastOrderNo = ""
    var ORDER_ID = ""
    
    var selectedOrderType = ""
    var expectedDate:Date!
    var myData : String!
    var delegate: OrderDoneDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let data =  UserDefaults.standard.string(forKey: "SeletedDivision")

        if data != "" || data != nil{
            lbl_orderNumber.text = "ORDER_NO : "
            //lbl_division.text = "DIVISION : \(data ?? "")"
        }
        setupDropDown()
        
        
        let withoutDuplicates = arr_ProductList.removingDuplicates(byKey: { $0.code })
        
        print(withoutDuplicates)
        
        
        for index:Product in arr_ProductList{
            
            if withoutDuplicates.contains(array: [index]){
            }else{
                arr_Duplicates_ProductList.append(index)
            }
        }
        
        print(arr_Duplicates_ProductList)
        
        
        for index1:Product in withoutDuplicates{
            var product_Qty = 0
            product_Qty = index1.qty
            
            for index2:Product in arr_Duplicates_ProductList{
                
                if index1.code == index2.code{
                    product_Qty = product_Qty + index2.qty
                }
            }
            
            let newProduct = Product()
            newProduct.name = index1.name
            newProduct.code = index1.code
            newProduct.price = index1.price
            newProduct.discount = index1.discount
            newProduct.unit = index1.unit
            newProduct.categoryCode = index1.categoryCode
            newProduct.amount = index1.amount
            newProduct.qty = product_Qty
            
            arr_Updated_ProductList.append(newProduct)
        }
        
        
        print(arr_Updated_ProductList)
        
        arr_ProductList = arr_Updated_ProductList
        
        
        appDelegate.arr_UpdatedDelegate_ProductList = arr_ProductList
        tableview_Order.reloadData()
        
        let oderList = arr_ProductList.filter({$0.qty > 0})
        self.lbl_ttlSku.text = "TTL SKU : \(oderList.count)"
        self.lbl_ttlQty.text = "TTL QTY : \(arr_ProductList.map({$0.qty}).reduce(0, +))"
        self.lbl_ttlAmt.text = "TTL AMT : \(arr_ProductList.map({$0.amount}).reduce(0, +))"
        
        txt_selectOption.delegate = self
        txt_dealerName.delegate = self
        txt_dealerMobile.delegate = self
        txt_expectedDate.delegate = self
        
        let headerNib = UINib.init(nibName: "DemoHeaderView", bundle: Bundle.main)
        tableview_Order.register(headerNib, forHeaderFooterViewReuseIdentifier: "DemoHeaderView")
        tableview_order_height.constant = 0
        tableview_Order.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        txt_expectedDate.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        
        //        txt_dealerMobile.isEnabled = false
        //        txt_dealerMobile.text = DataProvider.sharedInstance.userDetails.s_MobileNo!
        
         setUpDesign()
        
    }
    
    func setUpDesign(){
      
           btn_submitOrderDone.layer.cornerRadius = 20
           btn_submitOrderDone.layer.masksToBounds = true
        
          btn_addMore.layer.cornerRadius = 20
          btn_addMore.layer.masksToBounds = true
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        super.viewWillAppear(true)
        self.txt_delerNameTop.constant = 0
        self.txt_delarNameHeight.constant = 0
        self.txt_delarMobileTop.constant = 0
        self.txt_delarMobileNoHeight.constant = 0
        callAction = ActionType.Edit
        getData()
        LanguageChanged(strLan:keyLang)
        
        self.tableview_Order.reloadData()
        //checkIMEI()
    }
    
    func LanguageChanged(strLan:String){
        lbl_pleaseSelect.text = "Please select the follwing option for order processing".uppercased().localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!)
        btn_submitOrderDone.setTitle("Submit".uppercased().localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
    }
    override func onBackButtonPressed(_ sender: UIButton)
    {
        exitAlert1()
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_Back_pressed(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_AddMoreItems_pressed(_ sender: UIButton)
      {
          self.navigationController?.popViewController(animated: true)
      }
      
    
    
    override func onHomeButtonPressed(_ sender: UIButton) {
        exitAlert2(msg: "productListErrorMsg".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!))
    }
    
    override func onBellButtonPressed(_ sender: UIButton) {
        exitAlert3(msg: "productListErrorMsg".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!))
        
        
    }
    
    func exitAlert1()
    {
        let alert = UIAlertController(title: appName, message: "productListPreviousPage".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "YES".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                      style: .default,
                                      handler: self.yesPressed1)
        alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "NO".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                     style: .destructive,
                                     handler: self.noPressed1)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func yesPressed1(alert: UIAlertAction!)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func noPressed1(alert: UIAlertAction!)
    {
    }
    
    func exitAlert2(msg:String)
    {
        let alert = UIAlertController(title: appName, message: msg, preferredStyle: UIAlertControllerStyle.alert)
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
        arr_ProductList = []
        arr_ProductList.removeAll()
        
        appDelegate.arr_UpdatedDelegate_ProductList = []
        appDelegate.arr_UpdatedDelegate_ProductList.removeAll()
        print(arr_ProductList.count)
        self.tableview_Order.reloadData()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func noPressed2(alert: UIAlertAction!)
    {
    }
    
    func exitAlert3(msg:String)
    {
        let alert = UIAlertController(title: appName, message: msg, preferredStyle: UIAlertControllerStyle.alert)
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
        arr_ProductList = []
        arr_ProductList.removeAll()
        
        appDelegate.arr_UpdatedDelegate_ProductList = []
        appDelegate.arr_UpdatedDelegate_ProductList.removeAll()
        print(arr_ProductList.count)
        self.tableview_Order.reloadData()
        let notificationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationViewController) as! NotificationViewController
        self.navigationController?.pushViewController(notificationVC, animated: true)    }
    
    @objc func noPressed3(alert: UIAlertAction!)
    {
    }
    
    func setupDropDown()
    {
        selectDropDown.dismissMode = .automatic
        selectDropDown.separatorColor = .lightGray
        //selectDropDown.width = view_selectDivision.frame.width
        selectDropDown.bottomOffset = CGPoint(x: 0, y: view_selectOption.bounds.height)
        selectDropDown.direction = .bottom
        selectDropDown.cellHeight = 40
        selectDropDown.backgroundColor = .white
        // Action triggered on selection
        selectDropDown.selectionAction = {(index, item) in
            if self.txt_responder  != nil{
                self.txt_responder.text = item
            }
            self.dealer = self.arr_DealerCode[index]
            if(item == "Other")
            {
                self.txt_delerNameTop.constant = 16
                self.txt_delarNameHeight.constant = 40
                self.txt_dealerName.isEnabled = true
                self.txt_dealerMobile.isEnabled = true
            }
            else
            {
                self.txt_delerNameTop.constant = 0
                self.txt_delarNameHeight.constant = 0
//                if let name = self.dealer.s_FullName,
//                    let mob = self.dealer.MobileNo,let orderType = self.dealer.OrderType
//                {
                if let name = self.dealer.s_FullName,let orderType = self.dealer.OrderType
                               {
                    self.txt_dealerName.isEnabled = false
                    self.txt_dealerMobile.isEnabled = false
                    self.txt_dealerName.text = name
                   // self.txt_dealerMobile.text = mob
                    self.selectedOrderType = orderType
                    print(self.selectedOrderType)
                }
                else
                {
                    self.showAlert(msg: "dealerNotFound".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                }
            }
        }
    }
    
    @IBAction func btn_startDate_pressed(_ sender: UIButton)
    {
        _ = txt_expectedDate.becomeFirstResponder()
    }
    
    func DatePicker(sender:UITextField, tag:Int)
    {
        datePickerView = UIDatePicker()
        datePickerView.tag = tag
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if sender.tag == 1
        {
            expectedDate = sender.date
            txt_expectedDate.text = dateFormatter.string(from: sender.date)
        }
    }
    
    @objc func doneButtonClicked(_ sender: Any)
    {
        //your code when clicked on done
        handleDatePicker(sender: datePickerView)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if let obj = object as? UITableView {
            if obj == self.tableview_Order && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    //do stuff here
                    if newSize.height < 350 {
                    self.tableview_order_height.constant = newSize.height
                    } else {
                        self.tableview_order_height.constant = 350
                    }
                }
            }
        }
    }
    
    deinit {
        self.tableview_Order.removeObserver(self, forKeyPath: "contentSize")
    }
    
    func getData()
    {
        var parameters:Parameters = [:]
        var callApi = ""
        if(callAction == ActionType.Edit)
        {
            callApi = API.EditUserRegistration
            parameters = [Key.UserCode: DataProvider.sharedInstance.userDetails.s_UserCode!,
                          Key.ActionTypes: callAction]
        }
        else if(callAction == ActionType.GetOrderNo)
        {
            callApi = API.GetLastOrderNo
            parameters = [Key.ActionType: callAction]
        }
        else if(callAction == ActionType.GetDealerCode)
        {
            callApi = API.GetRDDMDetailsmapping
            
            let data =  UserDefaults.standard.string(forKey: "UD_CODE")

            if data != "" {
                parameters = [Key.ActionType: callAction,
                                      Key.SkuCategory:data ?? "",//arr_ProductList[1].categoryCode!,
                                      Key.SalesOfficeCode: saleOffice_CODE,
                                      Key.UserCode: DataProvider.sharedInstance.userDetails.s_UserCode!]
            }
    
        }
        
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: callApi, parameters: parameters, viewcontroller: self, actionType: callAction)
    }
    
    @IBAction func btn_selectOption_pressed(_ sender: UIButton)
    {
        txt_responder = txt_selectOption
        showOption()
    }
    
    
    func validate() -> Bool
    {
        if arr_ProductList.count == 0
        {
            showAlert(msg: "productNotFound".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
            return false
        }
        else if txt_selectOption.text == ""
        {
            
            showAlert(msg: "selectDealer".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
            return false
        }
         else if txt_selectOption.text == "Other"
              {
                  txt_delerNameTop.constant = 16
                  txt_delarNameHeight.constant = 40
                  if txt_dealerName.text == ""
                  {
                      showAlert(msg: "enterDealerName".localizableString(loc:
                          UserDefaults.standard.string(forKey: "keyLang")!))
                      return false
                  }
                  else if txt_dealerMobile.text == ""
                  {
                      showAlert(msg: "enterDealerMobile".localizableString(loc:
                          UserDefaults.standard.string(forKey: "keyLang")!))
                      return false
                  }
              }
              
              if txt_expectedDate.text == ""
              {
                  showAlert(msg: "enterDate".localizableString(loc:
                      UserDefaults.standard.string(forKey: "keyLang")!))
                  return false
              }
              else if txt_remark.text == ""{
                        
                            showAlert(msg: "enterRemark".localizableString(loc:
                                UserDefaults.standard.string(forKey: "keyLang")!))
                            return false
              }
               else
               {
                            return true
                }
            
          }
    
    @IBAction func btn_submit_pressed(_ sender: UIButton)
    {
        if validate()
        {
            var arrOder = [Order]()
            for product in appDelegate.arr_UpdatedDelegate_ProductList
            {
                let order = Order()
                order.SkuCategory = product.categoryCode!
                order.IsDivisinMaterial = ""
                order.SkuSubCategory = ""
                order.SearchCategory = ""
                order.DealerCodeName = txt_dealerName.text!
                order.DealerMobile = txt_dealerMobile.text!
                order.ExpDeliveryDate = txt_expectedDate.text!
                order.skucode = product.code!
                order.QTY = "\(product.qty)"
                order.AMT = "\(product.amount)"
                order.MobileNo = DataProvider.sharedInstance.userDetails.s_MobileNo!
                order.DealerCode = dealer.s_RetailerSapCode
                order.Dates = txt_expectedDate.text!
                order.ActionType = ActionType.Insert
                order.CreatedBy = DataProvider.sharedInstance.userDetails.s_MobileNo!
                order.OrderNo = ORDER_ID.uppercased()
                order.EmpCode = ""
                order.SalesOfficeCode = saleOffice_CODE
                order.UserCode = DataProvider.sharedInstance.userDetails.s_UserCode!
                order.Remark = txt_remark.text!
                order.OrderType = self.selectedOrderType
                order.Source = Source
                
                arrOder.append(order)
            }
            
            do {
                let jsonData = try JSONEncoder().encode(arrOder)
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                }
                
                callAction = API.InsUpdSKUProductDetails
                
                let parser = Parser()
                parser.delegate = self
                parser.callHTTPDataAPI(api: API.InsUpdSKUProductDetails, postData: jsonData, viewcontroller: self)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func showOption()
    {

       if arr_DealerCode != [] && arr_DealerCode != nil{
        
            selectDropDown.dataSource = arr_DealerCode.map{$0.s_FullName} as! [String]

                  selectDropDown.anchorView = txt_selectOption

                  txt_expectedDate.isEnabled = true
                  txt_remark.isEnabled = true
                  selectDropDown.show()
       }else{
         exitPARTNER()
     }
        
    }
    
    func exitPARTNER()
          {
              let alert = UIAlertController(title: appName, message: "NOPARTNERAVAILABLE".localizableString(loc:
                  UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
              let actionYes = UIAlertAction(title: "OK".localizableString(loc:
                  UserDefaults.standard.string(forKey: "keyLang")!),
                                            style: .default,
                                            handler: self.yesTap)
              alert.addAction(actionYes)
           
              self.present(alert, animated: true, completion: nil)
          }
          
          @objc func yesTap(alert: UIAlertAction!)
          {
              
              arr_ProductList = []
              arr_ProductList.removeAll()
              
              appDelegate.arr_UpdatedDelegate_ProductList = []
              appDelegate.arr_UpdatedDelegate_ProductList.removeAll()
              print(arr_ProductList.count)
              self.tableview_Order.reloadData()
              
              self.navigationController?.popToRootViewController(animated: true)
          }
}

extension OrderDetailViewController
{
    func didRecivedAppCredentailFali(msg: String)
    {
        alertTag = -1
        showAlert(msg: msg)
    }
    
    func didRecived_AppCredentail(appCredentail: AppCredential)
    {
        if appCredentail.actionType == ActionType.CheckIMEI
        {
            if (appCredentail.isIMEIExit)
            {
                let userStatus = Parser.checkUsertType(usertype: appCredentail.usertype, userStatus: appCredentail.userStatus, viewController: self)
                if (userStatus.0)
                {
                    callAction = ActionType.Edit
                    getData()
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
    }
    
    func didRecivedRespoance(api: String, parser: Parser, json: Any)
    {
        if(callAction == API.InsUpdSKUProductDetails)
        {
            let alertMessage = JSON(json)
            
            print(alertMessage)
            
            if alertMessage["ResponseCode"].stringValue == "00"{
                alertTag = 1
                showSuccessMsg(msg: alertMessage["ResponseMessage"].stringValue)
                //                exitAlert2(msg: alertMessage["ResponseMessage"].stringValue)
                
            }
            
        }
            
        else if (parser.isSuccess(result: json as! [String:Any]))
        {
            if  let ResponseData = parser.responseData as? String,
                let jsonData = ResponseData.data(using: String.Encoding.utf8)
            {
                if(callAction == ActionType.Edit)
                {
                    if  let json = ResponseData.parseJSONString as? [String:Any],
                        let s_MdmCode = json["s_MdmCode"] as? String,
                        let SalesOfficeCode = json["SalesOfficeCode"] as? String
                    {
                        MDM_CODE = s_MdmCode
                        saleOffice_CODE = SalesOfficeCode
                        
                        callAction = ActionType.GetOrderNo
                        getData()
                    }
                    else
                    {
                        showAlert(msg: "valueNotFound".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                }
                else if(callAction == ActionType.GetOrderNo)
                {
                    if  let json = ResponseData.parseJSONString as? [String:Any],
                        let LastOrderNo = json["LastOrderNo"] as? String
                    {
                        lastOrderNo = LastOrderNo
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dMMMyy/hh:mm"
                        let dstr = dateFormatter.string(from: Date())
                        
                        ORDER_ID = MDM_CODE + "/" + dstr + "/" + lastOrderNo
                        lbl_orderNumber.text = "ORDER_ID : \(ORDER_ID)".uppercased()
                        
                        callAction = ActionType.GetDealerCode
                        getData()
                    }
                }
                else if(callAction == ActionType.GetDealerCode)
                {
                    self.arr_DealerCode = try? JSONDecoder().decode([Dealer].self, from: jsonData)
                    let dc = Dealer()
                    dc.s_FullName = "Other"
                    dc.s_RetailerSapCode = "Other"
                    if((self.arr_DealerCode) == nil)
                    {
                        self.arr_DealerCode = [dc]
                    }
                    else
                    {
                        print(arr_DealerCode.count)
                        // self.arr_DealerCode.insert(dc, at: 0)
                    }
                }
            }
            else if parser.responseData != nil
            {
                if(callAction == ActionType.GetDealerCode)
                {
                    if((self.arr_DealerCode) == nil)
                    {
                        let dc = Dealer()
                        dc.s_FullName = "Other"
                        dc.s_RetailerSapCode = "Other"
                        self.arr_DealerCode = [dc]
                    }
                }
                else
                {
                    showAlert(msg: parser.responseMessage)
                }
            }
            else
            {
                showAlert(msg: parser.responseMessage)
            }
        }
        else
        {
            showAlert(msg: parser.responseMessage)
        }
    }
    
    func showSuccessMsg(msg : String)
    {
        let alert = UIAlertController(title: appName, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "YES",
                                      style: .default,
                                      handler: self.onYes)
        alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "NO".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                     style: .default,
                                     handler: self.onNo)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @objc  func onYes(alert: UIAlertAction!)
    {
        
        arr_ProductList = []
        arr_ProductList.removeAll()
        
        appDelegate.arr_UpdatedDelegate_ProductList = []
        appDelegate.arr_UpdatedDelegate_ProductList.removeAll()
        print(arr_ProductList.count)
        self.tableview_Order.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc  func onNo(alert: UIAlertAction!)
    {
        arr_ProductList = []
        arr_ProductList.removeAll()
        
        appDelegate.arr_UpdatedDelegate_ProductList = []
        appDelegate.arr_UpdatedDelegate_ProductList.removeAll()
        print(arr_ProductList.count)
        self.tableview_Order.reloadData()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func onOkPressed(alert: UIAlertAction!)
    {
        if alertTag == -1
        {
            removeAppSession()
            _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PasswordViewController)
        }
        else if(alertTag == 1)
        {
            delegate?.didOrderDone()
            self.navigationController?.popViewController(animated: true)
        }
        else if alertTag == 2
        {
            //exit(0)
            removeAppSession()
            _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PasswordViewController)
        }
    }
}

extension OrderDetailViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        let product = arr_ProductList[textField.tag]
        
        let qty = Int(textField.text!)
        
        let currentCharacterCount = textField.text!.count
        if (currentCharacterCount == 0)
        {
            if (string == "0")
            {
                return false
            }
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 5
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if (textField == txt_selectOption)
        {
            txt_responder = txt_selectOption
            showOption()
            return false
        }
        else if(textField == txt_expectedDate)
        {
            DatePicker(sender: textField, tag: 1)
        }
        else if textField == txt_dealerName || textField == txt_dealerMobile
        {
            if(txt_selectOption.text == "Other")
            {
                return true
            }
            else
            {
                showAlert(msg: "selectDealer".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
                return false
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
        
    {
        
        if textField.tag != -1{
            
            let product = arr_ProductList[textField.tag]
            
            if let qty = Int(textField.text!)
            {
                product.qty = qty
            }
            else
            {
                product.qty = 0
            }
            product.amount =  product.price! * Double(product.qty)
            
            let oderList = arr_ProductList.filter({$0.qty > 0})
            self.lbl_ttlSku.text = "TTL SKU : \(oderList.count)"
            self.lbl_ttlQty.text = "TTL QTY : \(arr_ProductList.map({$0.qty}).reduce(0, +))"
            self.lbl_ttlAmt.text = "TTL AMT : \(arr_ProductList.map({$0.amount}).reduce(0, +))"
            arr_ProductList[textField.tag] = product
            
            appDelegate.arr_UpdatedDelegate_ProductList[textField.tag] = product
            let ip = IndexPath(row: textField.tag, section: 0)
            tableview_Order.reloadRows(at: [ip], with: .automatic)
        }
    }
    
}

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arr_ProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let product = arr_ProductList[indexPath.row]
        
        let material = "\(product.name!)_\(product.code!)"//"-\(product.discount!)(\(product.unit?.trim() ?? ""))"
        print(material)
        
        if product.unit?.trim() != nil{
            self.myData = ""//"-(\(product.unit!.trim()))"
        }else{
            self.myData = ""
        }
        let mydata2 = "_\(product.code!)"
        
        //Making dictionaries of fonts that will be passed as an attribute
        
        let yourAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.blue]
        let yourOtherAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
        let yourOtherAttributes1: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red]
        
        let partOne1 = NSMutableAttributedString(string: product.name!, attributes: yourAttributes)
        let partOne2 = NSMutableAttributedString(string:mydata2, attributes: yourOtherAttributes)
        let partOne4 = NSMutableAttributedString(string: myData, attributes: yourOtherAttributes1)
        
        partOne1.append(partOne2)
        partOne1.append(partOne4)
        
       // cell.lbl_oderName.attributedText = partOne1
        cell.lbl_oderName.text = material //product.name!
        cell.lbl_oderName.numberOfLines = 0
        cell.lbl_amount.text = ""
        
        cell.txt_qty.isEnabled = true
        if product.qty > 0
        {
            cell.txt_qty.text = "\(product.qty)"
        }
        else
        {
            cell.txt_qty.text = ""
        }
        cell.txt_qty.delegate = self
        cell.txt_qty.tag = indexPath.row
        cell.lbl_amount.text = "\(product.amount)"
        
        cell.lbl_Price.text = "\(product.price ?? 0.0)"
        
        
        cell.btn_Delete.tag = indexPath.row
        cell.btn_Delete.addTarget(self, action: #selector(deleteBtnTapped(_ :)), for: .touchUpInside)
        
        // corner radius
             cell.viewCurve.layer.cornerRadius = 10

          //   cell.viewCurve.roundCorners([.bottomRight], radius: 10)
             // shadow
             cell.viewCurve.layer.shadowColor = UIColor.gray.cgColor
             cell.viewCurve.layer.shadowOffset = CGSize(width: 3, height: 3)
             cell.viewCurve.layer.shadowOpacity = 0.7
             cell.viewCurve.layer.shadowRadius = 3.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DemoHeaderView") as! DemoHeaderView
        
        headerView.lbl_oderName.numberOfLines = 0
        headerView.lbl_qty.numberOfLines = 0
        headerView.lbl_amount.numberOfLines = 0
        
        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        headerView.lbl_oderName.font = font
        headerView.lbl_qty.font = font
        headerView.lbl_amount.font = font
        headerView.lbl_oderName.text = hName
        headerView.lbl_qty.text = hQty
        headerView.lbl_amount.text = hAmount
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
//        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DemoHeaderView") as? DemoHeaderView
//        {
//            headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 58)
//
//            let font = UIFont.systemFont(ofSize: 16, weight: .medium)
//            let name_height = hName.height(withConstrainedWidth: headerView.lbl_oderName.frame.width, font: font)
//            let qty_height = hQty.height(withConstrainedWidth: headerView.lbl_qty.frame.width, font: font)
//            let amount_height = hName.height(withConstrainedWidth: headerView.lbl_amount.frame.width, font: font)
//
//            let largest = max(max(name_height, qty_height), amount_height)
//
//            return largest + 16
//        }
        return 0
    }
    
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    //    {
    //        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DemoHeaderView") as! DemoHeaderView
    //
    //        headerView.lbl_oderName.numberOfLines = 0
    //        headerView.lbl_qty.numberOfLines = 0
    //        headerView.lbl_amount.numberOfLines = 0
    //
    //        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
    //        headerView.lbl_oderName.font = font
    //        headerView.lbl_qty.font = font
    //        headerView.lbl_amount.font = font
    //        headerView.lbl_oderName.textColor = .black
    //        headerView.lbl_qty.textColor = .black
    //        headerView.lbl_amount.textColor = .black
    //        headerView.backgroundColor = .clear
    //        headerView.lbl_oderName.text = ""
    //        headerView.lbl_qty.text = "Total"
    //        headerView.lbl_qty.backgroundColor = .white
    //        headerView.lbl_amount.backgroundColor = .lightGray
    //        headerView.lbl_oderName.backgroundColor = .white
    //        headerView.lbl_amount.layer.borderWidth = 0
    //        headerView.lbl_oderName.layer.borderWidth = 0
    //        headerView.lbl_qty.layer.borderWidth = 0
    //
    //
    //        let totalSum = arr_ProductList.map({$0.amount}).reduce(0, +)
    //        headerView.lbl_amount.text = "\(totalSum)"
    //
    //        return headerView
    //    }
    //
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    //    {
    //        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DemoHeaderView") as? DemoHeaderView
    //        {
    //            headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 58)
    //            let font = UIFont.systemFont(ofSize: 16, weight: .medium)
    //            let name_height = "".height(withConstrainedWidth: headerView.lbl_oderName.frame.width, font: font)
    //            let qty_height = "Total".height(withConstrainedWidth: headerView.lbl_qty.frame.width, font: font)
    //            let totalSum = arr_ProductList.map({$0.amount}).reduce(0, +)
    //            let amount_height = "\(totalSum)".height(withConstrainedWidth: headerView.lbl_amount.frame.width, font: font)
    //
    //            let largest = max(max(name_height, qty_height), amount_height)
    //
    //            return largest + 16
    //        }
    //        return 0
    //    }
    
    @objc func deleteBtnTapped(_ sender : UIButton){
        
        let myIndex = IndexPath(item: sender.tag, section: 0)
        
        presentDeletionFailsafe(indexPath: myIndex)
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presentDeletionFailsafe(indexPath: indexPath)
        }
    }
    
    func presentDeletionFailsafe(indexPath: IndexPath) {
        
        let alert = UIAlertController(title: appName, message: "doyouwanttodelete".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
        // yes action
        let yesAction = UIAlertAction(title: "YES", style: .default) { _ in
            // replace data variable with your own data array
            self.arr_ProductList.remove(at: indexPath.row)
            appDelegate.arr_UpdatedDelegate_ProductList.remove(at: indexPath.row)
            //self.arr_ProductList = appDelegate.arr_UpdatedDelegate_ProductList
            self.tableview_Order.beginUpdates()
            self.tableview_Order.deleteRows(at: [indexPath], with: .fade)
            self.tableview_Order.endUpdates()
            self.tableview_Order.reloadData()
            appDelegate.arr_UpdatedDelegate_ProductList = self.arr_ProductList  //chetanChange
            
            let oderList = self.arr_ProductList.filter({$0.qty > 0})
            self.lbl_ttlSku.text = "TTL SKU : \(oderList.count)"
            self.lbl_ttlQty.text = "TTL QTY : \(self.arr_ProductList.map({$0.qty}).reduce(0, +))"
            self.lbl_ttlAmt.text = "TTL AMT : \(self.arr_ProductList.map({$0.amount}).reduce(0, +))"
            
            if self.arr_ProductList.count == 0{
                self.arr_ProductList.removeAll()
                self.arr_ProductList = []
                appDelegate.arr_UpdatedDelegate_ProductList = []
                appDelegate.arr_UpdatedDelegate_ProductList.removeAll()
                
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
        alert.addAction(yesAction)
        
        // cancel action
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension Array {
    func removingDuplicates<T: Hashable>(byKey key: (Product) -> T)  -> [Product] {
        var result = [Product]()
        var seen = Set<T>()
        for value in self {
            if seen.insert(key(value as! Product)).inserted {
                result.append(value as! Product)
            }
        }
        return result
    }
}
