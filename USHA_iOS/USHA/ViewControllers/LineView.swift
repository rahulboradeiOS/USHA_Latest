//
//  LineView.swift
//  USHA Retailer
//
//  Created by Rahul on 23/07/21.
//  Copyright © 2021 Apple.Inc. All rights reserved.
//

import Foundation
import UIKit

protocol setTTLViewDelegate  {
    func setTTlView()
    func loadTableView()
}

class LineView: UIView {
    
    @IBOutlet weak var lbl_oderName: UILabel!
    @IBOutlet weak var lbl_qty: UILabel!
    @IBOutlet weak var lbl_amount: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}




class lineViewCell : UITableViewCell {
    
    @IBOutlet weak var lbl_oderName: UILabel!
    @IBOutlet weak var txt_qty: UITextField!
    @IBOutlet weak var lbl_amount: UILabel!
    @IBOutlet weak var btn_delete: UIButton!
    
    
    
    var arr_product = [Product]()
    
    var indexPath = IndexPath()
    
    var viewCon = OrderDetailsTableViewCell()
    
    var ordercartVC:OrderCartDetailsViewController!

    var ordercartDetailsViewCon = UIViewController()
    
    var setTTLViewDelegate : setTTLViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.txt_qty.delegate = self
        self.txt_qty.tag = 1
        
        
    }
    
    override func prepareForReuse() {
//        self.arr_product = []
    }
    
    
    @IBAction func btn_delete_pressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: appName, message: "doyouwanttodelete".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
                // yes action
                let yesAction = UIAlertAction(title: "YES", style: .default) { _ in
                    // replace data variable with your own data array
                    
                    let arr = appDelegate.arr_UpdatedDelegate_ProductList
                    let productName = self.arr_product[self.btn_delete.tag].categoryCode
                    
                    for ele in arr {
                        if ele.categoryCode == productName {
                            let index = arr.index(of: ele)
                            appDelegate.arr_UpdatedDelegate_ProductList.remove(at: index!)
                            break
                        }
                    }
                    self.arr_product.remove(at: self.btn_delete.tag)
                    //                   appDelegate.arr_UpdatedDelegate_ProductList.remove(at: indexPath.row)
//                    self.viewCon.subMenuTable.beginUpdates()
//                    self.viewCon.subMenuTable.deleteRows(at: [self.indexPath], with: .fade)
//                    self.viewCon.subMenuTable.endUpdates()
                    self.viewCon.arr_product = self.arr_product
                    self.viewCon.subMenuTable.reloadData()
                    
                    //                   appDelegate.arr_UpdatedDelegate_ProductList = self.arr_product  //chetanChange
                    //
                    
                    
                    let oderList = self.arr_product.filter({$0.qty > 0})
                    
                    self.viewCon.lbl_ttlSku.text = "TTL PRD \n \(oderList.count)"
                    self.viewCon.lbl_ttlQty.text = "TTL QTY \n \(self.arr_product.map({$0.qty}).reduce(0, +))"
                    
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    formatter.minimumFractionDigits = 2
                    formatter.maximumFractionDigits = 2
                    
                    if let roundedPriceString = formatter.string(for: self.arr_product.map({$0.amount}).reduce(0, +)) {
                    self.viewCon.lbl_ttlAmt.text = "TTL AMT \n \(roundedPriceString)"
                    }
                    
//                    self.viewCon.lbl_ttlAmt.text = "TTL AMT : \(self.arr_product.map({$0.amount}).reduce(0, +))"
                    
                    self.setTTLViewDelegate?.setTTlView()
                    
                    if self.arr_product.count == 0 {
                    self.setTTLViewDelegate?.loadTableView()
                    }
//                    let alert = UIAlertController(title: "", message: "PRODUCT REMOVE FROM CART SUCCESSFULLY!", preferredStyle: .alert)
//                    let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
//
//                    }
//
//                    alert.addAction(okAction)
//
//                    self.ordercartDetailsViewCon.present(alert, animated: true, completion: nil)
                    
                    self.ordercartDetailsViewCon.view.makeToast(message: "PRODUCT REMOVE FROM CART SUCCESSFULLY!")
//                    self.ordercartVC.arr_prod
//                    self.ordercartVC.tblView_orderCartDetails.reloadData()
                    
                    if appDelegate.arr_UpdatedDelegate_ProductList.count == 0{
                        
                        let alert = UIAlertController(title: "", message: "YOUR ORDER CART IS EMPTY ! PLEASE ADD PRODUCTS TO ORDER ", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                            self.ordercartDetailsViewCon.navigationController?.popViewController(animated: true)
                            
                        }
                        
                        alert.addAction(okAction)
                        
                        self.ordercartDetailsViewCon.present(alert, animated: true, completion: nil)
                        
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
                alert.addAction(UIAlertAction(title: "NO", style: .destructive, handler: nil))
                
                self.ordercartDetailsViewCon.present(alert, animated: true, completion: nil)
    }
    
    
}


extension lineViewCell : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        
        if textField == self.txt_qty {
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
        }else {
            return true
        }
    }
    
     func textFieldDidEndEditing(_ textField: UITextField)
         {
 
            if (textField == self.txt_qty)
            {
                print("in textfield delegate method")
                let product = arr_product[self.tag]
                
                if let qty = Int(textField.text!)
                {
                    product.qty = qty
                }
                else
                {
                    product.qty = 0
                }
                product.amount =  product.price! * Double(product.qty)
                
                let oderList = arr_product.filter({$0.qty > 0})
                viewCon.lbl_ttlSku.text = "\(oderList.count)"
                viewCon.lbl_ttlQty.text = "\(arr_product.map({$0.qty}).reduce(0, +))"
                
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.minimumFractionDigits = 2
                formatter.maximumFractionDigits = 2
                
                if let roundedPriceString = formatter.string(for: arr_product.map({$0.amount}).reduce(0, +)) {
                    viewCon.lbl_ttlAmt.text = "\(roundedPriceString)"
                }
                
                //                              viewCon.lbl_ttlAmt.text = "TTL AMT : \(arr_product.map({$0.amount}).reduce(0, +))"
                arr_product[self.tag] = product
                let ip = IndexPath(row: self.tag, section: 0)
                
                let arr = appDelegate.arr_UpdatedDelegate_ProductList
                let productName = arr_product[self.tag].name
                for ele in arr {
                    if ele.name == productName {
                        if  let ind = arr.index(of: ele) {
                            product.divisionName = product.categoryName  //need to change
                            appDelegate.arr_UpdatedDelegate_ProductList[ind] = product
                            break
                        }
                    }
                }
                
                
                viewCon.subMenuTable.reloadRows(at: [ip], with: .automatic)
                //                ordercartDetailsViewCon.setTTlView()
                
                setTTLViewDelegate?.setTTlView()
                
            }
            
    }
    
}

