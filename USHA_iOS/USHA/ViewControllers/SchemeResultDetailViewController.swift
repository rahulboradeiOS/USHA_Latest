//
//  SchemeResultDetailViewController.swift
 
//
//  Created by Apple.Inc on 07/12/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit

class SchemeResultDetailViewController: BaseViewController {

    @IBOutlet weak var tableView_SchemeResult: UITableView!

    var arr_SchemeResult = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView_SchemeResult.delegate = self
        tableView_SchemeResult.dataSource = self
        tableView_SchemeResult.sectionHeaderHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
    }
    
    override func onBackButtonPressed(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_download(_ sender: UIButton) {
        
        if (Connectivity.isConnectedToInternet())
        {
            if let url = URL(string: scheme_result_url)
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:])
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(url)
                }
            }
        }
        else
        {
            showAlert(msg: "noInternetConnection_SCEHEMERESULT_DOWNLOAD".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
    }
    
    override func viewWillDisappear(_ animated : Bool)
    {
        super.viewWillDisappear(animated)
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
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

extension SchemeResultDetailViewController: UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arr_SchemeResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SchemeReslutTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
    
        let result = arr_SchemeResult[indexPath.row]
        cell.lbl_mobile.text = result["Mobileno"] as? String
        cell.lbl_fullName.text = result["FullName"] as? String
        cell.lbl_BusinessName.text = result["BusinessName"] as? String
        cell.lbl_BranchName.text = result["BranchName"] as? String
        if let point = result["Net_Sampark_Point_Under_STB_Scheme"] as? Double
        {
            cell.lbl_totRedPoint.text = "\(point)"
        }
        return cell
    }
    
    /* func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
     let headerView = UIView()
     let headerCell = tableView.dequeueReusableCell(withIdentifier: "hcell") as! SchemeReslutTableViewCell
     headerCell.frame = CGRect(x: headerCell.frame.origin.x, y: headerCell.frame.origin.y, width: tableView.frame.size.width, height: 58)
     
     headerCell.lbl_month.text = "MONTH"
     headerCell.lbl_accumulation.text = "ACCUMULATION"
     headerCell.lbl_redemption.text = "REDEMPTION"
     
     //        let font = UIFont.systemFont(ofSize: 13, weight: .medium)
     //        headerCell.lbl_month.font = font
     //        headerCell.lbl_accumulation.font = font
     //        headerCell.lbl_redemption.font = font
     
     headerCell.lbl_totAcc.text = "\(totAcc)"
     headerCell.lbl_totRed.text = "\(totRed)"
     
     
     headerView.addSubview(headerCell)
     return headerView
     }*/
    
    /*func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        //        let headerCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SchemeReslutTableViewCell
        //        headerCell.frame = CGRect(x: headerCell.frame.origin.x, y: headerCell.frame.origin.y, width: headerCell.frame.size.width, height: 32)
        //
        //        headerCell.lbl_month.text = "TOTAL"
        //        headerCell.lbl_accumulation.text = "\(totAcc)"
        //        headerCell.lbl_redemption.text = "\(totRed)"
        //
        //        let font = UIFont.systemFont(ofSize: 13, weight: .medium)
        //        headerCell.lbl_month.font = font
        //        headerCell.lbl_accumulation.font = font
        //        headerCell.lbl_redemption.font = font
        //        headerCell.backgroundColor = #colorLiteral(red: 0.2117647059, green: 0.4745098039, blue: 0.7568627451, alpha: 1)
        //        headerView.addSubview(headerCell)
        return headerView
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    /*    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
     {
     return 58
     }*/
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 1
    }
}

class SchemeReslutTableViewCell : UITableViewCell
{
    @IBOutlet weak var lbl_mobile: UILabel!
    @IBOutlet weak var lbl_fullName: UILabel!
    @IBOutlet weak var lbl_BusinessName: UILabel!
    @IBOutlet weak var lbl_BranchName: UILabel!
    @IBOutlet weak var lbl_totRedPoint: UILabel!
}
