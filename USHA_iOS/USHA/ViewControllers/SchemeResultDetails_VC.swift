//
//  SchemeResultDetails_VC.swift
 
//
//  Created by Apple on 14/02/20.
//  Copyright © 2020 Apple.Inc. All rights reserved.
//

import UIKit
import HASlider


class SlabPointsCollectionCell : UICollectionViewCell{
    
    @IBOutlet weak var lbl_Points: UILabel!

}


class SchemeResultDetails_VC: BaseViewController , UIScrollViewDelegate {
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var travelView: UIView!
    
    @IBOutlet weak var tblSchemeDetailView: UITableView!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var collSlabData: UICollectionView!
    @IBOutlet weak var lbl_Notification: UILabel!
    @IBOutlet weak var lbl_SchemeName: UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    //View for HASlider slider
       @IBOutlet var tipView_Slider: UIView!
       @IBOutlet weak var slider: HASlider!
       @IBOutlet weak var lblValue_Slider: UILabel!


    var mySchemeDetailsData : SchemeResultModelElement!
    var myGiftSlabUserData : [GiftSlabModelElement] = []
    var myFinalPassingData : [GiftSlabModelElement] = []
    
    var mySchemeSTBSchemeData : [SchemeResultModelElement] = []
    var selectedIndex:NSIndexPath?
    var selectedSlabID:Int = 0
    var progressArray: [Double] = []
    var thumbValue : Float!
    var indexSlider : Int!
    var valueSlider : Double!
    var alertTag = 0
    var senderTag = 0
    let action = API.InsertUpdateGiftSlabUser
    var notificationMsg : String!
    var GlobalSamparkPointUnderSTBScheme: Int = 0
    var blurView = UIVisualEffectView()
    
    override func viewDidLoad()
    {
     super.viewDidLoad()
     
     // Do any additional setup after loading the view.
       self.btn_submit.isHidden = true
        //navigationView.btn_dashbord_width.constant = 0
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        self.scrollView.delegate = self
    
        self.slider.isUserInteractionEnabled = false
       
        GettingSchemeDetails()
             
      
    }
    

    override func viewWillDisappear(_ animated: Bool)
    {
            self.popUpView.removeFromSuperview()
            self.alertView.removeFromSuperview()
            self.blurView.removeFromSuperview()
    }

    func settingData(){
        
        
        if self.mySchemeDetailsData != nil{
            
         
                lbl_Notification.text = "\(self.mySchemeDetailsData.notification!)*".uppercased()

                  let splitString1 = "\(self.mySchemeDetailsData.ruleName) ".uppercased()
                  let splitString2 = " \n NET ELIGIBLE POINTS : "
                  let splitString3 = "\(self.GlobalSamparkPointUnderSTBScheme) ".uppercased()

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
        
        self.alertView.borderWidth = 2
        self.alertView.borderColor = UIColor.black
        
        self.travelView.layer.cornerRadius = 4
        self.travelView.clipsToBounds = true
        self.travelView.borderColor = UIColor.orange
        self.travelView.borderWidth = 1.0
        
        self.progressView.layer.cornerRadius = 4
        self.progressView.clipsToBounds = true
        self.progressView.borderColor = UIColor(red: 51/255, green: 94/255, blue: 79/255, alpha: 1.0)
        self.progressView.borderWidth = 1.0
        
        
    }
    
      func GettingSchemeDetails()
         {
            
             let parameters = [Key.MobileNo: DataProvider.sharedInstance.userDetails.s_MobileNo!,
                               Key.ActionType: ActionType.GetSchemeDetails,
                               Key.RuleName:self.mySchemeDetailsData.ruleName, Key.RuleCode:self.mySchemeDetailsData.ruleCode,Key.FromDate:"",Key.ToDate:"",Key.EmpCode:"",Key.Months:"",Key.SalesOffice:"",Key.Years:"",Key.PageNumber:0] as [String : Any]
             let parser = Parser()
             parser.delegate = self
             parser.callAPI(api: API.GetschemeDetailsByMobile, parameters: parameters, viewcontroller: self, actionType: API.GetschemeDetailsByMobile)
             
         }
    

    override func onBackButtonPressed(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    

    override func onBellButtonPressed(_ sender : UIButton)
    {
    
            let notificationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationViewController) as! NotificationViewController
            self.navigationController?.pushViewController(notificationVC, animated: true)
        
    }
  
  
    
    func GetSchemeGiftSlabUser()
    { //{"MobileNo":"7358185498","ActionType":"GetSelectedGift","RuleName":null,"RuleCode":"RUL0075","FromDate":null,"ToDate":null,"EmpCode":null,"Months":null,"SalesOffice":"","Years":null,"PageNumber":0,"pkSlabID":0,"EarnedPoint":700.0}
        let parameters = [Key.MobileNo: DataProvider.sharedInstance.userDetails.s_MobileNo!
            ,
                          Key.ActionType: ActionType.GetSelectedGift,
                          Key.RuleName:"", Key.RuleCode:self.mySchemeDetailsData.ruleCode,Key.FromDate:"",Key.ToDate:"",Key.EmpCode:"",Key.Months:"",Key.SalesOffice:"",Key.Years:"",Key.PageNumber:0,Key.EarnedPoints:self.GlobalSamparkPointUnderSTBScheme] as [String : Any]
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.GetSchemeGiftSlabUser, parameters: parameters, viewcontroller: self, actionType: API.GetSchemeGiftSlabUser)
        
        
    }

