//
//  SurveyCompleteAnsViewController.swift
 
//
//  Created by Naveen on 28/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SurveyCompleteAnsViewController: BaseViewController {
    @IBOutlet weak var SurveyCompleteAnsTableView: UITableView!
    
    var strng = ""
    var myJsonArray = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetCompleteServyAns()
       
    }
    override func onBackButtonPressed(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func  GetCompleteServyAns(){
        
        let dic = ["ActionType":"GetQuestionsAnswer","s_SurveyCode":strng,"usercode":DataProvider.sharedInstance.userDetails.s_UserCode!]
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        let requestURL: String = "\(mainUrl)api/adminmaster/GetUserQuestionAnswer"
        
        
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
                       self.SurveyCompleteAnsTableView.reloadData()
                    }
                }
            }
        }
    }
}
extension SurveyCompleteAnsViewController:UITabBarDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myJsonArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedAnsTableViewCell") as! SelectedAnsTableViewCell
        cell.lbl_Qun.text = self.myJsonArray[indexPath.row]["s_Question"] as? String
        cell.lbl_Ans.text = self.myJsonArray[indexPath.row]["Answer"] as? String
        return cell
    }
    
    
}

