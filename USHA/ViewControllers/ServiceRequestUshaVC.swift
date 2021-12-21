//
//  ServiceRequestUshaVC.swift
 
//
//  Created by pro on 14/05/2020.
//  Copyright © 2020 Apple.Inc. All rights reserved.
//

import UIKit
import WebKit


class ServiceRequestUshaVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DispatchQueue.main.async {
            
              let url = URL(string: "https://app.servitiumcrm.com/usha/getCustomerInfo.jsp")
            self.webView.load(URLRequest(url: url!))
        }
        
    }
    

    @IBAction func btn_Back_pressed(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
  

}