    func setupWithCustomData()
    {
       
           if self.progressArray.count != 0{
                   self.collSlabData.delegate = self
                   self.collSlabData.dataSource = self
            
            
               self.tipView_Slider.layer.cornerRadius = 10
               self.tipView_Slider.clipsToBounds = true
                                                                              
               self.slider.leftTipView = tipView_Slider
               self.slider.isUserInteractionEnabled = false
            
               setupColViewLayout()
            
                settingData()
                   
               
//-------------------------
            
//            let progressWidth = self.slider.frame.width
//            let mySliderDivider = progressWidth / self.progressArray.count
//
            self.slider.minimumValue = 0//CGFloat(self.progressArray[0])//CGFloat(self.progressArray.min() ?? 0.0)
            self.slider.maximumValue = 1.0//CGFloat(self.progressArray.count)//CGFloat(self.progressArray.max() ?? 0.0)
            
       //     #####################
            if self.GlobalSamparkPointUnderSTBScheme != nil{

                 let apiValue = self.GlobalSamparkPointUnderSTBScheme
                
                if apiValue == 0{
                       self.slider.leftValue = 0
                }else{
                    caluclateProgress(value : Int(apiValue))
                }

                 self.lblValue_Slider.text = "\(apiValue)"
              
            }else{
                self.lblValue_Slider.text = "\(0.0)"
            }
   
//              let data = find(value: Double(apiValue), in: self.progressArray)
//               print(data!)
//
//            if Int(Double( self.valueSlider)) == apiValue{
//                self.slider.leftValue = CGFloat(self.indexSlider) + CGFloat(0.5)
//            }
//            else if  apiValue ==  Int(self.progressArray.last!){
//                    self.slider.leftValue = CGFloat(self.progressArray.count)
//                           }
//            else if  apiValue <  Int(self.progressArray[0]){
//                self.slider.leftValue = 0.1//CGFloat(self.indexSlider) + CGFloat(0.8)
//            }
//           else{
//                self.slider.leftValue = CGFloat(self.indexSlider) - CGFloat(0.4)
//            }
             
        }
  }
    
