//
//  DMSNewSchemeBilling_VC.swift
 
//
//  Created by pro on 09/04/2020.
//  Copyright © 2020 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire

class DMSSchemeGiftCell : UICollectionViewCell{
    
    @IBOutlet weak var lblGiftName : UILabel!
    @IBOutlet weak var imgGift : UIImageView!
    @IBOutlet weak var btnSelect : UIButton!

    
}

class GiftPointsCollectionCell : UICollectionViewCell{
    
  @IBOutlet weak var lblPoints : UILabel!


}

struct DMSBillingModelElement : Codable {

        let message : String?
        let mode : String?
        let productCoupoun : [ProductCoupoun]?

        enum CodingKeys: String, CodingKey {
                case message = "Message"
                case mode = "Mode"
                case productCoupoun = "ProductCoupoun"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                message = try values.decodeIfPresent(String.self, forKey: .message)
                mode = try values.decodeIfPresent(String.self, forKey: .mode)
                productCoupoun = try values.decodeIfPresent([ProductCoupoun].self, forKey: .productCoupoun)
        }

}

struct ProductCoupoun : Codable {

        let branch : String?
        let category : String?
        let productCode : String?
        let productImage : String?
        let productImagePath : String?
        let productName : String?
        let status : String?
        let userCode : String?
        var isCouponShow : Bool = false

        enum CodingKeys: String, CodingKey {
                case branch = "Branch"
                case category = "Category"
                case productCode = "ProductCode"
                case productImage = "ProductImage"
                case productImagePath = "ProductImagePath"
                case productName = "ProductName"
                case status = "Status"
                case userCode = "UserCode"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                branch = try values.decodeIfPresent(String.self, forKey: .branch)
                category = try values.decodeIfPresent(String.self, forKey: .category)
                productCode = try values.decodeIfPresent(String.self, forKey: .productCode)
                productImage = try values.decodeIfPresent(String.self, forKey: .productImage)
                productImagePath = try values.decodeIfPresent(String.self, forKey: .productImagePath)
                productName = try values.decodeIfPresent(String.self, forKey: .productName)
                status = try values.decodeIfPresent(String.self, forKey: .status)
                userCode = try values.decodeIfPresent(String.self, forKey: .userCode)
        }

}

struct InsertGiftModelElement : Codable {

        let branchname : String?
        let category : String?
        let productCode : String?
        let productImage : String?
        let productImagePath : String?
        let productName : String?
        let producttype : String?
        let schemeCode : String?
        let usercode : String?

        enum CodingKeys: String, CodingKey {
                case branchname = "branchname"
                case category = "Category"
                case productCode = "ProductCode"
                case productImage = "ProductImage"
                case productImagePath = "ProductImagePath"
                case productName = "ProductName"
                case producttype = "producttype"
                case schemeCode = "SchemeCode"
                case usercode = "usercode"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                branchname = try values.decodeIfPresent(String.self, forKey: .branchname)
                category = try values.decodeIfPresent(String.self, forKey: .category)
                productCode = try values.decodeIfPresent(String.self, forKey: .productCode)
                productImage = try values.decodeIfPresent(String.self, forKey: .productImage)
                productImagePath = try values.decodeIfPresent(String.self, forKey: .productImagePath)
                productName = try values.decodeIfPresent(String.self, forKey: .productName)
                producttype = try values.decodeIfPresent(String.self, forKey: .producttype)
                schemeCode = try values.decodeIfPresent(String.self, forKey: .schemeCode)
                usercode = try values.decodeIfPresent(String.self, forKey: .usercode)
        }

}



class DMSNewSchemeBilling_VC: BaseViewController {
    
    
    @IBOutlet weak var giftsCollView: UICollectionView!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var imgAnimeView: UIImageView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var imgGiftView: UIImageView!
    @IBOutlet weak var lbl_GiftName : UILabel!
    @IBOutlet weak var lbl_GiftPrice : UILabel!
    @IBOutlet weak var collDMSData: UICollectionView!
    @IBOutlet weak var lbl_SchemeName: UILabel!
    @IBOutlet weak var lbl_Notification: UILabel!
    @IBOutlet weak var lblGiftHeading: UILabel!



