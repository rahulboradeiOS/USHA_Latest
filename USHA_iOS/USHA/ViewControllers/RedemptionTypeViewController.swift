//
//  RedemptionTypeViewController.swift
//  ELECTRICIAN
//
//  Created by Apple.Inc on 30/11/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit

class RedemptionTypeViewController: BaseViewController
{

    @IBOutlet weak var balanceView: BalanceView!
    @IBOutlet weak var balanceView_height: NSLayoutConstraint!
    
    @IBOutlet weak var view_vouchers: UIView!
    @IBOutlet weak var view_Recharge: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view_vouchers.setShadow()
        view_Recharge.setShadow()
    }
        
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.configBalanceView()
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
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btn_Voucher_pressed(_ sender: Any)
    {
        if Connectivity.isConnectedToInternet()
        {
            goToVouchers()
        }
        else
        {
            showAlert(msg: "noInternetConnection_REDEEMVOUCHER".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
        
    }
    
    @IBAction func btn_recharge_pressed(_ sender: Any)
    {
        if Connectivity.isConnectedToInternet()
        {
            goToRecharge()
        }
        else
        {
            showAlert(msg: "noInternetConnection_MOBILETOPUP".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
        
    }
    
    @IBAction func btn_bankTransfer_pressed(_ sender: Any)
    {
        if Connectivity.isConnectedToInternet()
        {
            goToREDEMPTION()
        }
        else
        {
            showAlert(msg: "noInternetConnection_BANKTRANSFER".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
        
    }
    
    func goToVouchers()
    {
        let acc = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.VouchersViewController)
        self.navigationController?.pushViewController(acc, animated: true)
    }
    
    func goToRecharge()
    {
        let acc = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.RechargeViewController)
        self.navigationController?.pushViewController(acc, animated: true)
    }
    
    func goToREDEMPTION()
    {
        let acc = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.RedeemtionViewController)
        self.navigationController?.pushViewController(acc, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