    func caluclateProgress(value : Int){
        
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
            
            self.slider.leftValue = CGFloat((1 * Float(index ?? 0)) / 10 + 0.10)
        }
        }
    }
    
    func find(value searchValue: Double, in array: [Double]) -> Int?
       {
           for (index, value) in array.enumerated()
           {
                print(index)
               if value >= searchValue {
                self.indexSlider = index
                self.valueSlider = value
                   return index
               }
           }

           return nil
       }
       
    
    @IBAction func btn_Submit_pressed(_ sender: UIButton)
    {
        if(Connectivity.isConnectedToInternet())
        {
          
            if self.selectedSlabID != 0{
                                checkIMEI()
                                    self.senderTag = 1
                   }else{
                                             
                      showAlert(msg:"PLEASE SELECT GIFT")
                         
                        }
            
        }
        else
        {
            showAlert(msg: "NEED INTERNET CONNECTIVITY TO SUBMIT THE SELECTED GIFT")
        }
    }
    
    func showAlertView(){

        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        alertView.center = self.view.center

        blurView.contentView.addSubview(alertView)
        
        view.addSubview(blurView)


          }
    
    @IBAction func btn_Submit(_ sender: UIButton)
          {
            
             if  (Connectivity.isConnectedToInternet())
                    {
                            self.senderTag = 2
                            checkIMEI()

             }else{
                showAlert(msg: "NEED INTERNET CONNECTIVITY TO SUBMIT THE SELECTED GIFT")
            }
    }

    
    @IBAction func btn_ChangeGift(_ sender: UIButton)
          {
             self.alertView.removeFromSuperview()
            self.blurView.removeFromSuperview()
          }
    
    func showPopUPView(imagePath : String){

             popUpView.center = self.view.center

           self.view.addSubview(popUpView)

           DispatchQueue.main.async {
            self.imageView.image = UIImage(url: URL(string: imagePath))
           }

       }
       
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {

           return imageView
       }
       
       @IBAction func btn_CloseImgView_pressed(_ sender: UIButton)
       {
            removePopUpView()
       }
    
    
    func setupColViewLayout(){

           let cellSize = CGSize(width: (collSlabData.frame.size.width / CGFloat(self.progressArray.count)) - 4 , height: collSlabData.frame.size.height)
             let layout = UICollectionViewFlowLayout()
             layout.scrollDirection = .horizontal
             layout.itemSize = cellSize
             collSlabData.setCollectionViewLayout(layout, animated: true)
         }
    
       
       func removePopUpView() {

           UIView.animate(withDuration: 0.3, animations: {() -> Void in

                   self.popUpView.removeFromSuperview()

           }, completion: nil)
       }
    
  
}

extension SchemeResultDetails_VC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.progressArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SlabPointsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "slabCell", for: indexPath) as!  SlabPointsCollectionCell
        
        let myValues : Float = Float(self.progressArray[indexPath.row])
        
        cell.lbl_Points.text = "\(myValues.clean)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.5//CGFloat.leastNormalMagnitude
      }

      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.5//CGFloat.leastNormalMagnitude
      }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

//          let myValues : Float = Float(self.progressArray[indexPath.row])
//         return myValues.clean.size(withAttributes: nil)
//
//        let height = collectionView.frame.size.height
//        let width = collectionView.frame.size.width
//
//        let collectionWidth = width - CGFloat((progressArray.count - 1) * 5)
//        let collectionCellWidth = collectionWidth / progressArray.count
//        // in case you you want the cell to be 40% of your controllers view
//        return CGSize.init(width : collectionCellWidth , height : height)
  //  }


}


extension Float{
    var clean:String{
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f",self) : String(self)
    }
}

