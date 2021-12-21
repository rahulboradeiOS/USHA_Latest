//
//  ProfileViewController.swift
 
//
//  Created by Apple.Inc on 04/07/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController
{
    @IBOutlet weak var webView: UIWebView!

    var loadUrl:String!
    var AccessToken: String!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let url = URL (string: loadUrl)
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)
        webView.delegate = self
    }

    override func onBackButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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

extension ProfileViewController:UIWebViewDelegate
{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
//        if let url = request.url?.absoluteString {
//            if url == strReturnUrl
//            {
//                print(url)
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
        return true
    }
}
