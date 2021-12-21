//
//  OrderViewController.swift
 
//
//  Created by Apple.Inc on 18/12/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
import IQKeyboardManagerSwift

let hName = "MAT.CODE-DESC.(unit)"
let hQty = "QTY"
let hAmount = "AMOUNT(excl.GST)"
var flag:Int = 0


class OrderViewController: BaseViewController
{
  

    @IBOutlet weak var txt_selectDivision: SkyFloatingLabelTextField!
    @IBOutlet weak var btn_selectDivision: UIButton!
    @IBOutlet weak var btn_selectCategory: UIButton!

    @IBOutlet weak var view_selectDivision: UIView!
    @IBOutlet weak var view_selectCategory: UIView!
    @IBOutlet weak var view_selectCatType: UIView!
    @IBOutlet weak var view_SubCategory: UIView!


    @IBOutlet weak var txt_selectCategory: SkyFloatingLabelTextField!
    @IBOutlet weak var txt_selectSubCategory : SkyFloatingLabelTextField!
    @IBOutlet weak var txt_selectSub4Category : SkyFloatingLabelTextField!
    @IBOutlet weak var btn_selectSubCategory: UIButton!

    @IBOutlet weak var lbl_NoData: UILabel!
    @IBOutlet weak var tableview_Order: UITableView!
    
    @IBOutlet weak var btn_next: UIButton!
    
    @IBOutlet weak var lbl_ttlSku: UILabel!
    @IBOutlet weak var lbl_ttlQty: UILabel!
    @IBOutlet weak var lbl_ttlAmt: UILabel!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var txt_searchData : UITextFieldX!
    @IBOutlet weak var lblPartnerNameNCode : UILabel!
    

    var MDM_CODE = ""
    var saleOffice_CODE = ""
    
    var divisionTxt:String=""
    var divisionCode:String=""
    var drop2:String=""
    var drop3:String=""
    var drop4:String=""
    var txt_searchBar:UITextField!
    var txt_responder:UITextField!
    var orderList = [Product]()

    var divisionNameArray = [String]()

    let selectDropDown = DropDown()
    var dealer:Dealer!

    var arr_Division = [Division]()
    var arr_Category = [Division]()
    var arr_SubCategory = [Division]()
    var arr_Sub4Category = [Division]()
    var arr_ProductList = [Product]()
    var filterArr_ProductList = [Product]()
    var callAction = ""
    var SkuCategory:Division!
    var SkuSubCategory:Division!
    var SkuMaterialType:Division!
    var SkuCatType:Division!
    var myData : String!
    var selectedTAG : Int = 0
    var arr_DealerCode:[Dealer]!
    var arr_DealerList = [Dealer]()
    var divisionEle = [String:String]()
    var divisionDict = [[String:String]]()

    var isAdded: Bool = false

    var SearchBarValue:String!
    var searchActive : Bool = false
    var searchCheck : Bool = false

    var mySelectedProductListArray : [Product] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        refresh()
        searchActive = true
        divisionTxt = ""
        divisionCode = ""
        //searchView.isHidden = true
//        if txt_selectCategory.text != ""{
//            searchView.isHidden = false
//        }
//        else if txt_selectSubCategory.text != ""{
//            searchView.isHidden = true
//        }
//        else{
//            searchView.isHidden = true
//        }
        // Do any additional setup after loading the view.
        callAction = ActionType.SKUCategory
        getData()
        setupDropDown()
        selectByDivision()
     
             self.lbl_ttlSku.text = "TTL SKU : \(0)"
             self.lbl_ttlQty.text = "TTL QTY : \(0)"
             self.lbl_ttlAmt.text = "TTL AMT : \(0)"
            
        txt_selectDivision.delegate = self
        txt_selectCategory.delegate = self
        txt_selectSubCategory.delegate = self
        txt_selectSub4Category.delegate = self
        txt_searchData.delegate = self
        
        let headerNib = UINib.init(nibName: "DemoHeaderView", bundle: Bundle.main)
        tableview_Order.register(headerNib, forHeaderFooterViewReuseIdentifier: "DemoHeaderView")
        
        setUpDesign()
    }
    
        func setUpDesign(){
            
           // btn_next.layer.cornerRadius = 17.5
           // btn_next.layer.masksToBounds = true
 
            view_selectDivision.layer.cornerRadius = 17
            view_selectDivision.layer.borderWidth = 1.0
            view_selectDivision.layer.borderColor = UIColor.lightGray.cgColor
            view_selectDivision.layer.masksToBounds = true
            
            view_selectCategory.layer.cornerRadius = 17
            view_selectCategory.layer.borderWidth = 1.0
            view_selectCategory.layer.borderColor = UIColor.lightGray.cgColor
            view_selectCategory.layer.masksToBounds = true
            
            view_selectCatType.layer.cornerRadius = 17
            view_selectCatType.layer.borderWidth = 1.0
            view_selectCatType.layer.borderColor = UIColor.lightGray.cgColor
            view_selectCatType.layer.masksToBounds = true
            
            view_SubCategory.layer.cornerRadius = 17
            view_SubCategory.layer.borderWidth = 1.0
            view_SubCategory.layer.borderColor = UIColor.lightGray.cgColor
            view_SubCategory.layer.masksToBounds = true
            
            txt_searchData.layer.cornerRadius = 17
            txt_searchData.layer.borderWidth = 1.0
            txt_searchData.layer.borderColor = UIColor.lightGray.cgColor
            txt_searchData.layer.masksToBounds = true
      
       }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refresh()
        searchActive = true
        divisionTxt = ""
        divisionCode = ""
        LanguageChanged(strLan:keyLang)
    
        let uniqueArray = appDelegate.arr_UpdatedDelegate_ProductList.uniques(by: \.code)

        if appDelegate.arr_UpdatedDelegate_ProductList.count > 0{
            //btn_next.isHidden = false

        }else{
            flag = 0
            txt_selectDivision.isUserInteractionEnabled = true
            txt_selectDivision.text = ""
            txt_selectCategory.text = ""
            
            selectByDivision()
            self.searchCheck = false
            self.txt_searchData.text = ""
            refreshData()
            //self.tableview_Order.reloadData()
//            flag = 0
//            txt_selectDivision.isUserInteractionEnabled = true
//            txt_selectDivision.text = ""
//            arr_ProductList.removeAll()
//            mySelectedProductListArray.removeAll()
            
            ////btn_next.isHidden = true
        }
    }
    
    
    func LanguageChanged(strLan:String){
   
        btn_next.setTitle("NEXT".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), for: UIControlState.normal)
    }
    

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        callAction = ActionType.SKUCategory
        getData()
        setupDropDown()
        selectByDivision()
        selectionChange()
        txt_selectDivision.delegate = self
        txt_selectCategory.delegate = self
        txt_selectSubCategory.delegate = self
        txt_selectSub4Category.delegate = self
