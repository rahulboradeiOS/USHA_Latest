//
//  SchemeResultsViewController.swift
 
//
//  Created by Apple on 04/02/20.
//  Copyright © 2020 Apple.Inc. All rights reserved.
//

import UIKit

class SchemeResultsViewController: BaseViewController {
    
    
    @IBOutlet weak var tblSchemeView: UITableView!
    @IBOutlet weak var lbl_Date: UILabel!

    var mySchemeData : [SchemeResultModelElement] = []

    
    override func viewDidLoad()
    {
         super.viewDidLoad()
            setLabelUpdate()

     }
    
    func setLabelUpdate()
    {
        
    let twoDaysAgo = NSDate(timeIntervalSinceNow: -1*24*60*60)
              
              let dateMY = "\(twoDaysAgo)".prefix(19)

              let dateFormatterGet = DateFormatter()
              dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "dd-MM-yyyy"

              let date: Date? = dateFormatterGet.date(from: String(dateMY))
     
            self.lbl_Date.text = "SCHEME DETAILS UPDATED UPTO \(dateFormatter.string(from: date!))"
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
//        navigationView.btn_dashbord_width.constant = 0
//        if (navigationView != nil)
//              {
//                  if DataProvider.sharedInstance.userDetails != nil
//                  {
//                      navigationView.lbl_shopName.text = DataProvider.sharedInstance.userDetails.s_ShopName
//                      navigationView.lbl_mobNo.text = DataProvider.sharedInstance.userDetails.s_MobileNo
//                  }
//                  else
//                  {
//                      navigationView.lbl_shopName.text = ""
//                      navigationView.lbl_mobNo.text = ""
//                  }
//                  navigationView.layoutSubviews()
//                  navigationView.layoutIfNeeded()
//         }
        
        if(Connectivity.isConnectedToInternet())
                      {
                          GetschemeDetailsByMobile()
                          
                      }
                      else
                      {
                          showAlert(msg: MessageAndError.noInternetConnection_SchemeLISTING)
                      }
    }
    
    
    override func onBackButtonPressed(_ sender: UIButton) {
      self.navigationController?.popViewController(animated: true)
        
    }
    
   
   
    override func onBellButtonPressed(_ sender : UIButton)
    {
        let notificationVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.NotificationViewController) as! NotificationViewController
               self.navigationController?.pushViewController(notificationVC, animated: true)
        
    }

    
    func GetschemeDetailsByMobile()
    {
        
        let parameters = [Key.MobileNo: DataProvider.sharedInstance.userDetails.s_MobileNo!,
                                     Key.ActionType: ActionType.GetRuleDetails,
                                     Key.RuleName:"", Key.RuleCode:"",Key.FromDate:"",Key.ToDate:"",Key.EmpCode:"",Key.Months:"",Key.SalesOffice:"",Key.Years:"",Key.PageNumber:0] as [String : Any]
        let parser = Parser()
        parser.delegate = self
        parser.callAPI(api: API.GetschemeDetailsByMobile, parameters: parameters, viewcontroller: self, actionType: API.GetschemeDetailsByMobile)
   
    }
}


