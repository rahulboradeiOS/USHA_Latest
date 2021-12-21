//
//  AboutViewController.swift
 
//
//  Created by Apple.Inc on 28/05/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIWebViewDelegate
{
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var view_bar: UIView!
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_close: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.delegate = self

        let htmlFile = Bundle.main.path(forResource: "term_and_condition", ofType: "html")
        let htmlString = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
        webView.loadHTMLString(htmlString!, baseURL: nil)

    }
    
    @IBAction func btn_close_pressed(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
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
