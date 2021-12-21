//
//  OrderCartDetailsViewController.swift
//  USHA Retailer
//
//  Created by Rahul on 23/07/21.
//  Copyright © 2021 Apple.Inc. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import NotificationCenter
import CoreData
import SnapKit


@objc protocol OrderDoneDelegate: AnyObject
{
    @objc func didOrderDone()
}

protocol backViewDelegate
{
     func childViewControllerResponse(product_arr :[Product])
}


protocol  getValidationDelegate  {
    func validate()->Bool
    func prodValidate()->Bool
}

class OrderCartDetailsViewController: BaseViewController, setTTLViewDelegate {
   
    
    
    
    @IBOutlet weak var btn_submitOrderDone: UIButton!
    
    @IBOutlet weak var btn_cancelOrder: UIButton!
    
    @IBOutlet weak var btn_addProducts: UIButton!
    
    
    @IBOutlet weak var tblView_orderCartDetails: UITableView!
    
    @IBOutlet weak var ttl_Sku: UILabel!
    
    @IBOutlet weak var ttl_Qty: UILabel!
    
    @IBOutlet weak var ttl_Amt: UILabel!
    
    
    @IBOutlet weak var txt_expectedDate: SkyFloatingLabelTextField!
    @IBOutlet weak var expectedDateHeightConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var txt_remark: SkyFloatingLabelTextField!
    
    var blurVisualEffectView: UIVisualEffectView!

    var arr_DealerCode:[Dealer]!
    var arr_ProductList:[Product]!
    var arr_div:[Division]!
    var divisionText:String!
    var arr_Updated_ProductList:[Product] = []
    var arr_Duplicates_ProductList:[Product] = []

    var txt_responder:SkyFloatingLabelTextField!
    var selectDropDown = DropDown()
    var datePickerView:UIDatePicker!
    
    var validateDelegate : getValidationDelegate?
    
    var expectedDate:Date!
    var selectedOrderType = ""
    var callAction = ""
    var SkuCategory:Division!
    var SkuSubCategory:Division!
    var dealer:Dealer!
    var alertTag = 0
      
      var MDM_CODE = ""
      var saleOffice_CODE = ""
      var lastOrderNo = ""
      var ORDER_ID = ""
      var selectedTAG : Int = 0
    var arr_orderId = [String]()

    
    var dateTag = Int()
    var optionTag = Int()
    
    var delegate: OrderDoneDelegate?
    var backDelegate: backViewDelegate?
    
    var categoryNames = [String]()
    var info = [String:[Product]]()
    
    var dealerinfo = [String:[Dealer]]()
    
    var arr_allProduct = [[Product]]()
    
    var arr_dealer = [Dealer]()
    
    var arr_dealerName = [String]()

    var parameters:Parameters = [:]
    
    var orderIdString = String()

    var arr_product = [[Product]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let attributes = [
//            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14.0) // Note the !
        ]

        txt_remark.attributedPlaceholder = NSAttributedString(string: "REMARK*", attributes:attributes)
        
        
        setTTlView()
        
        btn_addProducts.titleLabel?.numberOfLines = 0
        btn_addProducts.titleLabel?.lineBreakMode = .byWordWrapping
        btn_addProducts.titleLabel?.textAlignment = .center
        self.btn_addProducts.setTitle("ADD MORE PRODUCT", for: .normal)

        
        self.txt_expectedDate.delegate = self
        self.txt_remark.delegate = self
        
        self.txt_remark.validateOnResign = false
       print(arr_ProductList)
        print(SkuCategory)
        for element in arr_ProductList! {
          // element.categoryName = divisionText
            print(element.categoryName)
                   if let catName = element.categoryName{
                       
                       if !categoryNames.contains(catName) {
                           categoryNames.append(catName)
                       }
                   }
               }
      
        
        print(categoryNames)
               for categoryName in categoryNames {
                   var arrayProduct = [Product]()
                print(categoryName)
                   for element in arr_ProductList {
                    print(element.categoryName)
                       if element.categoryName! == categoryName {
                           arrayProduct.append(element)
                       }
                   }
                   info[categoryName] = arrayProduct
               }

        for ele in info {
            self.arr_allProduct.append(ele.value)
        }
        
        
        
//        for ele in arr_allProduct {
//            for catname in categoryNames  {
//
//            if ele.first?.categoryName == catname  {
//                    self.arr_product.append(ele)
//            }else {
//                //cell.arr_product = arr_allProduct[indexPath.row]
//
//            }
//        }
//        }
        
        
        
//        self.tblView_orderCartDetails.reloadData()
        //hide it when getlastorderwill run
//        setupDropDown()
        
        let withoutDuplicates = arr_ProductList.removingDuplicate(byKey: { $0.code })
        
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
            print(index1.categoryName)
            newProduct.categoryName = index1.categoryName
            
            arr_Updated_ProductList.append(newProduct)
        }
        
        
        print(arr_Updated_ProductList)
        
        arr_ProductList = arr_Updated_ProductList
        
        
        appDelegate.arr_UpdatedDelegate_ProductList = arr_ProductList
//        tblView_orderCartDetails.reloadData()
        