    //View for HASlider slider
          @IBOutlet var tipView_Slider: UIView!
          @IBOutlet weak var slider: HASlider!
          @IBOutlet weak var lblValue_Slider: UILabel!
    
    var mySchemeDetailsData : SchemeResultModelElement!

    var blurView = UIVisualEffectView()
    var gifTimer: Timer?
    var giftTag : Int!
    var progressArray = [0.0 , 10000.0,20000,30000,40000,50000.0,60000.0,70000.0,80000.0,90000]
    var myParsingData: [ProductCoupoun] = []
    var myProductData: [InsertGiftModelElement] = []
    var giftingData: [InsertGiftModelElement] = []
    var imagePath: URL?
    var giftName : String!
    var selectedIndex:IndexPath?

    var modeActive_InActive: String?
    
    
  
 
    override func viewWillAppear(_ animated: Bool)
       {
           
//           navigationView.btn_dashbord_width.constant = 0
//           if (navigationView != nil)
//                 {
//                     if DataProvider.sharedInstance.userDetails != nil
//                     {
//                         navigationView.lbl_shopName.text = DataProvider.sharedInstance.userDetails.s_ShopName
//                         navigationView.lbl_mobNo.text = DataProvider.sharedInstance.userDetails.s_MobileNo
//                     }
//                     else
//                     {
//                         navigationView.lbl_shopName.text = ""
//                         navigationView.lbl_mobNo.text = ""
//                     }
//                     navigationView.layoutSubviews()
//                     navigationView.layoutIfNeeded()
//            }
           
         setupWithCustomData()
        
        if(Connectivity.isConnectedToInternet())
                           {
                               GetDMSProducts()
                               
                           }
                           else
                           {
                               showAlert(msg: MessageAndError.noInternetConnection)
                           }
      
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
      
       
    }
    
    func GetDMSProducts()
       {
           //{"MobileNo":"7358185498","ActionType":"GetSchemeDetails","RuleCode":"RUL0094"}
           let parameters = [Key.MobileNo: "7358185498"/*DataProvider.sharedInstance.userDetails.s_MobileNo!*/,
                                        Key.ActionType: ActionType.GetSchemeDetails,
                                        Key.RuleName:"", Key.RuleCode:"RUL0094",Key.FromDate:"",Key.ToDate:"",Key.EmpCode:"",Key.Months:"",Key.SalesOffice:"",Key.Years:"",Key.PageNumber:0] as [String : Any]
           let parser = Parser()
           parser.delegate = self
           parser.callAPI(api: API.GetDMSProducts, parameters: parameters, viewcontroller: self, actionType: API.GetDMSProducts)
      
       }
    
    override func viewWillDisappear(_ animated: Bool)
      {
              self.bg_view.removeFromSuperview()
              self.blurView.removeFromSuperview()
      }
    
    override func onBackButtonPressed(_ sender: UIButton) {
         self.navigationController?.popViewController(animated: true)
           
       }
       
