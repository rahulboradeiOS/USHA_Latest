//
//  YoutubeDetailsViewController.swift
 
//
//  Created by apple on 06/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit
import AVKit
import WebKit
class YoutubeDetailsViewController: BaseViewController, WKNavigationDelegate {
    
    @IBOutlet var progressVw: UIProgressView!
    @IBOutlet weak var wv: WKWebView!
    
    var observer: NSKeyValueObservation?
    var progressTintColor: UIColor = #colorLiteral(red: 0.3607843137, green: 0.3882352941, blue: 0.4039215686, alpha: 1)
    var videoID:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("youtubeDetails")

        initUI()
        
        guard let ID = videoID else { return }
        
        let youtubestrng = "https://www.youtube.com/embed/\(ID)"
        let feurl = URL(string: youtubestrng)
        let rew = URLRequest(url: feurl!)
        self.wv.load(rew)
        self.navigationController?.navigationBar.isHidden = false
        // loadYoutube(videoID: "oCm_lnoVf08")
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func btn_backPressed(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        //createMenuView()self.navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
//        func loadYoutube(videoID:String) {
//            guard  let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)")
//                else { return }
//            wv.load( URLRequest(url: youtubeURL) )
//        }
    private func initUI() {
        wv.navigationDelegate = self
        observer = wv.observe(\.estimatedProgress, options: .new) { _, change in
            if let value = change.newValue {
                if value == 1.0 {
                    self.progressVw.setProgress(1.0, animated: true)
                    self.progressVw.progressTintColor = self.progressTintColor
                } else {
                    self.progressVw.setProgress(Float(value), animated: true)
                }
                
            } else {
                self.progressVw.setProgress(0.0, animated: true)
            }
        }
    }
}

