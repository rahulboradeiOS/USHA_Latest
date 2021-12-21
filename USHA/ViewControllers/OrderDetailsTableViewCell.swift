//
//  OrderDetailsTableViewCell.swift
//  USHA Retailer
//
//  Created by Rahul on 23/07/21.
//  Copyright © 2021 Apple.Inc. All rights reserved.
//

import UIKit
import DropDown

class OrderDetailsTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, getValidationDelegate {
    
    
  
    
    
  

    @IBOutlet weak var txt_dealerName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txt_dealerMobile: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var txt_expectedDate: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txt_remark: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lbl_pleaseSelect: UILabel!
    
    @IBOutlet weak var lbl_division: UILabel!
    
    @IBOutlet weak var lbl_orderNumber: UILabel!
    
    @IBOutlet weak var view_selectOption: UIView!
    @IBOutlet weak var txt_selectOption: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_selectOption: UIButton!
    
    
    @IBOutlet weak var view_ttlDetails: UIView!
    @IBOutlet weak var lbl_ttlSku: UILabel!
    @IBOutlet weak var lbl_ttlQty: UILabel!
    @IBOutlet weak var lbl_ttlAmt: UILabel!
    
    @IBOutlet weak var lbl_swipeNote: UILabel!
    @IBOutlet weak var view_productList: UIView!
    
    @IBOutlet weak var view_productListHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView_productList: UIScrollView!
    @IBOutlet weak var contentView_scrollView: UIView!
    
    var subMenuTable = UITableView()
    var arr_product = [Product]()
    
    var viewCon = UIViewController()
    
    var categoryNames = [String]()
    var info = [String:[Product]]()
    
    var selectDropDown = DropDown()
    var arr_dealer = [Dealer]()
    var arr_dealerName = [String]()
    var filterArr_dealerName = [String]()

    var datePickerView:UIDatePicker!
    var expectedDate:Date!
    
    var orderCartVC : OrderCartDetailsViewController!
    
    
    var arr_ProductList:[Product]!
    var myData : String!



    
    var dealer:Dealer!
    var txt_responder:SkyFloatingLabelTextField!
    var selectedOrderType = ""


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
//        setUpTable()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        txt_expectedDate.text = ""
//        txt_remark.text = ""
//        txt_selectOption.text = ""
//        lbl_orderNumber.isHidden = true
//        lbl_division.text = ""
//        view_productList.isHidden = true
//          self.arr_product = []
        txt_selectOption.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
      }
    
    @objc func textFieldDidChange(_ textField:UITextField){
                
                if let text = textField.text{
                 
                 if text == ""{
//                     self.searchCheck = false
//                      self.tableview_Order.reloadData()
                 }else{
                     print(self.arr_ProductList)

                                      self.filterArr_dealerName = self.arr_dealerName.filter{
                                        let a = $0.lowercased().contains(text.lowercased())
                                          

                                          return a
                              }
                    
                    selectDropDown.dataSource = filterArr_dealerName
                                    selectDropDown.anchorView = self.txt_selectOption
                                    selectDropDown.show()
                    
                 }
      
             }
         }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)

//        setUpTable()
    }

    func setUpTable(){
//        subMenuTable = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), style:UITableViewStyle.plain)
        subMenuTable.delegate = self
        subMenuTable.dataSource = self
        
        let lineNib = UINib.init(nibName: "LineViewCell", bundle: Bundle.main)
        subMenuTable.register(lineNib, forCellReuseIdentifier: "lineView")
        
//        subMenuTable.frame = self.view_productList.frame
        self.addSubview(subMenuTable)
        
        self.subMenuTable.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view_productList)
            make.centerX.equalTo(self.view_productList)

            make.height.width.equalTo(self.view_productList)
        }
        
        let headerNib = UINib.init(nibName: "DemoHeaderView", bundle: Bundle.main)
        subMenuTable.register(headerNib, forHeaderFooterViewReuseIdentifier: "DemoHeaderView")
