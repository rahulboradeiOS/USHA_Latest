//
//  TransactionHistoryListViewController.swift
 
//
//  Created by Apple.Inc on 30/05/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit

class TransactionHistoryListViewController: BaseViewController {

    @IBOutlet weak var lbl_totalAccumulation: UILabel!
    @IBOutlet weak var lbl_totalAccNRed: UILabel!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var lbl_Heading: UILabel!

    @IBOutlet weak var lbl_totalRedemption: UILabel!
    @IBOutlet weak var tableView_transaction: UITableView!
    //@IBOutlet weak var lbl_dateRange: UILabel!
    
    var arr_Transaction:[Dashboard]!
    var startDate:Date!
    var endDate:Date!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView_transaction.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView_transaction.tableFooterView = UIView()
        
     
        var totalAccum = 0.0
        var totalRedem = 0.0
        
        for item in arr_Transaction
        {
            if item.s_Type == "ACC"
            {
                totalAccum = totalAccum + item.d_Points
            }
            else
            {
                totalRedem = totalRedem + item.d_Points
            }
        }
        
//        lbl_totalAccumulation.text = "\(totalAccum.roundToDecimal2(2))"
//        lbl_totalRedemption.text = "\(totalRedem.roundToDecimal2(2))"
        
        self.lbl_totalAccNRed.text = "TOTAL ACC    \(totalAccum.roundToDecimal2(2))        TOTAL RED    \(totalRedem.roundToDecimal2(2))"
        
        self.tableView_transaction.reloadData()
        
                setUpDesign()
        }
           
            func setUpDesign(){
              
                   totalView.layer.cornerRadius = 14
                   totalView.layer.masksToBounds = true
                
                lbl_Heading.layer.cornerRadius = 6
                lbl_Heading.layer.borderColor = UIColor.red.cgColor
                lbl_Heading.layer.borderWidth = 1.0
                lbl_Heading.layer.masksToBounds = true
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {

        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension TransactionHistoryListViewController: UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return arr_Transaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionListTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if (indexPath.row % 2) == 0
        {
           // cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        else
        {
          //  cell.backgroundColor = #colorLiteral(red: 0.8391417265, green: 0.8392630816, blue: 0.8391152024, alpha: 1)
        }
        let transaction = arr_Transaction[indexPath.row]
        print(transaction)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        print(transaction.d_AccRedDate)
        if let date = dateFormatter.date(from: transaction.d_AccRedDate)
        {
            dateFormatter.dateFormat = "dd/MM/yy" // "MM/dd/yyyy"
            cell.lbl_date.text = dateFormatter.string(from: date)
        }
        var date = transaction.d_AccRedDate!
        let index = date.index(date.startIndex, offsetBy: 10)
        let mySubstring = date[..<index]
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let showDate = inputFormatter.date(from: String(mySubstring))
        inputFormatter.dateFormat = "dd/MM/yyyy"
        let resultString = inputFormatter.string(from: showDate!)
        print(resultString)
        
        cell.lbl_date.text = resultString
        cell.lbl_scheme.text = transaction.s_SchemePromName!
        cell.lbl_product.text = transaction.s_skuCategoryName!
        cell.lbl_type.text = transaction.s_Type
        cell.lbl_points.text = "\(transaction.d_Points!)"
        if(transaction.s_Type == "ACC")
        {
            cell.lbl_type.textColor = UIColor(red: 17/255, green: 89/255, blue: 12/255, alpha: 1.0)
            cell.lbl_points.textColor = UIColor(red: 17/255, green: 89/255, blue: 12/255, alpha: 1.0)
        }
        else if(transaction.s_Type == "RED")
        {
            cell.lbl_type.textColor = .red
            cell.lbl_points.textColor = .red
        }else{
            cell.lbl_type.textColor = .blue
            cell.lbl_points.textColor = .blue
        }
        
        cell.viewCurve.layer.cornerRadius = 8
        cell.viewCurve.layer.borderColor = UIColor.gray.cgColor
        cell.viewCurve.layer.borderWidth = 0.8
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}

class TransactionListTableViewCell : UITableViewCell
{
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_scheme: UILabel!
    @IBOutlet weak var lbl_type: UILabel!
    @IBOutlet weak var lbl_product: UILabel!
    @IBOutlet weak var lbl_points: UILabel!
    @IBOutlet weak var viewCurve: UIView!
}

extension Double {
    func roundToDecimal2(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
