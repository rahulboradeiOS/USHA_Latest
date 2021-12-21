//
//  DetailsVC.swift
 
//
//  Created by Uday Eega on 01/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {
    var detaiLSDICT: [String:Any]?
    var webView = UIWebView()
    var dict = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dict = detaiLSDICT {
            
            let urlStr: String = "\(mainUrl)api/AdminMaster/GetGalleryDetailList/\(dict["stri"] as? String ?? "")"
            if let url = URL(string: urlStr) {
                webView.loadRequest(URLRequest(url: url))
            }
        }
        // Do any additional setup after loading the view.
    }
    
    
    
}
extension DetailsVC: UIWebViewDelegate {
    
    
    
}
