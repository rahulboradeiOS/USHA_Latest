//
//  CalenderViewController.swift
 
//
//  Created by Apple.Inc on 29/05/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import DropDown
import SQLite
class CalenderViewController: BaseViewController {

    @IBOutlet weak var collectionView_calender: UICollectionView!

    @IBOutlet weak var view_calender_header: UIView!
    @IBOutlet weak var view_month: UIView!
    
    @IBOutlet weak var lbl_Title: UILabel!
    
    @IBOutlet weak var btn_year: UIButton!
    @IBOutlet weak var lbl_year_line: UILabel!
    @IBOutlet weak var view_year: UIView!
    @IBOutlet weak var btn_select_month: UIButton!
    @IBOutlet weak var lbl_selected_month: UILabel!
    @IBOutlet weak var btn_select_year: UIButton!
    @IBOutlet weak var lbl_selected_year: UILabel!
    @IBOutlet weak var lbl_year: UILabel!
    
    @IBOutlet weak var btn_yearWise_selectYear: UIButton!
    @IBOutlet weak var btn_previous: UIButton!
    
    @IBOutlet weak var btn_next: UIButton!
    @IBOutlet weak var btn_month: UIButton!
    @IBOutlet weak var lbl_month_line: UILabel!
    
    @IBOutlet weak var view_selectMonth: UIView!
    @IBOutlet weak var view_selectYear: UIView!
    
    var isMonth = false
    var isYear = false
    var yearMonthValue : String = ""
    
  
    let months = Calendar.current.shortMonthSymbols
    let currentMonthInt = Calendar.current.component(.month, from: Date())
    let currentYearInt = Calendar.current.component(.year, from: Date())
    var years:[String] = []
    
    var selectedMonth:Int = 0
    var selectedYear:Int = 0
    
    var yearWiseSelectedYear:Int = 0

    var selectedMonthName:String!
    
    let dropDown = DropDown()

    var dashbordArray = [Dashboard]()

    var field:String!
    
//    var changedDate = Date()
//    var currentDate  = Date()

    var startDate:Date!
    var endDate:Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView_calender.delegate = self
        collectionView_calender.dataSource = self
        
        isYear = true
        viewStateChange()
        
        //years = (currentYearInt-10...currentYearInt+10).map { String($0) }
        
        years = (currentYearInt-2...currentYearInt).map { String($0) }

        
        selectedMonth = currentMonthInt
        selectedYear = currentYearInt
        yearWiseSelectedYear = currentYearInt
        
        selectedMonthName = months[currentMonthInt - 1]
        
