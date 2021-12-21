//
//  GalleryDetailsViewController.swift
 
//
//  Created by Naveen on 03/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit
import WebKit
class GalleryDetailsViewController: BaseViewController, WKNavigationDelegate {

//    @IBOutlet weak var NavigationBar: NavigationUIView!
    @IBOutlet var webVw: WKWebView!
    @IBOutlet var progressView:UIProgressView!
    var fileStrng = ""
    var srtng = "\(mainUrl)/NotificationUpload/"
    var newUrl = "http://mobileapps.usha.com:6060/SFAService/SFAService.svc/GetGalleryDetailsForRetailer"
    
    var observer: NSKeyValueObservation?
    var progressTintColor: UIColor = #colorLiteral(red: 0.3607843137, green: 0.3882352941, blue: 0.4039215686, alpha: 1)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Connectivity.isConnectedToInternet(){
        
            let urlstrng = srtng + fileStrng
            print(urlstrng)
            self.navigationController?.navigationBar.isHidden = false
            print(fileStrng)
            let furl = URL(string: urlstrng)!
            let rew = URLRequest(url: furl)
            self.webVw.load(rew)
            initUI()
        }else{
            self.showAlert(msg: "noInternetConnection".localizableString(loc:
                UserDefaults.standard.string(forKey: "keyLang")!))
        }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        print("gak")

        // Do any additional setup after loading the view.
    }
    func btn_backPressed(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
        
    override func onBackButtonPressed(_ sender: UIButton) {
//        //createMenuView()
        self.navigationController?.popViewController(animated: true)
    }
    

    
    private func initUI() {
        webVw.navigationDelegate = self
        observer = webVw.observe(\.estimatedProgress, options: .new) { _, change in
            if let value = change.newValue {
                if value == 1.0 {
                    self.progressView.setProgress(1.0, animated: true)
                    self.progressView.progressTintColor = self.progressTintColor
                } else {
                    self.progressView.setProgress(Float(value), animated: true)
                }
                
            } else {
                self.progressView.setProgress(0.0, animated: true)
            }
        }
    }


}
