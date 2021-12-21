//
//  AccumulationReportDetailController.swift
//  DemoApp
//
//  Created by omkar khandekar on 07/11/17.
//  Copyright © 2017 omkar khandekar. All rights reserved.
//

import UIKit

class AccumulationReportDetailController: BaseViewController
{
    @IBOutlet weak var selectionDetailLabel: UILabel!
    @IBOutlet weak var reportTableView: UITableView!
    @IBOutlet weak var lbl_TotalPoints: UILabel!
    @IBOutlet weak var view_RedStrip: UIView!
    
    var accumulationArray :[Dashboard]?
    
    var startDate : Date?
    var endDate : Date?
    var from_Date:Date?
    var persistanceClass = DataProvider.sharedInstance
    var field :String!
    var totalPoints :String = ""
    let dateFormatter = DateFormatter()
    var isMonthMode : Bool = false
    var isYearContinueMode : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        print(totalPoints)
        
        reportTableView.delegate = self
        reportTableView.dataSource = self
        
        let bundle = Bundle(for: AccumulationReportMonthTableViewCell.self)
        self.reportTableView.register(UINib(nibName: "AccumulationReportMonthTableViewCell", bundle: bundle), forCellReuseIdentifier: "month")
        
        let bundle2 = Bundle(for: AccumulationReportYearTableViewCell.self)
        self.reportTableView.register(UINib(nibName: "AccumulationReportYearTableViewCell", bundle: bundle2), forCellReuseIdentifier: "year")
        
        reportTableView.separatorStyle = .singleLine
        reportTableView.separatorColor = .gray
        
        self.lbl_TotalPoints.text = "TOTAL : \(totalPoints)"
//        print("startDate : \(startDate!)")
//        print("endDate : \(endDate!)")
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let currentField = field  else { return }
        
        if let items = self.accumulationArray
        {
            if isMonthMode
            {
                if isYearContinueMode
                {
                    dateFormatter.dateFormat = "MMM yyyy"
                    let month = dateFormatter.string(from: self.from_Date!)

                    if items.count == 0
                    {
                        switch currentField
                        {
                        case "d_Points":
                            selectionDetailLabel.text = String(format: "Accumulation Summary :- %@".uppercased(), month.uppercased())
                            selectionDetailLabel.textColor = UIColor.init(hex: "e30613")
                            break
                        case "d_SalesValue" :
                            selectionDetailLabel.text = String(format: "Secondary Sales Summary :- %@".uppercased(), month.uppercased())
                            selectionDetailLabel.textColor = UIColor.init(hex: "c13c0c")
                            break
                        case "RedemptionPoints" :
                            selectionDetailLabel.text = String(format: "Redemption Summary : - %@".uppercased(), month.uppercased())
                            selectionDetailLabel.textColor = UIColor.init(hex: "075c6b")
                            break
                        default:
                            break
                        }
                       return
                    }
                    
                    let item = items[0]
                    switch currentField
                    {
                    case "d_Points":
                        selectionDetailLabel.text = String(format: "Accumulation Summary :- %@".uppercased(), month.uppercased())
                        selectionDetailLabel.textColor = UIColor.init(hex: "e30613")
                        break
                    case "d_SalesValue" :
                        selectionDetailLabel.text = String(format: "Secondary Sales Summary  :- %@".uppercased(), month.uppercased())
                        selectionDetailLabel.textColor = UIColor.init(hex: "c13c0c")
                        break
                    case "RedemptionPoints" :
                        selectionDetailLabel.text = String(format: "Redemption Summary :- %@".uppercased(), month.uppercased())
                        selectionDetailLabel.textColor = UIColor.init(hex: "075c6b")
                        break
                    default:
                        break
                    }
                }
                else
                {
                    dateFormatter.dateFormat = "dd MMM yyyy"
                    let month = dateFormatter.string(from: self.from_Date!)

                    var totalPoints = 0.0
                    for item in items
                    {
                        totalPoints = totalPoints + item.d_Points!
                    }
                    let totalPointStr = String(format: "%.01f", totalPoints)

                    switch currentField
                    {
                    case "d_Points":
                        selectionDetailLabel.text = String(format: "Accumulation of :- %@".uppercased(), month.uppercased(), totalPointStr)
                        selectionDetailLabel.textColor = UIColor.init(hex: "e30613")
                        break
                    case "d_SalesValue" :
                        selectionDetailLabel.text = String(format: "Secondry sales of :- %@".uppercased(), month.uppercased(), totalPointStr)
                        selectionDetailLabel.textColor = UIColor.init(hex: "c13c0c")
                        break
                    case "RedemptionPoints" :
                        selectionDetailLabel.text = String(format: "Redemption of :- %@".uppercased(), month.uppercased(), totalPointStr)
                        selectionDetailLabel.textColor = UIColor.init(hex: "075c6b")
                        view_RedStrip.isHidden = true
                        break
                    default:
                        break
                    }
                }
            }
            else
            {
                dateFormatter.dateFormat = "MMM yyyy"
                let month = dateFormatter.string(from: self.from_Date!)

                switch currentField
                {
                case "d_Points":
                    selectionDetailLabel.text = String(format: "Accumulation Summary :- %@".uppercased(), month.uppercased())
                    selectionDetailLabel.textColor = UIColor.init(hex: "e30613")
                    break
                case "d_SalesValue" :
                    selectionDetailLabel.text = String(format: "Secondary Sales Summary :- %@".uppercased(), month.uppercased())
                    selectionDetailLabel.textColor = UIColor.init(hex: "c13c0c")
                    break
                case "RedemptionPoints" :
                    selectionDetailLabel.text = String(format: "Redemption Summary:- %@".uppercased(), month.uppercased())
                    selectionDetailLabel.textColor = UIColor.init(hex: "075c6b")
                    view_RedStrip.isHidden = true

                    break
                default:
                    break
                }
            }
        }
    