       override func onBellButtonPressed(_ sender : UIButton)
       {
           let notificationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationViewController) as! NotificationViewController
                  self.navigationController?.pushViewController(notificationVC, animated: true)
           
       }

    
     func setupWithCustomData()
        {
           
               if self.progressArray.count != 0{
                       self.collDMSData.delegate = self
                       self.collDMSData.dataSource = self
                
                
                   self.tipView_Slider.layer.cornerRadius = 10
                   self.tipView_Slider.clipsToBounds = true
                                                                                  
                   self.slider.leftTipView = tipView_Slider
                   self.slider.isUserInteractionEnabled = false
                
                
                    setupCollViewLayout()
                
                   // settingData(value: 23000)
    
                self.slider.minimumValue = 0//CGFloat(self.progressArray[0])//CGFloat(self.progressArray.min() ?? 0.0)
                self.slider.maximumValue = 1.0//CGFloat(self.progressArray.count)//CGFloat(self.progressArray.max() ?? 0.0)
    
            //    if self.GlobalSamparkPointUnderSTBScheme != nil{

                     let apiValue = 25000//self.GlobalSamparkPointUnderSTBScheme
                    
                if apiValue != 0{
                         caluclateProgress(value : apiValue)

                    }else{
                      self.slider.leftValue = 0
                    }

                     self.lblValue_Slider.text = "\(apiValue)"
                
                DispatchQueue.main.async {
                       self.collDMSData.reloadData()
                }
             
                  
//                }else{
//                    self.lblValue_Slider.text = "\(0.0)"
//                }

            }
      }
        
        func caluclateProgress(value : Int){
            
            let arrCount : Float = Float(self.progressArray.count)
            print(arrCount)
            
            if arrCount == 10.0{
                
                if self.progressArray.contains(Double(value)) {
                          print("contains value")
                          let index = self.progressArray.index(of:Double(value))
                          let midProg = (1 * Float(index ?? 0)) / 10 + 0.02
                          let exactValue = midProg + 0.05
                          print(exactValue)
                          self.slider.leftValue = CGFloat(exactValue)
                      } else {
                          var lastValue = 0
                          for i in self.progressArray {
                              if value >= Int(i) {
                                  lastValue = Int(i)
                              }
                          }
                          
                          let index = self.progressArray.index(of:Double(lastValue))
                          
                          print(index!)
                          
                          if index == 0{
                              self.slider.leftValue = CGFloat((1 * Float(index ?? 0)) / 10 + 0.05)
                          }else{
                          
                          self.slider.leftValue = CGFloat((1 * Float(index ?? 0)) / arrCount)
                      }
                      }
                
//                if self.progressArray.contains(Double(value)) {
//                               print("contains value")
//                               let index = self.progressArray.index(of:Double(value))
//                               let midProg = (1 * Float(index ?? 0))
//
//                               let val1 = (midProg / arrCount) + 0.04
//                               print(val1)
//
//                               self.slider.leftValue = CGFloat(val1)
//                           } else {
//                               var lastValue = 0
//                               for i in self.progressArray {
//                                   if value >= Int(i) {
//                                       lastValue = Int(i)
//                                   }
//                               }
//
//                               let index = self.progressArray.index(of:Double(lastValue))
//
//                               print(index!)
//
//                               if index == 0{
//
//                                   let midProg = (1 * Float(index ?? 0))
//
//                                   let val1 = (midProg / arrCount) + 0.05
//                                                 print(val1)
//                                   self.slider.leftValue = CGFloat(val1)
//                                  // self.slider.leftValue = CGFloat((1 * Float(index ?? 0)) / 10 + 0.05)
//                               }else{
//
//                                 let midProg = (1 * Float(index ?? 0))
//
//                                                 let val1 = (midProg / arrCount) + 0.10
//                                                               print(val1)
//                                                 self.slider.leftValue = CGFloat(val1)
//                                   // self.slider.leftValue = CGFloat((1 * Float(index ?? 0)) / 10 + 0.15)
//
//                           }
//                           }
           
            }
            
           
        }
    
    func setupCollViewLayout(){
    
      
            let cellSize = CGSize(width: (collDMSData.frame.size.width / CGFloat(self.progressArray.count)) - 4 , height: collDMSData.frame.size.height)
               let layout = UICollectionViewFlowLayout()
               layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4.0
        layout.minimumLineSpacing = 4.0
                layout.itemSize = cellSize
               collDMSData.setCollectionViewLayout(layout, animated: true)

}
    
    func settingData(value : Int){
          
          
          if self.mySchemeDetailsData != nil{
              
           
                  lbl_Notification.text = "  \(self.mySchemeDetailsData.notification!)*".uppercased()

                    let splitString1 = "\(self.mySchemeDetailsData.ruleName) ".uppercased()
                    let splitString2 = " \n TOTAL DMS BILLING : "
                    let splitString3 = "\(self.mySchemeDetailsData.netSamparkPointUnderSTBScheme) ".uppercased()

                    //Making dictionaries of fonts that will be passed as an attribute
                    
                    let redColor: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.red.cgColor]
                    let blackColor: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black.cgColor]
                    
                    let partOne = NSMutableAttributedString(string: splitString1, attributes: blackColor)
                    let partTwo = NSMutableAttributedString(string: splitString2, attributes: blackColor)
                    let partThree = NSMutableAttributedString(string: splitString3, attributes: redColor)
                  
                    partOne.append(partTwo)
                    partOne.append(partThree)

                     
                    lbl_SchemeName.attributedText =   partOne
              
        }
    }
    
 
    
    func showBlurGiftView(myJsonData : [InsertGiftModelElement] , giftTag : Int){

    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    blurView = UIVisualEffectView(effect: blurEffect)
    blurView.frame = view.bounds
    blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    popUpView.center = self.view.center

    blurView.contentView.addSubview(popUpView)
    
    view.addSubview(blurView)
        
        DispatchQueue.main.async{
            self.imgGiftView.image = UIImage(url: URL(string: "\(myJsonData[0].productImagePath ?? "")"))
            self.imgGiftView.backgroundColor = UIColor(patternImage: UIImage(named: "AnimeStars.png")! )
            self.lbl_GiftName.text = "\(myJsonData[0].productName ?? "Test")"
            self.lbl_GiftPrice.text = ""
            
            self.imagePath = URL(string: "\(myJsonData[0].productImagePath ?? "")")
            self.giftName = "\(myJsonData[0].productName ?? "Test")"
            
            self.myParsingData[giftTag].isCouponShow = true

            
            self.selectedIndex = IndexPath(row: giftTag, section: 0) as IndexPath
            self.giftsCollView.reloadData()
        }
      }
    
    func showPopUPView(myJsonData : [InsertGiftModelElement] , giftTag : Int ){

                bg_view.center = self.view.center

              self.view.addSubview(bg_view)

              DispatchQueue.main.async {
                
                               do {
                                         let gif = try UIImage(gifName: "gift-new.gif")
                                       
                                       self.imgAnimeView.setGifImage(gif)
                                         
                                     } catch {
                                         print(error)
                                     }
                self.giftingData = myJsonData
                self.giftTag = giftTag
                
                self.gifTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: false)
              
              }

          }
    
    @objc func runTimedCode(){
        
        self.removePopUpView()
        
        showBlurGiftView(myJsonData: self.giftingData, giftTag: self.giftTag)
        
    }
    
    @IBAction func btn_CloseBlur(_ sender: UIButton)
    {
       
        DispatchQueue.main.async {

            self.blurView.removeFromSuperview()
             self.giftsCollView.reloadData()
        }
       
        
    }
    
    func removePopUpView() {

             UIView.animate(withDuration: 0.3, animations: {() -> Void in

                     self.bg_view.removeFromSuperview()

             }, completion: nil)
         }
      


}

