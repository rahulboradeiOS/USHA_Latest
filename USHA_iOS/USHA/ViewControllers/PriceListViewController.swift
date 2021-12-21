//
//  PriceListViewController.swift
 
//
//  Created by Apple.Inc on 03/07/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class CatalogCollectionCell : UICollectionViewCell{
    
    @IBOutlet weak var lblProductName : UILabel!
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var bgView : UIView!

}

class ProductCatalogueData { //7th dropDown

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

class PriceListViewController: UIViewController
{
    
    @IBOutlet weak var collCatalogView : UICollectionView!

    var token = ""
    var productCatalogue : [ProductCatalogueData] = [ProductCatalogueData]()
    var imageURL = "https://ushajoy.usha.com/assets/images/CategoryImages/"
    var catalog_items = [
        ["Name": "fans", "Img": "usha-fans.png", "url":"https://www.ushafans.com"],["Name": "cooking appliances", "Img":"usha-cooking-appliances.png", "url": "https://www.ushacook.com"],["Name": "sewing machines", "Img": "usha-sewing-machines.png", "url":  "https://www.ushasew.com"],["Name": "fabric care", "Img": "usha-fabric-care.png", "url": "https://www.ushairons.com"],["Name": "water coolers", "Img": "usha-water-coolers-dispensers.png", "url": "https://www.ushawatersolutions.com"],["Name": "room coolers", "Img": "usha-room-coolers.png", "url":"https://www.ushaaircoolers.com"],["Name": "water heaters", "Img": "usha-water-heaters.png", "url": "https://www.ushawaterheaters.com"],["Name": "room heaters", "Img": "usha-room-heaters.png", "url": "https://www.usharoomheaters.com"],["Name": "electric water pump", "Img": "usha-electric-water-pumps.png", "url":"https://www.ushapumps.com/en"]
    ]
    
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
                    var token = json["access_token"] as? String ?? ""
                    self.getProductCatalogue(token: token)
                }
            }
        }
    }
    func getProductCatalogue(token:String) {
        var auth = "bearer " + token
        
        let requestURL: String = "https://ushajoyservice.usha.com/api/Tile/GetByType/ProductCatalogue"
        Alamofire.request(requestURL,method: .get, encoding: JSONEncoding.default, headers : ["Authorization":auth]).responseJSON { response in
            DispatchQueue.main.async {
                print("URL : \(requestURL)\nRESPONSE : \(response)")
                
                let swiftyJsonVar = JSON(response.result.value!)
                print(swiftyJsonVar)
                
                for i in swiftyJsonVar.arrayValue{
                    let s_FullName = i["TileType"].stringValue
                    var data = ProductCatalogueData(Sequence: i["Sequence"].intValue,
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
                    self.productCatalogue.append(data)
                }
                self.collCatalogView.dataSource = self
                self.collCatalogView.delegate = self
                self.collCatalogView.reloadData()
            }
        }
    }

  @IBAction func btn_Back_pressed(_ sender: UIButton) {
       self.navigationController?.popToRootViewController(animated: true)
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


extension PriceListViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productCatalogue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogCell", for: indexPath) as! CatalogCollectionCell
        
        let cellData = self.productCatalogue[indexPath.item]
        
        cell.lblProductName.text = "\(cellData.Title ?? "")".uppercased()
        
        let url = URL(string: "\(imageURL + cellData.ImageName! ?? "")")

        cell.imgView.kf.setImage(with: url)
        
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
        
         let cellData = self.productCatalogue[indexPath.item]
        
//         openPriceList(urlStr: "\(cellData["url"] ?? "")")
        
        //go to wkwebviewurl
        
        let wkVC = getViewContoller(storyboardName: Storyboard.Main, identifier: "CatlogueTypesViewController") as! CatlogueTypesViewController
        
        wkVC.selectedCatID = cellData.Id ?? 0
//        wkVC.fromVC = "Catalog"
        self.navigationController?.pushViewController(wkVC, animated: true)

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