        lbl_selected_month.text = months[currentMonthInt - 1]
        lbl_selected_year.text = "\(currentYearInt)"
        lbl_year.text = "\(yearWiseSelectedYear)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView_calender.reloadData()
    }
    
    @IBAction func onBackBttnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupDropDown(type:Int, dataSource:[String], view:UIView)
    {
        dropDown.dismissMode = .automatic
        dropDown.tag = type
        dropDown.width = view.frame.size.width
        dropDown.bottomOffset = CGPoint(x: 0, y: view.bounds.height - 10)
        dropDown.anchorView = view
        dropDown.direction = .bottom
        dropDown.cellHeight = 40
        dropDown.backgroundColor = .white
        dropDown.dataSource = dataSource
        dropDown.show()
        // Action triggered on selection
        dropDown.selectionAction = {(index, item) in
            if type == 0
            {
                self.selectedMonth = index+1
                self.lbl_selected_month.text = item
            }
            else if type == 1
            {
                self.selectedYear = Int(item)!
                self.lbl_selected_year.text = item
            }
            else
            {
                self.yearWiseSelectedYear = Int(item)!
                self.lbl_year.text = item
            }
            
            self.collectionView_calender.reloadData()
        }
    }

    func viewStateChange()
    {
        if isYear
        {
            yearMonthValue = "BY YEAR"
            
            isMonth = false
            btn_month.setTitleColor(UIColor.gray, for: .normal)
            lbl_month_line.backgroundColor = UIColor.gray
            btn_month.backgroundColor = UIColor.white
            btn_year.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            btn_year.backgroundColor = UIColor(red: 54/255, green: 180/255, blue: 63/255, alpha: 1.0)
            lbl_year_line.backgroundColor = #colorLiteral(red: 0.9253342748, green: 0.1854941547, blue: 0.2087527215, alpha: 1)
            
            view_year.isHidden = false
            view_month.isHidden = true
        }
        else if isMonth
        {
            yearMonthValue = "BY MONTH"
            isYear = false
            btn_year.setTitleColor(UIColor.gray, for: .normal)
            lbl_year_line.backgroundColor = UIColor.gray
            
            btn_month.backgroundColor = UIColor(red: 54/255, green: 180/255, blue: 63/255, alpha: 1.0)
            btn_year.backgroundColor = UIColor.white

            btn_month.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            lbl_month_line.backgroundColor = #colorLiteral(red: 0.9253342748, green: 0.1854941547, blue: 0.2087527215, alpha: 1)
            
            view_month.isHidden = false
            view_year.isHidden = true
        }
        collectionView_calender.reloadData()
    }
    
    @IBAction func btn_year_pressed(_ sender: UIButton)
    {
        isMonth = false
        isYear = true
        viewStateChange()
    }
    
    @IBAction func btn_month_pressed(_ sender: UIButton)
    {
        isYear = false
        isMonth = true
        viewStateChange()
    }
    
    
    @IBAction func btn_selectMonth_pressed(_ sender: UIButton)
    {
        dropDown.hide()
        setupDropDown(type: 0, dataSource: months, view: view_selectMonth)
    }
    
    @IBAction func btn_selectYear_pressed(_ sender: UIButton)
    {
        dropDown.hide()
        setupDropDown(type: 1, dataSource: years, view: view_selectYear)
    }
    
    @IBAction func btn_selectYearWised_pressed(_ sender: UIButton)
    {
        dropDown.hide()
        setupDropDown(type: 2, dataSource: years, view: sender)
    }
    
    @IBAction func btn_previous_pressed(_ sender: UIButton)
    {
        if (yearWiseSelectedYear == currentYearInt-3)
        {
            return
        }
        else
        {
            yearWiseSelectedYear = yearWiseSelectedYear - 1
            lbl_year.text = "\(yearWiseSelectedYear)"
        }
        collectionView_calender.reloadData()
    }
    
    @IBAction func btn_next_pressed(_ sender: UIButton)
    {
        if (yearWiseSelectedYear == currentYearInt)
        {
            return
        }
        else
        {
            yearWiseSelectedYear = yearWiseSelectedYear + 1
            lbl_year.text = "\(yearWiseSelectedYear)"
        }
        collectionView_calender.reloadData()
    }
    
    
    func dateFrom(day:Int, month:Int, year:Int) -> Date
    {
        let calendar = Calendar.current
        
        var startComps = DateComponents()
        startComps.day = day
        startComps.month = month
        startComps.year = year
        
        let date = calendar.date(from: startComps)
        return date!
    }
    
    func getDaysInMonth(month: Int, year: Int) -> Int
    {
        let calendar = Calendar.current
        
        var startComps = DateComponents()
        startComps.day = 1
        startComps.month = month
        startComps.year = year
        
        var endComps = DateComponents()
        endComps.day = 1
        endComps.month = month == 12 ? 1 : month + 1
        endComps.year = month == 12 ? year + 1 : year
        
        let startDate = calendar.date(from: startComps)
        //dateFromComponents(startComps)!
        let endDate = calendar.date(from: endComps)
        //dateFromComponents(endComps)!
        
        let diff = calendar.dateComponents([.day], from: startDate!, to: endDate!)
        
        //components(NSCalendar.Unit.Day, fromDate: startDate, toDate: endDate, options: NSCalendar.Options.MatchFirst)
        
        return diff.day!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getAccumulation(forDate date: Date, isMonth : Bool)-> (Double, [Dashboard])
    {
        var startInterVal : TimeInterval = 0
        var endInterVal : TimeInterval = 0
      
        let newDate = date.getGMTDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        var d_AccRedDate_str = "" //= dateFormatter.string(from: date)
        
        if (isMonth)
        {
            let startOfMonth = newDate.startOfMonth()
            let newDateS = startOfMonth!.getGMTDate()
            startInterVal = newDateS.timeIntervalSince1970
            startDate = newDateS
            
            let lastOfMonth = startOfMonth?.lastDayOfMonth()
            //let newDateE = lastOfMonth!.getGMTDate()
            endDate = lastOfMonth
            
            endInterVal = lastOfMonth!.timeIntervalSince1970
            
            dateFormatter.dateFormat = "yyyy-MM"
            d_AccRedDate_str = dateFormatter.string(from: date)
            print("d_AccRedDate_str = \(d_AccRedDate_str)")
            
        }
        else
        {
            let startOfday = newDate.startOfDay
            let newDateS = startOfday.getGMTDate()
            startDate = newDateS
            
            startInterVal = newDateS.timeIntervalSince1970
            
            let endOfDay = startOfday.endOfDay
            let newDateE = endOfDay!.getGMTDate()
            endDate = newDateE
            
            endInterVal = newDateE.timeIntervalSince1970
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            d_AccRedDate_str = dateFormatter.string(from: date)
            print("d_AccRedDate_str = \(d_AccRedDate_str)")
        }

        if let db = DataProvider.getDBConnection()
        {
            db.trace { (error) in
                print("trace error")
                print(error)
            }
            do {
                if let currentField = field
                {
                    var  query = ""
                    
                    switch currentField
                    {
                    case "d_Points":
//                        query = String(format: "select sum(d_Points), s_skuCategoryName, s_skuSubCategoryName, s_SchemePromName, d_AccRedDate from DASHBOARD where accRedDateTimeStamp >= %.0f and accRedDateTimeStamp < %.0f and s_Type = 'ACC' group by  s_skuCategoryName,s_SchemePromName", startInterVal,endInterVal)
                        
                       // let alice = tblDashboard.filter(c_d_AccRedDate.like("%\(d_AccRedDate_str)%"))
                        
                       // let c_s_Type_ = Expression<String>(DashboardKey.s_Type)
                       // let al = alice.filter(c_s_Type_ == "ACC")
//                        for row in try db.prepare(alice)
//                        {
//                            print("c_d_Points = \(row[c_d_Points])\nc_d_Points = \(row[c_d_Points])")
//                        }
                        
                        lbl_Title.text = "ACCUMULATION SUMMARY \(yearMonthValue)"
                        
                        query = String(format: "select round(sum(d_Points)) from DASHBOARD where d_AccRedDate like'%@%@%@' and s_Type = 'ACC'","%",d_AccRedDate_str,"%")
//                         query = String(format: "select round(sum(d_Points)),s_skuCategoryName,s_skuSubCategoryName,s_SchemePromName,d_AccRedDate from DASHBOARD where d_AccRedDate like'%@%@%@' and s_Type = 'ACC' group by  s_skuCategoryName,s_SchemePromName","%",d_AccRedDate_str,"%")

                    case "d_SalesValue" :
                        
//                        curCSV = sqldb.rawQuery("select round(sum(points),0) from "+ DBhelper.Table_Demo1 +" where red_date like'%"+date+"%'",null);

//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "yyyy-MM"
//                        let d_AccRedDate_str = dateFormatter.string(from: date)

                       // let date_str = "
                        lbl_Title.text = "SECONDARY SALES SUMMARY \(yearMonthValue)"
                        query = String(format: "select round(sum(d_SalesValue)) from DASHBOARD where d_AccRedDate like'%@%@%@' and s_Type = 'ACC'","%",d_AccRedDate_str,"%")

                        
//                         query = String(format: "select round(sum(d_SalesValue)),s_skuCategoryName,s_skuSubCategoryName,s_SchemePromName,d_AccRedDate from DASHBOARD where d_AccRedDate like'%@%@%@' and s_Type = 'ACC' group by  s_skuCategoryName,s_SchemePromName","%",d_AccRedDate_str,"%")
//
//                        print("qquery = \(qquery)")
//                        for row in try db.prepare(qquery)
//                        {
//                            if let points = row[0] //as? Double
//                            {
//                                print("points = \(points)")
//                            }
//                        }
                        
//                        query = String(format: "select sum(d_SalesValue), s_skuCategoryName, s_skuSubCategoryName, s_SchemePromName, d_AccRedDate from DASHBOARD where accRedDateTimeStamp >= %.0f and accRedDateTimeStamp < %.0f and s_Type = 'ACC' group by  s_skuCategoryName,s_SchemePromName", startInterVal,endInterVal)
                        
                    case "RedemptionPoints" :
//                        query = String(format: "select sum(d_Points), s_skuCategoryName, s_skuSubCategoryName, s_SchemePromName, d_AccRedDate from DASHBOARD where accRedDateTimeStamp >= %.0f and accRedDateTimeStamp < %.0f and s_Type = 'RED' group by  s_skuCategoryName,s_SchemePromName", currentField,startInterVal,endInterVal)
                        
                        lbl_Title.text = "REDEMPTION SUMMARY \(yearMonthValue)"
                        query = String(format: "select round(sum(d_Points)) from DASHBOARD where d_AccRedDate like'%@%@%@' and s_Type = 'RED'","%",d_AccRedDate_str,"%")

                        
                       // query = String(format: "select round(sum(d_Points)),s_skuCategoryName,s_skuSubCategoryName,s_SchemePromName,d_AccRedDate from DASHBOARD where d_AccRedDate like'%@%@%@' and s_Type = 'RED' group by  s_skuCategoryName,s_SchemePromName","%",d_AccRedDate_str,"%")

                    default:
                        break
                    }
                    
                    var accumulationPoints = 0.0
                    var arr_dashboard = [Dashboard]()
                    for row in try db.prepare(query)
                    {
                        let dash = Dashboard()
                        if let points = row[0] as? Double
                        {
                            accumulationPoints = accumulationPoints + points
                            dash.d_Points = points
                        }
                        
//                        if let s_skuCategoryName = row[1] as? String
//                        {
//                            dash.s_skuCategoryName = s_skuCategoryName
//                        }
//
//                        if let s_skuSubCategoryName = row[2] as? String
//                        {
//                            dash.s_skuSubCategoryName = s_skuSubCategoryName
//                        }
//
//                        if let s_SchemePromName = row[3] as? String
//                        {
//                            dash.s_SchemePromName = s_SchemePromName
//                        }
//
//                        if let d_AccRedDate = row[4] as? String
//                        {
//                            dash.d_AccRedDate = d_AccRedDate
//                        }
//
                        arr_dashboard.append(dash)
                    }
                    return (accumulationPoints, arr_dashboard)
                }
                else
                {
                    print("currentField not found")
                }
                
            } catch  {
                print("error query")
                print("Error info: \(error)")
            }
        }
        else
        {
            print("Error db path")
        }
        return (0.0, dashbordArray)
    }

    func getAccumulationSelection(forDate date: Date, isMonth : Bool)-> (Double, [Dashboard])
    {
       
        let dateFormatter = DateFormatter()
        var d_AccRedDate_str = ""
        
        if (isMonth)
        {
            dateFormatter.dateFormat = "yyyy-MM"
            d_AccRedDate_str = dateFormatter.string(from: date)
            print("d_AccRedDate_str = \(d_AccRedDate_str)")
            
            if let db = DataProvider.getDBConnection()
            {
                db.trace { (error) in
                    print("trace error")
                    print(error)
                }
                do {
                    if let currentField = field
                    {
                        var  query = ""
                        
                        switch currentField
                        {
                        case "d_Points":
                            
                            lbl_Title.text = "ACCUMULATION SUMMARY \(yearMonthValue)"
                            
                            query = String(format: "select round(sum(d_Points)),s_skuCategoryName,s_skuSubCategoryName,s_SchemePromName,d_AccRedDate from DASHBOARD where d_AccRedDate like'%@%@%@' and s_Type = 'ACC' group by  s_skuCategoryName,s_SchemePromName","%",d_AccRedDate_str,"%")
                            break
                        case "d_SalesValue" :
                            lbl_Title.text = "SECONDARY SALES SUMMARY \(yearMonthValue)"

                            query = String(format: "select round(sum(d_SalesValue)),s_skuCategoryName,s_skuSubCategoryName,s_SchemePromName,d_AccRedDate from DASHBOARD where d_AccRedDate like'%@%@%@' and s_Type = 'ACC' group by  s_skuCategoryName,s_SchemePromName","%",d_AccRedDate_str,"%")
                            break
                        case "RedemptionPoints" :
                            lbl_Title.text = "REDEMPTION SUMMARY \(yearMonthValue)"

                            query = String(format: "select round(sum(d_Points)),s_skuCategoryName,s_skuSubCategoryName,s_SchemePromName,d_AccRedDate from DASHBOARD where d_AccRedDate like'%@%@%@' and s_Type = 'RED' group by  s_skuCategoryName,s_SchemePromName","%",d_AccRedDate_str,"%")
                            
                        default:
                            break
                        }
                        
                        var accumulationPoints = 0.0
                        var arr_dashboard = [Dashboard]()
                        for row in try db.prepare(query)
                        {
                            let dash = Dashboard()
                            if let points = row[0] as? Double
                            {
                                accumulationPoints = accumulationPoints + points
                                dash.d_Points = points
                            }
                            
                            if let s_skuCategoryName = row[1] as? String
                            {
                                dash.s_skuCategoryName = s_skuCategoryName
                            }
                            
                            if let s_skuSubCategoryName = row[2] as? String
                            {
                                dash.s_skuSubCategoryName = s_skuSubCategoryName
                            }
                            
                            if let s_SchemePromName = row[3] as? String
                            {
                                dash.s_SchemePromName = s_SchemePromName
                            }
                            
                            if let d_AccRedDate = row[4] as? String
                            {
                                dash.d_AccRedDate = d_AccRedDate
                            }
                            
                            arr_dashboard.append(dash)
                        }
                        return (accumulationPoints, arr_dashboard)
                    }
                    else
                    {
                        print("currentField not found")
                    }
                    
                } catch  {
                    print("error query")
                    print("Error info: \(error)")
                }
            }
            else
            {
                print("Error db path")
            }
            
        }
        else
        {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            d_AccRedDate_str = dateFormatter.string(from: date)
            print("d_AccRedDate_str = \(d_AccRedDate_str)")
            
            if let db = DataProvider.getDBConnection()
            {
                db.trace { (error) in
                    print("trace error")
                    print(error)
                }
                do {
                    if let currentField = field
                    {
                        var  query = ""
                        
                        switch currentField
                        {
                        case "d_Points":
                            query = String(format: "select d_Points,s_skuCategoryName,s_skuSubCategoryName,s_SchemePromName,d_AccRedDate from DASHBOARD where d_AccRedDate like'%@%@%@' and s_Type = 'ACC'","%",d_AccRedDate_str,"%")
                            break
                        case "d_SalesValue" :
                            query = String(format: "select d_SalesValue,s_skuCategoryName,s_skuSubCategoryName,s_SchemePromName,d_AccRedDate from DASHBOARD where d_AccRedDate like'%@%@%@' and s_Type = 'ACC'","%",d_AccRedDate_str,"%")
                            break
                        case "RedemptionPoints" :
                            query = String(format: "select d_Points,s_skuCategoryName,s_skuSubCategoryName,s_SchemePromName,d_AccRedDate from DASHBOARD where d_AccRedDate like'%@%@%@' and s_Type = 'RED'","%",d_AccRedDate_str,"%")
                            
                        default:
                            break
                        }
                        
                        var accumulationPoints = 0.0
                        var arr_dashboard = [Dashboard]()
                        for row in try db.prepare(query)
                        {
                            let dash = Dashboard()
                            if let points = row[0] as? Double
                            {
                                accumulationPoints = accumulationPoints + points
                                dash.d_Points = points
                            }
                            
                            if let s_skuCategoryName = row[1] as? String
                            {
                                dash.s_skuCategoryName = s_skuCategoryName
                            }
                            
                            if let s_skuSubCategoryName = row[2] as? String
                            {
                                dash.s_skuSubCategoryName = s_skuSubCategoryName
                            }
                            
                            if let s_SchemePromName = row[3] as? String
                            {
                                dash.s_SchemePromName = s_SchemePromName
                            }
                            
                            if let d_AccRedDate = row[4] as? String
                            {
                                dash.d_AccRedDate = d_AccRedDate
                            }
                            
                            arr_dashboard.append(dash)
                        }
                        return (accumulationPoints, arr_dashboard)
                    }
                    else
                    {
                        print("currentField not found")
                    }
                    
                } catch  {
                    print("error query")
                    print("Error info: \(error)")
                }
            }
            else
            {
                print("Error db path")
            }
        }
        
      
        return (0.0, dashbordArray)
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

extension Date
{
    var dayFromDate:String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        let dayInWeek = formatter.string(from: self)
        return dayInWeek
    }
    
}

// MARK: - UICollectionViewDataSource
extension CalenderViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if isYear
        {
            return months.count
        }
        else
        {
            return getDaysInMonth(month: selectedMonth, year: selectedYear)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if isYear
        {
            //yearCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "yearCell",
                                                          for: indexPath) as! DashboardCollectionViewCell
         
            cell.lbl_monthName.text = "\(months[indexPath.item])".uppercased()
            
            var dateComponents = NSCalendar.current.dateComponents([.year, .month, .day, .hour,.second], from:Date())
            
            dateComponents.day = 1
            dateComponents.hour = 0
            dateComponents.second = 0
            dateComponents.month = indexPath.item + 1
            dateComponents.year = yearWiseSelectedYear

            if let currentMonthDate = NSCalendar.current.date(from: dateComponents) {
                
                let newDate = currentMonthDate.getGMTDate()
                
                //let month = dateFormatter.string(from: newDate)
                let points = getAccumulation(forDate: newDate, isMonth: true)
                print("\(points.0)")
                
                if points.0 > 0{
                    cell.lbl_points.backgroundColor = UIColor(red: 96/255, green: 206/255, blue: 203/255, alpha: 1.0)
                }else{
                    cell.lbl_points.backgroundColor = UIColor.white

                }
                
                cell.lbl_points.text = String(format: "%.0f", points.0) //"\(points.0)"
            }
            
            return cell
        }
        else if isMonth
        {
            //monthCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthCell",
                                                          for: indexPath) as! DashboardCollectionViewCell
            cell.lbl_day.text = "\(indexPath.item+1)"
            let date = dateFrom(day: indexPath.item+1, month: selectedMonth, year: selectedYear)
            cell.lbl_dayName.text = date.dayFromDate
            
            var dateComponents = NSCalendar.current.dateComponents([.year, .month, .day,.hour,.second], from:date)
            
            dateComponents.day = indexPath.item+1
            dateComponents.hour = 0
            dateComponents.second = 0
            
            if let currentLoopDate = NSCalendar.current.date(from: dateComponents) {
                let newDate = currentLoopDate.getGMTDate()
                let points = getAccumulation(forDate: newDate, isMonth: false)
                
                if points.0 > 0{
                    cell.lbl_points.backgroundColor = UIColor(red: 96/255, green: 206/255, blue: 203/255, alpha: 1.0)
                }else{
                    cell.lbl_points.backgroundColor = UIColor.white
                    
                }
                
                cell.lbl_points.text = String(format: "%.0f", points.0) // "\(points.0)"
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        //        if indexPath.section == 0
        //        {
        //            let width = (collectionView.frame.size.width - 24) / 2
        //            let height = (collectionView.frame.size.height - 24) / 6
        //            return CGSize(width: width, height: height)
        //        }
        let width = (collectionView.frame.size.width - 20) / 3
        //let height = width - (width / 4)
        return CGSize(width: width, height: width)
    }
    
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
extension CalenderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        var result = (0.0, [Dashboard]())
        var isMonthMode = false
        var from_Date:Date!
        if isYear
        {
            var dateComponents = NSCalendar.current.dateComponents([.year, .month, .day, .hour,.second], from:Date())
            
            dateComponents.day = 1
            dateComponents.hour = 0
            dateComponents.second = 0
            dateComponents.month = indexPath.item + 1
            dateComponents.year = yearWiseSelectedYear
            
            if let currentMonthDate = NSCalendar.current.date(from: dateComponents) {
                let newDate = currentMonthDate.getGMTDate()
                from_Date = newDate
                result = getAccumulationSelection(forDate: newDate, isMonth: true)
            }
            isMonthMode = false
        }
        else if isMonth
        {
            let date = dateFrom(day: indexPath.item+1, month: selectedMonth, year: selectedYear)
            var dateComponents = NSCalendar.current.dateComponents([.year, .month, .day,.hour,.second], from:date)
            
            dateComponents.day = indexPath.item+1
            dateComponents.hour = 0
            dateComponents.second = 0
            
            if let currentLoopDate = NSCalendar.current.date(from: dateComponents) {
                let newDate = currentLoopDate.getGMTDate()
                from_Date = newDate
                result = getAccumulationSelection(forDate: newDate, isMonth: false)
            }
            isMonthMode = true
        }
        if result.1.count == 0
        {
            showAlert(msg: "noDataAvailable".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
        else
        {
            let controller = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.AccumulationReportDetailController) as! AccumulationReportDetailController
            controller.isMonthMode = isMonthMode
            controller.totalPoints = String(format: "%.0f", result.0)
            controller.accumulationArray = result.1
            controller.startDate = startDate
            controller.endDate = endDate
            controller.field = self.field
            controller.from_Date = from_Date
            self.navigationController?.pushViewController(controller, animated: true)
        }
       
    }
}

