//
//  GetQuestionsBySurveyNameViewController.swift
 
//
//  Created by Naveen on 27/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GetQuestionsBySurveyNameViewController: BaseViewController, UITextViewDelegate {
    
    @IBOutlet weak var btn_SubmitGetQ: UIButton!
    @IBOutlet weak var btn_laterGetQ: UIButton!
    @IBOutlet weak var GetQuestionsListTableView: UITableView!
    
    var myJsonArray = [[String:Any]]()
    var Radiobutton = ""
    let rect1 = CGRect(x: 10, y: 0, width: 20, height: 40)
    let lbl1 = UILabel.self
    var selectedArray:NSMutableArray = []
    var finalArray: [[String:String]] = [[:]]
    var arrayNew:NSArray = []
    var allFields: Fields?
    var radioString:String = ""
    var textString:String = ""
    var strng = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TextTableViewCell", bundle: nil)
        self.GetQuestionsListTableView.register(nib, forCellReuseIdentifier: "TextTableViewCell")
        let nib1 = UINib(nibName: "CheckboxTableViewCell", bundle: nil)
        self.GetQuestionsListTableView.register(nib1, forCellReuseIdentifier: "CheckboxTableViewCell")
        let nib2 = UINib(nibName: "RadioTableViewCell", bundle: nil)
        self.GetQuestionsListTableView.register(nib2, forCellReuseIdentifier: "RadioTableViewCell")
        let nib3 = UINib(nibName: "DropDownTableViewCell", bundle: nil)
        self.GetQuestionsListTableView.register(nib3, forCellReuseIdentifier: "DropDownTableViewCell")
        GetQuestionsBySurveyName()
        //        SubmitSurvey()
        self.GetQuestionsListTableView.reloadData()
        addReginTapGesture()
        // CheckboxTableViewCell
    }
    
    func btn_backPressed(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        //createMenuView()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func  GetQuestionsBySurveyName(){
        
        self.view.makeToastActivity(message: "Processing...")

        let dic = ["ActionType":"GetQuestions",
                   "s_SurveyCode": self.strng]
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        let requestURL: String = "\(mainUrl)api/adminmaster/GetQuestionsBySurveyName"
        manager.request(requestURL, method : .post, parameters : dic, encoding : JSONEncoding.default , headers : ["Content-Type":"application/json","Clientid":" qBd/jix0ctU= ","SecretId":"7Whc1QzyT1Pfrtm88ArNaQ=="]).responseJSON { response in
            DispatchQueue.main.async {
                self.view.hideToastActivity()
                print("URL : \(requestURL)\nRESPONSE : \(response)")
                let responsString = response.data?.toString()
                print(responsString!)
                let ndata = responsString?.data(using: String.Encoding.utf8)
                do {
                    let jsonDecoder = JSONDecoder()
                    self.allFields = try jsonDecoder.decode(Fields.self, from: ndata!)
                } catch {
                    
                }
                if let json = try? JSONSerialization.jsonObject(with: ndata!, options: []) as! [String:Any]
                {
                    print("Complete json = \(json)")
                    //                    self.myJsonArray = json["ResponseData"]["AnswerOption"] as! Array
                    if let  responseData  = json["ResponseData"] as? [[String:Any]] {
                        self.myJsonArray = responseData
                        print(self.myJsonArray)
                        self.GetQuestionsListTableView.reloadData()
                    } else {
                        self.showAlert(msg: "somethingWentWrong".localizableString(loc:
                            UserDefaults.standard.string(forKey: "keyLang")!))
                    }
                }
            }
        }
    }
    
    func ValidateData(){
        
        var params: [[String:String]] = [[:]]
        let selected:[String?] = allFields?.responseData?.filter({ (field) -> Bool in
            if let mandatory = field.b_IsMandatory, mandatory == true {
                return (field.s_QueCode != nil)
            } else {
                return false
            }
        }).map({ $0.s_QueCode }) ?? []
        params.removeAll()
        var mandatoryChecked: Bool = false
        for dict in allFields?.responseData ?? [] {
            for inner in dict.answerOption ?? [] {
                //                if dict.b_IsMandatory == true {
                //
                //                    if dict.s_AnswerType == "TextBox" && inner.Useranswer.count > 0 {
                //                        mandatoryChecked = true
                //                    } else if inner.Useranswer == "1" {
                //                        mandatoryChecked = true
                //                    } else {
                //                        mandatoryChecked = false
                //                    }
                //                }
                
                if inner.Useranswer.count > 0 && dict.s_AnswerType == "TextBox" {
                    params.append(["usercode":DataProvider.sharedInstance.userDetails.s_UserCode!,
                                   "surveycode": self.strng,
                                   "quecode":dict.s_QueCode ?? "",
                                   "answercode":inner.s_Answercode ?? "",
                                   "Useranswer":inner.Useranswer ])
                } else if inner.Useranswer == "1" {
                    
                    params.append(["usercode":DataProvider.sharedInstance.userDetails.s_UserCode!,
                                   "surveycode": self.strng,
                                   "quecode":dict.s_QueCode ?? "",
                                   "answercode":inner.s_Answercode ?? "",
                                   "Useranswer":inner.s_AnswerOption ?? ""])
                }
            }
        }
        
        let finalCodes = params.map { $0["quecode"] }
        
        if params.count > 0 {
            mandatoryChecked = finalCodes.contains(array: selected)
//            let finalCodes: Set<String?> = Set(params.map { $0["quecode"] })
//            let mandatoryCodes: Set<String?> = Set(selected.map{ $0 }!
            
            
//            if selected?.count == finalCodes.count {
//                mandatoryChecked = true
//            } else {
//                mandatoryChecked = false
//            }
        }
        
        
        //        let finalCodes = params.map { $0["quecode"] }
        
        
        print("===FINAL RESPONSE\(params)")
        if mandatoryChecked {
            print("======SUCCESS")
            SubmitSurvey(params)
        } else {
            print("======ALL FAILED")
            showAlert(msg: "* fields are mandatory")
        }
    }
    
    func  SubmitSurvey(_ params:[[String:String]]){
        
        self.view.makeToastActivity(message: "Submiting...")

        let disc = ["UserSurvey":params]
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        
        let requestURL: String = "\(mainUrl)api/adminmaster/InsertUserSurvey"
        
        manager.request(requestURL, method : .post, parameters :disc, encoding : JSONEncoding.default , headers : ["Content-Type":"application/json","Clientid":" qBd/jix0ctU= ","SecretId":"7Whc1QzyT1Pfrtm88ArNaQ=="]).responseJSON { response in
            DispatchQueue.main.async {
                self.view.hideToastActivity()
                print("URL : \(requestURL)\nRESPONSE : \(response)")
                let responsString = response.data?.toString()
                print(responsString!)
             
                let ndata = responsString?.data(using: String.Encoding.utf8)
                if let json = try? JSONSerialization.jsonObject(with: ndata!, options: []) as! [String:Any]
                {
                    print("Complete json = \(json)")
                    
                    if let ResponseCode = json["ResponseCode"] as? String
                    {
                        let responseCode = Int(ResponseCode)
                        if responseCode == 00
                        {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        else
                        {
                            if let responseMessage = json["ResponseMessage"] as? String {
                                self.showAlert(msg: responseMessage)
                            } else {
                                self.showAlert(msg: "somethingWentWrong".localizableString(loc:
                                    UserDefaults.standard.string(forKey: "keyLang")!))
                            }
                        }
                    }
                } else {
                    self.showAlert(msg:"somethingWentWrong".localizableString(loc:
                        UserDefaults.standard.string(forKey: "keyLang")!))
                }
            }
        }
    }
    
    @IBAction func laterButtonAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func OnSubmitButtonPressed_Survery(_ sender: Any) {
        
        ValidateData()
    }
}

extension GetQuestionsBySurveyNameViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return myJsonArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let AnsType = myJsonArray[section]["s_AnswerType"] as! String
        if AnsType == "DropdownList" {
            return 1
        }
        if let array = myJsonArray[section]["AnswerOption"] as? NSArray{
            return array.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let rect = CGRect(x: 30, y: 0, width: tableView.frame.size.width-60, height: 60)
        let footerView = UIView(frame:rect)
        let lbl = UILabel(frame:rect)
        lbl.text =  "\(section + 1)) \( myJsonArray[section]["s_Question"] as? String ?? "")"
        lbl.font = UIFont.systemFont(ofSize: 20)
        footerView.addSubview(lbl)
        lbl.textColor = .black
        lbl.numberOfLines = 0
        footerView.backgroundColor = UIColor.white
        
        let mandetory = myJsonArray[section]["b_IsMandatory"] as! Int
        
        if mandetory == 1{
            let lbl1 = UILabel(frame:rect1)
            lbl1.text = "*"
            lbl1.textColor = .red
            lbl1.font = UIFont.systemFont(ofSize: 30)
            footerView.addSubview(lbl1)
        }else{
            let lbl1 = UILabel(frame:rect1)
            lbl1.text = ""
            lbl1.textColor = .red
            lbl1.font = UIFont.systemFont(ofSize: 30)
            footerView.addSubview(lbl1)
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let AnsType = myJsonArray[indexPath.section]["s_AnswerType"] as! String
        
        if AnsType == "RadioButtonList" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RadioTableViewCell") as! RadioTableViewCell
            cell.selectionStyle = .none
            if let array = myJsonArray[indexPath.section]["AnswerOption"] as? NSArray{
                if let dict = array[indexPath.row] as? NSDictionary {
                    cell.lbbl1.text = dict["s_AnswerOption"] as? String ?? ""
                }
                cell.bttn1.addTarget(self, action: #selector(RadioButtonClicked(sender:)), for: .touchUpInside)
                
                cell.bttn1.tag = indexPath.row + 10
                cell.bttn1.titleLabel?.textColor = UIColor.clear
                cell.bttn1.titleLabel?.text = "\(indexPath.section + 10)"
                
                if allFields?.responseData?[indexPath.section].answerOption?[indexPath.row].Useranswer == "1" {
                    cell.bttn1.setImage(UIImage(named: "icon-select") , for: UIControlState.normal)
                    
                } else {
                    cell.bttn1.setImage(UIImage(named: "default") , for: UIControlState.normal)
                }
                
            }
            
            return cell
        } else if AnsType == "DropdownList" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell") as! DropDownTableViewCell
            cell.selectionStyle = .none
            cell.txtfield_dropdown.text = myJsonArray[indexPath.row]["s_Question"] as? String
            if let array = myJsonArray[indexPath.section]["AnswerOption"] as? [[String:Any]] {
                let dropDownNames = array.map { $0["s_AnswerOption"] as! String }
                cell.arr_dropdown = dropDownNames
                cell.txtfield_dropdown.text = ""
                for option in allFields?.responseData?[indexPath.section].answerOption ?? [] {
                    if option.Useranswer == "1" {
                        cell.txtfield_dropdown.text = option.s_AnswerOption
                        break;
                    }
                }
                //                cell.txtfield_dropdown.text = array[indexPath.row]["s_AnswerOption"] as? String ?? ""
                //                cell.txtfield_dropdown.tag = indexPath.section
                cell.selectDropDown.tag = indexPath.section
                cell.delegate = self
                //                }
            }
            return cell
        }
        else if AnsType == "CheckboxList"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckboxTableViewCell") as! CheckboxTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            arrayNew = myJsonArray[indexPath.section]["AnswerOption"] as! NSArray
            if arrayNew.count > 0 {
                let dict:Any = arrayNew[indexPath.row]
                let newDict = arrayNew[indexPath.row] as? [String:Any]
                cell.lbl1.text = newDict!["s_AnswerOption"] as? String
                cell.btn1.addTarget(self, action: #selector(checkMarkButtonClicked(sender:)), for: .touchUpInside)
                cell.btn1.tag = indexPath.row + 10
                cell.btn1.titleLabel?.textColor = UIColor.clear
                cell.btn1.titleLabel?.text = "\(indexPath.section + 10)"
                if selectedArray.contains(dict) {
                    let btnImage = UIImage(named: "read_image")
                    cell.btn1.setImage(btnImage , for: UIControlState.normal)
                    print(selectedArray)
                    //                    cell.itemImage.image = UIImage(named: "Group 46")
                } else {
                    let btnImage = UIImage(named: "")
                    cell.btn1.setImage(btnImage , for: UIControlState.normal)
                    print(selectedArray)
                    //                    cell.itemImage.image = UIImage(named: "Rectangle 43")
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell") as! TextTableViewCell
            cell.selectionStyle = .none
            cell.textview.tag = indexPath.section + 10
            cell.textview.delegate = self
            if let count = allFields?.responseData?[indexPath.section].answerOption?[indexPath.row].Useranswer.count, count > 0 {
                cell.textview.text = allFields?.responseData?[indexPath.section].answerOption?[indexPath.row].Useranswer
            } else {
                cell.textview.text = ""
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let AnsType = myJsonArray[indexPath.row]["s_AnswerType"] as! String
        if AnsType == "TextBox" || AnsType == "DropdownList" {
            return 70
        } else if AnsType == "CheckboxList" {
            return 70
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let AnsType = myJsonArray[indexPath.section]["s_AnswerType"] as! String
//        if  AnsType == "RadioButtonList" {
//            let cell:RadioTableViewCell = tableView.cellForRow(at: indexPath) as! RadioTableViewCell
//            if let array = myJsonArray[indexPath.section]["AnswerOption"] as? NSArray{
//                if let dict = array[indexPath.row] as? NSDictionary{
//                    radioString = dict["s_AnswerOption"] as? String ?? ""
//                    //                    print(radioString)
//                    allFields?.responseData?[indexPath.section].answerOption?[indexPath.row].Useranswer = "1"
//                    let btnImage = UIImage(named: "icon-select")
//                    cell.bttn1.setImage(btnImage , for: UIControlState.normal)
//                }
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let AnsType = myJsonArray[indexPath.section]["s_AnswerType"] as! String
//        if  AnsType == "RadioButtonList" {
//            let cell:RadioTableViewCell = tableView.cellForRow(at: indexPath) as! RadioTableViewCell
//            let btnImage = UIImage(named: "default")
//            allFields?.responseData?[indexPath.section].answerOption?[indexPath.row].Useranswer = "0"
//            cell.bttn1.setImage(btnImage , for: UIControlState.normal)
//        }
    }
    @objc func checkMarkButtonClicked ( sender: UIButton) {
        //        print("button presed")
        
        if let title = sender.titleLabel?.text {
            if let section = Int(title) {
                if allFields?.responseData?[section - 10].answerOption?[sender.tag - 10].Useranswer == "1" {
                    allFields?.responseData?[section - 10].answerOption?[sender.tag - 10].Useranswer = "0"
                } else {
                    allFields?.responseData?[section - 10].answerOption?[sender.tag - 10].Useranswer = "1"
                }
            }
        }
        
        
        let dict:Any = arrayNew[(sender.tag - 10)%1500]
        
        if !selectedArray.contains(dict){
            selectedArray.add(dict)
        }else {
            selectedArray.remove(dict)
        }
        self.GetQuestionsListTableView.reloadData()
        
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.hasText && textView.text.count > 0  {
            allFields?.responseData?[textView.tag - 10].answerOption?[0].Useranswer = textView.text
        } else {
            allFields?.responseData?[textView.tag - 10].answerOption?[0].Useranswer = ""
        }
        
    }
    @objc func RadioButtonClicked ( sender: UIButton) {
        
        if let title = sender.titleLabel?.text {
            if let section = Int(title) {
                if let count = allFields?.responseData?[section - 10].answerOption?.count {
                    for i in 0..<count {
                        if i == sender.tag - 10 {
                            allFields?.responseData?[section - 10].answerOption?[sender.tag - 10].Useranswer = "1"
                        } else {
                            allFields?.responseData?[section - 10].answerOption?[i].Useranswer = "0"
                        }
                    }
                    self.GetQuestionsListTableView.reloadData()
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GetQuestionsBySurveyNameViewController: CheckboxTableViewCellDelegate{
    func checkboxBtnPressed(){
        self.GetQuestionsListTableView.visibleCells.forEach { (checkboxCell) in
            if let cellDetails = checkboxCell as? CheckboxTableViewCell{
                cellDetails.btn1.setImage(UIImage(named: "m_accumulate"), for: .normal)
            }
        }
    }
}

extension GetQuestionsBySurveyNameViewController:DropDownDataPassing {
    
    func selectedData(section: Int, index: Int, selectedText: String) {
        
        if let count = allFields?.responseData?[section].answerOption?.count {
            for i in 0..<count {
                if i == index {
                    allFields?.responseData?[section].answerOption?[index].Useranswer = "1"
                } else {
                    allFields?.responseData?[section].answerOption?[i].Useranswer = "0"
                }
            }
            self.GetQuestionsListTableView.reloadData()
        }
    }
    
}
extension Array where Element: Equatable {
    func contains(array: [Element]) -> Bool {
        for item in array {
            if !self.contains(item) { return false }
        }
        return true
    }
}