        let headerNib = UINib.init(nibName: "DemoHeaderView", bundle: Bundle.main)
        tblView_orderCartDetails.register(headerNib, forHeaderFooterViewReuseIdentifier: "DemoHeaderView")

    }
    
    func loadTableView() {
        self.categoryNames.removeAll()
        for element in appDelegate.arr_UpdatedDelegate_ProductList {
                   print(element.categoryName)
                   if let catName = element.categoryName{
                       
                       if !categoryNames.contains(catName) {
                           categoryNames.append(catName)
                       }
                   }
               }

        self.tblView_orderCartDetails.reloadData()
       }
    
    
    func setTTlView(){
        let oderList = appDelegate.arr_UpdatedDelegate_ProductList.filter({$0.qty > 0})
               
               self.ttl_Sku.text = "TTL PRD \n \(oderList.count)"
               self.ttl_Qty.text = "TTL QTY \n \(appDelegate.arr_UpdatedDelegate_ProductList.map({$0.qty}).reduce(0, +))"
               
               let formatter = NumberFormatter()
               formatter.numberStyle = .decimal
               formatter.minimumFractionDigits = 2
               formatter.maximumFractionDigits = 2
               
               if let roundedPriceString = formatter.string(for: appDelegate.arr_UpdatedDelegate_ProductList.map({$0.amount}).reduce(0, +)) {
               self.ttl_Amt.text = "TTL AMT \n \(roundedPriceString)"
               }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//               self.txt_delerNameTop.constant = 0
//               self.txt_delarNameHeight.constant = 0
//               self.txt_delarMobileTop.constant = 0
//               self.txt_delarMobileNoHeight.constant = 0
        
        
        
               callAction = ActionType.Edit
               getData()
               LanguageChanged(strLan:keyLang)
        expectedDateHeightConstraint.constant = 0
            
//                self.tblView_orderCartDetails.reloadData()
        
    }
    
  
    
    func LanguageChanged(strLan:String){
        
//           lbl_pleaseSelect.text = "Please select the following option for order processing".uppercased().localizableString(loc:
//               UserDefaults.standard.string(forKey: "keyLang")!)
        //   btn_submitOrderDone.setTitle("SubmitOrder".uppercased().localizableString(loc:
           //    UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
           

       }
    override func onBackButtonPressed(_ sender: UIButton)
     {
        let result = validateDelegate?.prodValidate()
        if result == true {
         exitAlert1()
        }else {
            
        }
         //self.navigationController?.popViewController(animated: true)
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
        
        if selectedTAG == 2{
                  arr_ProductList = []
                   arr_ProductList.removeAll()
                   
                   appDelegate.arr_UpdatedDelegate_ProductList = []
                   appDelegate.arr_UpdatedDelegate_ProductList.removeAll()
                   appDelegate.arr_updatedDealerList = []
                   appDelegate.arr_updatedDealerList.removeAll()
                   appDelegate.dealerDict.removeAll()

                   print(arr_ProductList.count)
                   self.tblView_orderCartDetails.reloadData()
                   UserDefaults.standard.removeObject(forKey: "DivisionValue")
            
                   self.navigationController?.popViewController(animated: true)

        }else{
           
        backDelegate?.childViewControllerResponse(product_arr: arr_ProductList)
        self.navigationController?.popViewController(animated: true)
        }
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
        appDelegate.arr_updatedDealerList = []
        appDelegate.arr_updatedDealerList.removeAll()
        appDelegate.dealerDict.removeAll()

        print(arr_ProductList.count)
        self.tblView_orderCartDetails.reloadData()
        UserDefaults.standard.removeObject(forKey: "DivisionValue")

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
        appDelegate.arr_updatedDealerList = []
        appDelegate.arr_updatedDealerList.removeAll()
        appDelegate.dealerDict.removeAll()

        print(arr_ProductList.count)
        self.tblView_orderCartDetails.reloadData()
        UserDefaults.standard.removeObject(forKey: "DivisionValue")

        let notificationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationViewController) as! NotificationViewController
        self.navigationController?.pushViewController(notificationVC, animated: true)    }
    
    @objc func noPressed3(alert: UIAlertAction!)
    {
    }
    
    //USED THIS FUNCTION IN CELL CALSS
        
    func setupDropDown()
    {

        let indexpath = IndexPath(row: optionTag, section: 0)
        let cell = tblView_orderCartDetails.cellForRow(at: indexpath) as! OrderDetailsTableViewCell

        selectDropDown.dismissMode = .automatic
        selectDropDown.separatorColor = .lightGray
//        selectDropDown.width = self.txt_responder.frame.width
        selectDropDown.bottomOffset = CGPoint(x: 0, y: cell.view_selectOption.bounds.height)
        selectDropDown.direction = .bottom
        selectDropDown.cellHeight = 30
        selectDropDown.backgroundColor = .white
        // Action triggered on selection
        selectDropDown.selectionAction = {(index, item) in
            if self.txt_responder  != nil{
                self.txt_responder.text = item
//                appDelegate.arr_UpdatedDelegate_ProductList[self.optionTag].dealerName = item
                
                let indexpath = IndexPath(row: self.optionTag, section: 0)
                let cell = self.tblView_orderCartDetails.cellForRow(at: indexpath) as! OrderDetailsTableViewCell
                
             
                    for arrEle in appDelegate.arr_UpdatedDelegate_ProductList {
                                for cat in self.categoryNames {
                                    if cell.lbl_division.text == cat && arrEle.categoryName == cell.lbl_division.text {
                                        print(item)
                            arrEle.dealerName = item
                        }
                    }
                }
               
                
            }
            self.dealer = self.arr_dealer[index]
            if let orderType = self.dealer.OrderType {
                self.selectedOrderType = orderType

            }else {
               self.selectedOrderType = "Not Applicable"
                
            }
//            if(item == "Other")
//            {
////                cell.txt_delerNameTop.constant = 16
////                cell.txt_delarNameHeight.constant = 40
//                cell.txt_dealerName.isEnabled = true
//                cell.txt_dealerMobile.isEnabled = true
//            }
//            else
//            {
////                self.txt_delerNameTop.constant = 0
////                self.txt_delarNameHeight.constant = 0
//                if let name = self.dealer.s_FullName,
//                    let mob = self.dealer.MobileNo,let orderType = self.dealer.OrderType
//                {
//                    cell.txt_dealerName.isEnabled = false
//                    cell.txt_dealerMobile.isEnabled = false
//                    cell.txt_dealerName.text = name
//                    cell.txt_dealerMobile.text = mob
//                    self.selectedOrderType = orderType
//                    print(self.selectedOrderType)
//                }
//                else
//                {
//                    self.showAlert(msg: "dealerNotFound".localizableString(loc:
//                        UserDefaults.standard.string(forKey: "keyLang")!))
//                }
//            }
        }
    }
    
    @IBAction func btn_Back_pressed(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btn_CancelORDER(_ sender: UIButton)
          {
               exitAlertCancel()
       
        }
       
       func exitAlertCancel()
       {
           let alert = UIAlertController(title: "", message: "CancelORDER".localizableString(loc:
               UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
           let actionYes = UIAlertAction(title: "YES".localizableString(loc:
               UserDefaults.standard.string(forKey: "keyLang")!),
                                         style: .default,
                                         handler: self.yes1Pressed1)
           alert.addAction(actionYes)
           
           let actionNo = UIAlertAction(title: "NO".localizableString(loc:
               UserDefaults.standard.string(forKey: "keyLang")!),
                                        style: .destructive,
                                        handler: self.no1Pressed1)
           alert.addAction(actionNo)
           
           self.present(alert, animated: true, completion: nil)
       }
       
       @objc func yes1Pressed1(alert: UIAlertAction!)
       {
           
           arr_ProductList = []
           arr_ProductList.removeAll()
           
           appDelegate.arr_UpdatedDelegate_ProductList = []
           appDelegate.arr_UpdatedDelegate_ProductList.removeAll()
        appDelegate.arr_updatedDealerList = []
        appDelegate.arr_updatedDealerList.removeAll()
        appDelegate.dealerDict.removeAll()

           print(arr_ProductList.count)
           self.tblView_orderCartDetails.reloadData()
           UserDefaults.standard.removeObject(forKey: "DivisionValue")

           self.navigationController?.popToRootViewController(animated: true)
       }
       
       @objc func no1Pressed1(alert: UIAlertAction!)
       {
       }
    
    //change this to @objc func in cell for row class hide because it there is no button on select date
    
    @objc func btn_selectedDate_pressed(_ sender: UIButton)
    {
        _ = txt_expectedDate.becomeFirstResponder()
    }
    
    //used following three functions in cell class
    
    func DatePicker(sender:UITextField, tag:Int)
    {
        datePickerView = UIDatePicker()
        datePickerView.tag = tag
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        dateTag = tag
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:tag:)), for: .valueChanged)
        datePickerView.minimumDate = Date()
    }

    @objc func handleDatePicker(sender: UIDatePicker, tag: Int)
    {


//        let indexpath = IndexPath(row: dateTag, section: 0)
//        let cell = tblView_orderCartDetails.cellForRow(at: indexpath) as! OrderDetailsTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        //if cell.txt_expectedDate.tag == dateTag {
            expectedDate = sender.date
            self.txt_expectedDate.text = dateFormatter.string(from: sender.date)
            //            appDelegate.arr_UpdatedDelegate_ProductList[dateTag].dealDate = dateFormatter.string(from: sender.date)

//           let indexpath = IndexPath(row: self.optionTag, section: 0)
//            let cell = self.tblView_orderCartDetails.cellForRow(at: indexpath) as! OrderDetailsTableViewCell
//
//
//                for arrEle in appDelegate.arr_UpdatedDelegate_ProductList {
//                    for cat in self.categoryNames {
//                        if cell.lbl_division.text == cat && arrEle.categoryName == cell.lbl_division.text {
//                        arrEle.dealDate = dateFormatter.string(from: sender.date)
//                    }
//                }
//            }

        //}
    }

    @objc func doneButtonClicked(_ sender: Any)
    {
        //your code when clicked on done
        handleDatePicker(sender: datePickerView, tag: dateTag)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
      {
          if let obj = object as? UITableView {
              if obj == self.tblView_orderCartDetails && keyPath == "contentSize" {
                  if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                      //do stuff here
                    //change take tableview  height constant here hiding it because now there are all things in  tableview
//                      self.tblView_orderCartDetails.constant = newSize.height
                  }
              }
          }
      }
      
