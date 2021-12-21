//
//  HeaderView.swift
 
//
//  Created by Gaurav Oka on 16/10/20.
//  Copyright © 2020 Apple.Inc. All rights reserved.
//

import Foundation
import DropDown




class HeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var lbl_oderName: UILabel!
    @IBOutlet weak var lbl_qty: UILabel!
    @IBOutlet weak var lbl_amount: UILabel!
}


class profileCell: UITableViewCell {
    
    @IBOutlet weak var lbl_profileName: UILabel!
    
    
    @IBOutlet weak var view_selectType: UIView!
    @IBOutlet weak var txt_selectType: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btn_selectType: UIButton!
    
    @IBOutlet weak var view_selectCat: UIView!
    @IBOutlet weak var txt_selectCat: SkyFloatingLabelTextField!
    
        
    @IBOutlet weak var btn_selectCat: UIButton!
    
    var arr_productNameCode = [Division]()
    var productnameCode = Division()

    
    var selectDropDown = DropDown()
    var txt_responder:SkyFloatingLabelTextField!

    var arr_selectedProductProfile = [ProductProfile]()
    
    
    override func awakeFromNib() {
        
        self.txt_selectType.delegate = self
        self.txt_selectCat.delegate = self
        setupDropDown()
        
        self.btn_selectType.addTarget(self, action: #selector(btn_selectType_pressed), for: .touchUpInside)
        self.btn_selectCat.addTarget(self, action: #selector(btn_selectCat_pressed), for: .touchUpInside)
        
    }
    
    @objc func btn_selectType_pressed(_ sender: UIButton)
       {
           txt_responder = self.txt_selectType
           showType()
       }
    
    @objc func btn_selectCat_pressed(_ sender: UIButton)
       {
           txt_responder = self.txt_selectCat
           showCat()
       }
    
    func setupDropDown()
       {

           selectDropDown.dismissMode = .automatic
           selectDropDown.separatorColor = .lightGray
   //        selectDropDown.width = self.txt_responder.frame.width
//            selectDropDown.bottomOffset = CGPoint(x: 0, y: self.view_selectCat.bounds.height)
//               selectDropDown.topOffset = CGPoint(x: 0, y:-(self.view_selectOption.bounds.height))

           selectDropDown.direction = .bottom
           selectDropDown.cellHeight = 30
           selectDropDown.backgroundColor = .white
           // Action triggered on selection
           selectDropDown.selectionAction = {(index, item) in
               if self.txt_responder  != nil{
                if self.txt_responder == self.txt_selectType {
                   self.txt_responder.text = item
                    
                    for ele in appDelegate.arr_productProfile {
                        if ele.DivCode ==  self.productnameCode.code {
                            ele.companyAssociate = item
                        }
                    }
                    
                    
                }else if self.txt_responder == self.txt_selectCat {
                    self.txt_responder.text = item
                    
                    for ele in appDelegate.arr_productProfile {
                        if ele.DivCode ==  self.productnameCode.code {
                            ele.Category = item
                        }
                    }
                    
                    
                 }
                
           }
       }
    }

    
    func showType()
     {

 //        selectDropDown.dataSource = arr_dealer.map{$0.s_FullName} as! [String]
         selectDropDown.dataSource = ["Dir. Partner","Retailer","Not Dealing"]
        selectDropDown.bottomOffset = CGPoint(x: 0, y: self.view_selectType.bounds.height)


         selectDropDown.anchorView = self.txt_selectType
         
//            self.txt_expectedDate.isEnabled = true
//            self.txt_remark.isEnabled = true
         selectDropDown.show()
         
     }
    
    
    
    func showCat()
     {

 //        selectDropDown.dataSource = arr_dealer.map{$0.s_FullName} as! [String]
         selectDropDown.dataSource = ["A","B","C"]
        selectDropDown.bottomOffset = CGPoint(x: 0, y: self.view_selectCat.bounds.height)

         selectDropDown.anchorView = self.txt_selectCat
         
//            self.txt_expectedDate.isEnabled = true
//            self.txt_remark.isEnabled = true
         selectDropDown.show()
         
     }
    
    
    
    
    
}

extension profileCell : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
       {
           

           if (textField == txt_selectType)
           {
                print("tag one select option ")
//                optionTag = textField.tag
            self.txt_responder = self.txt_selectType
            showType()
                return false
//               return true

           }

           else if(textField == txt_selectCat )
           {
               print("tag two select date ")
            print("tag one select option ")
//                optionTag = textField.tag
            self.txt_responder = self.txt_selectCat
            showCat()
            return false

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
}
