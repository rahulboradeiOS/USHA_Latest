//
//  GalleryViewController.swift
 
//
//  Created by apple on 02/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import SQLite
import SwiftyJSON
import DropDown

var GYSegmet = 1
class GalleryViewController: BaseViewController {
    
    @IBOutlet weak var txtContentsArray: SkyFloatingLabelTextField!
    @IBOutlet weak var GYSegmet: UISegmentedControl!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
     let selectDropDown = DropDown()
     var txt_responder:UITextField?
    
    
    @IBOutlet weak var tblParsingView: UITableView!
    var playlistID:String = ""
    var youtubelistArray = [String: Any]()
    
    var myGalleryData  = JSON()
    var myYoutubeData = JSON()
    var myJsonArray = [[String:Any]]()
    var strLan:String = ""
    var myJsonData = JSON()
    var myData: [JSON] = []

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Connectivity.isConnectedToInternet(){
            
//            self.setUpSegmentCtrl()
//            self.parsingData()
            
//            GYSegmet.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
//            setupDropDown()
            
        }else{
            self.showAlert(msg: "noInternetConnection".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
        
        LanguageChanged(strLan:keyLang)
//        self.txtContentsArray.text = "ALL"
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("gal")

        makeGetCallWithAlamofire1()
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func makeGetCallWithAlamofire1() {
        let urlString: String = "https://sfaservice.usha.com:4041/SFAService.svc/GetGalleryDetailsForRetailer"
        let params = ["Data":["GalleryType":"Video","ClientID":"924334897168-tl3ktp6e71p028vttr62tg94klc9n5mq"]]
        print(params)
        Alamofire.request(urlString, method: .post, parameters: params , encoding:JSONEncoding.default, headers: nil).responseJSON { (json) in
            if  json.error == nil {
                ///////
            }
            print(json)
                            if let jsson = json.result.value as? [String: Any] {
                                print(json)
                                self.youtubelistArray = jsson
                                print(self.youtubelistArray)
                                self.tblParsingView.reloadData()
                                
                            }
        }
        
//
//
//
//        Alamofire.request(urlString)
//            .responseJSON { json in
//                if  json.error == nil {
//                    ///////
//                }
//                if let jsson = json.result.value as? [String: Any] {
//                    print(json)
//                    self.youtubelistArray = jsson
//                    print(self.youtubelistArray)
//                    self.tableview.reloadData()
//                }
//        }
    }
    

    
    func LanguageChanged(strLan:String){
    
//        GYSegmet.setTitle("GALLERY".localizableString(loc:
//            UserDefaults.standard.string(forKey: "keyLang")!), forSegmentAt:0)
//        GYSegmet.setTitle("PRODUCT VIDEOS".localizableString(loc:
//            UserDefaults.standard.string(forKey: "keyLang")!), forSegmentAt:1)
        
    }
//  GYSegmet.setTitle("Your Title", forSegmentAt: 0)
    
    func setUpSegmentCtrl(){
        let font = UIFont.systemFont(ofSize: 17)
        self.navigationController?.navigationBar.isHidden = false
        GYSegmet.selectedSegmentIndex = 0
        GYSegmet.backgroundColor = UIColor.lightGray//UIColor.init(red: 237/255, green: 27/255, blue: 35/255, alpha: 1.0)
        GYSegmet.tintColor = UIColor.init(red: 63/255, green: 140/255, blue: 72/255, alpha: 1.0)
    
        GYSegmet.setTitleTextAttributes([
            NSAttributedStringKey.font : font,
            NSAttributedStringKey.foregroundColor: UIColor.white
            ], for: .normal)
        GYSegmet.setTitleTextAttributes([
            NSAttributedStringKey.font : font,
            NSAttributedStringKey.foregroundColor: UIColor.black
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
    
    
    func parsingData(){
        
        let parameters = ["PageNumber":"1",
                          "ActionTypes":"GetGalleryDetailsByMobile",
                          "FromDate":""] //6
        WebAPIClient.shared.parsingDataJSON(parameters, completionHandler:{ (result) in
            switch (result) {
            case .Success(let responseDict, _):
                if responseDict != nil {
                    let mydata  = "\(responseDict["ResponseData"])"
                    print("mydata Info : \(mydata)")
                    let data = mydata.data(using: .utf8)!
                    do {
                         let jsonArray = try  JSONSerialization.jsonObject(with: data, options :[])
                        self.myJsonData = JSON(jsonArray)
                        print("Gallary data:\(jsonArray)")
                        DispatchQueue.main.async {
                            self.myGalleryData = self.myJsonData
                            self.tblParsingView.reloadData()
                            
                        }
                    
                    } catch let error as NSError {
                        print(error)
                    }
                }
                    
                else {
                    
                    let responseMessage = responseDict["error_msg"]
                    print("Response Message : \(responseMessage)")
                }
                
            case .Failure(let failureMessage, let statusCode):
                print("Message : \(failureMessage)")
                print("Status Code : \(statusCode)")
                break
            }
        })
        
    }
    
    
    @IBAction func GYSegmet(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            sender.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
            
            self.myGalleryData = self.myJsonData
            heightConstraint.constant = 40
        }else{
            sender.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
            
            self.myGalleryData = self.myYoutubeData
            heightConstraint.constant = 0
            
        }
        self.tblParsingView.reloadData()
    }
    
}

extension GalleryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
//         if GYSegmet.selectedSegmentIndex == 0
//         {
//            if self.txtContentsArray.text != nil {
//
//                if (self.txtContentsArray.text?.contains("VIDEO"))!{
//                    self.myData = self.myGalleryData.arrayValue.filter({$0["AttachmentType"].stringValue == "Video"})
//                    if self.myData.count == 0{
//                        self.showAlert(msg: "NO VIDEO FOUND")
//                    }
//                    return self.myData.count
//                }
//
//                if (self.txtContentsArray?.text?.contains("IMAGE"))!{
//                    self.myData = self.myGalleryData.arrayValue.filter({$0["AttachmentType"].stringValue == "Image"})
//                    if self.myData.count == 0{
//                        self.showAlert(msg: "NO IMAGE FOUND")
//                    }
//                    return self.myData.count
//                }
//                if (self.txtContentsArray?.text?.contains("ALL"))!{
//
//                    return self.myGalleryData.count
//                }
//                if (self.txtContentsArray?.text?.contains("DOCUMENT"))!{
//                    self.myData = self.myGalleryData.arrayValue.filter({$0["AttachmentType"].stringValue == "Document"})
//                    if self.myData.count == 0{
//                        self.showAlert(msg: "NO DOCUMENT FOUND")
//                    }
//                    return self.myData.count
//                }
//                if (self.txtContentsArray?.text?.contains("AUDIO"))!{
//                    self.myData = self.myGalleryData.arrayValue.filter({$0["AttachmentType"].stringValue == "Audio"})
//                    if self.myData.count == 0{
//                        self.showAlert(msg: "NO AUDIO FOUND")
//                    }
//                    return self.myData.count
//                }
//
//            }
//         }else{
//                return self.myGalleryData.count
//
//            }
//       return 0
        
        if youtubelistArray.count == 0
        {
            //self.showAlert(msg: "NO DATA FOUND")
            return 0
        }
        else
        {
            let dict = JSON(youtubelistArray)
            print(self.youtubelistArray.count)
            let array = dict.dictionary?["Results"]?.array!
            return array!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryTableViewCell", for: indexPath) as! GalleryTableViewCell
        let dict = JSON(youtubelistArray)
        print(dict)
        
        print(self.youtubelistArray.count)
        
//        cell.imageVew.kf.setImage(with: dict.dictionary?["Results"]?.array?[indexPath.row].dictionary?["snippet"]?.dictionary?["thumbnails"]?.dictionary?["default"]?.dictionary?["url"]?.url)
        
        cell.imgProfile.kf.setImage(with: dict.dictionary?["Results"]?.array?[indexPath.row].dictionary?["GalleryThumbnail"]?.url)
        
//        cell.titleLabel.text = dict.dictionary?["items"]?.array?[indexPath.row].dictionary?["snippet"]?.dictionary?["title"]?.stringValue
        
        cell.lblTitle.text = dict.dictionary?["Results"]?.array?[indexPath.row].dictionary?["PlaylistName"]?.stringValue
        
        cell.lblMesssage.text = ""
        return cell
//        if GYSegmet.selectedSegmentIndex == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryTableViewCell", for: indexPath) as! GalleryTableViewCell
//
//            if (self.txtContentsArray?.text?.contains("ALL"))!{
//                let cellData = myGalleryData[indexPath.row]
//                cell.lblTitle.text = cellData["Title"].stringValue
//                cell.lblMesssage.text = cellData["Messages"].stringValue
//                let fileExt = cellData["AttachmentType"].stringValue
//                if fileExt=="Text" {
//                    cell.imgProfile?.image = UIImage(named: "Document_ios")
//                    // change image
//                }else if fileExt=="Image" {
//                    cell.imgProfile?.image = UIImage(named: "image")
//                    // change image
//                }else if fileExt=="Video" {
//                    cell.imgProfile?.image = UIImage(named: "Video_ios")
//                    // change image
//                }else if fileExt=="Document" {
//                    cell.imgProfile?.image = UIImage(named: "Document_ios")
//                    // change image
//                }else if fileExt=="Audio" {
//                    cell.imgProfile?.image = UIImage(named: "Audio_ios")
//                    // change image
//                }
//
//            }else{
//
//                    let cellData = self.myData[indexPath.row]
//                    cell.lblTitle.text = cellData["Title"].stringValue
//                    cell.lblMesssage.text = cellData["Messages"].stringValue
//                    let fileExt = cellData["AttachmentType"].stringValue
//                    if fileExt=="Text" {
//                        cell.imgProfile?.image = UIImage(named: "Document_ios")
//                        // change image
//                    }else if fileExt=="Image" {
//                        cell.imgProfile?.image = UIImage(named: "image")
//                        // change image
//                    }else if fileExt=="Video" {
//                        cell.imgProfile?.image = UIImage(named: "Video_ios")
//                        // change image
//                    }else if fileExt=="Document" {
//                        cell.imgProfile?.image = UIImage(named: "Document_ios")
//                        // change image
//                    }else if fileExt=="Audio" {
//                        cell.imgProfile?.image = UIImage(named: "Audio_ios")
//                        // change image
//                }
//
//
//            }
//
//            return cell
//        }else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "YouTubeTableViewCell", for: indexPath) as! YouTubeTableViewCell
//
//                cell.lblChannelTitle.text = myGalleryData[indexPath.row]["PlaylistName"].stringValue
//                let url = URL(string: myGalleryData[indexPath.row]["GalleryThumbnail"].stringValue)
//                cell.ImgChannel?.kf.setImage(with: url)
//
//            return cell
//        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if Connectivity.isConnectedToInternet(){
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "YoutubeListViewController") as! YoutubeListViewController
            
            let dict = JSON(youtubelistArray)
            
//            vc.videoID = dict.dictionary?["items"]?.array?[indexPath.row].dictionary?["snippet"]?.dictionary?["resourceId"]?.dictionary?["videoId"]?.stringValue
      
            
            //uncomment this
            
            vc.videoID = dict.dictionary?["Results"]?.array?[indexPath.row].dictionary?["PlaylistID"]?.stringValue
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            self.showAlert(msg: "noInternetConnection".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
        
        
//        if Connectivity.isConnectedToInternet(){
//        
//        if GYSegmet.selectedSegmentIndex == 0{
//            let vc = storyboard?.instantiateViewController(withIdentifier: "GalleryDetailsViewController") as! GalleryDetailsViewController
//       
//            vc.fileStrng = myGalleryData[indexPath.row]["FileAttachment"].stringValue
//            self.navigationController?.pushViewController(vc, animated: true)
//        }else{
//            let yvc = storyboard?.instantiateViewController(withIdentifier: "YoutubeListViewController") as! YoutubeListViewController
//                yvc.playlistID = myGalleryData[indexPath.row]["PlaylistID"].stringValue
//     
//            self.navigationController?.pushViewController(yvc, animated: true)
//        }
//    
//    }else{
//            self.showAlert(msg: "noInternetConnectivityGallery".localizableString(loc:
//                UserDefaults.standard.string(forKey: "keyLang")!))
//        }
    }
}

extension GalleryViewController: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
       txt_responder = textField as? SkyFloatingLabelTextField
        if (textField == txtContentsArray)
        {
            showFormType()
            return false
        }
        return true
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        guard !(searchText.isEmpty) else{
//            tableArray = myJsonArray
//            tblParsingView.reloadData()
//            return
//        }
//
//        tableArray = myJsonArray.filter( {
//
//            print($0)
//
//            if let a = $0 as? [String:Any]
//            {
//                let b = a["FileExt"] as? String
//                let value = b!.lowercased().contains(searchText.lowercased())
//                return value
//            }
//            else
//            {
//                return false
//            }
//        })
//        tblParsingView.reloadData()
//    }
//
    }
}

extension GalleryViewController{
    
    func setupDropDown()
    {
        selectDropDown.dismissMode = .automatic
        selectDropDown.separatorColor = .lightGray
        //selectDropDown.width = view_selectDivision.frame.width
        selectDropDown.bottomOffset = CGPoint(x: 0, y: txtContentsArray.bounds.height)
        selectDropDown.direction = .bottom
        selectDropDown.cellHeight = 40
        selectDropDown.backgroundColor = .white
        // Action triggered on selection
        selectDropDown.selectionAction = {(index, item) in
            
            self.txt_responder!.text = item
            if(self.txt_responder == self.txtContentsArray)
            {
                self.parsingData()
            }
        }
    }
    
    func showFormType()
    {
        selectDropDown.dataSource = ["ALL","AUDIO","DOCUMENT","IMAGE","VIDEO"]
        selectDropDown.anchorView = self.txtContentsArray
        selectDropDown.show()
    }
}