extension SchemeResultsViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.mySchemeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchemeCell", for: indexPath) as! SchemeResultTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let scheme = self.mySchemeData[indexPath.row]
        
        cell.lbl_schemeName.numberOfLines = 0
        cell.lbl_StartDate.numberOfLines = 0
        cell.lbl_EndDate.numberOfLines = 0
        cell.lbl_Status.numberOfLines = 0
        
        let font = UIFont.systemFont(ofSize: 13, weight: .regular)
        let font1 = UIFont.systemFont(ofSize: 12, weight: .bold)
        
        cell.lbl_schemeName.font = font1
        cell.lbl_StartDate.font = font
        cell.lbl_EndDate.font = font
        cell.lbl_Status.font = font
       
        cell.lbl_schemeName.text = "\(scheme.ruleName)"
        cell.lbl_StartDate.text = "\(scheme.fromDate)"
        cell.lbl_EndDate.text = "\(scheme.toDate)"
        
        let status = "\(scheme.head)"
        
        if status == "Running"{
            cell.lbl_Status.text = "\(scheme.head)"
            cell.lbl_Status.textColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 1.0)
        }else if status == "Closed"{
            cell.lbl_Status.text = "\(scheme.head)"
            cell.lbl_Status.textColor = UIColor.red
        }
        
        cell.btn_SchemeDetails.tag = indexPath.row
        cell.btn_Download.tag = indexPath.row
        cell.btn_Download.addTarget(self, action: #selector(Docs_Download), for: .touchUpInside)
        cell.btn_SchemeDetails.addTarget(self, action: #selector(goTo_SchemeDetails), for: .touchUpInside)

        
        return cell
    }
    
    
    @objc func Docs_Download(_ sender : UIButton){
        
        if(Connectivity.isConnectedToInternet())
               {
                   let myUrl = self.mySchemeData[sender.tag].attachmentPath
                        
                        if myUrl != ""{

                            guard let url = URL(string: myUrl) else { return }
                            UIApplication.shared.open(url)
                            
                        }else{
                            showAlert(msg: "Document Address Not Available")
                        }
                   
               }
               else
               {
                   showAlert(msg: MessageAndError.noInternetConnection_SchemeLISTING)
               }
        
     
   
    }
    
    @objc func goTo_SchemeDetails(_ sender : UIButton){
 
        if(Connectivity.isConnectedToInternet())
        {
            
            print(sender.tag)
            
            if sender.tag == 0{
                
                let dmsVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.DMSNewSchemeBilling_VC) as! DMSNewSchemeBilling_VC
                              dmsVC.mySchemeDetailsData = self.mySchemeData[sender.tag]
                              self.navigationController?.pushViewController(dmsVC, animated: true)
            }else{
            
              let schemeResultsVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.SchemeResultDetails_VC) as! SchemeResultDetails_VC
                schemeResultsVC.mySchemeDetailsData = self.mySchemeData[sender.tag]
                self.navigationController?.pushViewController(schemeResultsVC, animated: true)
            }
        }
        else
        {
            showAlert(msg: MessageAndError.noInternetConnection_SchemeDETAILS)
        }

    }
    
     //MARK:- Saving PDF
     //MARK:-
    
    func savePdf(urlString:String, fileName:String) {
        DispatchQueue.main.async {
            let url = URL(string: urlString)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "SAMPARK-\(fileName).pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                print("pdf successfully saved!")
            } catch {
                print("Pdf could not be saved")
            }
        }
    }
    
    func showSavedPdf(url:String, fileName:String) {
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("\(fileName).pdf") {
                        // its your file! do what you want with it!
                        
                    }
                }
            } catch {
                print("could not locate pdf file !!!!!!!")
            }
        }
    }
    
    // check to avoid saving a file multiple times
    func pdfFileAlreadySaved(url:String, fileName:String)-> Bool {
        var status = false
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("SAMPARK-\(fileName).pdf") {
                        status = true
                    }
                }
            } catch {
                print("could not locate pdf file !!!!!!!")
            }
        }
        return status
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! SchemeHeaderTableViewCell
        
        headerView.lbl_schemeName.numberOfLines = 0
        headerView.lbl_StartDate.numberOfLines = 0
        headerView.lbl_EndDate.numberOfLines = 0
        headerView.lbl_Status.numberOfLines = 0
        headerView.lbl_Download.numberOfLines = 0
        
        let font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        headerView.lbl_schemeName.font = font
        headerView.lbl_StartDate.font = font
        headerView.lbl_EndDate.font = font
        headerView.lbl_Status.font = font
        headerView.lbl_Download.font = font

        headerView.lbl_schemeName.text = "SCHEME"
        headerView.lbl_StartDate.text = "START DATE"
        headerView.lbl_EndDate.text = "END DATE"
        headerView.lbl_Status.text = "STATUS"
        headerView.lbl_Download.text = "DETAILS"
        
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if let headerView = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as? SchemeHeaderTableViewCell
        {
            
            let font = UIFont.systemFont(ofSize: 12, weight: .medium)
            let name_height = "SCHEME".height(withConstrainedWidth: headerView.lbl_schemeName.frame.width, font: font)
            let start_height = "START DATE".height(withConstrainedWidth: headerView.lbl_StartDate.frame.width, font: font)
            let end_height = "END DATE".height(withConstrainedWidth: headerView.lbl_EndDate.frame.width, font: font)
            let status_height = "STATUS".height(withConstrainedWidth: headerView.lbl_Status.frame.width, font: font)
            let download_height = "DETAILS".height(withConstrainedWidth: headerView.lbl_Download.frame.width, font: font)
            
            let largest = max(max(name_height, start_height,end_height,status_height), download_height)
            
            return largest 
        }
        return 50
}

}


extension SchemeResultsViewController
{
    func didRecivedGetschemeDetailsByMobile(responseData:[[String:Any]])
    {
        
        let mySchemeData = JSON(responseData)
      
            do
            {
               
                self.mySchemeData = try JSONDecoder().decode([SchemeResultModelElement].self, from: mySchemeData.rawData())
                    print(self.mySchemeData)
            
                
                DispatchQueue.main.async {
                    self.tblSchemeView.delegate = self
                    self.tblSchemeView.dataSource = self

                    self.tblSchemeView.reloadData()
                }
                
                
            }catch let error as NSError {
                print(error)
            }
       
    }
}

