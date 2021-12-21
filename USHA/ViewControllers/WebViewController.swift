//
//  PaymentViewController.swift
 
//
//  Created by Apple.Inc on 24/05/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var view_bar: UIView!
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_close: UIButton!
    
    var loadUrl:String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("web")
        let url = URL (string: loadUrl)
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)
        webView.delegate = self
    }

    @IBAction func btn_close_pressed(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension WebViewController:UIWebViewDelegate
{
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {

        return true
    }

}