extension SchemeResultDetails_VC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.myFinalPassingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! SchemeDetailsCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let giftSlab = self.myFinalPassingData[indexPath.row]

        cell.lbl_PointSlab.text = "\(String(describing: giftSlab.sGiftSlabPoints!))"
        cell.lbl_Gift.text = giftSlab.sGift
        
        let imageData = giftSlab.filePath
        print(imageData ?? "0")
        if imageData != nil{
            
            cell.imgView.image = UIImage(url: URL(string: imageData ?? ""))
            
        }else{
            cell.imgView.image = UIImage(named: "noimgAvailable")
        }
        
        cell.btn_OpenImage.tag = indexPath.row
        cell.btn_OpenImage.addTarget(self, action: #selector(showImage(_:)), for: .touchUpInside)
        
        cell.btn_RadioSelect.tag = indexPath.row
        cell.btn_RadioSelect.addTarget(self, action: #selector(switchRadioButon(_:)), for: .touchUpInside)
        
          let eligibleGift : Bool = giftSlab.eligibleGift!
        
        if self.selectedIndex == indexPath as NSIndexPath{ //Here sender.tag would be your indexPath.row
           cell.btn_RadioSelect.setImage(UIImage(named: "radio"),for:UIControlState.normal)
        }else{
        
                    let isActive = self.myFinalPassingData.map{($0.isActive)}
                    print(isActive)
        
                    let isActive1 : Bool = giftSlab.isActive!
        
                    if isActive.contains(array: [true]){
        
                        cell.btn_RadioSelect.isUserInteractionEnabled = false
        
                        if isActive1 == true{
        
                            cell.btn_RadioSelect.setImage(UIImage(named: "radio"),for:UIControlState.normal)
                        }else{
                            cell.btn_RadioSelect.setImage(UIImage(named: "slash_1"),for:UIControlState.normal)
        
                        }
        
                    }else {
        
                            if eligibleGift == true
                            {
                                    cell.btn_RadioSelect.isUserInteractionEnabled = true
                                
                                    cell.btn_RadioSelect.setImage(UIImage(named: "dot"),for:UIControlState.normal)
        
                                                let fromDate = self.myFinalPassingData[indexPath.row].fromDate
                                                let toDate = self.myFinalPassingData[indexPath.row].toDate
        
                                                  let dateFormat = "dd-MM-yyyy"
        
                                                  let dateFormatter = DateFormatter()
                                                  dateFormatter.dateFormat = dateFormat
        
                                                  let startDate = dateFormatter.date(from: fromDate ?? "")
                                                  let endDate = dateFormatter.date(from: toDate ?? "")
        
                                                  let currentDate = Date()
        
                                                  guard let _ = startDate, let _ = endDate else {
                                                      fatalError("Date Format does not match ⚠️")
                                                  }
        
                                                 if startDate! < currentDate && currentDate < endDate! {
                                                      print("✅")
                                                    
                                                     self.btn_submit.isHidden = false
        
        
                                                  } else {
                                                      print("❌")
                                                  self.btn_submit.isHidden = true
                                           }
        
                            }else{
        
                               cell.btn_RadioSelect.setImage(UIImage(named: "slash_1"),for:UIControlState.normal)
                               cell.btn_RadioSelect.isUserInteractionEnabled = false
        
                        }
            }

    }
       
        return cell
    }
    
    //MARK:- RADIO BUTTON ACTION
    //MARK:-
    
    @objc func switchRadioButon(_ sender : UIButton){
     
        self.selectedIndex = IndexPath(row: sender.tag, section: 0) as NSIndexPath

        self.tblSchemeDetailView.deselectRow(at: self.selectedIndex! as IndexPath, animated: true)
        
        self.selectedSlabID = self.myFinalPassingData[sender.tag].slabID ?? 0
        print(self.selectedSlabID)
    
                DispatchQueue.main.async {
                    self.btn_submit.isHidden = false
                    self.tblSchemeDetailView.reloadData()
                }
        
    }
    

    @objc func showImage(_ sender:UIButton)
    {
        
        let imageUrl = self.myFinalPassingData[sender.tag].filePath
        if imageUrl != nil{
        
            showPopUPView(imagePath: imageUrl ?? "")
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SchemeDetailHeaderCell
        
        headerView.lbl_PointSlab.numberOfLines = 0
        headerView.lbl_Gift.numberOfLines = 0
        headerView.lbl_Images.numberOfLines = 0
     
        let font = UIFont.systemFont(ofSize: 13, weight: .bold)
        
        headerView.lbl_PointSlab.font = font
        headerView.lbl_Gift.font = font
        headerView.lbl_Images.font = font
    
        headerView.lbl_PointSlab.text = "POINT SLAB"
        headerView.lbl_Gift.text = "GIFTS"
        headerView.lbl_Images.text = "IMAGES"
      
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100//UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 40
    }
    
}


extension SchemeResultDetails_VC
{
    func didRecivedGetGiftSlabUser(responseData:[[String:Any]])
    {
        
        let myGiftSlabData = JSON(responseData)
        print(myGiftSlabData)
    
        if myGiftSlabData.count > 0 {
            
            do
            {
                self.myFinalPassingData = []
                
                let data = try JSONDecoder().decode([GiftSlabModelElement].self, from: myGiftSlabData.rawData())
                
                
                for index in data{
                    
                    let value = index
                    value.isSelected = false
                    self.myFinalPassingData.append(value)

                    
                }
                
                
                let dataArr = myFinalPassingData.map {(Double($0.sGiftSlabPoints!))}
                self.progressArray = dataArr.removeDuplicates()

                self.progressArray.insert(0, at: 0)

//                let array = [0.0,800.0,1801.0,4001.0,60001.0,11001.0]//,23001.0,33001.0,44001.0,55001.0,464545.0]
//
//                self.progressArray.append(contentsOf:array)
//
//                     print(self.progressArray)
                
               // let dataValue =  forTrailingZero(temp: dataArr.last!)
                              
                          //    self.lbl_LastIndex.text = "\(dataValue)"
                           //   self.progressArray.removeLast()
                
                
//                let max = Int(self.progressArray.max() ?? 0.0)
//
//
//                let multiples = pow(10, countDigit(num: max) - 1)
//                let roundedValue = max.roundedDown(toMultipleOf:multiples.int)
//
//                self.progressArray = divideInto10EqualParts(roundedValue, parts: 7).map {Double($0)}

                setupWithCustomData()
                              
                DispatchQueue.main.async {
                    
                    self.tblSchemeDetailView.delegate = self
                    self.tblSchemeDetailView.dataSource = self
                    self.tblSchemeDetailView.reloadData()
                }
                
                
            }catch let error as NSError {
                print(error)
            }
        }
//        else{
//
//                let alert = UIAlertController(title: "STATUS!", message: "NO SCHEME DATA FOUND...",         preferredStyle: UIAlertControllerStyle.alert)
//
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
//
//                    self.navigationController?.popToRootViewController(animated: true)
//                }))
//
//                self.present(alert, animated: true, completion: nil)
//
//        }
    }
    
    func average<C: Collection>(of c: C) -> Double where C.Element == Double {
        precondition(!c.isEmpty, "Cannot compute average of empty collection")
        return Double(c.reduce(0, +))/Double(c.count)
    }
    
    func forTrailingZero(temp: Double) -> String {
           let tempVar = String(format: "%.f", temp)///"%.2f"
           return tempVar
       }
    
    func  countDigit(num : Int) -> Int
     {
         if (num == 0) {
             return 0
         }
         
         return 1 + countDigit(num: num / 10);
     }
    
    func divideInto10EqualParts(_ value: Int,parts: Int) -> [Int] {
        var temp: [Int] = []
        for i in 1...parts {
            let initialParts = value / parts
            temp.append(initialParts * i)
        }
        return temp
    }
    
    
    
    func didRecivedStatusInsertUpdateGiftSlabUser(responseData:String)
    {
        
 
           let alert = UIAlertController(title: appName, message: "YOUR GIFT SELECTION HAS BEEN SUBMITTED", preferredStyle:UIAlertControllerStyle.alert)
           let actionYes = UIAlertAction(title: "OK".localizableString(loc:
               UserDefaults.standard.string(forKey: "keyLang")!),
                                         style: .default,
                                         handler: self.okPressed)
           alert.addAction(actionYes)
      
           self.present(alert, animated: true, completion: nil)
       }
   
    @objc func okPressed(alert: UIAlertAction!)
      {
          self.navigationController?.popViewController(animated: true)
      }
}



class CustomSlider: UISlider {
    @IBInspectable var trackHeight: CGFloat = 25
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: self.frame.width, height: trackHeight))//bounds.width
    }
}


 
extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}