        view_RedStrip.layer.cornerRadius = 12
        view_RedStrip.layer.masksToBounds = true
        
    }
    
    @IBAction func onBackBttnPressed(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
extension AccumulationReportDetailController : UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let items = self.accumulationArray
        {
            if items.count == 0
            {
                return 1
            }
            return items.count
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        headerView.backgroundColor = .white
        
        if (self.accumulationArray != nil)
        {
            if isMonthMode
            {
               
                    switch field
                    {
                    case "d_Points":
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "month") as? AccumulationReportMonthTableViewCell
                        {
                        cell.lbl_schmeName.text = "SCHEME"
                        cell.lbl_schmeName.font = UIFont.boldSystemFont(ofSize: 14.0)

                        cell.lbl_divsion.text = "DIVISION"
                        cell.lbl_divsion.font = UIFont.boldSystemFont(ofSize: 14.0)

                        cell.lbl_category.text = "CATEGORY"
                        cell.lbl_category.font = UIFont.boldSystemFont(ofSize: 14.0)

                        cell.lbl_Points.text = "POINTS"
                        cell.lbl_Points.font = UIFont.boldSystemFont(ofSize: 14.0)

                        headerView.frame.size.height = 44
                            
                            headerView.addSubview(cell)
                            cell.frame = headerView.frame
                            
                            view_RedStrip.isHidden = true
                        }
                       
                        break
                    case "d_SalesValue" :
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "month") as? AccumulationReportMonthTableViewCell
                        {
                        cell.lbl_schmeName.text = "SCHEME"
                        cell.lbl_divsion.text = "DIVISION"
                        cell.lbl_category.text = "CATEGORY"
                        cell.lbl_Points.text = "SECONDARY SALES"
                        
                        cell.lbl_schmeName.font = UIFont.boldSystemFont(ofSize: 14.0)
                        cell.lbl_divsion.font = UIFont.boldSystemFont(ofSize: 14.0)
                        cell.lbl_category.font = UIFont.boldSystemFont(ofSize: 14.0)
                        cell.lbl_Points.font = UIFont.boldSystemFont(ofSize: 14.0)
                        
                        headerView.frame.size.height = 55
                            
                            headerView.addSubview(cell)
                            cell.frame = headerView.frame
                            view_RedStrip.isHidden = true
                        }
                       
                        break
                    case "RedemptionPoints" :
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "year") as? AccumulationReportYearTableViewCell//AccumulationReportMonthTableViewCell
                        {
                 
                            cell.lbl_schemeName.text = "SCHEME"
                        cell.lbl_divsion.text = "PRODUCT"
                        //cell.lbl_category.text = "Category"
                        cell.lbl_Points.text = "POINTS"
                        
                            cell.lbl_schemeName.font = UIFont.boldSystemFont(ofSize: 14.0)
                        cell.lbl_divsion.font = UIFont.boldSystemFont(ofSize: 14.0)
                        //cell.lbl_category.font = UIFont.boldSystemFont(ofSize: 14.0)
                        cell.lbl_Points.font = UIFont.boldSystemFont(ofSize: 14.0)
                       
                            
                        headerView.frame.size.height = 44
                            
                            headerView.addSubview(cell)
                            cell.frame = headerView.frame
                            
                        }
                        break
                    default:
                        break
                    }
            }
            else
            {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "year") as? AccumulationReportYearTableViewCell
                {
                    
                    switch field
                    {
                    case "d_Points":
                        cell.lbl_schemeName.text = "SCHEME"
                        cell.lbl_divsion.text = "DIVISION"
                        //cell.lbl_category.text = "Category"
                        cell.lbl_Points.text = "POINTS"
                        
                        cell.lbl_schemeName.font = UIFont.boldSystemFont(ofSize: 14.0)
                        cell.lbl_divsion.font = UIFont.boldSystemFont(ofSize: 14.0)
                        //cell.lbl_category.font = UIFont.boldSystemFont(ofSize: 14.0)
                        cell.lbl_Points.font = UIFont.boldSystemFont(ofSize: 14.0)
                        
                        headerView.frame.size.height = 44
                        headerView.addSubview(cell)
                        cell.frame = headerView.frame
                        break
                    case "d_SalesValue" :
                        cell.lbl_schemeName.text = "SCHEME"
                        cell.lbl_divsion.text = "DIVISION"
                        //cell.lbl_category.text = "Category"
                        cell.lbl_Points.text = "SECONDARY SALES"
                        
                        cell.lbl_schemeName.font = UIFont.boldSystemFont(ofSize: 14.0)
                        cell.lbl_divsion.font = UIFont.boldSystemFont(ofSize: 14.0)
                        //cell.lbl_category.font = UIFont.boldSystemFont(ofSize: 14.0)
                        cell.lbl_Points.font = UIFont.boldSystemFont(ofSize: 14.0)
                        
                        headerView.frame.size.height = 55
                        headerView.addSubview(cell)
                        cell.frame = headerView.frame
                        break
                    case "RedemptionPoints" :
                        cell.lbl_schemeName.text = "SCHEME"
                        cell.lbl_divsion.text = "PRODUCT"
                        //cell.lbl_category.text = "Category"
                        cell.lbl_Points.text = "POINTS"
                        
                        cell.lbl_schemeName.font = UIFont.boldSystemFont(ofSize: 14.0)
                        cell.lbl_divsion.font = UIFont.boldSystemFont(ofSize: 14.0)
                        //cell.lbl_category.font = UIFont.boldSystemFont(ofSize: 14.0)
                        cell.lbl_Points.font = UIFont.boldSystemFont(ofSize: 14.0)
                        
                        headerView.frame.size.height = 44
                        headerView.addSubview(cell)
                        cell.frame = headerView.frame
                        break
                    default:
                        break
                    }
                    
                   
                }
            }
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let items = self.accumulationArray
        {
            if isMonthMode
            {
                switch field
                {
                case "d_Points":
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "month") as? AccumulationReportMonthTableViewCell
                    {
                        if items.count == 0
                        {
                            cell.lbl_schmeName.text = "NO SCHEME"
                            cell.lbl_divsion.text = "NO DIVISION"
                            cell.lbl_category.text =  "NO CATEGORY"
                            cell.lbl_Points.text = "0.0"
                            return cell
                        }
                        
                        let accumulation = items[indexPath.row]
                        
                        if let scheme = accumulation.s_SchemePromName
                        {
                            cell.lbl_schmeName.text = scheme
                        }
                        
                        if let division = accumulation.s_skuCategoryName {
                            cell.lbl_divsion.text = division
                        }
                        if let points = accumulation.d_Points {
                            cell.lbl_Points.text = String(format: "%.01f", points)
                        }
                        if let category = accumulation.s_skuSubCategoryName {
                            cell.lbl_category.text =  category
                        }
                        else
                        {
                            cell.lbl_category.text =  ""
                        }
                        cell.backgroundColor = UIColor.white
                        return cell
                    }
                    //break
                case "d_SalesValue" :
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "month") as? AccumulationReportMonthTableViewCell
                    {
                        if items.count == 0
                        {
                            cell.lbl_schmeName.text = "NO SCHEME"
                            cell.lbl_divsion.text = "NO DIVISION"
                            cell.lbl_category.text =  "NO CATEGORY"
                            cell.lbl_Points.text = "0.0"
                            return cell
                        }
                        
                        let accumulation = items[indexPath.row]
                        
                        if let scheme = accumulation.s_SchemePromName
                        {
                            cell.lbl_schmeName.text = scheme
                        }
                        
                        if let division = accumulation.s_skuCategoryName {
                            cell.lbl_divsion.text = division
                        }
                        if let points = accumulation.d_Points {
                            cell.lbl_Points.text = String(format: "%.01f", points)
                        }
                        if let category = accumulation.s_skuSubCategoryName {
                            cell.lbl_category.text =  category
                        }
                        else
                        {
                            cell.lbl_category.text =  ""
                        }
                        cell.backgroundColor = UIColor.white
                        return cell
                    }
                    //break
                case "RedemptionPoints" :
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "year") as? AccumulationReportYearTableViewCell
                    {
                        if items.count == 0
                        {
                            cell.lbl_divsion.text = "NO SCHEME"
                            cell.lbl_divsion.text = "NO DIVISION"
                            //                        cell.lbl_category.text =  "No Category"
                            cell.lbl_Points.text = "0.0"
                            
                            return cell
                        }
                        
                        let accumulation = items[indexPath.row]
                        
                        if let scheme = accumulation.s_SchemePromName {
                            cell.lbl_schemeName.text = scheme
                        }
                        
                        if let division = accumulation.s_skuCategoryName {
                            cell.lbl_divsion.text = division
                        }
                        
                        //                    if let s_skuSubCategoryName = accumulation.s_skuSubCategoryName {
                        //                        cell.lbl_category.text = s_skuSubCategoryName
                        //                    }
                        
                        if let points = accumulation.d_Points {
                            cell.lbl_Points.text = String(format: "%.01f", points)
                        }
                        cell.backgroundColor = UIColor.white
                        return cell
                    }
                   // break
                default:
                    break
                }
            }
            else
            {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "year") as? AccumulationReportYearTableViewCell
                {
                    if items.count == 0
                    {
                        cell.lbl_divsion.text = "NO SCHEME"
                        cell.lbl_divsion.text = "NO DIVISION"
//                        cell.lbl_category.text =  "No Category"
                        cell.lbl_Points.text = "0.0"

                        return cell
                    }

                    let accumulation = items[indexPath.row]

                    if let scheme = accumulation.s_SchemePromName {
                        cell.lbl_schemeName.text = scheme
                    }
                    
                    if let division = accumulation.s_skuCategoryName {
                        cell.lbl_divsion.text = division
                    }
                    
//                    if let s_skuSubCategoryName = accumulation.s_skuSubCategoryName {
//                        cell.lbl_category.text = s_skuSubCategoryName
//                    }
                    
                    if let points = accumulation.d_Points {
                        cell.lbl_Points.text = String(format: "%.01f", points)
                    }
                    
                    cell.backgroundColor = UIColor.white
                    return cell
                }
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let items = self.accumulationArray
        {
            if items.count == 0
            {
                return
            }
            
            if isMonthMode
            {
                return
            }
            else
            {
                if (field == "RedemptionPoints")
                {
                    return
                }
                else
                {
                    let controller = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.AccumulationReportDetailController) as! AccumulationReportDetailController
                    controller.isMonthMode = true
                    controller.isYearContinueMode = true
                    controller.startDate = self.startDate
                    controller.endDate = self.endDate
                    controller.field = self.field
                    controller.totalPoints = "\(items[indexPath.row].d_Points!)"
                    controller.from_Date = self.from_Date
                    if items.count == 0
                    {
                        controller.accumulationArray = [Dashboard]()
                    }
                    else
                    {
                        let accumulation = items[indexPath.row]
                        let array = getAccumulation(filter: accumulation)
                        controller.accumulationArray = array
                    }
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if (self.accumulationArray != nil)
        {
            if isMonthMode
            {
                switch field
                {
                case "d_Points":
                     return 44
                case "d_SalesValue" :
                     return 44
                case "RedemptionPoints" :
                     return 44
                default:
                    break
                }
            }
            else
            {
            }
        }
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }

    func getAccumulation(filter : Dashboard)->[Dashboard]
    {
        var accumulationArray = [Dashboard]()
        guard let db = DataProvider.getDBConnection() else { return [] }
        
        var startInterVal : TimeInterval = 0
        var endInterVal : TimeInterval = 0
        
        
        if let start = self.startDate {
            startInterVal = start.timeIntervalSince1970
        }
        
        
        if let end = self.endDate {
            endInterVal = end.timeIntervalSince1970
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        var d_AccRedDate_str = "" //= dateFormatter.string(from: date)
        
//        if (isMonthMode)
//        {
            dateFormatter.dateFormat = "yyyy-MM"
            d_AccRedDate_str = dateFormatter.string(from: from_Date!)
            print("d_AccRedDate_str = \(d_AccRedDate_str)")

            
//        }
//        else
//        {
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            d_AccRedDate_str = dateFormatter.string(from: self.startDate!)
//            print("d_AccRedDate_str = \(d_AccRedDate_str)")
//
//        }
        
        db.trace { (error) in
            print(error)
        }
        do {
            
            guard let currentField = field  else { return  [] }
            
            var  query = ""
            
            switch currentField
            {
            case "d_Points":
                query = String(format: "select round(sum(d_Points)),s_skuCategoryName,s_skuSubCategoryName,s_SchemePromName,d_AccRedDate from DASHBOARD where d_AccRedDate like'%@%@%@' and s_Type = 'ACC' and s_skuCategoryName = '%@' and s_SchemePromName = '%@' group by s_skuSubCategoryName","%",d_AccRedDate_str,"%",filter.s_skuCategoryName!, filter.s_SchemePromName!)

                break
            case "d_SalesValue" :
                query = String(format: "select round(sum(d_SalesValue)), s_skuCategoryName, s_skuSubCategoryName, s_SchemePromName from DASHBOARD where d_AccRedDate like'%@%@%@' and s_skuCategoryName = '%@' and s_SchemePromName = '%@' and s_Type = 'ACC' group by s_skuSubCategoryName", "%",d_AccRedDate_str,"%",filter.s_skuCategoryName!, filter.s_SchemePromName!)
                break
            case "RedemptionPoints" :
                query = String(format: "select d_Points, s_skuCategoryName, s_skuSubCategoryName, s_SchemePromName from DASHBOARD where d_AccRedDate like'%@%@%@' and s_Type = 'RED' and s_skuCategoryName = '%@' and s_SchemePromName = '%@'", startInterVal, endInterVal, filter.s_skuCategoryName!, filter.s_SchemePromName!)
                break
            default:
                break
            }
           
            for row in try db.prepare(query) {
                let currentAccumulation = Dashboard()

                if let AccumulationPoints = row[0] as? Double  {
                    currentAccumulation.d_Points = AccumulationPoints
                }
                if let ProductDivision = row[1] as? String  {
                    currentAccumulation.s_skuCategoryName = ProductDivision
                }
                
                if let ProductCategory = row[2] as? String  {
                    currentAccumulation.s_skuSubCategoryName = ProductCategory
                }
               
                if let s_SchemePromName = row[3] as? String  {
                    currentAccumulation.s_SchemePromName = s_SchemePromName
                }
                
                accumulationArray.append(currentAccumulation)
                
            }
            return accumulationArray
            
        } catch  {
            print("error DB Insert")
        }
        return []
    }
}