//        if txt_selectCategory.text != ""{
//            searchView.isHidden = false
//        }
//        else if txt_selectSubCategory.text != ""{
//            searchView.isHidden = true
//        }
//        else{
//            searchView.isHidden = true
//        }
        

    }
    @IBAction func searchBtnPressed(_ sender: Any) {
        print("Searching")
        print(filterArr_ProductList)
        print(arr_ProductList)
        self.filterArr_ProductList = self.arr_ProductList
        DispatchQueue.main.async {
            self.refreshData()
        }
        
    }
    
    @IBAction func btn_Back_pressed(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func onBackButtonPressed(_ sender: UIButton)
    {
        exitAlert()
        //self.navigationController?.popViewController(animated: true)
    }
    
    func exitAlert()
    {
        let alert = UIAlertController(title: appName, message: "productListErrorMsg".localizableString(loc:
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
        appDelegate.arr_UpdatedDelegate_ProductList = []
        appDelegate.arr_UpdatedDelegate_ProductList.removeAll()
        appDelegate.arr_updatedDealerList = []
        appDelegate.arr_updatedDealerList.removeAll()
        appDelegate.dealerDict.removeAll()
        print(arr_ProductList.count)
        self.tableview_Order.reloadData()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func noPressed(alert: UIAlertAction!)
    {
    }
    
    func setupDropDown()
    {
        selectDropDown.dismissMode = .automatic
        selectDropDown.separatorColor = .lightGray
        //selectDropDown.width = view_selectDivision.frame.width
        selectDropDown.bottomOffset = CGPoint(x: 0, y: txt_selectDivision.bounds.height)
        selectDropDown.direction = .bottom
        selectDropDown.cellHeight = 40
        selectDropDown.backgroundColor = .white
        // Action triggered on selection
        selectDropDown.selectionAction = {(index, item) in
            print(index)
            print(item)
            
            self.txt_responder.text = item
            if self.txt_responder.text == "SELECT CATEGORY"{
                self.searchActive = true
                self.arr_Category.removeAll()
                self.arr_SubCategory.removeAll()
                self.arr_Sub4Category.removeAll()
                self.txt_selectCategory.text = ""
                self.txt_selectSubCategory.text = ""
                self.txt_selectSub4Category.text = ""
                self.divisionTxt = ""
                self.divisionCode = ""
                self.drop2 = ""
                self.drop3 = ""
                self.drop4 = ""
                self.txt_searchData.text = ""
                self.filterArr_ProductList.removeAll()
                self.arr_ProductList.removeAll()
                self.tableview_Order.reloadData()
            }
            if self.txt_responder.text == "SELECT DIVISION"{
                self.searchActive = true
                self.arr_SubCategory.removeAll()
                self.arr_Sub4Category.removeAll()
                self.txt_selectSubCategory.text = ""
                self.txt_selectSub4Category.text = ""
                self.drop2 = ""
                self.drop3 = ""
                self.drop4 = ""
                self.txt_searchData.text = ""
                self.filterArr_ProductList.removeAll()
                self.arr_ProductList.removeAll()
                self.tableview_Order.reloadData()
            }
            if self.txt_responder.text == "SELECT CAT TYPE"{
                self.searchActive = true
                self.arr_Sub4Category.removeAll()
                self.txt_selectSub4Category.text = ""
                self.drop3 = ""
                self.drop4 = ""
                self.txt_searchData.text = ""
                self.filterArr_ProductList.removeAll()
                self.arr_ProductList.removeAll()
                self.tableview_Order.reloadData()
            }
            if self.txt_responder.text == "SELECT SUB CATEGORY"{
                self.searchActive = true
                self.drop4 = ""
                self.filterArr_ProductList.removeAll()
                self.arr_ProductList.removeAll()
                self.tableview_Order.reloadData()
            }
            if index != 0{
                var index = index - 1
            
            if(self.txt_responder == self.txt_selectDivision)
            {

                    if  self.arr_Division[index].name != nil,
                        self.arr_Division[index].code != nil && self.arr_Division[index].name != "SELECT CATEGORY"
                    {
                        self.SkuCategory = self.arr_Division[index]
                        
                        UserDefaults.standard.set(self.arr_Division[index].name, forKey: "SeletedDivision")
                        print(self.arr_Division[index].name)
                        
                        let defaults = UserDefaults.standard
                        defaults.set(self.arr_Division[index].name, forKey: "DivisionValue")
                        
                        self.divisionTxt = self.arr_Division[index].name!
                        self.divisionCode = self.arr_Division[index].code!
                        self.searchActive = true
                        self.txt_selectCategory.text = ""
                        self.txt_selectSubCategory.text = ""
                        self.txt_selectSub4Category.text = ""
                        self.txt_searchData.text = ""
                        self.filterArr_ProductList.removeAll()
                        self.arr_ProductList.removeAll()
                        self.tableview_Order.reloadData()
                       // self.searchView.isHidden = true
                        self.callAction = ActionType.SKUSubCategory
                        self.getData()
                    }
                    else
                    {
                        self.showAlert(msg: "CATEGORY NOT FOUND")
                    }
            }
            else if(self.txt_responder == self.txt_selectCategory)
            {
                print(self.arr_Category[index].name)
                    print(self.arr_Category[index].code)
                if  self.arr_Category[index].name != nil,
                    self.arr_Category[index].code != nil &&  self.arr_Category[index].name != "SELECT DIVISION"
                {
                    self.SkuSubCategory = self.arr_Category[index]
                    self.txt_selectSubCategory.text = ""
                    self.txt_selectSub4Category.text = ""
                    self.txt_searchData.text = ""
                    self.filterArr_ProductList.removeAll()
                    self.arr_ProductList.removeAll()
                    self.tableview_Order.reloadData()
                    
                    print(self.arr_Category[index].code)
                    self.searchActive = true
                    self.drop2 = self.arr_Category[index].code!
                    UserDefaults.standard.set(self.arr_Category[index].code, forKey: "UD_CODE")

                    self.callAction = ActionType.SKUMaterialType
                   // self.searchView.isHidden = false
                    self.getData()
                }
                else
                {
                    self.showAlert(msg: "SUBCATEGORY NOT FOUND")
                }
            }
                else if(self.txt_responder == self.txt_selectSubCategory)
                {
                    if  self.arr_SubCategory[index].name != nil,
                        self.arr_SubCategory[index].code != nil
                    {
                        self.SkuMaterialType = self.arr_SubCategory[index]
                        
                        self.txt_selectSub4Category.text = ""
                      //  self.searchView.isHidden = true
                        print(self.arr_SubCategory[index].code)
                        self.searchActive = true
                        self.drop3 = self.arr_SubCategory[index].code!
                        self.callAction = ActionType.SKUCatType
                        self.getData()
                    }
                    else
                    {
                        self.showAlert(msg: "SUBCATEGORY NOT FOUND")
                    }
                }
                else if(self.txt_responder == self.txt_selectSub4Category)
                               {
                                   if  self.arr_Sub4Category[index].name != nil,
                                       self.arr_Sub4Category[index].code != nil
                                   {
                                       self.SkuCatType = self.arr_Sub4Category[index]
                                       print(self.arr_Sub4Category[index].code)
                                    self.searchActive = false
                                    self.drop4 = self.arr_Sub4Category[index].code!
                                       self.callAction = ActionType.GetProductByMaterialType
                                       self.getData()
                                   }
                                   else
                                   {
                                       self.showAlert(msg: "SUBCATEGORY NOT FOUND")
                                   }
                               }
            else if(self.txt_responder == self.txt_searchBar)
            {
               // self.searchBar_material.resignFirstResponder()
                if  self.arr_Category[index].name != nil,
                    self.arr_Category[index].code != nil
                {
                    self.SkuSubCategory = self.arr_Category[index]
                    
                    let defaults = UserDefaults.standard
                    defaults.set(self.arr_Category[index].code, forKey: "DivisionValue")
                    
                    self.callAction = ActionType.GetProductByCode
                    self.getData()
                }
                else
                {
                    self.showAlert(msg: "SUBCATEGORY NOT FOUND")
                }
                }
            }
        }
    }

    func getData()
    {
        //btn_next.isHidden = true
        //tableview_Order.isHidden = true
        
         //MARK: I HAVE CHANGED

        var parameters:Parameters = [:]
        var callApi = ""
        if(callAction == ActionType.SKUCategory)
        {
            callApi = API.GetUserDrpCode
            parameters = [Key.ActionTypes: callAction]
        }
        else if(callAction == ActionType.SKUSubCategory)
        {
            callApi = API.GetUserDrpCode
            parameters = [Key.ActionTypes: callAction, Key.SKUCode: SkuCategory.code!]
            
            print(parameters)
        }
        else if(callAction == ActionType.Edit)
        {
            callApi = API.EditUserRegistration
            print(DataProvider.sharedInstance.userDetails.s_UserCode!)
            parameters = [Key.UserCode: DataProvider.sharedInstance.userDetails.s_UserCode!,
                          Key.ActionTypes: callAction]
        }
        else if(callAction == ActionType.GetDealerCode)
        {
            callApi = API.GetRDDMDetailsmapping
            //pass array here
            
            for orderEle in orderList {
                
                //                let objdivlist = DivisionList()
                //                objdivlist.DivisionCode = orderEle.categoryCode
                //                arrDivisionList.append(objdivlist)
                
                divisionEle["DivisionCode"] = orderEle.categoryCode
                
                if divisionDict.count == 0 {
                    divisionDict.append(divisionEle)
                }else {
                    if !divisionDict.contains(divisionEle) {
                        divisionDict.append(divisionEle)
                    }
                }
                
                
            }
            
            print("arrDivisionList:  \(divisionDict)")
            print(" Json arrDivisionList:  \(JSON(divisionDict))")
            
            let data =  UserDefaults.standard.string(forKey: "UD_CODE")

            parameters = [Key.ActionType: callAction,
                          Key.SkuCategory:data ?? "",//arr_ProductList[1].categoryCode!,
                          Key.SalesOfficeCode: saleOffice_CODE,
                          Key.UserCode: DataProvider.sharedInstance.userDetails.s_UserCode!]
        }
        else if(callAction == ActionType.SKUMaterialType)
                 {
                     callApi = API.GetUserDrpCode
                     parameters = [Key.ActionTypes: callAction, Key.SKUCode: SkuCategory.code!,Key.SKUSubCode: SkuSubCategory.code!]
                    print(parameters)
                   // {"ActionTypes":"SKUMaterialType","SKUCode":"1","SKUSubCode":"2"}

                 }
            
            else if(callAction == ActionType.SKUCatType)
                           {
                               callApi = API.GetUserDrpCode
                               parameters = [Key.ActionTypes: callAction,Key.SKUSubCode: SkuMaterialType.code!]
                              print(parameters)

                           }
            
        else if(callAction == ActionType.GetProductByMaterialType)
        {
            txt_searchData.text = nil
            searchCheck = false
            //self.filterArr_ProductList.removeAll()
            callApi = API.GetProductByCatSubCat
            parameters = [Key.ActionType: callAction, Key.SkuCategory: SkuCatType.code!]
            print(parameters)
//7{"SkuCategory":"Coffee Maker","ActionType":"GetProductByMaterialType"}

        }
            
            
        else if(callAction == ActionType.GetProductByMatCode)
        {
            callApi = API.GetMaterialCode
            //parameters = [Key.ActionType: callAction, Key.MaterialCode: SkuSubCategory.code!, Key.SkuCategory: txt_searchData.text!]
            parameters = ["SkuCategory":drop2,"MaterialCode":txt_searchData.text!,"SkuSubCategory":drop4,"SKU_MaterialType":drop3,"subcategory":divisionTxt,"ActionType":"GetProductByMatCode"]
            print(parameters)
        }
        else if(callAction == ActionType.GetProductByCode)
        {
            callApi = API.GetProductByCatSubCat
            parameters = [Key.ActionType: callAction, Key.MaterialCode: SkuSubCategory.code!]
        }
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: callApi, parameters: parameters, viewcontroller: self, actionType: callAction)
    }
    func suggestionSearchBar(MaterialCode:String)
    {
        let manager = Alamofire.SessionManager.default
        let parameters = ["ActionType": "GetProductByMatCode", "MaterialCode": MaterialCode, "SkuCategory":SkuSubCategory.code!]
        print(parameters)
       // var url = "https://retailerwebapiqa.usha.com:5065/api/Transction/GetMaterialCode"
         var url = mainUrl + "/api/Transction/GetMaterialCode"
        manager.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                print(response)
                print(response.result)
            }
        

    }
    func selectByDivision()
    {
      
        self.selectedTAG = 1

//        view_byDivision.isHidden = false
//        view.bringSubview(toFront: view_byDivision)
        selectionChange()

    }
    
    func selectByMaterial()
    {
        self.selectedTAG = 2

        selectionChange()
        txt_searchBar!.text = ""
    

    }
    
    func selectionChange()
    {
        arr_ProductList = []
    
        
        if flag == 1{
            txt_selectDivision.isUserInteractionEnabled = false
          
            flag = 0
        }else{
            txt_selectDivision.isUserInteractionEnabled = true
          
        }
        
        
        txt_selectCategory.text = ""
        txt_selectSubCategory.text = ""
        txt_selectSub4Category.text = ""
        txt_searchData.text = ""
        refreshData()
//        tableview_Order.reloadData()
//        tableview_Order.isHidden = true
//        lbl_NoData.isHidden = true
        // btn_next.isHidden = true
    }
    @objc func didPressOnDoneButton() {
//        callAction = ActionType.GetProductByMatCode
//        getData()
        if txt_searchData.text == ""{
            self.filterArr_ProductList.removeAll()
            self.arr_ProductList.removeAll()
            self.tableview_Order.reloadData()
        }
        txt_searchData.delegate = self
        txt_searchData.resignFirstResponder()
        
    }
//    @IBAction func btn_byDivision_pressed(_ sender: UIButton)
//    {
//        selectByDivision()
//    }
//
//    @IBAction func btn_byMaterial_pressed(_ sender: UIButton)
//    {
//        selectByMaterial()
//    }
    
    @IBAction func btn_selectDivision_pressed(_ sender: UIButton)
    {
        _ = txt_selectDivision.becomeFirstResponder()
    }
    
    @IBAction func btn_selectCategory_pressed(_ sender: UIButton)
    {
        _ = txt_selectCategory.becomeFirstResponder()
    }
    
    @IBAction func btn_selectSubCategory_pressed(_ sender: UIButton)
    {
        _ = txt_selectSubCategory.becomeFirstResponder()
    }
    
    @IBAction func btn_selectSub4Category_pressed(_ sender: UIButton)
    {
        _ = txt_selectSub4Category.becomeFirstResponder()
    }
    func autoAddData() {
        if var dealerArray = self.arr_DealerCode {
            dealerArray.removeAll()
        }
//        if((self.arr_DealerCode) == nil)
//        {
//            //self.arr_DealerCode = [dc]
//            print("NO DEALER LINKED WITH SELECTED CATEGORY")
//            showAlert(msg: "NO DEALER LINKED WITH SELECTED CATEGORY")
//        }
//        else
//        {
            //print(arr_DealerCode.count)
            orderList = arr_ProductList.filter({$0.qty > 0})
            if(orderList.count > 0)
            {
                //call here get dealer no
                
                callAction = ActionType.Edit
                getData()
                
                //            flag = 1
                //
                //            mySelectedProductListArray.append(contentsOf: orderList)
                //
                //            for index:Product in orderList{
                //
                //                appDelegate.arr_UpdatedDelegate_ProductList.append(index)
                //
                //            }
                //
                //            self.view.makeToast(message: "Products Are added to the cart!")
                //            arr_ProductList.removeAll()
                //            txt_selectDivision.text = ""
                //            txt_selectCategory.text = ""
                //            self.tableview_Order.reloadData()
                
            }
            else
            {
                let orderList = arr_ProductList.filter({$0.qty > 0})
                if(orderList.count > 0)
                {
                    
                    if arr_ProductList.count > 0{
                        
                        let orderList = arr_ProductList.filter({$0.qty > 0})
                        
                        if(orderList.count > 0)
                        {
                            
                            callAction = ActionType.Edit
                            getData()
                        }
                        //                    flag = 1
                        //
                        //
                        //                    for index:Product in orderList{
                        //
                        //                        appDelegate.arr_UpdatedDelegate_ProductList.append(index)
                        //
                        //                    }
                        //                    self.view.makeToast(message: "Products Are added to the cart!")
                        //                    arr_ProductList.removeAll()
                        //                    txt_selectDivision.text = ""
                        //                    txt_selectCategory.text = ""
                        //                    self.tableview_Order.reloadData()
                        
                    }
                }else{
                    
                    showAlert(msg: "Product added to Cart".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                }
            }
            // self.arr_DealerCode.insert(dc, at: 0)
       // }
        
    }
    @IBAction func btn_next_pressed(_ sender: UIButton)
    {
        if var dealerArray = self.arr_DealerCode {
            dealerArray.removeAll()
        }
//        if((self.arr_DealerCode) == nil)
//        {
//            //self.arr_DealerCode = [dc]
//            print("NO DEALER LINKED WITH SELECTED CATEGORY")
//            showAlert(msg: "NO DEALER LINKED WITH SELECTED CATEGORY")
//        }
//        else
//        {
            //print(arr_DealerCode.count)
            orderList = arr_ProductList.filter({$0.qty > 0})
            if(orderList.count > 0)
            {
                //call here get dealer no
                
                callAction = ActionType.Edit
                getData()
                
                //            flag = 1
                //
                //            mySelectedProductListArray.append(contentsOf: orderList)
                //
                //            for index:Product in orderList{
                //
                //                appDelegate.arr_UpdatedDelegate_ProductList.append(index)
                //
                //            }
                //
                //            self.view.makeToast(message: "Products Are added to the cart!")
                //            arr_ProductList.removeAll()
                //            txt_selectDivision.text = ""
                //            txt_selectCategory.text = ""
                //            self.tableview_Order.reloadData()
                
            }
            else
            {
                let orderList = arr_ProductList.filter({$0.qty > 0})
                if(orderList.count > 0)
                {
                    
                    if arr_ProductList.count > 0{
                        
                        let orderList = arr_ProductList.filter({$0.qty > 0})
                        print(orderList)
                        if(orderList.count > 0)
                        {
                            
                            callAction = ActionType.Edit
                            getData()
                        }
                        //                    flag = 1
                        //
                        //
                        //                    for index:Product in orderList{
                        //
                        //                        appDelegate.arr_UpdatedDelegate_ProductList.append(index)
                        //
                        //                    }
                        //                    self.view.makeToast(message: "Products Are added to the cart!")
                        //                    arr_ProductList.removeAll()
                        //                    txt_selectDivision.text = ""
                        //                    txt_selectCategory.text = ""
                        //                    self.tableview_Order.reloadData()
                        
                    }
                }else{
                    print("Product")
                   // showAlert(msg: "addProduct".localizableString(loc: UserDefaults.standard.string(forKey: "keyLang")!))
                }
            }
            // self.arr_DealerCode.insert(dc, at: 0)
       // }
        
    }
//    {
//        let orderList = arr_ProductList.filter({$0.qty > 0})
//
//        let orderList = appDelegate.arr_UpdatedDelegate_ProductList.filter({$0.qty > 0})
//        let uniqueProductList = orderList.uniques(by: \.code)
//        print("UNIQUE ID:\(uniqueProductList)")
//        appDelegate.arr_UpdatedDelegate_ProductList = uniqueProductList
//
//        if(orderList.count > 0)
//        {
//
//            let detailVC = getViewContoller(storyboardName: Storyboard.Main, identifier: "OrderCartDetailsViewController") as! OrderCartDetailsViewController
//            detailVC.selectedTAG = self.selectedTAG
//            detailVC.arr_ProductList = appDelegate.arr_UpdatedDelegate_ProductList
//            detailVC.SkuCategory = self.SkuCategory
//            detailVC.delegate = self
//            ////        detailVC.delegate = self
//            self.navigationController?.pushViewController(detailVC, animated: true)
//
//            //            let detailVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.OrderDetailViewController) as! OrderDetailViewController
//            //            detailVC.selectedTAG = self.selectedTAG
//            //            detailVC.arr_ProductList = appDelegate.arr_UpdatedDelegate_ProductList
//            //            detailVC.SkuCategory = self.SkuCategory
//            //            detailVC.delegate = self
//            //            self.navigationController?.pushViewController(detailVC, animated: true)
//        }
//        else
//        {
//            let orderList = appDelegate.arr_UpdatedDelegate_ProductList.filter({$0.qty > 0})
//            if(orderList.count > 0)
//            {
//
//                if appDelegate.arr_UpdatedDelegate_ProductList.count > 0{
//
//                    let orderList = arr_ProductList.filter({$0.qty > 0})
//
//                    let detailVC = getViewContoller(storyboardName: Storyboard.Main, identifier: "OrderCartDetailsViewController") as! OrderCartDetailsViewController
//                    detailVC.selectedTAG = self.selectedTAG
//                    detailVC.arr_ProductList = appDelegate.arr_UpdatedDelegate_ProductList
//                    detailVC.SkuCategory = self.SkuCategory
//                    detailVC.delegate = self
//                    ////        detailVC.delegate = self
//                    self.navigationController?.pushViewController(detailVC, animated: true)
//                }
//            }else{
//
//                showAlert( msg: "noProduct".localizableString(loc:
//                    UserDefaults.standard.string(forKey: "keyLang")!))
//            }
//        }
//    }
//    {
//
//        let orderList = arr_ProductList.filter({$0.qty > 0})
//        let uniqueProductList = orderList.uniques(by: \.code)
//        appDelegate.arr_UpdatedDelegate_ProductList = uniqueProductList
//        if(orderList.count > 0)
//        {
//
//            flag = 1
//
//            mySelectedProductListArray.append(contentsOf: orderList)
//
//            for index:Product in orderList{
//                index.categoryName = divisionTxt!
//                index.categoryCode = divisionCode!
//                index.divisionName = divisionTxt!
//                appDelegate.arr_UpdatedDelegate_ProductList.append(index)
//
//            }
//
//
//           // let detailVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.OrderDetailViewController) as! OrderDetailViewController
////            let detailVC = getViewContoller(storyboardName: Storyboard.Main, identifier: "OrderCartDetailsViewController") as! OrderCartDetailsViewController
////            detailVC.selectedTAG = self.selectedTAG
////            detailVC.arr_ProductList = appDelegate.arr_UpdatedDelegate_ProductList
////            print(self.SkuCategory)
////            detailVC.SkuCategory = self.SkuCategory
////            detailVC.arr_div = self.arr_Division
////            detailVC.delegate = self
////            self.navigationController?.pushViewController(detailVC, animated: true)
//        }
//        else
//        {
//            let orderList = appDelegate.arr_UpdatedDelegate_ProductList.filter({$0.qty > 0})
//            if(orderList.count > 0)
//            {
//
//            if appDelegate.arr_UpdatedDelegate_ProductList.count > 0{
//
//                let orderList = arr_ProductList.filter({$0.qty > 0})
//
//                flag = 1
//
//
//                for index:Product in orderList{
//                    index.categoryName = divisionTxt!
//                    index.categoryCode = divisionCode!
//                    index.divisionName = divisionTxt!
//                    appDelegate.arr_UpdatedDelegate_ProductList.append(index)
//
//                }
//
//                //let detailVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.OrderDetailViewController) as! OrderDetailViewController
////                let detailVC = getViewContoller(storyboardName: Storyboard.Main, identifier: "OrderCartDetailsViewController") as! OrderCartDetailsViewController
////                detailVC.selectedTAG = self.selectedTAG
////                detailVC.arr_ProductList = appDelegate.arr_UpdatedDelegate_ProductList
////                print(self.SkuCategory)
////                detailVC.SkuCategory = self.SkuCategory
////                detailVC.arr_div = self.arr_Division
////                detailVC.delegate = self
////                self.navigationController?.pushViewController(detailVC, animated: true)
//            }
//            }else{
//
//                showAlert(msg: "addProduct".localizableString(loc:
//                    UserDefaults.standard.string(forKey: "keyLang")!))
//            }
//        }
//
//    }
    
    @IBAction func btn_ViewCart_Pressed(_ sender: Any)
    {
        txt_searchData.delegate = self
        txt_searchData.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let orderList = appDelegate.arr_UpdatedDelegate_ProductList.filter({$0.qty > 0})
            let uniqueProductList = orderList.uniques(by: \.code)
            print("UNIQUE ID:\(uniqueProductList)")
            appDelegate.arr_UpdatedDelegate_ProductList = uniqueProductList
            print(orderList.count)
            if(orderList.count > 0)
            {
                
                let orderCartView = getViewContoller(storyboardName: Storyboard.Main, identifier: "OrderCartDetailsViewController") as! OrderCartDetailsViewController
                orderCartView.selectedTAG = self.selectedTAG
                print(appDelegate.arr_UpdatedDelegate_ProductList)
                print( self.SkuCategory)
                var div = appDelegate.arr_UpdatedDelegate_ProductList
                var d = div
                for element in d {
                  // element.categoryName = divisionText
                    print(element.categoryName)
                    print(element.amount)
                    print(element.dealerCode)
                    print(element.divisionName)
                    print(element.qty)
                    print(element.SubCategoryName)
                    print(element.price)
                    print(element.name)
                       }
                orderCartView.arr_ProductList = appDelegate.arr_UpdatedDelegate_ProductList
                orderCartView.SkuCategory = self.SkuCategory
                ////        detailVC.delegate = self
                self.navigationController?.pushViewController(orderCartView, animated: true)
                
                //            let detailVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.OrderDetailViewController) as! OrderDetailViewController
                //            detailVC.selectedTAG = self.selectedTAG
                //            detailVC.arr_ProductList = appDelegate.arr_UpdatedDelegate_ProductList
                //            detailVC.SkuCategory = self.SkuCategory
                //            detailVC.delegate = self
                //            self.navigationController?.pushViewController(detailVC, animated: true)
            }
            else
            {
                let orderList = appDelegate.arr_UpdatedDelegate_ProductList.filter({$0.qty > 0})
                if(orderList.count > 0)
                {
                    
                    if appDelegate.arr_UpdatedDelegate_ProductList.count > 0{
                        
                        let orderList = self.arr_ProductList.filter({$0.qty > 0})
                        
                        let orderCartView = getViewContoller(storyboardName: Storyboard.Main, identifier: "OrderCartDetailsViewController") as! OrderCartDetailsViewController
                        orderCartView.selectedTAG = self.selectedTAG
                        orderCartView.arr_ProductList = appDelegate.arr_UpdatedDelegate_ProductList
                        orderCartView.SkuCategory = self.SkuCategory
                        ////        detailVC.delegate = self
                        self.navigationController?.pushViewController(orderCartView, animated: true)
                    }
                }else{
                    
                    self.showAlert( msg: "noProduct".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                }
            }
        }
    }
//    {
//        let orderList = arr_ProductList.filter({$0.qty > 0})
//        let uniqueProductList = orderList.uniques(by: \.code)
//        appDelegate.arr_UpdatedDelegate_ProductList = uniqueProductList
//        if(orderList.count > 0)
//        {
//            let detailVC = getViewContoller(storyboardName: Storyboard.Main, identifier: "OrderCartDetailsViewController") as! OrderCartDetailsViewController
//            detailVC.selectedTAG = self.selectedTAG
//            detailVC.arr_ProductList = appDelegate.arr_UpdatedDelegate_ProductList
//            print(self.SkuCategory)
//            detailVC.SkuCategory = self.SkuCategory
//            detailVC.arr_div = self.arr_Division
//            detailVC.divisionText = self.divisionTxt!
//            detailVC.delegate = self
//            self.navigationController?.pushViewController(detailVC, animated: true)
//
//        }else{
//
//            showAlert(msg: "addProduct".localizableString(loc:
//                UserDefaults.standard.string(forKey: "keyLang")!))
//        }
//    }
    
    
}


extension RangeReplaceableCollection where Element: Hashable {
    var orderedSet: Self {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
    mutating func removeDuplicates() {
        var set = Set<Element>()
        removeAll { !set.insert($0).inserted }
    }
}

extension OrderViewController: UISearchBarDelegate
{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchActive = false;
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        searchActive = false
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.searchActive = true;
        if(searchText.count >= 2)
        {
            callAction = ActionType.GetProductByMatCode
            getData()
        }
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if(searchActive)
        {
         
            self.view.endEditing(true)
            searchActive = false
        }
    }
}

extension OrderViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        print("range.length: \(range.length), range.location: \(range.location), text: '\(textField.text!)' string: '\(string)'")
               
        if (textField == txt_selectDivision)
        {
            print("drop1")
        }
        else if (textField == txt_selectCategory)
        {
        }
        else if (textField == txt_selectSubCategory)
        {
        }
        else if (textField == txt_searchData)
        {
                self.searchCheck = true
           
            let searchText  = textField.text! + string
            if searchActive != false{

                if range.location == 2{//searchText.count == 3{
                    callAction = ActionType.GetProductByMatCode
                    getData()
                }
                if range.location == -0{
                    self.filterArr_ProductList.removeAll()
                    self.arr_ProductList.removeAll()
                    self.tableview_Order.reloadData()
                }
                
                print(self.arr_ProductList)
                    
                    self.filterArr_ProductList = self.arr_ProductList.filter{
                        
                        print($0)
                        
                        let a = $0.code!.uppercased().contains(textField.text!.uppercased())
                        let b = $0.name!.uppercased().contains(textField.text!.uppercased())
                        
                        return a || b
                        
                    }
                refreshData()
            }else{
                //self.filterArr_ProductList = self.arr_ProductList
                if range.location >= 1{
                print(self.arr_ProductList)
                    
                    self.filterArr_ProductList = self.arr_ProductList.filter{
                        
                        print($0)
                        
                        let a = $0.code!.uppercased().contains(textField.text!.uppercased())
                        let b = $0.name!.uppercased().contains(textField.text!.uppercased())
                        
                        return a || b
                        
                    }
                refreshData()
                }
                if range.location == -0{
                    self.filterArr_ProductList = self.arr_ProductList
                    self.tableview_Order.reloadData()
                }
            }
           
            
             print(self.filterArr_ProductList)
//                if self.filterArr_ProductList.count > 0 {
//
//                    self.tableview_Order.delegate = self
//                    self.tableview_Order.dataSource = self
//                    self.tableview_Order.reloadData()
//                }
         
        }else{
            
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
        
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        var cell = OrderTableViewCell()
        if (textField == txt_selectDivision)
        {
            self.view.endEditing(true)
            txt_responder = txt_selectDivision
            selectDropDown.dataSource = ["SELECT CATEGORY"] + arr_Division.map{$0.name} as! [String]
            var div = arr_Division.map{$0.name} as! [String]
            print(div)
            print(txt_selectDivision)
            selectDropDown.anchorView = txt_selectDivision
            selectDropDown.show()
            return false
        }
        else if(textField == txt_selectCategory)
        {
            self.view.endEditing(true)
            txt_responder = txt_selectCategory
            selectDropDown.dataSource = ["SELECT DIVISION"] + arr_Category.map{$0.name} as! [String]
            selectDropDown.anchorView = txt_selectCategory
            selectDropDown.show()
            return false
        }
        else if(textField == txt_selectSubCategory)
        {
            self.view.endEditing(true)
            txt_responder = txt_selectSubCategory
            selectDropDown.dataSource = ["SELECT CAT TYPE"] + arr_SubCategory.map{$0.name} as! [String]
            selectDropDown.anchorView = txt_selectSubCategory
            selectDropDown.show()
            return false
        }
        else if(textField == txt_selectSub4Category)
               {
                    self.view.endEditing(true)
                   txt_responder = txt_selectSub4Category
                   selectDropDown.dataSource = ["SELECT SUB CATEGORY"] + arr_Sub4Category.map{$0.name} as! [String]
                   selectDropDown.anchorView = txt_selectSub4Category
                   selectDropDown.show()
                   return false
               }
        else if(textField == txt_searchData)
               {
                    self.filterArr_ProductList = self.arr_ProductList
                  // return false
               }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if (textField == txt_selectDivision)
        {
        }
        else if (textField == txt_selectCategory)
        {
        } else if (textField == txt_selectSubCategory)
                      {
                      }
                   else if (textField == txt_selectSub4Category)
                          {
                          }
        else if (textField == txt_searchData)
        {
            searchCheck = true
            let invocation = IQInvocation(self, #selector(didPressOnDoneButton))
            textField.keyboardToolbar.doneBarButton.invocation = invocation
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        var cell = OrderTableViewCell()
        if (textField == txt_selectDivision)
        {
        }
        else if (textField == txt_selectCategory)
        {
        } else if (textField == txt_selectSubCategory)
               {
               }
            else if (textField == txt_selectSub4Category)
                   {
                   }
        else if (textField == txt_searchData)
        {
            if textField.text == ""{
                searchCheck = false
            }else{
                searchCheck = true
            }
         
        }
        else
        {
        
            let product = self.arr_ProductList[textField.tag]
            print(product)
            if let qty = Int(textField.text!)
            {
                product.qty = qty // Setup Autosave
                autoAddData()
                if searchCheck == true{
                divisionTxt = product.CatName!
                divisionCode = product.CatCode!
                }
            }
            else
            {
                product.qty = 0
                autoAddData()
            }
            product.amount =  product.price ?? 0 * Double(product.qty)
            
            let oderList = arr_ProductList.filter({$0.qty > 0})
                    self.lbl_ttlSku.text = "TTL SKU : \(oderList.count)"
                     self.lbl_ttlQty.text = "TTL QTY : \(arr_ProductList.map({$0.qty}).reduce(0, +))"
                     self.lbl_ttlAmt.text = "TTL AMT : \(arr_ProductList.map({$0.amount}).reduce(0, +))"
            
            arr_ProductList[textField.tag] = product
            let ip = IndexPath(row: textField.tag, section: 0)
                //tableview_Order.reloadRows(at: [ip], with: .automatic)
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Yes worked")
        return true
    }
}

extension OrderViewController
{
    func didRecivedRespoance(api: String, parser: Parser, json: Any)
    {
        if  (parser.isSuccess(result: json as! [String:Any])),
            let ResponseData = parser.responseData as? String,
            let json = ResponseData.data(using: String.Encoding.utf8)
            
        {
            do {

                if(callAction == ActionType.SKUCategory)
                {
                    self.arr_Division = try JSONDecoder().decode([Division].self, from: json)
                    print(self.arr_Division)
                }
                else if(callAction == ActionType.Edit)
                {
                    if  let json = ResponseData.parseJSONString as? [String:Any],
                        let s_MdmCode = json["s_MdmCode"] as? String,
                        let SalesOfficeCode = json["SalesOfficeCode"] as? String
                    {
                        MDM_CODE = s_MdmCode
                        saleOffice_CODE = SalesOfficeCode
                        
                        //call here get dealercode api
                        callAction = ActionType.GetDealerCode
                        getData()
                        //                        callAction = ActionType.GetOrderNo
                        //                        getData()
                    }
                    else
                    {
                        showAlert(msg: "valueNotFound".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                }

                else if(callAction == ActionType.SKUSubCategory)
                {
                    self.arr_Category = try JSONDecoder().decode([Division].self, from: json)
                }
        
                    else if(callAction == ActionType.SKUMaterialType)
                                 {
                                     self.arr_SubCategory = try JSONDecoder().decode([Division].self, from: json)
                        
                                 }
                    else if(callAction == ActionType.SKUCatType)
                                                    {
                                                        self.arr_Sub4Category = try JSONDecoder().decode([Division].self, from: json)
                                                    }
//                else if(callAction == ActionType.GetProductByMaterialType)
//                {
//                    self.arr_Category = try JSONDecoder().decode([Division].self, from: json)
//                    txt_responder = txt_searchBar
//                    selectDropDown.dataSource = arr_Category.map{$0.code} as! [String]
//                    selectDropDown.anchorView = txt_responder
//                    selectDropDown.show()
//                }
                    else if(callAction == ActionType.GetProductByMatCode)
                {
                   // self.arr_Category = try JSONDecoder().decode([Division].self, from: json)
                    self.arr_ProductList = try JSONDecoder().decode([Product].self, from: json)
                    self.filterArr_ProductList = self.arr_ProductList
                        DispatchQueue.main.async {
                            self.refreshData()
                        }
                    //txt_responder = txt_searchBar
                    print(arr_Category)
                       // refreshData()
                }
                else if(callAction == ActionType.GetProductByMaterialType || callAction == ActionType.GetProductByCode)
                {
                    self.arr_ProductList = try JSONDecoder().decode([Product].self, from: json)
                    self.filterArr_ProductList = self.arr_ProductList
                   refreshData()
                }
                else if parser.responseData != nil
               {
                   if(callAction == ActionType.GetDealerCode)
                   {
                       // if((self.arr_DealerCode) == nil)
                       // {
                    self.arr_DealerCode = try? JSONDecoder().decode([Dealer].self, from: json)

//                       let dc = Dealer()
//                       dc.s_FullName = "Other"
//                       dc.s_RetailerSapCode = "Other"
                    if((self.arr_DealerCode) == nil)
                    {
                        //self.arr_DealerCode = [dc]
                        print("NO DEALER LINKED WITH SELECTED CATEGORY")
                        showAlert(msg: "NO DEALER LINKED WITH SELECTED CATEGORY")
                    }
                    else
                    {
                        print(arr_DealerCode.count)
                        // self.arr_DealerCode.insert(dc, at: 0)
                   // }
                       
                       
                       
                       
                       if let jsonObj =  try JSONSerialization.jsonObject(with: json, options: []) as? [Any] {
                           print("jsonObj: \(jsonObj)")
                           
                           let json = JSON(jsonObj).arrayValue
                           
                           print("Dealer json\(json)")
                           
                           var finalMsg = ""
                           
                         //  for element in json {
                               
//                               let jsonDict = element.dictionary!
//                               let jsonString = jsonDict["ParentJson"]?.stringValue
//                               let data: NSData = jsonString!.data(using: .utf8)! as NSData
//                               let dataJson = JSON(data)
//
//                               let parentArray = dataJson.arrayValue
                               
//                               for  parentele in parentArray {
                                   
//                                   let divisionCode = parentele["DivisionCode"].stringValue
                                   
//                                   if divisionNameArray.count == 0 {
//                                       divisionNameArray.append(divisionCode)
//                                   }else {
//                                       if !divisionNameArray.contains(divisionCode){
//                                           divisionNameArray.append(divisionCode)
//                                       }
//                                   }
                                   
//                                   let dataJson = parentele["data"].arrayValue
                                  // for element in orderList {
                                     //  if element.categoryCode == divisionCode {
                                           arr_DealerList.removeAll()
                                           for dealerEle in arr_DealerCode {
                                               let dealerObj = Dealer()
                                            print(divisionTxt)
                                            print(divisionCode)
                                            dealerObj.categoryName = divisionTxt
                                            dealerObj.categoryCode = divisionCode
                                            dealerObj.s_FullName = dealerEle.s_FullName
                                            print("dealerObj.s_FullName\(dealerEle.s_FullName)")
                                            dealerObj.OrderType = dealerEle.OrderType
                                            dealerObj.MobileNo = dealerEle.MobileNo
                                            dealerObj.s_RetailerSapCode = dealerEle.s_RetailerSapCode
                                            finalMsg = dealerEle.FinalMsg ?? ""
                                               
                                               if arr_DealerList.count == 0 {
                                                   arr_DealerList.append(dealerObj)
                                               }else {
                                                   if !arr_DealerList.contains(dealerObj){
                                                       arr_DealerList.append(dealerObj)
                                                   }
                                               }
                                               
                                               if appDelegate.arr_updatedDealerList.count == 0 {
                                                   appDelegate.arr_updatedDealerList.append(dealerObj)
                                               }else{
                                                   if !appDelegate.arr_updatedDealerList.contains(dealerObj) {
                                                       appDelegate.arr_updatedDealerList.append(dealerObj)
                                                       
                                                   }
                                               }
                                               
                                           }
                                           
                                           //add dictionary element here
                                           appDelegate.dealerDict[divisionTxt] = arr_DealerList
                                       //}
                                 //  }
                                   print("dealer dict : \(appDelegate.dealerDict)")
                                   
//                               }
                               
                               //commented this to check new flow
                               //                                for element in orderList {
                               //                                    let dealerObj = Dealer()
                               //                                    dealerObj.categoryName = element.categoryName!
                               //                                    dealerObj.categoryCode = element.categoryCode!
                               //                                    dealerObj.s_FullName = jsonDict["s_FullName"]?.stringValue
                               //                                    dealerObj.OrderType = jsonDict["OrderType"]?.stringValue
                               //                                    dealerObj.MobileNo = jsonDict["MobileNo"]?.stringValue
                               //                                    dealerObj.s_RetailerSapCode = jsonDict["s_RetailerSapCode"]?.stringValue
                               //
                               //
                               //                                    arr_DealerList.append(dealerObj)
                               //                                    appDelegate.arr_updatedDealerList.append(dealerObj)
                               //
                               //                                }
                               
                               
                          // }
                           
                           if finalMsg == ""{
                               flag = 1
                               
                               mySelectedProductListArray.append(contentsOf: orderList)
                               
                               
                               for index:Product in orderList{
                                index.categoryName = divisionTxt
                                index.categoryCode = divisionCode
                                index.divisionName = divisionTxt
                                
                                
                                print(orderList)
                                print(index.categoryName)
                                   if appDelegate.arr_UpdatedDelegate_ProductList.count == 0{
                                       appDelegate.arr_UpdatedDelegate_ProductList.append(index)
                                   }else {
                                       
                                       for ele in appDelegate.arr_UpdatedDelegate_ProductList {
                                           
                                           if ele.code == index.code {
                                               
                                               let ind = appDelegate.arr_UpdatedDelegate_ProductList.index(of: ele)
                                               
                                               if isAdded == false {
                                                   ele.qty = ele.qty + index.qty
                                                   ele.amount = ele.amount + index.amount
                                               }
                                            print(ele.categoryName)
                                               ele.divisionName = ele.categoryName
                                               appDelegate.arr_UpdatedDelegate_ProductList[ind!] = ele
                                               break
                                           }
                                               
                                           else {
                                               
                                               appDelegate.arr_UpdatedDelegate_ProductList.append(index)
                                               
                                               
                                               //                                            let items = appDelegate.arr_UpdatedDelegate_ProductList.filter{$0.code == ele.code}
                                               //                                            if !items.isEmpty{
                                               //                                            for item in items {
                                               //                                                if item.code != index.code {
                                               //                                                    appDelegate.arr_UpdatedDelegate_ProductList.append(index)
                                               //                                                }
                                               //                                            }
                                               //                                            }else {
                                               //                                                appDelegate.arr_UpdatedDelegate_ProductList.append(index)
                                               //                                            }
                                               //                                            if items.count == 0{
                                               //
                                               //                                                    appDelegate.arr_UpdatedDelegate_ProductList.append(index)
                                               //
                                               //                                                }
                                               
                                           }
                                           
                                       }
                                       
                                       
                                       //                                        for ele in appDelegate.arr_UpdatedDelegate_ProductList {
                                       //                                            if ele.code != index.code{
                                       //                                                if !appDelegate.arr_UpdatedDelegate_ProductList.contains(index) {
                                       //                                                    appDelegate.arr_UpdatedDelegate_ProductList.append(index)
                                       //
                                       //                                                }
                                       //                                            }
                                       //
                                       //                                        }
                                       
                                       
                                   }
                                   
                                   //                                appDelegate.arr_UpdatedDelegate_ProductList.append(index)
                                   
                                   for element in arr_Category {
                                       if element.name == self.txt_selectCategory.text {
                                        print(element.name)
                                        print(element)
                                           self.SkuSubCategory = element
                                           //                                                self.callAction = ActionType.GetProduct
                                           //                                                self.getData()
                                       }
                                   }
                               }
                               
                               isAdded = true
                               
                               // self.view.makeToast(message: "addedProduct".localizableString(loc:
                               //                                        UserDefaults.standard.string(forKey: "keyLang")!))
                               //self.showAlert(msg:"Product added to cart".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!))
                               //MARK: Product added alert
                               //                                        self.btn_viewCart.setTitle("VIEW CART \(appDelegate.arr_UpdatedDelegate_ProductList.count)", for: .normal)
                               //                                        arr_ProductList.removeAll()
                               
                               let uniqueArray = appDelegate.arr_UpdatedDelegate_ProductList.uniques(by: \.code)
                               
                               //self.counterlabel.text = String(uniqueArray.count)
                               
                               // txt_selectDivision.text = ""
                               // txt_selectCategory.text = ""
                            //refreshData()
                               //self.tableview_Order.reloadData()
                           }else {
                            //refreshData()
                               //self.tableview_Order.reloadData()
                               showAlert(msg:finalMsg)
                              // refresh()
                               
                               
                               //                                showAlert(msg:"NoPartner".localizableString(loc:
                               //                                                                                UserDefaults.standard.string(forKey: "keyLang")!))
                           }
                           
                           //commented this to check new flow of dealer
                           
                           //                            let jsonDict = json[0].dictionary!
                           //                            let finalMsg = jsonDict["FinalMsg"]?.stringValue
                           //                            if finalMsg == "" {
                           //                                if arr_DealerCode.count > 0 {
                           //                                                                            showAlert(msg: parser.responseData as! String)
                           //                                    flag = 1
                           //
                           //                                    mySelectedProductListArray.append(contentsOf: orderList)
                           //
                           //                                    for index:Product in orderList{
                           //
                           //                                        appDelegate.arr_UpdatedDelegate_ProductList.append(index)
                           //
                           //
                           //                                        for element in arr_Category {
                           //                                            if element.name == self.txt_selectCategory.text {
                           //                                                self.SkuSubCategory = element
                           //                                                //                                                self.callAction = ActionType.GetProduct
                           //                                                //                                                self.getData()
                           //                                            }
                           //                                        }
                           //                                    }
                           //                                    isAdded = true
                           //
                           //                                    //                                        self.view.makeToast(message: "addedProduct".localizableString(loc:
                           //                                    //                                        UserDefaults.standard.string(forKey: "keyLang")!))
                           //
                           //                                    self.showAlert(msg:"addedProduct".localizableString(loc:
                           //                                                                                            UserDefaults.standard.string(forKey: "keyLang")!))
                           //
                           //                                    //                                        self.btn_viewCart.setTitle("VIEW CART \(appDelegate.arr_UpdatedDelegate_ProductList.count)", for: .normal)
                           //                                    //                                        arr_ProductList.removeAll()
                           //
                           //                                    self.counterlabel.text = String(appDelegate.arr_UpdatedDelegate_ProductList.count)
                           //
                           //                                    //                                        txt_selectDivision.text = ""
                           //                                    //                                        txt_selectCategory.text = ""
                           //                                    self.tableview_Order.reloadData()
                           //
                           //
                           //                                } else {
                           //
                           //                                    showAlert(msg: parser.responseData as! String)
                           //                                    print("show here alert for no partner available")
                           //                                    self.callAction = ActionType.GetProduct
                           //                                    self.getData()
                           //                                }
                           //                            }else {
                           //                                //                                    arr_ProductList.removeAll()
                           //                                //                                    txt_selectDivision.text = ""
                           //                                //                                    txt_selectCategory.text = ""
                           //                                self.tableview_Order.reloadData()
                           //                                //                                    showAlert(msg:finalMsg!)
                           //                                showAlert(msg:"NoPartner".localizableString(loc:
                           //                                                                                UserDefaults.standard.string(forKey: "keyLang")!))
                           //
                           //
                           //                                self.callAction = ActionType.GetProduct
                           //                                self.getData()
                           //                            }
                           
                           
                           
                           
                           //                            let jsonDict = json[0].dictionary!
                           //
                           //                            for element in orderList {
                           //                                let dealerObj = Dealer()
                           //                                dealerObj.categoryName = element.categoryName!
                           //                                dealerObj.categoryCode = element.categoryCode!
                           //                                dealerObj.s_FullName = jsonDict["s_FullName"]?.stringValue
                           //                                arr_DealerList.append(dealerObj)
                           //                            appDelegate.arr_updatedDealerList.append(dealerObj)
                           //                            }
                           //
                           //
                           //                            let finalMsg = jsonDict["FinalMsg"]?.stringValue
                           //                            if finalMsg == "" {
                           //                                if arr_DealerCode.count > 0 {
                           //                                    //                                        showAlert(msg: parser.responseData as! String)
                           //                                    flag = 1
                           //
                           //                                    mySelectedProductListArray.append(contentsOf: orderList)
                           //
                           //                                    for index:Product in orderList{
                           //
                           //                                        appDelegate.arr_UpdatedDelegate_ProductList.append(index)
                           //
                           //                                    }
                           //
                           //                                    self.view.makeToast(message: "Products Are added to the cart!")
                           //                                    arr_ProductList.removeAll()
                           //                                    txt_selectDivision.text = ""
                           //                                    txt_selectCategory.text = ""
                           //                                    self.tableview_Order.reloadData()
                           //
                           //                                } else {
                           //
                           //                                    showAlert(msg: parser.responseData as! String)
                           //                                }
                           //                            }else {
                           //                                arr_ProductList.removeAll()
                           //                                txt_selectDivision.text = ""
                           //                                txt_selectCategory.text = ""
                           //                                self.tableview_Order.reloadData()
                           //                                showAlert(msg:finalMsg!)
                           //
                           //                            }
                       }
                       
                       //check count of dealer code here and in  count comes more then add product
                       //                            if arr_DealerCode.count > 0 {
                       //                                showAlert(msg: parser.responseData as! String)
                       //                                flag = 1
                       //
                       //                                           mySelectedProductListArray.append(contentsOf: orderList)
                       //
                       //                                           for index:Product in orderList{
                       //
                       //                                               appDelegate.arr_UpdatedDelegate_ProductList.append(index)
                       //
                       //                                           }
                       //
                       //                                           self.view.makeToast(message: "Products Are added to the cart!")
                       //                                           arr_ProductList.removeAll()
                       //                                           txt_selectDivision.text = ""
                       //                                           txt_selectCategory.text = ""
                       //                                           self.tableview_Order.reloadData()
                       //
                       //                            } else {
                       //                                showAlert(msg: parser.responseData as! String)
                       //                            }
                       print("Dealer Code Array is  \(self.arr_DealerCode)")
                       }
                   }
                   else
                   {
                       showAlert(msg: parser.responseMessage)
                   }
               }
            } catch {
                print("Decoder Error \(error.localizedDescription)")
            }
        }
        else
        {
            showAlert(msg: parser.responseMessage)
        }
    }
    func refresh() {
        
       // txt_searchProd.isUserInteractionEnabled = true
        
        isAdded = false
        
        self.txt_selectDivision.isUserInteractionEnabled = true
        self.btn_selectDivision.isUserInteractionEnabled = true
        self.txt_selectCategory.isUserInteractionEnabled = true
        self.txt_selectCategory.isUserInteractionEnabled = true
        
        txt_selectDivision.text = nil
        txt_selectCategory.text = nil
        divisionTxt = ""
        divisionCode = ""
        //        txt_searchBar.text = nil
        txt_searchData.text = nil
       // txt_searchProd.text = nil
        lbl_NoData.isHidden = true
        searchCheck = false
//        searchByMatCheck = false
//
//        btn_closeSearch.alpha = 0
//        btn_closeProdSearch.alpha = 1
//        btn_prodSearchWidthConstraint.constant = 30
//        btn_closeProdSearch.setImage(#imageLiteral(resourceName: "audio-record"), for: .normal)
        //        self.height_searchDataHeight.constant = 37.5
        
        
        arr_ProductList.removeAll()
        filterArr_ProductList.removeAll()
        //searchProducts.removeAll()
        tableview_Order.reloadData()
        self.lbl_ttlSku.text = "TTL PRD \n \(0)"
        self.lbl_ttlQty.text = "TTL QTY \n \(0)"
        self.lbl_ttlAmt.text = "TTL AMT \n \(0)"
    }
    func refreshData()
    {
        if(self.arr_ProductList.count > 0)
        {
            //btn_next.isHidden = false
            tableview_Order.isHidden = false
            lbl_NoData.isHidden = true
            self.tableview_Order.delegate = self
            self.tableview_Order.dataSource = self
            self.tableview_Order.reloadData()
        }
        else
        {
            lbl_NoData.isHidden = false
        }
    }
}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if searchCheck == true{
            return self.filterArr_ProductList.count         
        }else{
            return self.arr_ProductList.count
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if searchCheck == true{
            let product = filterArr_ProductList[indexPath.row]
            let material = "\(product.name!)_\(product.code!)"// "-\(product.discount!)(\(product.unit?.trim() ?? ""))"
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
            let partOne4 = NSMutableAttributedString(string: self.myData, attributes: yourOtherAttributes1)
            
            partOne1.append(partOne2)
            partOne1.append(partOne4)
            
           // cell.lbl_oderName.attributedText = partOne1
            cell.lbl_oderName.text = material //product.name!
            cell.lbl_oderName.numberOfLines = 0
            cell.lbl_amount.text = ""
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
            
        }else{
            let product = arr_ProductList[indexPath.row]
            let material = "\(product.name!)_\(product.code!)"//-\(product.discount!)(\(product.unit?.trim() ?? ""))"
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
            let partOne4 = NSMutableAttributedString(string: self.myData, attributes: yourOtherAttributes1)
            
            partOne1.append(partOne2)
            partOne1.append(partOne4)
            
           // cell.lbl_oderName.attributedText = partOne1
            cell.lbl_oderName.text = material //product.name!
            cell.lbl_oderName.numberOfLines = 0
            cell.lbl_amount.text = ""
            
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
        }
        
        
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
        let x = hAmount
       print(x)
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 1
    }
}

//extension OrderViewController: OrderDoneDelegate
//{
//    func didOrderDone()
//    {
//        txt_searchBar!.text = ""
//        txt_selectCategory.text = ""
//        txt_selectSubCategory.text = ""
//        txt_selectSub4Category.text = ""
//        txt_selectDivision.text = ""
//        selectionChange()
//    }
//}
extension OrderViewController: OrderDoneDelegate
{
    func didOrderDone()
    {
        txt_searchBar.text = ""
        txt_selectCategory.text = ""
        txt_selectDivision.text = ""
        selectionChange()
    }
}
class OrderTableViewCell:UITableViewCell
{
    @IBOutlet weak var lbl_oderName: UILabel!
    @IBOutlet weak var lbl_qty: UILabel!
    @IBOutlet weak var txt_qty: UITextField!
    @IBOutlet weak var lbl_amount: UILabel!
    @IBOutlet weak var viewCurve: UIView!
    @IBOutlet weak var btn_Delete: UIButton!
    @IBOutlet weak var lbl_Price: UILabel!
      @IBOutlet weak var lbl_BaseAmt: UILabel!
   
    var isAdded:Bool = false
}


class SchemeResultTableViewCell:UITableViewCell
{
    @IBOutlet weak var lbl_schemeName: UILabel!
    @IBOutlet weak var lbl_StartDate: UILabel!
    @IBOutlet weak var lbl_EndDate: UILabel!
    @IBOutlet weak var lbl_Status: UILabel!
    @IBOutlet weak var btn_Download: UIButton!
    @IBOutlet weak var btn_SchemeDetails: UIButton!
}

class SchemeDetailHeaderCell:UITableViewCell
{
    @IBOutlet weak var lbl_PointSlab: UILabel!
    @IBOutlet weak var lbl_Gift: UILabel!
    @IBOutlet weak var lbl_Images: UILabel!

}


class SchemeDetailsCell:UITableViewCell
{
    @IBOutlet weak var lbl_PointSlab: UILabel!
    @IBOutlet weak var lbl_Gift: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btn_RadioSelect: UIButton!
    @IBOutlet weak var btn_OpenImage: UIButton!

   
}


extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
}

extension Array {
    
    func uniques<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return reduce([]) { result, element in
            let alreadyExists = (result.contains(where: { $0[keyPath: keyPath] == element[keyPath: keyPath] }))
            return alreadyExists ? result : result + [element]
        }
    }
}