extension BinaryInteger {
  func roundedTowardZero(toMultipleOf m: Self) -> Self {
    return self - (self % m)
  }
  
  func roundedAwayFromZero(toMultipleOf m: Self) -> Self {
    let x = self.roundedTowardZero(toMultipleOf: m)
    if x == self { return x }
    return (m.signum() == self.signum()) ? (x + m) : (x - m)
  }
  
  func roundedDown(toMultipleOf m: Self) -> Self {
    return (self < 0) ? self.roundedAwayFromZero(toMultipleOf: m)
                      : self.roundedTowardZero(toMultipleOf: m)
  }
  
  func roundedUp(toMultipleOf m: Self) -> Self {
    return (self > 0) ? self.roundedAwayFromZero(toMultipleOf: m)
                      : self.roundedTowardZero(toMultipleOf: m)
  }
}



extension Decimal {
    var int: Int {
        return NSDecimalNumber(decimal: self).intValue
    }
}



extension SchemeResultDetails_VC {
    
  func didRecivedGetDashboardDataForApi(){}
       
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
                      let userStatus = Parser.checkUsertType(usertype: usertype, userStatus: userStatus, viewController: self)
                      if (userStatus.0)
                      {
                          if action == API.InsertUpdateGiftSlabUser
                          {
                             
                            if self.senderTag == 1{
                              
                                    showAlertView()
                              
                            }else if self.senderTag == 2{
                                
                                          let parameters = [Key.MobileNo: DataProvider.sharedInstance.userDetails.s_MobileNo!
                                                 ,
                                                 Key.ActionType: ActionType.InsertSelectedGift,
                                                 Key.RuleName:"", Key.RuleCode:self.mySchemeDetailsData.ruleCode,Key.FromDate:"",Key.ToDate:"",Key.EmpCode:DataProvider.sharedInstance.userDetails.s_MobileNo!,Key.Months:"",Key.SalesOffice:"",Key.Years:"",Key.Source : Source,Key.PageNumber:0,Key.PKSlab_ID : self.selectedSlabID] as [String : Any]
                                             let parser = Parser()
                                             parser.delegate = self
                                             parser.callAPI(api: API.InsertUpdateGiftSlabUser, parameters: parameters, viewcontroller: self, actionType: API.InsertUpdateGiftSlabUser)
                            }
                              
                          }
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
}


extension SchemeResultDetails_VC
{
    func didRecivedGetschemeDetailsByMobile(responseData:[[String:Any]])
    {
        
        let mySchemeData = JSON(responseData)
      
            do
            {
                self.mySchemeSTBSchemeData = try JSONDecoder().decode([SchemeResultModelElement].self, from: mySchemeData.rawData())
                
                print(self.mySchemeSTBSchemeData)
                
                if self.mySchemeSTBSchemeData.count != 0{
                    self.GlobalSamparkPointUnderSTBScheme = Int(self.mySchemeSTBSchemeData[0].netSamparkPointUnderSTBScheme)
                               print(self.GlobalSamparkPointUnderSTBScheme)
                }else{
                    self.GlobalSamparkPointUnderSTBScheme = Int(0.0)
                }
                
                if(Connectivity.isConnectedToInternet())
                     {
                         GetSchemeGiftSlabUser()
                      }
                     else
                     {
                         showAlert(msg: MessageAndError.noInternetConnection_SchemeDETAILS)
                     }
                
            }catch let error as NSError {
                print(error)
            }
       
    }
}
