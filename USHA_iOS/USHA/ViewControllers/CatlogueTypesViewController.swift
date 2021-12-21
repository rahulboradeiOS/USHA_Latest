//
//  CatlogueTypesViewController.swift
//  USHA Retailer
//
//  Created by Rahul on 29/06/21.
//  Copyright © 2021 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ProductCatalogueTypeData { //7th dropDown

    var Sequence: Int?
    var ParentId: Int?
    var TileType: String?
    var Title: String?
    var ImageName: String?
    var Url: String?
    var Image: String?
    var Id: Int?
    var CreatedBy: Int?
    var CreatedOn: Int?
    var IsActive: Bool?
    var IsDeleted: Bool?
    var IP: Double?
    var CallType: String?
    var ResultCode: String?
    var Message: String?

    init(Sequence: Int?, ParentId: Int?, TileType: String?, Title: String?, ImageName: String?, Url: String?, Image: String?, Id: Int?, CreatedBy: Int?, CreatedOn: Int?, IsActive: Bool?, IsDeleted: Bool?, IP: Double?, CallType: String?, ResultCode: String?, Message: String?){

        self.Sequence = Sequence
        self.ParentId = ParentId
        self.TileType = TileType
        self.Title = Title
        self.ImageName = ImageName
        self.Url = Url
        self.Image = Image
        self.Id = Id
        self.CreatedBy = CreatedBy
        self.CreatedOn = CreatedOn
        self.IsActive = IsActive
        self.IsDeleted = IsDeleted
        self.IP = IP
        self.CallType = CallType
        self.ResultCode = ResultCode
        self.Message = Message
  }
 }
class CatlogueTypesViewController: UIViewController {
    
    
    @IBOutlet weak var collCatalogView : UICollectionView!

    var token = ""
    var productCatalogueType : [ProductCatalogueTypeData] = [ProductCatalogueTypeData]()
    var imageURL = "https://ushajoy.usha.com/assets/images/CategoryImages/"
    
    var selectedCatID = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        getToken()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collCatalogView.reloadData()
    }
    func getToken(){
        
        let dic : [String: Any] = ["UserName":"0000099999","grant_type":"password","Scope":"U","Password":"Usha@1234"]
        
        let requestURL: String = "https://ushajoyservice.usha.com/token"
        Alamofire.request(requestURL, method : .post, parameters : dic, encoding : URLEncoding.httpBody , headers : ["Content-Type":"application/x-www-form-urlencoded"]).responseJSON { response in
            DispatchQueue.main.async {
                print("URL : \(requestURL)\nRESPONSE : \(response)")
                let responsString = response.data?.toString()
                print(responsString!)
                let ndata = responsString?.data(using: String.Encoding.utf8)
                if let json = try? JSONSerialization.jsonObject(with: ndata!, options: []) as! [String:Any]
                {
                    print("Complete json = \(json)")
                    self.token = json["access_token"] as? String ?? ""
                    self.getProductCatalogue(token: self.token)
                }
            }
        }
    }
    func getProductCatalogue(token:String) {
        var auth = "bearer " + token
        
        let dic : [String: Any] = ["ParentId":selectedCatID,"TileType":"ProductCatalogue"]

        let requestURL: String = "https://ushajoyservice.usha.com/api/Tile/GetChildTiles"
        Alamofire.request(requestURL, method : .post, parameters : dic, encoding : URLEncoding.httpBody , headers : ["Authorization":auth,"Content-Type":"application/x-www-form-urlencoded"]).responseJSON { response in
            DispatchQueue.main.async {
                print("URL : \(requestURL)\nRESPONSE : \(response)")
                
                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                
                for i in swiftyJsonVar.arrayValue{
                    let s_FullName = i["TileType"].stringValue
                    var data = ProductCatalogueTypeData(Sequence: i["Sequence"].intValue,
                                                    ParentId: i["ParentId"].intValue,
                                                    TileType: i["TileType"].stringValue,
                                                    Title: i["Title"].stringValue,
                                                    ImageName: i["ImageName"].stringValue,
                                                    Url: i["Url"].stringValue,
                                                    Image: i["Image"].stringValue,
                                                    Id: i["Id"].intValue,
                                                    CreatedBy: i["CreatedBy"].intValue,
                                                    CreatedOn: i["CreatedOn"].intValue,
                                                    IsActive: i["IsActive"].boolValue,
                                                    IsDeleted: i["IsDeleted"].boolValue,
                                                    IP: i["IP"].doubleValue,
                                                    CallType: i["CallType"].stringValue,
                                                    ResultCode: i["ResultCode"].stringValue,
                                                    Message: i["Message"].stringValue)
                    self.productCatalogueType.append(data)
                }
                self.collCatalogView.dataSource = self
                self.collCatalogView.delegate = self
                self.collCatalogView.reloadData()
            }
        }
    }

  @IBAction func btn_Back_pressed(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    

    func openPriceList(urlStr:String)
    {
        if let url = URL(string: urlStr)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
 
}
extension CatlogueTypesViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productCatalogueType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatlogueTypeCollectionViewCell", for: indexPath) as! CatlogueTypeCollectionViewCell
        
        let cellData = self.productCatalogueType[indexPath.item]
        
        cell.nameTXT.text = "\(cellData.Title ?? "")".uppercased()
        
        let url = URL(string: "\(imageURL + cellData.ImageName! ?? "")")

        cell.imageName.kf.setImage(with: url)
        
        cell.bgView.layer.shadowColor = UIColor.darkGray.cgColor
        cell.bgView.layer.shadowOpacity = 1
        cell.bgView.layer.shadowOffset = CGSize.zero
        cell.bgView.layer.shadowRadius = 3
        cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
        cell.bgView.layer.borderWidth = 1.0
        cell.bgView.layer.cornerRadius = 3
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

         let cellData = self.productCatalogueType[indexPath.item]

//         openPriceList(urlStr: "\(cellData["url"] ?? "")")

        //go to wkwebviewurl

        var auth = "bearer " + token
        let dic : [String: Any] = ["Type":"Catalogue","FileName":"\(cellData.Url ?? "")"]

        let requestURL: String = "https://ushajoyservice.usha.com/api/External/GetAccountStatement"
        Alamofire.request(requestURL, method : .post, parameters : dic, encoding : URLEncoding.httpBody , headers : ["Authorization":auth,"Content-Type":"application/x-www-form-urlencoded"]).responseJSON { response in
            DispatchQueue.main.async {
                print("URL : \(requestURL)\nRESPONSE : \(response)")
                
                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar["MSG"].stringValue)
                let wkVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.WKWebViewController) as! WKWebViewController
                wkVC.loadUrl = swiftyJsonVar["MSG"].stringValue
                wkVC.fromVC = "Catalog"
                self.navigationController?.pushViewController(wkVC, animated: true)

            }
        }
        

    }
    
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

                      let padding: CGFloat = 20
                      let cellSize = collectionView.frame.size.width - padding

                      let cellWidth = (cellSize / 2 )
                      let size = CGSize(width: CGFloat(cellWidth), height: 135)

                      return size


        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
