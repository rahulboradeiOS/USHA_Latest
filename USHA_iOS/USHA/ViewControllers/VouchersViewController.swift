//
//  VouchersViewController.swift
//  ELECTRICIAN
//
//  Created by Apple.Inc on 30/11/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
//import Lottie
import SQLite
class VouchersViewController: BaseViewController
{
    @IBOutlet weak var balanceView: BalanceView!
    @IBOutlet weak var balanceView_height: NSLayoutConstraint!
    @IBOutlet weak var lblCartCount: UILabel!
    @IBOutlet weak var collectionView_vouchers: UICollectionView!
    @IBOutlet weak var btn_viewCart: UIButton!
    @IBOutlet weak var lbl_totalbalance: UILabel!
       @IBOutlet weak var lbl_UserName: UILabel!
    var array_Vouchers = [Voucher]()
    
    var array_SaveVouchers = [Voucher]()
    var someValue: Int = 0 {
        didSet {
            self.lblCartCount.text = "\(someValue)"
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView_vouchers.delegate = self
        collectionView_vouchers.dataSource = self
        getVouchers()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        getVouchetrsFromDB()
        collectionView_vouchers.reloadData()
       // self.configBalanceView()
        self.lbl_UserName.text = "Welcome - \(DataProvider.sharedInstance.userDetails.s_ShopName ?? "")"
        self.lbl_totalbalance.text = "\u{20B9} "+"\(String(DataProvider.sharedInstance.userDetails.d_Balance!))"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func configBalanceView()
    {
        balanceView.configBalance()
        balanceView.viewController = self
        layoutBalanceView()
        balanceView.btn_syncBalance.isHidden = true
        balanceView.btn_totalBalance.isHidden = true
        balanceView.btn_viewTotalBalanceDetails.isHidden = true
    }
    
    func layoutBalanceView()
    {
        balanceView.layoutSubviews()
        balanceView.layoutIfNeeded()
        let height = balanceView.balanceView.frame.size.height
        balanceView_height.constant = height
    }
    
    @IBAction func onBackBttnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getVouchetrsFromDB()
    {
        guard let db = DataProvider.getDBConnection() else { print("DB Error in voucher list get from db"); return}
        
        array_SaveVouchers.removeAll()
        do{
            for voucher in try db.prepare(tblVoucher)
            {
                let v = Voucher()
                v.Image = voucher[c_Image]
                v.ProductImage = voucher[c_ProductImage]
                v.RedProductName = voucher[c_RedProductName]
                v.qty = voucher[c_Qty]
                v.total = voucher[c_Total]
                v.id = voucher[c_Pk_VoucherID]
                v.RedProductCode = voucher[c_RedProductCode]
                v.RedProductDescription = voucher[c_RedProductDescription]
                array_SaveVouchers.append(v)
              
            }
             someValue = array_SaveVouchers.count
        }
        catch
        {
            
            print("error DB Insert")
            print("Error info: \(error)")
        }
        self.collectionView_vouchers.reloadData()
    }
    
    func getVouchers()
    {
        let parameters:Parameters = [Key.TypeV:"SelectProductByCategory", Key.SubCategoryCode : "REDC000156", Key.s_UserCode : "", Key.s_EmployeeCode : "EMP00012", Key.s_ProductCode : "Operation"]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        let jsons = jsonData!.toString()
    
        let urlEncoadedJson = jsons.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        let url = "\(baseUrl)Transction/getProductByCategory?jsondata=\(urlEncoadedJson!)"
        self.view.makeToastActivity(message: "Processing...")
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        manager.request(url, method : .get, parameters : nil, encoding : JSONEncoding.default , headers : headers).responseJSON { response in
            DispatchQueue.main.async {
                print("URL : \(url)\nRESPONSE : \(response)")
                
                switch response.result
                {
                case .success:
                    if let json = response.result.value as? [String:Any]
                    {
                        //print("json = \(json)")
                        if let voucherArray = json["LSP_SelectProductByCategory_Result"] as? [[String:Any]]
                        {
                            self.array_Vouchers = VoucherParser.parseVoucher(json: voucherArray)
                            self.collectionView_vouchers.reloadData()
                        }
                    }
                    else
                    {
                        self.showAlert(msg: "somethingWentWrong".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                    break
                case .failure(let error):
                    print(error)
                    switch (response.error!._code)
                    {
                    case NSURLErrorTimedOut:
                        self.showAlert(msg:"server_is_Busy".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                        break
                    case NSURLErrorNotConnectedToInternet:
                        self.showAlert(msg: error.localizedDescription)
                        break
                    default:
                        self.showAlert(msg: "serviceUnavailable".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                }
                self.view.hideToastActivity()
            }
        }
    }
    
    @IBAction func btn_add_pressed(_ sender: UIButton)
    {
        let voucher = array_Vouchers[sender.tag]
        voucher.qty = 1
        var price:Double = 0.0
        if let n = Double(voucher.Image!)
        {
            price = n
        }
        voucher.total = price*Double(voucher.qty!)
        
        if(isVoucherInCart(RedProductCode: voucher.RedProductCode!))
        {
            update(voucher: voucher)
        }
        else
        {
            save(voucher: voucher)
            self.someValue += 1
        }
        let ip = IndexPath(item: sender.tag, section: 0)
        self.collectionView_vouchers.reloadItems(at: [ip])
    }
    
    func update(voucher:Voucher)
    {
        guard let db = DataProvider.getDBConnection() else
        {
            print("db connection not found")
            return
        }
        let query = tblVoucher.filter(c_RedProductCode == voucher.RedProductCode!)
        //let row = query.select(c_Qty)
        do
        {
            if let row = try db.pluck(query)
            {
                voucher.qty = row[c_Qty] + 1
                var price:Double = 0.0
                if let n = Double(voucher.Image!)
                {
                    price = n
                }
                voucher.total = price*Double(voucher.qty!)
                if try db.run(query.update(c_Qty <- voucher.qty!, c_Total <- voucher.total!))  > 0
                {
                    print("updated alice")
                    showAlert(msg: "voucherAdded".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                }
                else
                {
                    print("query not found")
                    save(voucher: voucher)
                }
            }
            else
            {
                print("query not found")
                save(voucher: voucher)
            }
        }catch {
            print("failed: \(error)")
            save(voucher: voucher)
        }
    }
    
    func save(voucher:Voucher)
    {
        if(VoucherParser.saveVoucherData(voucher: voucher))
        {
            
            showAlert(msg: "voucherAdded".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
        else
        {
            showAlert(msg: "voucherAddedFailed".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
    }
    
    func isVoucherInCart(RedProductCode:String) -> Bool
    {
        if let db = DataProvider.getDBConnection()
        {
            do{
                let alice = tblVoucher.filter(c_RedProductCode == RedProductCode)
                let row = Array(try db.prepare(alice))
                if row.count > 0
                {
                    return true
                }
            }catch{
                print("faild \(error)")
                return false
            }
        }
        return false
    }
    
    
    @IBAction func btn_viewCart_pressed(_ sender: Any)
    {
        getVouchetrsFromDB()
        
        if array_SaveVouchers.count > 0
        {
            let vwlVC = getViewContoller(storyboardName: "Main", identifier: Identifier.VouchersWishListViewController) as! VouchersWishListViewController
            self.navigationController?.pushViewController(vwlVC, animated: true)
        }
        else
        {
            showAlert(msg: "No item selected!".uppercased())
        }
    }
    
//    @objc func switchToggled(sender:LOTAnimatedSwitch)
//    {
//        print("The switch is \(sender.isOn ? "on" : "off")")
//    }
}

// MARK: - UICollectionViewDataSource
extension VouchersViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return array_Vouchers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VouchersCollectionViewCell.identifier, for: indexPath) as! VouchersCollectionViewCell
        
        let voucher = array_Vouchers[indexPath.item]
        
        if  let price = voucher.Image,
            let RedProductName = voucher.RedProductName,
            let ProductImage = voucher.ProductImage
        {
            let imageUrl = "\(mainUrlPowerPlus)/CommanFiles/RedImages/\(ProductImage)"
            var urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            cell.img_icon.downloadedFrom(link: urlString!)
            cell.lbl_title.text = RedProductName
            cell.lbl_price.text = price
            cell.btn_add.tag = indexPath.row
            //cell.heartIcon.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
            cell.btn_add.setShadow()

            if(isVoucherInCart(RedProductCode: voucher.RedProductCode!))
            {
                cell.btn_add.backgroundColor = ColorConstants.Navigation_Color
            }
            else
            {
                cell.btn_add.setTitleColor(.white, for: .normal)
                cell.btn_add.backgroundColor = .red
            }
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (collectionView.frame.size.width - 40) / 2
        return CGSize(width: width, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UICollectionViewDelegate
extension VouchersViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
//        let voucherDic = array_Vouchers[indexPath.item]
    }
}

class VouchersCollectionViewCell: UICollectionViewCell
{
    static let identifier = "VouchersCell"
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var img_icon: UIImageView!
    @IBOutlet weak var btn_add: UIButton!
    @IBOutlet weak var view_bg: UIView!
    
    //var heartIcon:LOTAnimationView!
    //var heartIcon:LOTAnimatedSwitch!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override public func layoutSubviews()
    {
        super.layoutSubviews()
        
        //heartIcon.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        //heartIcon.center = CGPoint(x: btn_add.frame.midX, y: btn_add.frame.midY)
        view_bg.setShadow()
        btn_add.setShadow()
    }
}
