//
//  ServiceRequestTableViewCell.swift
 
//
//  Created by Naveen on 16/07/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

class ServiceRequestTableViewCell: UITableViewCell {
    
    

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
        
        // Configure the view for the selected state
    }
    
}
extension ServiceRequestTableViewCell:UIWebViewDelegate
{
    func WebView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        return true
    }
}

