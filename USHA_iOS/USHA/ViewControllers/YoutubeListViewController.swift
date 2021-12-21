//
//  YoutubeListViewController.swift
 
//
//  Created by Kav Interactive on 14/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class YoutubeListViewController: BaseViewController {

    
    @IBOutlet var tableview:UITableView!
    var playlistID:String = ""
    var youtubelistArray = [String: Any]()
    var videoID:String?

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("youtubelist")
        if Connectivity.isConnectedToInternet(){
            // Do any additional setup after loading the view.
            let nib = UINib(nibName: "YoutubeListCell", bundle: nil)
            self.tableview.register(nib, forCellReuseIdentifier: "YoutubeListCell")
//            makeGetCallWithAlamofire()
            makeGetCallWithAlamofire1()
        }else{
            self.showAlert(msg: "noInternetConnection".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func btn_backPressed(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        //createMenuView()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func makeGetCallWithAlamofire() {
        let urlString: String = "https://www.googleapis.com/youtube/v3/playlistItems?playlistId=\(playlistID)&maxResults=50&part=snippet&key=AIzaSyAzgIzXHh1tvsJUO-lelRXvsb7t9w7DV7c"
        Alamofire.request(urlString)
            .responseJSON { json in
                if  json.error == nil {
                    ///////
                }
                if let jsson = json.result.value as? [String: Any] {
                    print(json)
                    self.youtubelistArray = jsson
                    print(self.youtubelistArray)
                    self.tableview.reloadData()
                }
        }
    }
    
    
    func makeGetCallWithAlamofire1() {
        let urlString: String = "https://www.googleapis.com/youtube/v3/playlistItems?playlistId=" + videoID! + "&maxResults=50&part=snippet&key=AIzaSyAzgIzXHh1tvsJUO-lelRXvsb7t9w7DV7c"
       
        Alamofire.request(urlString, method: .get , encoding:JSONEncoding.default, headers: nil).responseJSON { (json) in
            if  json.error == nil {
                ///////
            }
            print(json)
                            if let jsson = json.result.value as? [String: Any] {
                                print(json)
                                self.youtubelistArray = jsson
                                print(self.youtubelistArray)
                                self.tableview.reloadData()
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
    
}
    
extension YoutubeListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if youtubelistArray.count == 0
        {
            return 0
        }
        else
        {
            let dict = JSON(youtubelistArray)
            print(self.youtubelistArray.count)
            let array = dict.dictionary?["items"]?.array!
            return array!.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YoutubeListCell") as! YoutubeListCell
        let dict = JSON(youtubelistArray)
        print(dict)
        
        print(self.youtubelistArray.count)
        
        cell.imageVew.kf.setImage(with: dict.dictionary?["items"]?.array?[indexPath.row].dictionary?["snippet"]?.dictionary?["thumbnails"]?.dictionary?["default"]?.dictionary?["url"]?.url)
        
//        cell.imageVew.kf.setImage(with: dict.dictionary?["Results"]?.array?[indexPath.row].dictionary?["GalleryThumbnail"]?.url)
        
        cell.titleLabel.text = dict.dictionary?["items"]?.array?[indexPath.row].dictionary?["snippet"]?.dictionary?["title"]?.stringValue
        
//        cell.titleLabel.text = dict.dictionary?["Results"]?.array?[indexPath.row].dictionary?["PlaylistName"]?.stringValue
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if Connectivity.isConnectedToInternet(){
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "YoutubeDetailsViewController") as! YoutubeDetailsViewController
            
            let dict = JSON(youtubelistArray)
            
            vc.videoID = dict.dictionary?["items"]?.array?[indexPath.row].dictionary?["snippet"]?.dictionary?["resourceId"]?.dictionary?["videoId"]?.stringValue
            
//            vc.videoID = dict.dictionary?["Results"]?.array?[indexPath.row].dictionary?["PlaylistID"]?.stringValue
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            self.showAlert(msg: "noInternetConnection".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
     
    }
}