extension DMSNewSchemeBilling_VC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == giftsCollView{
            return self.myParsingData.count
        }
        
          print(self.progressArray.count)
            return self.progressArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == giftsCollView{

                         let cell : DMSSchemeGiftCell = collectionView.dequeueReusableCell(withReuseIdentifier: "giftCell", for: indexPath) as!  DMSSchemeGiftCell
            
            if self.modeActive_InActive == "InActive"{
            
                           let data = self.myParsingData[indexPath.row]

                                cell.imgGift.image = UIImage(url: URL(string:"\(data.productImagePath ?? "")"))
                                cell.lblGiftName.text = "\(data.productName ?? "Test")"
                                cell.btnSelect.isUserInteractionEnabled = false
                
                                self.lblGiftHeading.text = "AVAILABLE GIFTS"
             }
            else{

                if self.myParsingData[indexPath.row].isCouponShow == true{
          
                    cell.imgGift.image = UIImage(url: self.imagePath)
                    cell.lblGiftName.text = "\(self.giftName ?? "Test")"
                }else{
                    cell.imgGift.image = UIImage(named: "static-gift.jpg")
                    cell.lblGiftName.text = "Open Your Gift"
             }

                           cell.btnSelect.isUserInteractionEnabled = true

                
                            self.lblGiftHeading.text = "CHOOSE GIFTS"
                        }

                  cell.btnSelect.tag =  indexPath.row
                  cell.btnSelect.addTarget(self, action: #selector(didSelectBttn(_ :)), for: .touchUpInside)

                  cell.layer.masksToBounds = true
                  cell.layer.cornerRadius = 5
                  cell.layer.borderWidth = 1.5
                  cell.layer.shadowOffset = CGSize(width: -1, height: 1)
                  cell.layer.borderColor = UIColor.red.cgColor

                 return cell
        }else{
        
                    let cell1 : GiftPointsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pointsCell", for: indexPath) as!  GiftPointsCollectionCell

                    let myValues : Float = Float(self.progressArray[indexPath.row])
            
            cell1.lblPoints.text = "\(myValues.clean)"

                  
                    return cell1
        }
       
    }
    
    
    
    @objc func didSelectBttn(_ sender : UIButton){
        
        
        
        if(Connectivity.isConnectedToInternet())
                                {
                                    
                                    InsertUpdateDMSGiftUser(giftTag : sender.tag ,giftButton : sender)
                                    
                                }
                                else
                                {
                                    showAlert(msg: MessageAndError.noInternetConnection)
                                }
        
    }
    
    func InsertUpdateDMSGiftUser(giftTag : Int ,giftButton : UIButton)
          {
     
            var request = URLRequest(url: URL(string:baseUrl + API.InsertUpdateDMSGiftUser)!)
                           //  viewcontroller.view.makeToastActivity(message: "Processing...")
            request.httpMethod = "POST"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           request.setValue("qBd/jix0ctU=", forHTTPHeaderField: "Clientid")
           request.setValue("7Whc1QzyT1Pfrtm88ArNaQ==", forHTTPHeaderField: "SecretId")
           
            let values = [[

            Key.MobileNo: "9867289138",
            Key.RuleCode:"RUL0094",
            Key.Source:Source,
            Key.DMSProductCode:"",
            Key.EmpCode:"9867289138",
            Key.Category:self.myParsingData[giftTag].category!,
            Key.ItemQty:1,
            Key.BranchName:self.myParsingData[giftTag].branch!

            ]]

            request.httpBody = try! JSONSerialization.data(withJSONObject: values)
            
            self.view.makeToastActivity(message: "Processing...")


            Alamofire.request(request)
                .responseJSON { response in
                    // do whatever you want here
                    switch response.result {
                    case .failure(let error):
                        print(error)

                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                            print(responseString)
                        }
                    case .success(let responseObject):
                         if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
                                                   print(responseString)
                            
                            let data = JSON(responseObject)
                            print(data)
                            
                            let responseData = "\(data["ResponseData"])"
                            
                            self.myProductData = []
                         
                            if responseData != ""{

                                let data = responseData.data(using: .utf8)!
                                 do {
                                      let jsonArray = try  JSONSerialization.jsonObject(with: data, options :[])
                                      let myJsonData = JSON(jsonArray)

                                    self.myProductData =  try JSONDecoder().decode([InsertGiftModelElement].self, from: myJsonData.rawData())
                                    

                                 DispatchQueue.main.async {
                                                    self.giftsCollView.reloadData()
                                            }
                                    
                                        self.showPopUPView(myJsonData : self.myProductData , giftTag : giftTag)
                                    
                                          }catch let error as NSError {
                                              print(error)
                                          }

                                }else{
                                                    self.showAlert(msg: "NO DATA FOUND")
                                          }
                                            
                            }
                            
                         }
                    
                    self.view.hideToastActivity()
                    }
            }
  
    
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
     if collectionView == giftsCollView{
    
        let padding: CGFloat = 15
                  let cellSize = collectionView.frame.size.width - padding
                  
                  let cellWidth = (cellSize / 2 )
                  let size = CGSize(width: CGFloat(cellWidth), height: 135)
                  
                  return size
     }else{
        let cellSize = CGSize(width: (collDMSData.frame.size.width / CGFloat(self.progressArray.count)) - 4 , height: collDMSData.frame.size.height)
      return cellSize
    }
    }
}


extension DMSNewSchemeBilling_VC
{
   
    func didRecivedDMSProducts(responseData:Any)
    {
        
        let mySchemeData = JSON(responseData)
        print(mySchemeData)
      
            do
            {
               
                let dmsData = try JSONDecoder().decode(DMSBillingModelElement.self, from: mySchemeData.rawData())
                
                self.modeActive_InActive = dmsData.mode
                
                let parsingData = dmsData.productCoupoun
                
                if self.modeActive_InActive  == "Active"{
                
                if parsingData != nil{
                    self.myParsingData = dmsData.productCoupoun ?? []
                                  
                                                       DispatchQueue.main.async {
                                                           self.giftsCollView.delegate = self
                                                           self.giftsCollView.dataSource = self
                                       
                                                           self.giftsCollView.reloadData()
                                       }
                }else{
                    showAlert(msg: "NO DATA FOUND")
                }
                }
             
            }catch let error as NSError {
                print(error)
            }
       
    }
    
   
}
