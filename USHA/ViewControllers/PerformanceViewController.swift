//
//  PerformanceViewController.swift
 
//
//  Created by Apple.Inc on 28/05/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit

class PerformanceViewController: BaseViewController {

    @IBOutlet weak var collectionView_performance: UICollectionView!
    @IBOutlet weak var lbl_lastSuncDate: UILabel!
    @IBOutlet weak var lbl_performanceOfTheMonth: UILabel!
    
    @IBOutlet weak var schemeWiseResults: UILabel!
    @IBOutlet weak var lblLastMonth: UILabel!

//    var arr_performanceMenu = [["img": "d_accum", "title": "ACCUMULATION", "points":"0.0"], ["img": "d_redeem.png", "title": "REDEMPTION", "points":"0.0"], ["img": "d_secondarySale", "title": "SAMPARK SALES", "points":"0.0"], ["img": "d_dmsbilling", "title": "DISTRIBUTOR BILLING", "points":"0.0"]]
    
     var arr_performanceMenu = [["img": "save.png", "title": "Accumulation", "points":"0.0"], ["img": "hand.png", "title": "Redeemption", "points":"0.0"], ["img": "hand_1.png", "title": " Sales ", "points":"0.0"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        menuItem()
        
        collectionView_performance.delegate = self
        collectionView_performance.dataSource = self
        
        var lastSyncDate : String = ""
        
        let pref =  UserDefaults.standard
        if let date = pref.string(forKey: defaultsKeys.lastDashboardSyncDate) {
            lastSyncDate = date
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let d = dateFormatter.date(from: lastSyncDate)
        {
            let date = Calendar.current.date(byAdding: .day, value: -1, to: d)

            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dstr = dateFormatter.string(from: date!)
            lbl_lastSuncDate.text = "( * Figure Up to \(dstr) )".uppercased()
        }
        else
        {
            let date = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dstr = dateFormatter.string(from: date!)
            lbl_lastSuncDate.text = "* Figure Up to \(dstr)".uppercased()
        }
        
                  let date = Calendar.current.date(byAdding: .month, value: -1, to: Date())
                   dateFormatter.dateFormat = "MMM yyyy"
                   let dstr = dateFormatter.string(from: date!)
                   lblLastMonth.text = " \(dstr) "
        
        self.getAccumulationFromDB()
    }
    
    @IBAction func onBackBttnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getAccumulationFromDB()
    {
        guard let db = DataProvider.getDBConnection() else {
            print("Error db path")
            return
        }
        
        var startInterVal : TimeInterval = 0
        var endInterVal : TimeInterval = 0
        
        let startOfMonth = Date().startOfMonth()
        let newDateS = startOfMonth!.getGMTDate()
        startInterVal = newDateS.timeIntervalSince1970
        
        let lastOfMonth = startOfMonth?.lastDayOfMonth()
        let newDateE = lastOfMonth!.getGMTDate()
        endInterVal = newDateE.timeIntervalSince1970
        
        db.trace { (error) in
            print("trace error")
            print(error)
        }
        do {
            
            var accumulationPoints = 0.0
            var secondarySalesValues = 0.0
            var redemptionPoints = 0.0
            
            var lastSyncDate : String = ""

            let pref =  UserDefaults.standard
            if let date = pref.string(forKey: defaultsKeys.lastDashboardSyncDate) {
                lastSyncDate = date
            }
            
            var d_AccRedDate_str = ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let d = dateFormatter.date(from: lastSyncDate)
            {
                let date = Calendar.current.date(byAdding: .day, value: -1, to: d)
                dateFormatter.dateFormat = "yyyy-MM"

                d_AccRedDate_str = dateFormatter.string(from: date!)
            }
            
            //let acc_query = String(format: "select sum(d_Points) from DASHBOARD where accRedDateTimeStamp >= %.0f and accRedDateTimeStamp < %.0f and s_Type = 'ACC'", startInterVal, endInterVal)
            
            let acc_query = String(format: "select sum(d_Points) from DASHBOARD where d_AccRedDate like'%@%@%@' and s_Type = 'ACC'","%",d_AccRedDate_str,"%")

            let rowAccQ = try db.prepare(acc_query)
            for row in rowAccQ
            {
                if let points = row[0] as? Double  {
                    accumulationPoints = points
                }
            }
            arr_performanceMenu[0]["points"] = "\(accumulationPoints)"

            
            //let red_query = String(format: "select sum(d_Points)  from DASHBOARD where accRedDateTimeStamp >= %.0f and accRedDateTimeStamp < %.0f and s_Type = 'RED'", startInterVal, endInterVal)
            
            let red_query = String(format: "select sum(d_Points) from DASHBOARD where d_AccRedDate like'%@%@%@' and s_Type = 'RED'","%",d_AccRedDate_str,"%")

            let rowRedQ = try db.prepare(red_query)
            for row in  rowRedQ
            {
                if let points = row[0] as? Double {
                    redemptionPoints = points
                }
            }
            arr_performanceMenu[1]["points"] = "\(redemptionPoints)"

            //let sale_query = String(format: "select sum(d_SalesValue) from DASHBOARD where accRedDateTimeStamp >= %.0f and accRedDateTimeStamp < %.0f and s_Type = 'ACC'", startInterVal, endInterVal)

            let sale_query = String(format: "select sum(d_SalesValue) from DASHBOARD where d_AccRedDate like'%@%@%@' and s_Type = 'ACC'","%",d_AccRedDate_str,"%")

            let rowSaleQ = try db.prepare(sale_query)
            for row in rowSaleQ
            {
                if let values = row[0] as? Double {
                    secondarySalesValues = values
                }
            }
            arr_performanceMenu[2]["points"] = "\(secondarySalesValues)"

            print("accumulationPoints = \(accumulationPoints)")
            print("secondarySalesValues = \(secondarySalesValues)")
            print("redemptionPoints = \(redemptionPoints)")
            
        } catch  {
            print("error query")
            print("Error info: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UICollectionViewDataSource
extension PerformanceViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arr_performanceMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1",
                                                      for: indexPath) as! DashboardCollectionViewCell
        
        
        let titleDic = arr_performanceMenu[indexPath.item]
        
        let title = titleDic["title"]
        cell.lbl_title.text = "\(title!)"
        
        if indexPath.item == 0
        {
          //  cell.lbl_title.textColor = UIColor.init(hex: "2e8f15")
        }
        else if indexPath.item == 1
        {
            //cell.lbl_title.textColor = UIColor.init(hex: "075c6b")
        }
        else
        {
          //  cell.lbl_title.textColor = UIColor.init(hex: "c13c0c")
            cell.lbl_value.text = "Value"
        }
        
        
        let img = titleDic["img"]
        
        cell.img_icon.image = UIImage.init(named: img!)
            //?.withRenderingMode(.alwaysTemplate)
//        cell.img_icon.tintColor = UIColor.black
        cell.lbl_points.text = titleDic["points"]
        return cell
    }
    
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
   {
//        if indexPath.section == 0
//        {
             let width = (collectionView.frame.size.width - 25) / 3
//            let height = (collectionView.frame.size.height - 24) / 6
            return CGSize(width: width, height: 135)
        }
//        let width = (collectionView.frame.size.width - 20)
//        let height = (collectionView.frame.size.height - 32) / 4
//        return CGSize(width: width, height: height)
 //   }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        
//        if section == 0
//        {
//            return 8
//        }
//        return 0
//    }
}

// MARK: - UICollectionViewDelegate
extension PerformanceViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let calVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.CalenderViewController) as! CalenderViewController
            switch indexPath.row
            {
            case 0:
                calVC.field = "d_Points"
                 self.navigationController?.pushViewController(calVC, animated: true)
                break
            case 1:
                calVC.field = "RedemptionPoints"
                 self.navigationController?.pushViewController(calVC, animated: true)
                break
            case 2:
                calVC.field = "d_SalesValue"
                 self.navigationController?.pushViewController(calVC, animated: true)
                break
            case 3:
               // calVC.field = "d_SalesValue"
                
                let GalleryVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.DMSBillingViewController) as! DMSBillingViewController
                self.navigationController?.pushViewController(GalleryVC, animated: true)
                
                break
            default:
                break
            }
       

    }
}


extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
