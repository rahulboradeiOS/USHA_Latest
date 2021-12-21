
import UIKit
import SQLite
import Alamofire

class VouchersWishListViewController: BaseViewController
{
    @IBOutlet weak var balanceView: BalanceView!
    @IBOutlet weak var balanceView_height: NSLayoutConstraint!
    
    @IBOutlet weak var tableView_VouchersList: UITableView!
    @IBOutlet weak var btn_redeem: UIButton!
    @IBOutlet weak var lbl_totalbalance: UILabel!
          @IBOutlet weak var lbl_UserName: UILabel!
    var footerCell:VouchersWishListTableViewCell!
    
    var arrayWishList = [Voucher]()
    var arrSchemeName = [String]()
    var redemMsg = ""
    var alertTag = 0
    var action:RedeemtionViewControllerAction = .none
    
    var vouchersTotal = 0.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getVouchetrsFromDB()
        tableView_VouchersList.delegate = self
        tableView_VouchersList.dataSource = self
        
        btn_redeem.layer.cornerRadius = 20
        btn_redeem.layer.masksToBounds = true
        
        //self.configBalanceView()
        self.lbl_UserName.text = "Welcome - \(DataProvider.sharedInstance.userDetails.s_ShopName ?? "")"
        self.lbl_totalbalance.text = "\u{20B9} "+"\(String(DataProvider.sharedInstance.userDetails.d_Balance!))"
    }
    
    @IBAction func onBackBttnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    
    func getVouchetrsFromDB()
    {
        guard let db = DataProvider.getDBConnection() else { print("DB Error in voucher list get from db"); return}
        
        var arrVouchers = [Voucher]()
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
                arrVouchers.append(v)
            }
            self.arrayWishList = arrVouchers
        }
        catch
        {
            print("error DB Insert")
            print("Error info: \(error)")
        }
    }

    @IBAction func btn_delete_pressed(_ sender: UIButton)
    {
        deleteAlert(tag:sender.tag)
        //deleteCartVoucher(atIndex: sender.tag)
    }
    
    @IBAction func btn_redeem_pressed(_ sender: UIButton)
    {
        let balance = DataProvider.sharedInstance.selectedScehme.d_Balance!
        if vouchersTotal > balance
        {
            showAlert(msg: "TOTAL AMOUNT SHOULD BE LESS THAN BALANCE!".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
        else if vouchersTotal < 10.00 || vouchersTotal > 1000.00
        {
            showAlert(msg: "TOTAL AMOUNT BETWEEN 10.00 TO 1000.00!".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
        else
        {
            if Connectivity.isConnectedToInternet()
            {
                checkIMEI()
            }
            else
            {
                showAlert(msg:"noInternetConnection_REDEEMVOUCHER".localizableString(loc:
                    UserDefaults.standard.string(forKey: "keyLang")!))
            }
            
        }
    }
    
    func deleteCartVoucher(atIndex:Int)
    {
        let voucher = arrayWishList[atIndex]
        guard let db = DataProvider.getDBConnection()
        else
        {
            print("DB Error in voucher list get from db");
            return
        }
        
        let alice = tblVoucher.filter(c_Pk_VoucherID == voucher.id!)
        do {
            if try db.run(alice.delete()) > 0 {
                print("deleted alice")
            } else {
                print("alice not found")
            }
        } catch {
            print("delete failed: \(error)")
        }
        
        arrayWishList.remove(at: atIndex)
        if arrayWishList.count == 0
        {
            alertTag = 1
            let alert = UIAlertController(title: "", message: "YOUR CART IS EMPTY, KINDLY GO BACK AND ADD ITEMS TO REDEEM!", preferredStyle: UIAlertControllerStyle.alert)
            let actionYes = UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: { action in
                                            self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(actionYes)
        
            self.present(alert, animated: true, completion: nil)
        }
            //showAlert(msg: "cart is empty please add item into the cart!".uppercased())
        tableView_VouchersList.reloadData()
    }
    
    func deleteAlert(tag:Int)
    {
        let alert = UIAlertController(title: appName, message: "voucherDelete".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!), preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "YES".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                      style: .default,
                                      handler: { action in
                                        self.deleteCartVoucher(atIndex: tag)
        })
        alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "NO".localizableString(loc:
            UserDefaults.standard.string(forKey: "keyLang")!),
                                     style: .destructive,
                                     handler: { action in
                                        let ip = IndexPath(row: tag, section: 0)
                                        self.tableView_VouchersList.reloadRows(at: [ip], with: .automatic)
        })
        alert.addAction(actionNo)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension VouchersWishListViewController//: ParserDelegate
{
    func redeemVouchers()
    {
        var arr_reddet = [Parameters]()
        
        for voucher in arrayWishList
        {
            let reddet:Parameters = [Key.ProductCode: voucher.RedProductCode!,
                                     Key.ProductName : voucher.RedProductName!,
                                     Key.ProductQuantity: voucher.qty!,
                                     Key.ProductPrice: voucher.Image!]
            arr_reddet.append(reddet)
        }
        
        let parameters:Parameters = [Key.reddet:arr_reddet,
                                     Key.RedeemType: RedeemTypeV,
                                     Key.MobileNo: DataProvider.sharedInstance.userDetails.s_MobileNo!,
                                     Key.SchemeName: staticSchemeCode,
                                     Key.OTP: "",
                                     Key.RedemmValue: "",
                                     Key.AccountNo: "",
                                     Key.BankName: "",
                                     Key.IFSCCode: "",
                                     Key.Source: Source,
                                     //Key.Messege: messageBankTransfer,
            Key.CreatedBy: DataProvider.sharedInstance.userDetails.s_MobileNo!]
        
        print(parameters)
        
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.Redeemption, parameters: parameters, viewcontroller: self, actionType: API.Redeemption)
    }
    
    func updateBalance(json:[[String:Any]])
    {
        if json.count > 0
        {
            let result_Balance = SchemeParser.parseScheme(json: json)
            
            guard let db = DataProvider.getDBConnection() else {
                print("db connection not found")
                return
            }
            
            do {
                
                let itExists = try db.scalar(tblScheme.exists)
                if itExists
                {
                    for item in result_Balance.1
                    {
                        let alice = tblScheme.filter(c_s_SchemePromName.like(item.s_SchemePromName!))
                        try db.run(alice.update(c_d_Balance <- item.d_Balance!))
                    }
                }
                else
                {
                    DataProvider.dropTable(table: tblScheme)
                    for item in result_Balance.1
                    {
                        SchemeParser.saveSchemeData(scheme: item)
                    }
                }
                
                        let sScheme = staticSchemeName
                        let alice = tblScheme.filter(c_s_SchemePromName.like(sScheme))
                        
                print(alice.count)
                
                for row in try db.prepare(alice)
                {
                    print("row[c_d_Balance] = \(row[c_s_SchemePromName])")
                    DataProvider.sharedInstance.selectedScehme.d_Balance = row[c_d_Balance]
                }
                
                let sum = try db.scalar(tblScheme.select(c_d_Balance.sum))
                if let total = sum  {
                    DataProvider.sharedInstance.userDetails.d_Balance = total
                }
                
                for scheme in try db.prepare(tblScheme.select(c_s_SchemePromName)) {
                    //print("c_s_SchemePromName: \(scheme[c_s_SchemePromName])")
                    self.arrSchemeName.append(scheme[c_s_SchemePromName])
                }
                
            }catch  {
                print("error DB Insert")
                print("Error info: \(error)")
            }
            
            setUserDefaults(value: Date(), key: defaultsKeys.lastBalnceSyncDate)
            configBalanceView()
        }
        else
        {
            print("no scheme data")
        }
    }
    
    func getBalanceByUserCode(userCode:String)
    {
        let parameters:Parameters = [Key.UserCode : userCode]
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.GetBalanceByUserCode, parameters: parameters, viewcontroller: self, actionType: API.GetBalanceByUserCode)
    }
    
    func didRecivedRespoance(api: String, parser: Parser, json: Any)
    {
        if api == API.Redeemption
        {
            redemMsg = parser.responseMessage
            if parser.responseCode == 01
            {
                showAlert(msg: "\(redemMsg)!".uppercased())
                return
            }
            //txt_point.text = ""
            self.getBalanceByUserCode(userCode: DataProvider.sharedInstance.userDetails.s_UserCode!)
        }
        else if api == API.GetBalanceByUserCode
        {
            if let json = parser.responseData as? [[String:Any]]
            {
                if action == .SYNC
                {
                    updateBalance(json: json)
                }
                else
                {
                    updateBalance(json: json)
                    alertTag = 1
                    showAlert(msg: "\(redemMsg)!".uppercased())
                }
            }
            else
            {
                print("no scheme data")
            }
        }
    }
    
    
    func didRecivedAppCredentailFali(msg: String)
    {
        alertTag = -1
        showAlert(msg: msg)
    }
    
    @objc func didRecived_AppCredentail(appCredentail: AppCredential)
    {
        if appCredentail.actionType == ActionType.CheckIMEI
        {
            if (appCredentail.isIMEIExit)
            {
                let userStatus = Parser.checkUsertType(appCredentail: appCredentail, viewController: self)
                if (userStatus.0)
                {
                    redeemVouchers()
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
    
    
    override func onOkPressed(alert: UIAlertAction!)
    {
        if alertTag == 1
        {
            //createMenuView()
            DataProvider.dropTable(table: tblVoucher)
            self.navigationController?.popViewController(animated: true)
            
            //            for viewController in (self.navigationController?.viewControllers)!
            //            {
            //                if let vc = viewController as? RedemptionTypeViewController
            //                {
            //                    DataProvider.dropTable(table: tblVoucher)
            //                    self.navigationController?.popToViewController(vc, animated: true)
            //                    break
            //                }
            //            }
        }
        else if alertTag == -1
        {
//            goToPasswordViewController(isRemoveAppSession: true)
        }
        else if alertTag == 2
        {
            //exit(0)
//            goToPasswordViewController(isRemoveAppSession: true)
        }
    }
}


// MARK: UIStepperControllerDelegate functions
extension VouchersWishListViewController : UIStepperControllerDelegate
{
    func stepperDidAddValues(stepper: UIStepperController)
    {
        updateVoucher(stepper: stepper)
    }
    
    func stepperDidSubtractValues(stepper: UIStepperController)
    {
        updateVoucher(stepper: stepper)
    }
    
    func updateVoucher(stepper:UIStepperController)
    {
        if(stepper.count == 0)
        {
            let ip = IndexPath(row: stepper.tag, section: 0)
            self.tableView_VouchersList.reloadRows(at: [ip], with: .automatic)
            //deleteAlert(tag: stepper.tag)
        }
        else
        {
            let voucher = arrayWishList[stepper.tag]
            voucher.qty = Int(stepper.count)
            var price:Double = 0.0
            if let n = Double(voucher.Image!)
            {
                price = n
            }
            voucher.total = price*Double(voucher.qty!)
            arrayWishList[stepper.tag] = voucher
            
            guard let db = DataProvider.getDBConnection() else { print("DB Error in voucher list get from db"); return}
            
            print("voucher.id = \(voucher.id!)")
            
            let alice = tblVoucher.filter(c_Pk_VoucherID == voucher.id!)
            do {
                if try db.run(alice.update(c_Qty <- voucher.qty!, c_Total <- voucher.total!)) > 0
                {
                    print("updated alice")
                } else {
                    print("alice not found")
                }
            } catch {
                print("update failed: \(error)")
            }
            
            let ip = IndexPath(row: stepper.tag, section: 0)
            tableView_VouchersList.reloadRows(at: [ip], with: .automatic)
            updateTotal()
        }
    }
    
    func updateTotal()
    {
        guard let db = DataProvider.getDBConnection() else
        {
            print("DB Error in voucher list get from db");
            return
        }
        do
        {
            if let sum = try db.scalar(tblVoucher.select(c_Total.sum)) // -> Double?
            {
                vouchersTotal = sum
                footerCell.lbl_total.text = "\(sum)"
            }
            else
            {
                footerCell.lbl_total.text = "-"
            }
        }
        catch
        {
            print("sum faild \(error)")
        }
    }
}


extension VouchersWishListViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayWishList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: VouchersWishListTableViewCell.identifier) as? VouchersWishListTableViewCell
        {
            cell.selectionStyle = .none
            let voucher = arrayWishList[indexPath.row]
            if  let price = voucher.Image,
                let RedProductName = voucher.RedProductName,
                let ProductImage = voucher.ProductImage
            {
                let imageUrl = "\(mainUrlPowerPlus)/CommanFiles/RedImages/\(ProductImage)"//RedImages + "\(ProductImage)"
                var urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

                cell.img_icon.downloadedFrom(link: urlString!)
                cell.lbl_title.text = RedProductName
                cell.lbl_price.text = price
                let qty = CGFloat(voucher.qty!)
                cell.view_stepper.count = qty
                cell.lbl_total.text = "\(voucher.total!)"
            }
            cell.btn_delete.tag = indexPath.row
            cell.view_stepper.tag = indexPath.row
            cell.view_stepper.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let fView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        fView.backgroundColor = .clear
        
        if (footerCell == nil)
        {
            footerCell = tableView.dequeueReusableCell(withIdentifier: "TotalCell") as? VouchersWishListTableViewCell
        }
        footerCell.frame = fView.frame
        fView.addSubview(footerCell)
        if(footerCell != nil)
        {
            updateTotal()
        }
        return fView
    }
    
    
    //unc tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //        let notificationDetailVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationDetailViewController) as! NotificationDetailViewController
        //        notificationDetailVC.notification = arr_notification[indexPath.row]
        //        self.navigationController?.pushViewController(notificationDetailVC, animated: true)
    }
    
}

class VouchersWishListTableViewCell: UITableViewCell
{
    static let identifier = "VouchersCell"
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var img_icon: UIImageView!
    @IBOutlet weak var btn_delete: UIButton!
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var view_stepper: UIStepperController!
    @IBOutlet weak var lbl_total: UILabel!
    
    //var heartIcon:LOTAnimationView!
    //var heartIcon:LOTAnimatedSwitch!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override public func layoutSubviews()
    {
        super.layoutSubviews()
        view_bg.setShadow()
    }
    
    
}