//      deinit {
//          self.tblView_orderCartDetails.removeObserver(self, forKeyPath: "contentSize")
//      }
    
   //used in cell class
//    func showOption()
//    {
//        arr_dealer.removeAll()
//        arr_dealerName.removeAll()
//        let indexpath = IndexPath(row: optionTag, section: 0)
//        let cell = tblView_orderCartDetails.cellForRow(at: indexpath) as! OrderDetailsTableViewCell
//
//        let arr = appDelegate.arr_updatedDealerList
//
//
//        for element in arr {
//            if element.categoryName == cell.lbl_division.text {
//                if !arr_dealer.contains(element) {
//                    arr_dealer.append(element)
//                }
//            }
//        }
//
//        for ele in arr_dealer {
//            if arr_dealerName.count == 0 {
//                arr_dealerName.append(ele.s_FullName!)
//            }else {
//                if !arr_dealerName.contains(ele.s_FullName!) {
//                     arr_dealerName.append(ele.s_FullName!)
//                }
//            }
//        }
//
//
////        selectDropDown.dataSource = arr_dealer.map{$0.s_FullName} as! [String]
//        selectDropDown.dataSource = arr_dealerName
//
//        selectDropDown.anchorView = cell.txt_selectOption
//
//        cell.txt_expectedDate.isEnabled = true
//        cell.txt_remark.isEnabled = true
//        selectDropDown.show()
//
//    }
    
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
            parameters = [Key.ActionType: callAction,
                          Key.SkuCategory: arr_ProductList[0].categoryCode!,
                          Key.SalesOfficeCode: saleOffice_CODE,
                          Key.UserCode: DataProvider.sharedInstance.userDetails.s_UserCode!]
        }
        
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: callApi, parameters: parameters, viewcontroller: self, actionType: callAction)
    }
    
    
   @objc func btn_selectOption_pressed(_ sender: UIButton)
      {
//          showOption()
      }
    
    func exitPARTNER(msg : String)
         {
          let blurEffect = UIBlurEffect(style: .light)
          self.blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
          self.blurVisualEffectView.frame = CGRect(x: 0, y:65, width: view.bounds.width, height: view.bounds.height)
          self.blurVisualEffectView.backgroundColor = UIColor(white: 1.0, alpha: 0.9)

          
             let alert = UIAlertController(title: "", message: "\(msg)".localizableString(loc:
                 UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
             let actionYes = UIAlertAction(title: "OK".localizableString(loc:
                 UserDefaults.standard.string(forKey: "keyLang")!),
                                           style: .default,
                                           handler: self.yesTap)
             alert.addAction(actionYes)
            self.view.addSubview(blurVisualEffectView)
             self.present(alert, animated: true, completion: nil)
         }
         
         @objc func yesTap(alert: UIAlertAction!)
         {
             arr_ProductList = []
             arr_ProductList.removeAll()
             
             appDelegate.arr_UpdatedDelegate_ProductList = []
             appDelegate.arr_UpdatedDelegate_ProductList.removeAll()
             appDelegate.arr_updatedDealerList = []
             appDelegate.arr_updatedDealerList.removeAll()
            appDelegate.dealerDict.removeAll()

             print(arr_ProductList.count)
             self.tblView_orderCartDetails.reloadData()
             UserDefaults.standard.removeObject(forKey: "DivisionValue")
              self.blurVisualEffectView.removeFromSuperview()

             self.navigationController?.popViewController(animated: true)
         }
    
    @objc func funcValidate() -> Bool
    {
       let result = validateDelegate?.validate()
        
        if result == true {
            for i in 0...categoryNames.count-1 {
    //
                let indexpath = IndexPath(row: i, section: 0)
                let cell = tblView_orderCartDetails.cellForRow(at: indexpath) as! OrderDetailsTableViewCell
//            if self.txt_expectedDate.text == ""
//            {
//                showAlert(msg: "enterDate".localizableString(loc:
//                    UserDefaults.standard.string(forKey: "keyLang")!))
//                return false
//            }

//                if self.txt_remark.text == ""{
//
//                showAlert(msg: "enterRemark".localizableString(loc:
//                    UserDefaults.standard.string(forKey: "keyLang")!))
//                return false
//                }
                    if cell.txt_remark.text == ""{
                        
                        //showAlert(msg: "enterRemark".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!))
                        return false
                    }
                    else {
                    return true

                }
            }
        }else {
            return false
        }
        
//        for i in 0...categoryNames.count-1 {
////
//            let indexpath = IndexPath(row: i, section: 0)
//            let cell = tblView_orderCartDetails.cellForRow(at: indexpath) as! OrderDetailsTableViewCell
////
////            if arr_ProductList.count == 0
////            {
////                showAlert(msg: "productNotFound".localizableString(loc:
////                    UserDefaults.standard.string(forKey: "keyLang")!))
////                return false
////            }
////            else if cell.txt_selectOption.text == ""
////            {
////
////                showAlert(msg: "selectDealer".localizableString(loc:
////                    UserDefaults.standard.string(forKey: "keyLang")!))
////                return false
////            }
////            else if cell.txt_selectOption.text == "Other"
////            {
////                //                txt_delerNameTop.constant = 16
////                //                txt_delarNameHeight.constant = 40
////                //                if txt_dealerName.text == ""
////                //                {
////                //                    showAlert(msg: "enterDealerName".localizableString(loc:
////                //                        UserDefaults.standard.string(forKey: "keyLang")!))
////                //                    return false
////                //                }
////                //                else if txt_dealerMobile.text == ""
////                //                {
////                //                    showAlert(msg: "enterDealerMobile".localizableString(loc:
////                //                        UserDefaults.standard.string(forKey: "keyLang")!))
////                //                    return false
////                //                }
////            }
////
////            if cell.txt_expectedDate.text == ""
////            {
////                showAlert(msg: "enterDate".localizableString(loc:
////                    UserDefaults.standard.string(forKey: "keyLang")!))
////                return false
////            }
////             if cell.txt_remark.text == ""{
////
////                showAlert(msg: "enterRemark".localizableString(loc:
////                    UserDefaults.standard.string(forKey: "keyLang")!))
////                return false
////            }
//////            else
//////            {
//////                return true
//////            }
//        }
//
       return false
    }
    
    
    @IBAction func btn_addMoreProducts(_ sender: UIButton) {
        
        let result = validateDelegate?.prodValidate()
        
        if result == true {
        self.navigationController?.popViewController(animated: true)
        }else {
            
        }
        
    }
    
    @IBAction func btn_submit_pressed(_ sender: UIButton)
    {
        
        if funcValidate()
        {
//
//            var arrOder = [Order]()
//            var arr = appDelegate.arr_UpdatedDelegate_ProductList
//
//            for i in 0...categoryNames.count-1 {
//
//                let indexpath = IndexPath(row: i, section: 0)
//                let cell = tblView_orderCartDetails.cellForRow(at: indexpath) as! OrderDetailsTableViewCell
//
//
//                for catname in categoryNames {
//                    if catname == cell.lbl_division.text {
//
//                        for j in 0...arr.count-1 {
//                            let element = arr[j]
//                            if element.categoryName == cell.lbl_division.text {
//                                let order = Order()
//
//
//                                order.QTY = String(element.qty)
//                                order.AMT = String(element.amount)
//                                order.skucode = element.code
//                                order.SkuCategory = element.categoryCode
//
//
//                                order.OrderNo = arr_orderId[i].uppercased()
//
//                                //                        order.DealerCodeName = cell.txt_selectOption.text
//                                //                        order.ExpDeliveryDate = cell.txt_expectedDate.text
//                                //                        order.Dates = cell.txt_expectedDate.text
//                                //                        order.Remark = cell.txt_remark.text
//
//                                let dealr_arr = appDelegate.arr_updatedDealerList
//                                for dealerEle in dealr_arr {
//                                    if dealerEle.s_FullName == cell.txt_selectOption.text {
//                                        order.DealerMobile =  dealerEle.MobileNo
//                                        order.DealerCode = dealerEle.s_RetailerSapCode
//
//                                        order.DealerCodeName = cell.txt_selectOption.text
//                                        order.ExpDeliveryDate = cell.txt_expectedDate.text
//                                        order.Dates = cell.txt_expectedDate.text
//                                        order.Remark = cell.txt_remark.text
//
//                                    }
//                                }
//                                //                order.DealerMobile =
//
//                                order.UserCode = DataProvider.sharedInstance.userDetails.s_UserCode!
//                                order.CreatedBy = DataProvider.sharedInstance.userDetails.s_MobileNo!
//                                order.ActionType = ActionType.Insert
//                                order.Source = Source
//                                //                order.DealerCode =
//                                order.OrderType = self.selectedOrderType
//
//                                arrOder.append(order)
//                            }
//                        }
//                    }
//                }
//
//
//
//            }
//
//            do {
//                let jsonData = try JSONEncoder().encode(arrOder)
//
//                if let jsonString = String(data: jsonData, encoding: .utf8) {
//                    print(jsonString)
//                }
//
//                //            if let json = try JSONSerialization.jsonObject(with: jsonData, options : .allowFragments) as? [Dictionary<String,Any>]
//                //            {
//                //               print(json) // use the json here
//                //                callAction = API.InsUpdSKUProductDetails
//                //                parameters = json[0]
//                //                self.orderSubmitAPI(api: callAction, parameters: parameters, viewcontroller: self)
//                //            } else {
//                //                print("bad json")
//                //            }
//
//                callAction = API.InsUpdSKUProductDetails
//                //
////                let parser = Parser()
////                parser.delegate = self
////                parser.callHTTPDataAPI(api: callAction, postData: jsonData, viewcontroller: self)
//
//            } catch {
//                print(error.localizedDescription)
//            }

//        }
        
        
        
//        if validate()
//               {
//
                   var arrOder = [Order]()
//                   var arr = appDelegate.arr_UpdatedDelegate_ProductList

                   for i in 0...categoryNames.count-1 {

                       let indexpath = IndexPath(row: i, section: 0)
                       let cell = tblView_orderCartDetails.cellForRow(at: indexpath) as! OrderDetailsTableViewCell

                    let catelment = categoryNames[i]
                    //for catname in categoryNames {
                        
                        for j in 0...appDelegate.arr_UpdatedDelegate_ProductList.count-1 {
                             let element = appDelegate.arr_UpdatedDelegate_ProductList[j]
                            if catelment == element.divisionName {


                                print(element.divisionName)
                                if element.categoryName == element.divisionName {
                                    let order = Order()


                                    order.QTY = String(element.qty)
                                    order.AMT = String(element.amount)
                                    order.skucode = element.code
                                    order.SkuCategory = element.categoryCode

                                    //unhide it when orderid api works
//                                    order.OrderNo = arr_orderId[i].uppercased()

                                    //                        order.DealerCodeName = cell.txt_selectOption.text
                                    //                        order.ExpDeliveryDate = cell.txt_expectedDate.text
                                    //                        order.Dates = cell.txt_expectedDate.text
                                    order.Remark = cell.txt_remark.text //Change R

                                    let dealr_arr = appDelegate.arr_updatedDealerList
                                    for dealerEle in dealr_arr {
                                        //unhide this when order api works
                                        if dealerEle.s_FullName == element.dealerName {
                                            order.DealerMobile =  dealerEle.MobileNo
                                            order.DealerCode = dealerEle.s_RetailerSapCode

                                            order.DealerCodeName = element.dealerName
//                                            order.ExpDeliveryDate = self.txt_expectedDate.text
//                                            order.Dates = element.dealDate
//                                            order.Remark = element.remark
//                                            order.Dates = self.txt_expectedDate.text
                                            order.Remark = cell.txt_remark.text//self.txt_remark.text // Change R
                                        }
                                    }
                                    //                order.DealerMobile =

                                    order.UserCode = DataProvider.sharedInstance.userDetails.s_UserCode!
                                    order.CreatedBy = DataProvider.sharedInstance.userDetails.s_MobileNo!
                                    order.ActionType = ActionType.Insert
                                    order.Source = Source
                                    //                order.DealerCode =
                                    order.OrderType = element.orderType
                                        
                                    if arrOder.count > 0 {
                                        if !arrOder.contains(order) {
                                           arrOder.append(order)
                                        }
                                    }else {
                                    arrOder.append(order)
                                    }
                                }
                            

                            }

                        }
                    //}

                   }

                   do {
                       let jsonData = try JSONEncoder().encode(arrOder)

                       if let jsonString = String(data: jsonData, encoding: .utf8) {
                           print(jsonString)
                       }

                       //            if let json = try JSONSerialization.jsonObject(with: jsonData, options : .allowFragments) as? [Dictionary<String,Any>]
                       //            {
                       //               print(json) // use the json here
                       //                callAction = API.InsUpdSKUProductDetails
                       //                parameters = json[0]
                       //                self.orderSubmitAPI(api: callAction, parameters: parameters, viewcontroller: self)
                       //            } else {
                       //                print("bad json")
                       //            }

                       callAction = API.InsUpdSKUProductDetails
                       //
                       let parser = Parser()
                       parser.delegate = self
                    print(jsonData)
                       parser.callHTTPDataAPI(api: callAction, postData: jsonData, viewcontroller: self)

                   } catch {
                       print(error.localizedDescription)
                   }


               }//end of validate
    
    }

    
    func orderSubmitAPI(api:String, parameters:Parameters, viewcontroller:UIViewController)
    {
        print(parameters)
        let url = baseUrl + api
        viewcontroller.view.makeToastActivity(message: "Processing...")
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        manager.request(url, method : .post, parameters : parameters, encoding : JSONEncoding.default , headers : headers).responseJSON { response in
            DispatchQueue.main.async {

                print("URL : \(url)\nRESPONSE : \(response)")
                
                let resultVal = response.result.value!
                let json = JSON(resultVal)
                let responseMessage = json["ResponseMessage"]
                
                if responseMessage.stringValue == "Success" {
                   
                }
                viewcontroller.view.hideToastActivity()

            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension OrderCartDetailsViewController
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
//                for element in arr_orderId {
//                    if orderIdString.count > 0 {
//                        //if !orderIdString.contains(element) {
//                    orderIdString = orderIdString + "," + element
//                        //}
//                    } else {
//                        orderIdString = element
//                    }
//                }
//                let message = "DEAR RETAILER! YOUR ORDER NO.:\(orderIdString)  HAS BEEN SUBMITTED TO PARTNER SUCCESSFULLY.PARTNER WILL CONTACT YOU SHORTLY. DO YOU WANT TO PLACE ANOTHER ORDER."
                showSuccessMsg(msg: alertMessage["ResponseMessage"].stringValue.uppercased())
//                showSuccessMsg(msg: message)
                
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
//                        lbl_orderNumber.text = "ORDER_NO : \(ORDER_ID)".uppercased()
                        //hiding this because getting to dealer code messge
//                        callAction = ActionType.GetDealerCode
//                        getData()
                        self.tblView_orderCartDetails.reloadData()
//                        setupDropDown()
                    }
                }
                else if(callAction == ActionType.GetDealerCode)
                {
                    self.arr_DealerCode = try? JSONDecoder().decode([Dealer].self, from: jsonData)
                    
                    print(self.arr_DealerCode)
                  
                    if self.arr_DealerCode.count > 0{
                    if self.arr_DealerCode[0].FinalMsg != ""{
                        
                        exitPARTNER(msg : self.arr_DealerCode[0].FinalMsg ?? "")

                    }else{
                    
                    let dc = Dealer()
                    dc.s_FullName = "Other"
                    dc.s_RetailerSapCode = "Other"
                    if((self.arr_DealerCode) == nil)
                    {
                        self.arr_DealerCode = [dc]
                    }
                    else
                    {
                        print("Count of dealer Code Array = \(arr_DealerCode.count)")
                        // self.arr_DealerCode.insert(dc, at: 0)
                    }
                }
                    }else{
                        //change to api message
                        exitPARTNER(msg : "NOPARTNERAVAILABLE".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))

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
        let actionYes = UIAlertAction(title: "YES".localizableString(loc:
        UserDefaults.standard.string(forKey: "keyLang")!),
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
        appDelegate.arr_updatedDealerList = []
        appDelegate.arr_updatedDealerList.removeAll()
            appDelegate.dealerDict.removeAll()

        print(arr_ProductList.count)
        self.tblView_orderCartDetails.reloadData()
        UserDefaults.standard.removeObject(forKey: "DivisionValue")

        self.navigationController?.popViewController(animated: true)
    }
    
    @objc  func onNo(alert: UIAlertAction!)
    {
        arr_ProductList = []
        arr_ProductList.removeAll()
        
        appDelegate.arr_UpdatedDelegate_ProductList = []
        appDelegate.arr_UpdatedDelegate_ProductList.removeAll()
        appDelegate.arr_updatedDealerList = []
        appDelegate.arr_updatedDealerList.removeAll()
        appDelegate.dealerDict.removeAll()

        print(arr_ProductList.count)
        self.tblView_orderCartDetails.reloadData()
        UserDefaults.standard.removeObject(forKey: "DivisionValue")

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

//hiding textfield delegate because calling it in cell class

//extension OrderCartDetailsViewController: UITextFieldDelegate
//{
////    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
////    {
////
////        if (textField == txt_remark){
////
////            let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789, "
////
////                       let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
////                       let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
////                       return (string == filtered)
////            }
////
////        let currentCharacterCount = textField.text!.count
////        if (currentCharacterCount == 0)
////        {
////            if (string == "0")
////            {
////                return false
////            }
////        }
////        let newLength = currentCharacterCount + string.count - range.length
////        return newLength <= 5
////
////    }
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
//    {
//        let cell = tblView_orderCartDetails.cellForRow(at: IndexPath(row: textField.tag, section: 0)) as! OrderDetailsTableViewCell
//
//
//        if (textField == cell.txt_selectOption)
//        {
//            optionTag = textField.tag
//            txt_responder = cell.txt_selectOption
//            showOption()
//            return false
//        }
//
//        else if(textField == cell.txt_expectedDate )
//        {
//            DatePicker(sender: textField, tag: textField.tag)
//        }
////        else if textField == txt_dealerName || textField == txt_dealerMobile
////        {
////            if(txt_selectOption.text == "Other")
////            {
////                return true
////            }
////            else
////            {
////                showAlert(msg: "selectDealer".localizableString(loc:
////                    UserDefaults.standard.string(forKey: "keyLang")!))
////                return false
////            }
////        }
//        return true
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField)
//    {
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField)
//
//    {
//
//        let cell = tblView_orderCartDetails.cellForRow(at: IndexPath(row: textField.superview!.tag, section: 0)) as! OrderDetailsTableViewCell
//
//        if (textField == cell.txt_remark) {
//            //            appDelegate.arr_UpdatedDelegate_ProductList[textField.tag].remark = textField.text
//
//
//
//
//                for arrEle in appDelegate.arr_UpdatedDelegate_ProductList {
//                    for cat in self.categoryNames  {
//                    if cell.lbl_division.text == cat && arrEle.categoryName == cell.lbl_division.text  {
//                        arrEle.remark = cell.txt_remark.text
//                    }
//                }
//            }
//        }
////
////        if textField.tag != -1 &&  textField.tag != 2{
////
////            let product = arr_ProductList[textField.tag]
////
////            if let qty = Int(textField.text!)
////            {
////                product.qty = qty
////            }
////            else
////            {
////                product.qty = 0
////            }
////            product.amount =  product.price! * Double(product.qty)
////
////            let oderList = arr_ProductList.filter({$0.qty > 0})
////            self.lbl_ttlSku.text = "TTL SKU : \(oderList.count)"
////            self.lbl_ttlQty.text = "TTL QTY : \(arr_ProductList.map({$0.qty}).reduce(0, +))"
////            self.lbl_ttlAmt.text = "TTL AMT : \(arr_ProductList.map({$0.amount}).reduce(0, +))"
////            arr_ProductList[textField.tag] = product
////
////            appDelegate.arr_UpdatedDelegate_ProductList[textField.tag] = product
////            let ip = IndexPath(row: textField.tag, section: 0)
////            tableview_Order.reloadRows(at: [ip], with: .automatic)
//        }
//
//
//
//    }
    


extension OrderCartDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arr_allProduct.count
        return categoryNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblView_orderCartDetails.dequeueReusableCell(withIdentifier: "orderDetailCell") as! OrderDetailsTableViewCell
        
//        for categoryName in categoryNames {
//                        var arrayProduct = [Product]()
//
//                        for element in arr_ProductList {
//                            if element.categoryName! == categoryName {
//                                arrayProduct.append(element)
//                            }
//                        }
//                        info[categoryName] = arrayProduct
//                    }
//
//             for ele in info {
//                 self.arr_allProduct.append(ele.value)
//             }
        
        print("indexpath for big tableview is \(indexPath.row)")
        
//        cell.cellView.layer.shadowColor = UIColor.lightGray.cgColor
//        cell.cellView.layer.shadowOpacity = 0.5
//        cell.cellView.layer.shadowOffset = .zero
//        cell.cellView.layer.shadowRadius = 5
//
//        cell.view_productList.layer.shadowColor = UIColor.white.cgColor
//        cell.view_productList.layer.shadowOpacity = 0.5
//        cell.view_productList.layer.shadowOffset = .zero
//        cell.view_productList.layer.shadowRadius = 5

        
        cell.txt_selectOption.text = ""
//        cell.txt_expectedDate.text = ""
        cell.txt_remark.text = "" //Change R
        cell.lbl_division.text = ""
        cell.arr_product = []
        //        cell.view_productList.isHidden = true
        
        self.validateDelegate = cell
        
        
        
        
        //code for setting order no
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dMMMyy/HH:mm"
//        let dstr = dateFormatter.string(from: Date()).uppercased()
//        if let lastOrder = Int(lastOrderNo) {
//            cell.lbl_orderNumber.text = MDM_CODE + "/" + dstr + "/" + "\( lastOrder + indexPath.row)"
//            if arr_orderId.count == 0 {
//            self.arr_orderId.append(MDM_CODE + "/" + dstr + "/" + "\( lastOrder + indexPath.row)")
//            }else {
//                if !arr_orderId.contains(MDM_CODE + "/" + dstr + "/" + "\( lastOrder + indexPath.row)"){
//                    self.arr_orderId.append(MDM_CODE + "/" + dstr + "/" + "\( lastOrder + indexPath.row)")
//                }
//            }
//        }else {
//            //            cell.lbl_orderNumber.text = MDM_CODE + "/" + dstr + "/" + "\( 0 + indexPath.row)"
//            //            self.arr_orderId.append(String(0 + indexPath.row))
//        }
        
        cell.tag = indexPath.row
        
        //hide this when you want to call delegate method from here
        //        cell.txt_expectedDate.delegate = self
        //        cell.txt_expectedDate.tag = indexPath.row
        //        cell.txt_expectedDate.tag = 2
        
        
        //        cell.txt_selectOption.delegate = self
        //        cell.txt_selectOption.tag = indexPath.row
        //        cell.txt_selectOption.tag = 1
        
                cell.txt_remark.delegate = self //Change R
                cell.txt_remark.tag = indexPath.row //Change R
                cell.txt_remark.tag = 3 //Change R
        
        
        
        
        cell.btn_selectOption.addTarget(self, action: #selector(btn_selectOption_pressed), for: .touchUpInside)
        cell.btn_selectOption.tag = indexPath.row
        cell.btn_selectOption.tag = 4
        
        cell.viewCon = self
        
        
        cell.info = info
        cell.categoryNames = categoryNames
        cell.arr_ProductList = arr_ProductList
        cell.orderCartVC = self

        //        for ele in info {
        //            self.arr_allProduct.append(ele.value)
        //        }
        
        //        for arrAllProdtctEle in arr_allProduct {
        //            for arrproductEle in arrAllProdtctEle {
        //                let lineProduct = arrproductEle.categoryName
        //                for element in categoryNames {
        //                    if element == lineProduct {
        //                        let oderList = arr_allProduct[indexPath.row].filter({$0.qty > 0})
        //                        cell.lbl_ttlSku.text = "TTL SKU : \(oderList.count)"
        //                        cell.lbl_ttlQty.text = "TTL QTY : \(arr_allProduct[indexPath.row].map({$0.qty}).reduce(0, +))"
        //                        cell.lbl_ttlAmt.text = "TTL AMT : \(arr_allProduct[indexPath.row].map({$0.amount}).reduce(0, +))"
        //                        cell.arr_product = arr_allProduct[indexPath.row]
        //                        //                    cell.lbl_division.text = element
        //
        //                        for arrEle in appDelegate.arr_UpdatedDelegate_ProductList {
        //                            for cat in categoryNames {
        //                            if arrEle.categoryName == lineProduct && cat == lineProduct {
        //                                arrEle.divisionName = lineProduct
        //                                cell.txt_selectOption.text = arrEle.dealerName
        //                                cell.txt_expectedDate.text = arrEle.dealDate
        //                                cell.txt_remark.text = arrEle.remark
        //                                cell.lbl_division.text = lineProduct
        //                            }
        //                        }
        //                        }
        //
        //                    }
        //                }
        //            }
        //        }
        
        
        
        print("arr_product \(arr_allProduct[indexPath.row])")
        
        //        let oderList = arr_allProduct[indexPath.row].filter({$0.qty > 0})
        //        cell.lbl_ttlSku.text = "TTL SKU : \(oderList.count)"
        //        cell.lbl_ttlQty.text = "TTL QTY : \(arr_allProduct[indexPath.row].map({$0.qty}).reduce(0, +))"
        //        cell.lbl_ttlAmt.text = "TTL AMT : \(arr_allProduct[indexPath.row].map({$0.amount}).reduce(0, +))"
        
        //        cell.txt_remark.text = arr_allProduct[indexPath.row].first?.remark
        //        cell.txt_selectOption.text = arr_allProduct[indexPath.row].first?.dealerName
        //        cell.txt_expectedDate.text = arr_allProduct[indexPath.row].first?.dealDate
        //        cell.lbl_division.text = categoryNames[indexPath.row]
        
//        cell.arr_product = arr_product[indexPath.row]
        
        //code for  passing arr_product arr to cell and setting total sku qty amt
        print(arr_allProduct)
        for ele in arr_allProduct {
            for catname in categoryNames {
                print(ele.first?.divisionName)
                print(catname)
                print(categoryNames[indexPath.row])
            if ele.first?.categoryName == categoryNames[indexPath.row] && catname == categoryNames[indexPath.row]  {
                for arrEle in appDelegate.arr_UpdatedDelegate_ProductList {
                    cell.view_productList.isHidden = false
                    arrEle.productArr = ele
                    cell.arr_product = ele
                   // cell.txt_remark.text = arrEle.remark
//                    cell.view_productListHeightConstraint.constant = 60
//                    height for product view
                    
                    
                    
                    let height = CGFloat(40 + ele.count * 50)
                    
                    cell.view_productListHeightConstraint.constant = height
//
//                    if height <= 170 {
//                        cell.view_productListHeightConstraint.constant = height
//
//                    }else {
//                       cell.view_productListHeightConstraint.constant = 150
//                    }
                    
                }
                
                cell.view_ttlDetails.isHidden = false
//                cell.lbl_swipeNote.isHidden = true
                let oderList = ele.filter({$0.qty > 0})
                cell.lbl_ttlSku.text = "\(oderList.count)"
                cell.lbl_ttlQty.text = "\(ele.map({$0.qty}).reduce(0, +))"
                
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.minimumFractionDigits = 2
                formatter.maximumFractionDigits = 2
                
                if let roundedPriceString = formatter.string(for: ele.map({$0.amount}).reduce(0, +)) {
                cell.lbl_ttlAmt.text = "\(roundedPriceString)"
                }
                
//                cell.lbl_ttlAmt.text = "TTL AMT : \(ele.map({$0.amount}).reduce(0, +))"
                
            }else {
                //cell.arr_product = arr_allProduct[indexPath.row]
                
            }
        }
        }
        
        //code for setting dealer name category name date remark
        for arrEle in appDelegate.arr_UpdatedDelegate_ProductList {
            if arrEle.categoryName == categoryNames[indexPath.row] {
                arrEle.divisionName = categoryNames[indexPath.row]
                // arrEle.productArr = arr_allProduct[indexPath.row]
                cell.txt_selectOption.text = arrEle.dealerName
//                cell.txt_expectedDate.text = arrEle.dealDate
                cell.txt_remark.text = arrEle.remark //Change R
                cell.lbl_division.text = arrEle.divisionName
                // cell.arr_product = arrEle.productArr!
  
            }
        }
        
        arr_dealer.removeAll()
        arr_dealerName.removeAll()
        
        //dommenting this to check new functionality
//                   let arr = appDelegate.arr_updatedDealerList
//
//
//                   for element in arr {
//                       if element.categoryName == cell.lbl_division.text {
//                           if !arr_dealer.contains(element) {
//                               arr_dealer.append(element)
//                           }
//                       }
//                   }
//
//                   for ele in arr_dealer {
//                       if arr_dealerName.count == 0 {
//                           arr_dealerName.append(ele.s_FullName!)
//                       }else {
//                           if !arr_dealerName.contains(ele.s_FullName!) {
//                                arr_dealerName.append(ele.s_FullName!)
//                           }
//                       }
//                   }
        
        
        let arrDict = appDelegate.dealerDict
        
        for  ele in arrDict {
            if ele.key == cell.lbl_division.text {
                arr_dealer = ele.value
            }
        }
        
        for ele in arr_dealer {
            if arr_dealerName.count == 0 {
                let dealerInfo = ele.s_FullName! + " " + ele.s_RetailerSapCode!
                arr_dealerName.append(ele.s_FullName!)
            }else {
                if !arr_dealerName.contains(ele.s_FullName!) {
                    let dealerInfo = ele.s_FullName! + " " + ele.s_RetailerSapCode!
                     arr_dealerName.append(ele.s_FullName!)
                }
            }
        }
        
        //set select partner automatically in case of 1 dealer name
        if arr_dealerName.count == 1 {
            
            cell.txt_selectOption.text = arr_dealerName[0]
            cell.txt_selectOption.isUserInteractionEnabled = false
            cell.btn_selectOption.isUserInteractionEnabled = false
            for arrEle in appDelegate.arr_UpdatedDelegate_ProductList {
                for cat in self.categoryNames {
                    if cell.lbl_division.text == cat && arrEle.categoryName == cell.lbl_division.text {
                        arrEle.dealerName = arr_dealerName[0]
                    }
                }
            }
            
            self.dealer = self.arr_dealer[0]
            if let orderType = self.dealer.OrderType {
                self.selectedOrderType = orderType
                
                for arrEle in appDelegate.arr_UpdatedDelegate_ProductList {
                    for cat in self.categoryNames  {
                        if cell.lbl_division.text == cat && arrEle.categoryName == cell.lbl_division.text  {
                            arrEle.orderType = orderType
                        }
                    }
                }
                
            }else {
                self.selectedOrderType = "Not Applicable"
                
            }
            
            
        }else {
            cell.txt_selectOption.isUserInteractionEnabled = true
            cell.btn_selectOption.isUserInteractionEnabled = true
        }
        
        cell.subMenuTable.reloadData()
        
        //        for productType in info {
        //
        //            let lineProduct = productType.key
        //
        //            for  element in categoryNames {
        //
        //                if element == lineProduct {
        //
        ////                    let oderList = arr_allProduct[indexPath.row].filter({$0.qty > 0})
        ////                    cell.lbl_ttlSku.text = "TTL SKU : \(oderList.count)"
        ////                    cell.lbl_ttlQty.text = "TTL QTY : \(arr_allProduct[indexPath.row].map({$0.qty}).reduce(0, +))"
        ////                    cell.lbl_ttlAmt.text = "TTL AMT : \(arr_allProduct[indexPath.row].map({$0.amount}).reduce(0, +))"
        //                    cell.arr_product = arr_allProduct[indexPath.row]
        ////                    cell.lbl_division.text = element
        //
        ////                    for arrEle in appDelegate.arr_UpdatedDelegate_ProductList {
        ////                        if arrEle.categoryName == element {
        ////                            arrEle.divisionName = element
        ////                            cell.txt_selectOption.text = arrEle.dealerName
        ////                            cell.txt_expectedDate.text = arrEle.dealDate
        ////                            cell.txt_remark.text = arrEle.remark
        ////                            cell.lbl_division.text = element
        ////                        }
        ////                    }
        //
        ////                    info.removeValue(forKey: lineProduct)
        //                    break
        //                }else {
        //                    cell.lbl_ttlSku.text = "not available"
        //                    cell.lbl_ttlQty.text = "not available"
        //                    cell.lbl_ttlAmt.text = "not available"
        //                     cell.arr_product = []
        //                    cell.lbl_division.text = "not available"
        //
        //                }
        //
        //            }
        //            break
        //        }
        
        
        
        
        
        //        if let lineOneVal = info["CONSUMER LIGHTING"] {
        //            cell.arr_product = lineOneVal
        //        }
        
        //        cell.scrollView_productList.delegate = self
        //
        //        let headerView = DemoHeader.instanceFromNib()
        //        headerView.lbl_oderName.numberOfLines = 0
        //        headerView.lbl_qty.numberOfLines = 0
        //        headerView.lbl_amount.numberOfLines = 0
        //
        //        let font = UIFont.systemFont(ofSize: 16, weight: .medium)
        //
        //        headerView.lbl_oderName.font = font
        //        headerView.lbl_qty.font = font
        //        headerView.lbl_amount.font = font
        //        headerView.lbl_oderName.text = hName
        //        headerView.lbl_qty.text = hQty
        //        headerView.lbl_amount.text = hAmount
        //        headerView.frame.size.height = 30
        //        headerView.frame.size.width = cell.view_productList.frame.size.width
        ////        headerView.bottomAnchor.anchorWithOffset(to: cell.contentView_scrollView.bottomAnchor)
        //
        //        let lineview1 = Line_view.instanceFromNib()
        //        lineview1.lbl_oderName.numberOfLines = 0
        //        lineview1.lbl_qty.numberOfLines = 0
        //        lineview1.lbl_amount.numberOfLines = 0
        //
        //        if let lineOneVal = info["CONSUMER LIGHTING"] {
        //            for element in lineOneVal {
        //                lineview1.lbl_oderName.text = element.name!
        //                lineview1.lbl_qty.text = String(element.qty)
        //                lineview1.lbl_amount.text = String(element.amount)
        //                lineview1.frame.size.height = 30
        //                lineview1.frame.size.width = cell.view_productList.frame.size.width
        ////                headerView.bottomAnchor.anchorWithOffset(to: cell.contentView_scrollView.bottomAnchor)
        //            }
        //        }
        //
        //        cell.contentView_scrollView.addSubview(headerView)
        //        cell.contentView_scrollView.addSubview(lineview1)
        //
        //        lineview1.snp.makeConstraints { (make) in
        //            make.top.equalTo(headerView.snp.bottom).offset(5)
        //            make.leading.equalTo(headerView.snp.leading)
        //        }
        
        
        setTTlView()
        
        return cell
        
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
    
    
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//
//
//           let headerView = tblView.dequeueReusableHeaderFooterView(withIdentifier: "DemoHeaderView") as! DemoHeaderView
//
//           headerView.lbl_oderName.numberOfLines = 0
//           headerView.lbl_qty.numberOfLines = 0
//           headerView.lbl_amount.numberOfLines = 0
//
//           let font = UIFont.systemFont(ofSize: 16, weight: .medium)
//
//           headerView.lbl_oderName.font = font
//           headerView.lbl_qty.font = font
//           headerView.lbl_amount.font = font
//           headerView.lbl_oderName.text = hName
//           headerView.lbl_qty.text = hQty
//           headerView.lbl_amount.text = hAmount
//
//
//           return headerView
//
//
//       }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
//       {
//           if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DemoHeaderView") as? DemoHeaderView
//           {
//               headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 58)
//
//               let font = UIFont.systemFont(ofSize: 16, weight: .medium)
//               let name_height = hName.height(withConstrainedWidth: headerView.lbl_oderName.frame.width, font: font)
//               let qty_height = hQty.height(withConstrainedWidth: headerView.lbl_qty.frame.width, font: font)
//               let amount_height = hName.height(withConstrainedWidth: headerView.lbl_amount.frame.width, font: font)
//
//               let largest = max(max(name_height, qty_height), amount_height)
//
//               return largest + 16
//           }
//           return 50
//       }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//           if editingStyle == .delete {
//               presentDeletionFailsafe(indexPath: indexPath)
//           }
//       }
//
//       func presentDeletionFailsafe(indexPath: IndexPath) {
//
//           let alert = UIAlertController(title: appName, message: "doyouwanttodelete".localizableString(loc:
//               UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
//           // yes action
//           let yesAction = UIAlertAction(title: "YES", style: .default) { _ in
//               // replace data variable with your own data array
//               self.arr_ProductList.remove(at: indexPath.row)
//               appDelegate.arr_UpdatedDelegate_ProductList.remove(at: indexPath.row)
//               self.tblView_orderCartDetails.beginUpdates()
//               self.tblView_orderCartDetails.deleteRows(at: [indexPath], with: .fade)
//               self.tblView_orderCartDetails.endUpdates()
//               self.tblView_orderCartDetails.reloadData()
//
//               appDelegate.arr_UpdatedDelegate_ProductList = self.arr_ProductList  //chetanChange
//
//               let oderList = self.arr_ProductList.filter({$0.qty > 0})
//
////               self.lbl_ttlSku.text = "TTL SKU : \(oderList.count)"
////               self.lbl_ttlQty.text = "TTL QTY : \(self.arr_ProductList.map({$0.qty}).reduce(0, +))"
////               self.lbl_ttlAmt.text = "TTL AMT : \(self.arr_ProductList.map({$0.amount}).reduce(0, +))"
//
//        if self.arr_ProductList.count == 0{
//                   let alert = UIAlertController(title: appName, message: "AllItemsdelete".localizableString(loc:
//                       UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
//                   // yes action
//                   let yesAction = UIAlertAction(title: "OK", style: .default) { _ in
//                       // replace data variable with your own data array
//
//                           self.arr_ProductList.removeAll()
//                           self.arr_ProductList = []
//                           appDelegate.arr_UpdatedDelegate_ProductList = []
//                           appDelegate.arr_UpdatedDelegate_ProductList.removeAll()
//                           UserDefaults.standard.removeObject(forKey: "DivisionValue")
//
//                           self.navigationController?.popViewController(animated: true)
//                       }
//
//                   alert.addAction(yesAction)
//
//
//               self.present(alert, animated: true, completion: nil)
//               }
//           }
//
//           alert.addAction(yesAction)
//
//           // cancel action
//           alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
//
//           self.present(alert, animated: true, completion: nil)
//       }
}

extension Array {
    func removingDuplicate<T: Hashable>(byKey key: (Product) -> T)  -> [Product] {
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

class DemoHeader: DemoHeaderView {
    class func instanceFromNib() -> DemoHeaderView {
        return UINib(nibName: "DemoHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DemoHeaderView
    }
    
  
}


class Line_view: UIView {
    class func instanceFromNib() -> LineView {
        return UINib(nibName: "LineView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LineView
    }
}

extension OrderCartDetailsViewController : UITextFieldDelegate {
    
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            let currentCharacterCount = textField.text?.count ?? 0
            let newLength = currentCharacterCount + string.count - range.length
            
            if textField == self.txt_expectedDate {
                let ACCEPTABLE_CHARACTERS = "/0123456789"
                let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
                let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
                return (string == filtered && newLength <= 11)
            }
    //        else if (textField.tag == 1)
    //        {
    //            print("tag one select option ")
    //            //                optionTag = textField.tag
    //            txt_responder = self.txt_selectOption
    //            showOption()
    //            return true
    //
    //        }
            else
            {
                return true
            }
        }
        
        
         func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
            {
                

//                if (textField.tag == 1)
//                {
//                     print("tag one select option ")
//    //                optionTag = textField.tag
//                    txt_responder = self.txt_selectOption
//                    showOption()
//    //                return false
//                    return false
//
//                }

                 if(textField == txt_expectedDate )
                {
                    print("tag two select date ")

                    DatePicker(sender: textField, tag: textField.tag)
                }
        //        else if textField == txt_dealerName || textField == txt_dealerMobile
        //        {
        //            if(txt_selectOption.text == "Other")
        //            {
        //                return true
        //            }
        //            else
        //            {
        //                showAlert(msg: "selectDealer".localizableString(loc:
        //                    UserDefaults.standard.string(forKey: "keyLang")!))
        //                return false
        //            }
        //        }
                return true
            }
        
        func textFieldDidBeginEditing(_ textField: UITextField)
         {
            
         }
         
         func textFieldDidEndEditing(_ textField: UITextField)
         {
            
             if (textField == txt_remark) {
                        
                        print("tag three remark ended")
    //                                 appDelegate.arr_UpdatedDelegate_ProductList[textField.tag].remark = textField.text


//                             for arrEle in appDelegate.arr_UpdatedDelegate_ProductList {
//                                 for cat in self.categoryNames  {
//                                 if self.lbl_division.text == cat && arrEle.categoryName == self.lbl_division.text  {
//                                     arrEle.remark = self.txt_remark.text
//                                 }
//                             }
//                         }
                     }
            
            
    //        let index = IndexPath(row: textField.tag, section: 0)
    //        let cell = subMenuTable.cellForRow(at: index) as! lineViewCell
    //
    //        if (textField == cell.txt_qty)
    //         {
    //             print("in textfield delegate method")
    //                 let product = arr_product[textField.tag]
    //
    //                          if let qty = Int(textField.text!)
    //                          {
    //                              product.qty = qty
    //                          }
    //                          else
    //                          {
    //                              product.qty = 0
    //                          }
    //                          product.amount =  product.price! * Double(product.qty)
    //
    //                          let oderList = arr_product.filter({$0.qty > 0})
    //                          self.lbl_ttlSku.text = "TTL SKU : \(oderList.count)"
    //                          self.lbl_ttlQty.text = "TTL QTY : \(arr_product.map({$0.qty}).reduce(0, +))"
    //                          self.lbl_ttlAmt.text = "TTL AMT : \(arr_product.map({$0.amount}).reduce(0, +))"
    //                          arr_product[textField.tag] = product
    //                          let ip = IndexPath(row: textField.tag, section: 0)
    //
    //                          let arr = appDelegate.arr_UpdatedDelegate_ProductList
    //                          let productName = arr_product[textField.tag].name
    //                          for ele in arr {
    //                              if ele.name == productName {
    //                                if  let ind = arr.index(of: ele) {
    //                                  appDelegate.arr_UpdatedDelegate_ProductList[ind] = product
    //                                  break
    //                                }
    //                              }
    //                          }
    //
    //
    //                          subMenuTable.reloadRows(at: [ip], with: .automatic)
    //
    //
    //
    //        }
         }
    
}

