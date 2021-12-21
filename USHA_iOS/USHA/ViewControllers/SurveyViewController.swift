//
//  SurveyViewController.swift
 
//
//  Created by Naveen on 27/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SurveyViewController: BaseViewController {

    @IBOutlet weak var SERVEYSEGMENT: UISegmentedControl!
    @IBOutlet weak var Tbl_Survey_P_C: UITableView!
    
    @IBAction func SERVEYSEGMENT(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            
            sender.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.gray], for: .selected)
            print("index = 0")
            tableArray = yArray
        }else{
            
            sender.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.gray], for: .selected)
            print("index = 1")
            tableArray = myJsonArray
        }
        self.Tbl_Survey_P_C.reloadData()
    }
    var tableArray = [[String:Any]]()
    var yArray = [[String:Any]]()
    var myJsonArray = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SERVEYSEGMENT.selectedSegmentIndex = 0
        let nib = UINib(nibName: "CompletedCell", bundle: nil)
        self.Tbl_Survey_P_C.register(nib, forCellReuseIdentifier: "CompletedCell")
        GetPendingServy()
        GetCompleteServy()
        setUpSegmentCtrl()
//        self.Tbl_Survey_P_C.reloadData()
 
    }
    func setUpSegmentCtrl(){
        
        let font = UIFont.systemFont(ofSize: 17)
        
        self.navigationController?.navigationBar.isHidden = false
        SERVEYSEGMENT.selectedSegmentIndex = 0
        
        SERVEYSEGMENT.backgroundColor = UIColor.init(red: 237/255, green: 27/255, blue: 35/255, alpha: 1.0)
        
        SERVEYSEGMENT.tintColor = UIColor.init(red: 237/255, green: 27/255, blue: 35/255, alpha: 1.0)
        
        SERVEYSEGMENT.setTitleTextAttributes([
            NSAttributedStringKey.font : font,
            NSAttributedStringKey.foregroundColor: UIColor.white
            ], for: .normal)
        
        SERVEYSEGMENT.setTitleTextAttributes([
            NSAttributedStringKey.font : font,
            NSAttributedStringKey.foregroundColor: UIColor.white
            ], for: .selected)
    }
    
    
    func btn_backPressed(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        //createMenuView()
        self.navigationController?.popToRootViewController(animated: true)
    }

    func  GetPendingServy(){
        
        let dic = ["ActionType":"GetAllQuestionair",     "usercode":DataProvider.sharedInstance.userDetails.s_UserCode!,//need to change dynamic
                         "surveystatus":"PENDING"]
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        let requestURL: String = "\(mainUrl)api/adminmaster/GetAllSurvey"
        
        
        manager.request(requestURL, method : .post, parameters : dic, encoding : JSONEncoding.default , headers : ["Content-Type":"application/json","Clientid":" qBd/jix0ctU= ","SecretId":"7Whc1QzyT1Pfrtm88ArNaQ=="]).responseJSON { response in
            DispatchQueue.main.async {
                print("URL : \(requestURL)\nRESPONSE : \(response)")
                var responsString = response.data?.toString()
                print(responsString!)
      
                let ndata = responsString?.data(using: String.Encoding.utf8)
                if let json = try? JSONSerialization.jsonObject(with: ndata!, options: []) as! [String:Any]
                {
                    print("Json = \(json)")
                    
                    if let  responseData  = json["ResponseData"] as? [[String:Any]]{
                      self.yArray = responseData
                        self.tableArray = self.yArray
                    }
             
                    self.Tbl_Survey_P_C.reloadData()
                }
               
                
            }
        }
        
        
    }
    func  GetCompleteServy(){
        
        let dic = ["ActionType":"GetAllQuestionair",
                   "usercode":DataProvider.sharedInstance.userDetails.s_UserCode!,
                   "surveystatus":"COMPLETE"]
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        let requestURL: String = "\(mainUrl)api/adminmaster/GetAllSurvey"
        
        
        manager.request(requestURL, method : .post, parameters : dic, encoding : JSONEncoding.default , headers : ["Content-Type":"application/json","Clientid":" qBd/jix0ctU= ","SecretId":"7Whc1QzyT1Pfrtm88ArNaQ=="]).responseJSON { response in
            DispatchQueue.main.async {
                print("URL : \(requestURL)\nRESPONSE : \(response)")
                var responsString = response.data?.toString()
                print(responsString!)
             
                let ndata = responsString?.data(using: String.Encoding.utf8)
                if let json = try? JSONSerialization.jsonObject(with: ndata!, options: []) as! [String:Any]
                {
                    print("Complete json = \(json)")
                    if let  responseData  = json["ResponseData"] as? [[String:Any]]{
                        
                        self.myJsonArray = responseData
                        print(self.myJsonArray)
//                        self.Tbl_Survey_P_C.reloadData()
                    }
                }
                
                
            }
        }
        
        
    }


}
extension SurveyViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if SERVEYSEGMENT.selectedSegmentIndex == 0{
            return 100
        }else{
            return 100
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if SERVEYSEGMENT.selectedSegmentIndex == 0{
     let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyPendingTableViewCell") as! SurveyPendingTableViewCell
        cell.lbl_msg_servery.text = tableArray[indexPath.row]["s_surveyName"] as? String
            cell.lbl.text = tableArray[indexPath.row]["d_createddate"] as? String
        return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedCell") as! CompletedCell
             cell.lbl.text = tableArray[indexPath.row]["s_surveyName"] as? String
//            if ( tableArray[indexPath.row]["s_surveyName"] as? String !== "") {
//
//            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if SERVEYSEGMENT.selectedSegmentIndex == 0{
        let vc = storyboard?.instantiateViewController(withIdentifier: "GetQuestionsBySurveyNameViewController") as! GetQuestionsBySurveyNameViewController
            vc.strng = tableArray[indexPath.row]["s_SurveyCode"] as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    else{
    let vc = storyboard?.instantiateViewController(withIdentifier: "SurveyCompleteAnsViewController") as! SurveyCompleteAnsViewController
        vc.strng = tableArray[indexPath.row]["s_SurveyCode"] as! String
    self.navigationController?.pushViewController(vc, animated: true)
    }
}
}
