//
//  ParseDataVC.swift
//  Agora iOS Voice Tutorial
//
//  Created by Apple on 02/03/19.
//  Copyright © 2019 Agora. All rights reserved.
//

import UIKit

class ParseDataVC: UIViewController {
    
    
    @IBOutlet var tblParsingView: UITableView!
    var myJsonArray = JSON()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        parsingData()
    }
    
    func  parsingData(){
    
            
        let parameters = ["PageNumber":"1",
            "ActionTypes":"GetGalleryDetailsByMobile",
            "FromDate":"2019-01-04 16:24:22"] //6
            
            ProgressHUD.show("Please wait...", interaction: false)
            WebAPIClient.shared.parsingDataJSON(parameters, completionHandler:{ (result) in
                
                ProgressHUD.dismiss()
                
                switch (result) {
                case .Success(let responseDict, _):
                    
                    if responseDict != nil {
                        
                        let mydata  = "\(responseDict["ResponseData"])"
                        print("mydata Info : \(mydata.count)")

                        
                        let data = mydata.data(using: .utf8)!
                        do {
                            if let jsonArray = try  JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                            {
                                // use the json here

                                self.myJsonArray = JSON(jsonArray)
                                print("self.myJsonArray Info : \(self.myJsonArray.count)")

                                self.tblParsingView.reloadData()
                                
                            } else {
                                print("bad json")
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                        
                    }
                        
                    else {
                        
                        let responseMessage = responseDict["error_msg"]
                        print("Response Message : \(responseMessage)")
                        KSToastView.ks_showToast(responseMessage)
                    }
                    
                case .Failure(let failureMessage, let statusCode):
                    print("Message : \(failureMessage)")
                    print("Status Code : \(statusCode)")
                    KSToastView.ks_showToast(failureMessage)
                    break
                }
            })
            
        }
    
}


// MARK : Extensions

extension ParseDataVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(myJsonArray.count)
        return myJsonArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblParsingView.dequeueReusableCell(withIdentifier: "parseCell", for: indexPath) as! parseTableViewCell
        
        cell.lblTitle.text = myJsonArray[indexPath.row]["Title"].stringValue
        cell.lblMesssage.text = myJsonArray[indexPath.row]["Messages"].stringValue
        
        let fileExt = myJsonArray[indexPath.row]["FileExt"].stringValue
        print(fileExt)
        
        
        
        
        
        
        var imagePathString =  myJsonArray[indexPath.row]["ImageUrl"].stringValue
        imagePathString = imagePathString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let imageURL = URL(string: imagePathString)!
        print(imageURL)

        cell.imgProfile.af_setImage(withURL: imageURL,imageTransition: UIImageView.ImageTransition.flipFromLeft(0.5), completion: nil)
        
        return cell
        
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