//
//        self.subMenuTable.snp.makeConstraints({ (make) in
//            make.leading.trailing.top.bottom.equalTo(self)
//        })
     }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.subMenuTable.snp.makeConstraints({ (make) in
//            make.leading.trailing.top.bottom.equalTo(self)
//        })
        subMenuTable.frame = self.view_productList.frame

        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //unhide this when you  want to call  parenttableview delegate from cell classs
        self.txt_selectOption.tag = 1
        self.txt_selectOption.delegate = self
//        self.txt_expectedDate.tag = 2
//        self.txt_expectedDate.delegate = self
//        self.txt_remark.tag = 3
//        self.txt_remark.delegate = self
        
        self.subMenuTable.separatorStyle = .none
        self.subMenuTable.isScrollEnabled = false
        
        let attributes = [
//            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14.0) // Note the !
        ]

        txt_selectOption.attributedPlaceholder = NSAttributedString(string: "SELECT ORDER DELIVERY PARTNER*", attributes:attributes)
        
        
//        self.txt_remark.validateOnResign = false
        
        self.txt_selectOption.validateOnResign = false
        
        setUpTable()
        
        self.btn_selectOption.addTarget(self, action: #selector(btn_selectOption_pressed), for: .touchUpInside)
        
        setupDropDown()
    }
    
     func validate() -> Bool
        {
            
            for i in 0...categoryNames.count-1 {
                
               
                
                if arr_ProductList.count == 0
                {
                    showAlert(msg: "productNotFound".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                    return false
                }
                else if self.txt_selectOption.text == ""
                {
                    
                    showAlert(msg: "selectDealer".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                    return false
                }
                else if self.txt_selectOption.text == "Other"
                {
                    //                txt_delerNameTop.constant = 16
                    //                txt_delarNameHeight.constant = 40
                    //                if txt_dealerName.text == ""
                    //                {
                    //                    showAlert(msg: "enterDealerName".localizableString(loc:
                    //                        UserDefaults.standard.string(forKey: "keyLang")!))
                    //                    return false
                    //                }
                    //                else if txt_dealerMobile.text == ""
                    //                {
                    //                    showAlert(msg: "enterDealerMobile".localizableString(loc:
                    //                        UserDefaults.standard.string(forKey: "keyLang")!))
                    //                    return false
                    //                }
                }
                
//                if self.txt_expectedDate.text == ""
//                {
//                    showAlert(msg: "enterDate".localizableString(loc:
//                        UserDefaults.standard.string(forKey: "keyLang")!))
//                    return false
//                }
                else if self.txt_remark.text == ""{

                    showAlert(msg: "enterRemark".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                    return false
                }
    //            else
    //            {
    //                return true
    //            }
                
                for ele in appDelegate.arr_UpdatedDelegate_ProductList {
                    if ele.qty == 0 {
                        showAlert(msg: "PLEASE ENTER PRODUCT QUANTITY GREATER THAN ZERO")
                        return false
                        
                    }
                }
            }
        
            return true
        }
    
    func prodValidate() -> Bool {
//        for ele in arr_product {
//            if ele.qty == 0 {
//                let alertCon = UIAlertController(title: "", message: "PLEASE ENTER PRODUCT QUANTITY > 0", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
////                            return false
//                }
//                alertCon.addAction(okAction)
//
//                viewCon.present(alertCon, animated: true, completion: nil)
//
//            }
//        }
        
        for ele in appDelegate.arr_UpdatedDelegate_ProductList {
            if ele.qty == 0 {
                showAlert(msg: "PLEASE ENTER PRODUCT QUANTITY GREATER THAN ZERO")
                return false
                
            }else {
                
            }
        }
      return true
    }
    
    
    
    func showAlert(msg:String)
     {
         let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
         //We add buttons to the alert controller by creating UIAlertActions:
         let actionOk = UIAlertAction(title: "OK".localizableString(loc:
             UserDefaults.standard.string(forKey: "keyLang")!),
                                      style: .default,
                                      handler: self.onOkPressed)
         //You can use a block here to handle a press on this button
         
         alertController.addAction(actionOk)
         
         viewCon.present(alertController, animated: true, completion: nil)
     }
     
     @objc func onOkPressed(alert: UIAlertAction!)
     {
          
     }
    
       @objc func btn_selectOption_pressed(_ sender: UIButton)
          {
              txt_responder = self.txt_selectOption
              showOption()
          }
    
     func setupDropDown()
        {

            selectDropDown.dismissMode = .automatic
            selectDropDown.separatorColor = .lightGray
    //        selectDropDown.width = self.txt_responder.frame.width
//            selectDropDown.bottomOffset = CGPoint(x: 0, y: self.view_selectOption.bounds.height)
                selectDropDown.topOffset = CGPoint(x: 0, y:-(self.view_selectOption.bounds.height))

            selectDropDown.direction = .top
            selectDropDown.cellHeight = 30
            selectDropDown.backgroundColor = .white
            // Action triggered on selection
            selectDropDown.selectionAction = {(index, item) in
                if self.txt_responder  != nil{
                    self.txt_responder.text = item
    //                appDelegate.arr_UpdatedDelegate_ProductList[self.optionTag].dealerName = item

                        for arrEle in appDelegate.arr_UpdatedDelegate_ProductList {
                                    for cat in self.categoryNames {
                                        if self.lbl_division.text == cat && arrEle.categoryCode == self.lbl_division.text {
                                arrEle.dealerName = item
                            }
                        }
                    }
  
                }
                
                self.dealer = self.arr_dealer[index]
                if let orderType = self.dealer.OrderType {
                    self.selectedOrderType = orderType
                    
                    for arrEle in appDelegate.arr_UpdatedDelegate_ProductList {
                                              for cat in self.categoryNames  {
                                              if self.lbl_division.text == cat && arrEle.categoryCode == self.lbl_division.text  {
                                                  arrEle.orderType = orderType
                                              }
                                          }
                                      }

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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func presentDeletionFailsafe(indexPath: IndexPath) {
        
            
            
            
            let alert = UIAlertController(title: appName, message: "doyouwanttodelete".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
            // yes action
            let yesAction = UIAlertAction(title: "YES", style: .default) { _ in
                // replace data variable with your own data array
                
                let arr = appDelegate.arr_UpdatedDelegate_ProductList
                let productName = self.arr_product[indexPath.row].name
                
                for ele in arr {
                    if ele.name == productName {
                        let index = arr.index(of: ele)
                        appDelegate.arr_UpdatedDelegate_ProductList.remove(at: index!)
                        break
                    }
                }
                self.arr_product.remove(at: indexPath.row)
                //                   appDelegate.arr_UpdatedDelegate_ProductList.remove(at: indexPath.row)
                self.subMenuTable.beginUpdates()
                self.subMenuTable.deleteRows(at: [indexPath], with: .fade)
                self.subMenuTable.endUpdates()
                self.subMenuTable.reloadData()
                
                //                   appDelegate.arr_UpdatedDelegate_ProductList = self.arr_product  //chetanChange
                //
                
                
                let oderList = self.arr_product.filter({$0.qty > 0})
                
                self.lbl_ttlSku.text = "TTL PRD : \n \(oderList.count)"
                self.lbl_ttlQty.text = "TTL QTY : \n \(self.arr_product.map({$0.qty}).reduce(0, +))"
                
                let formatter = NumberFormatter()
                           formatter.numberStyle = .decimal
                           formatter.minimumFractionDigits = 2
                           formatter.maximumFractionDigits = 2
                           
                if let roundedPriceString = formatter.string(for: self.arr_product.map({$0.amount}).reduce(0, +)){

                self.lbl_ttlAmt.text = "TTL AMT : \(roundedPriceString)"
                }
                
//                self.lbl_ttlAmt.text = "TTL AMT : \(self.arr_product.map({$0.amount}).reduce(0, +))"
                
                if appDelegate.arr_UpdatedDelegate_ProductList.count == 0{
                    
                    let alert = UIAlertController(title: "", message: "YOUR ORDER CART IS EMPTY ! PLEASE ADD PRODUCTS TO ORDER ", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                                        self.viewCon.navigationController?.popViewController(animated: true)

                    }
                    
                    alert.addAction(okAction)
                    
                    self.viewCon.present(alert, animated: true, completion: nil)
                    
    //                let alert = UIAlertController(title: appName, message: "AllItemsdelete".localizableString(loc:
    //                    UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
    //                // yes action
    //                let yesAction = UIAlertAction(title: "OK", style: .default) { _ in
    //                    // replace data variable with your own data array
    //
    //                    self.arr_product.removeAll()
    //                    self.arr_product = []
    //                    appDelegate.arr_UpdatedDelegate_ProductList = []
    //                    appDelegate.arr_UpdatedDelegate_ProductList.removeAll()
    //                    UserDefaults.standard.removeObject(forKey: "DivisionValue")
    //
    //                    //                               self.navigationController?.popViewController(animated: true)
    //                }
    //
    //                alert.addAction(yesAction)
    //
    //
    //                self.viewCon.present(alert, animated: true, completion: nil)
                }
            }
            
            alert.addAction(yesAction)
            
            // cancel action
            alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
            
            self.viewCon.present(alert, animated: true, completion: nil)
        }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return  arr_product.count

    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lineView") as! lineViewCell
        
//        cell.lbl_amount.text = String(arr_product[indexPath.row][indexPath.row].amount)
//        cell.lbl_oderName.text = arr_product[indexPath.row][indexPath.row].name
//        cell.lbl_qty.text = String(arr_product[indexPath.row][indexPath.row].qty)
        
//                for productType in info {
//                    for  element in categoryNames {
//                    let lineProduct = productType.key
//                        if element == lineProduct {
//                            cell.lbl_amount.text = String(arr_product[indexPath.row].amount)
//                                   cell.lbl_oderName.text = arr_product[indexPath.row].name
//                                   cell.lbl_qty.text = String(arr_product[indexPath.row].qty)
//                        }
//                    }
//                }
        print("in small tableview array is \(arr_product[indexPath.row])")
        print("indexpath for small tableview is \(indexPath.row)")
        
        let product = arr_product[indexPath.row]
        
        if product.unit?.trim() != nil{
            
            self.myData = ""//"-(\(product.unit!.trim()))"
        }else{
            self.myData = ""//"-(null)"
        }
        
        
        let mydata2 = "_\(product.code!)"
        
        //Making dictionaries of fonts that will be passed as an attribute
        
        let yourAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.blue]
        let yourOtherAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
        let yourOtherAttributes1: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red]
        
        let partOne1 = NSMutableAttributedString(string: product.name!, attributes: yourAttributes)
        let partOne2 = NSMutableAttributedString(string:mydata2, attributes: yourOtherAttributes)
        let partOne4 = NSMutableAttributedString(string: self.myData, attributes: yourOtherAttributes1)
        
        partOne1.append(partOne2)
        partOne1.append(partOne4)
       
//        cell.lbl_oderName.text = arr_product[indexPath.row].name! + arr_product[indexPath.row].code!
        cell.lbl_oderName.attributedText = partOne1

        cell.txt_qty.text = String(arr_product[indexPath.row].qty)
        cell.btn_delete.tag = indexPath.row
        
        
        let formatter = NumberFormatter()
                           formatter.numberStyle = .decimal
                           formatter.minimumFractionDigits = 2
                           formatter.maximumFractionDigits = 2

                if let roundedPriceString = formatter.string(for: arr_product[indexPath.row].amount){
                        cell.lbl_amount.text = "\(String(describing: roundedPriceString))"
                }
//         cell.lbl_amount.text = String(arr_product[indexPath.row].amount)
        print("quantity for product is \(cell.txt_qty.text)")
        
        cell.tag = indexPath.row
        
//        cell.txt_qty.delegate = self
//        cell.txt_qty.tag = indexPath.row
        
        cell.arr_product = arr_product
        cell.viewCon = self
        cell.ordercartVC = self.orderCartVC
        cell.ordercartDetailsViewCon = viewCon as! OrderCartDetailsViewController
        cell.setTTLViewDelegate = self.viewCon as! OrderCartDetailsViewController
        cell.indexPath = indexPath
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("in did select")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    
    
               let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DemoHeaderView") as! DemoHeaderView
    
               headerView.lbl_oderName.numberOfLines = 0
               headerView.lbl_qty.numberOfLines = 0
               headerView.lbl_amount.numberOfLines = 0
    
               let font = UIFont.systemFont(ofSize: 12, weight: .medium)
    
               headerView.lbl_oderName.font = font
               headerView.lbl_qty.font = font
               headerView.lbl_amount.font = font
               headerView.lbl_oderName.text = hName
               headerView.lbl_qty.text = hQty
               headerView.lbl_amount.text = hAmount
    
    
               return headerView
    
    
           }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
           {
               if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DemoHeaderView") as? DemoHeaderView
               {
                   headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30)
                   
                   let font = UIFont.systemFont(ofSize: 12, weight: .medium)
                   let name_height = hName.height(withConstrainedWidth: headerView.lbl_oderName.frame.width, font: font)
                   let qty_height = hQty.height(withConstrainedWidth: headerView.lbl_qty.frame.width, font: font)
                   let amount_height = hName.height(withConstrainedWidth: headerView.lbl_amount.frame.width, font: font)
                   
                   let largest = max(max(name_height, qty_height), amount_height)
                   
                   return largest + 8
               }
               return 50
           }
    
//     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//               if editingStyle == .delete {
//                   presentDeletionFailsafe(indexPath: indexPath)
//               }
//           }
}

extension OrderDetailsTableViewCell : UITextFieldDelegate {
    
    func DatePicker(sender:UITextField, tag:Int)
      {
          datePickerView = UIDatePicker()
          datePickerView.tag = tag
          datePickerView.datePickerMode = .date
          sender.inputView = datePickerView
//          dateTag = tag
          datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
          datePickerView.minimumDate = Date()

      }
      
      @objc func handleDatePicker(sender: UIDatePicker)
      {
          
          
       
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd/MM/yyyy"
        //if self.txt_expectedDate.tag =={
              expectedDate = sender.date
              self.txt_expectedDate.text = dateFormatter.string(from: sender.date)
              //            appDelegate.arr_UpdatedDelegate_ProductList[dateTag].dealDate = dateFormatter.string(from: sender.date)

                  for arrEle in appDelegate.arr_UpdatedDelegate_ProductList {
                      for cat in self.categoryNames {
                          if self.lbl_division.text == cat && arrEle.categoryCode == self.lbl_division.text {
                          arrEle.dealDate = dateFormatter.string(from: sender.date)
                      }
                  }
              }
              
          //}
      }
      
      @objc func doneButtonClicked(_ sender: Any)
      {
          //your code when clicked on done
          handleDatePicker(sender: datePickerView)
      }
    
       func showOption()
        {
            arr_dealer.removeAll()
            arr_dealerName.removeAll()
        
        //commenting this to check new functionality
        
//            let arr = appDelegate.arr_updatedDealerList
//
//
//            for element in arr {
//                if element.categoryName == self.lbl_division.text {
//                    if !arr_dealer.contains(element) {
//                        arr_dealer.append(element)
//                    }
//                }
//            }
//
//            for ele in arr_dealer {
//                if arr_dealerName.count == 0 {
//                    let dealerInfo = ele.s_FullName! + " " + ele.s_RetailerSapCode!
//                    arr_dealerName.append(ele.s_FullName!)
//                }else {
//                    if !arr_dealerName.contains(ele.s_FullName!) {
//                        let dealerInfo = ele.s_FullName! + " " + ele.s_RetailerSapCode!
//                         arr_dealerName.append(ele.s_FullName!)
//                    }
//                }
//            }
        
        let arrDict = appDelegate.dealerDict
        
        for  ele in arrDict {
            if ele.key == self.lbl_division.text {
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

    //        selectDropDown.dataSource = arr_dealer.map{$0.s_FullName} as! [String]
            selectDropDown.dataSource = arr_dealerName

            selectDropDown.anchorView = self.txt_selectOption
            
//            self.txt_expectedDate.isEnabled = true
//            self.txt_remark.isEnabled = true
            selectDropDown.show()
            
        }
    
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
            

            if (textField.tag == 1)
            {
                 print("tag one select option ")
//                optionTag = textField.tag
                txt_responder = self.txt_selectOption
                showOption()
//                return false
                return true

            }

            else if(textField.tag == 2 )
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
        
         if (textField.tag == 3) {
                    
                    print("tag three remark ended")
//                                 appDelegate.arr_UpdatedDelegate_ProductList[textField.tag].remark = textField.text


                         for arrEle in appDelegate.arr_UpdatedDelegate_ProductList {
                             for cat in self.categoryNames  {
                             if self.lbl_division.text == cat && arrEle.categoryName == self.lbl_division.text  {
                                 arrEle.remark = self.txt_remark.text
                             }
                         }
                     }
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

