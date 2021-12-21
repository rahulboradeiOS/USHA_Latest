//
//  PosmServiceStatusTableViewCell.swift
 
//
//  Created by Naveen on 08/08/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class PosmServiceStatusTableViewCell: UITableViewCell {
    
    
    let loadUrl = "http://10.199.6.199:8090/HistoryApp/Index?Source=NewDealerPortal%20&TOKEN=\(UserDefaults.standard.string(forKey: "accessToken")!)"
    @IBOutlet weak var WebView: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let url = URL (string: loadUrl)
        print(url!)
        let requestObj = URLRequest(url: url!)
        WebView.loadRequest(requestObj)
        WebView.delegate = self as UIWebViewDelegate
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension PosmServiceStatusTableViewCell:UIWebViewDelegate
{
    private func WebView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        return true
    }
}

