//
//  posmServiceRequestTableViewCell.swift
 
//
//  Created by Naveen on 08/08/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class posmServiceRequestTableViewCell: UITableViewCell {
    
   // var loadUrl = "http://10.199.6.199:8090/HistoryApp/Index?Source=NewDealerPortal%20&TOKEN=\(UserDefaults.standard.string(forKey: "accessToken") ?? "")"

    let loadUrl = ""

    @IBOutlet weak var WebView: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let url = URL (string: loadUrl)
        print(url)
        let requestObj = URLRequest(url: url!)
        WebView.loadRequest(requestObj)
        WebView.delegate = self 
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
extension posmServiceRequestTableViewCell:UIWebViewDelegate
{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        return true
    }
}

