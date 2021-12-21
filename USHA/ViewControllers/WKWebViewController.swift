//
//  WKWebViewController.swift
 
//
//  Created by Gaurav Oka on 06/10/20.
//  Copyright © 2020 Apple.Inc. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {
    
    
    @IBOutlet weak var wkWebView: WKWebView!
    var loadUrl:String!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    var downloadPDF:UIButton!
    var mimeTypes:[String]!
    var pdfLink:URL!

    var fromVC:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadButton.isHidden = true
        print("web")
        if fromVC == "Catalog" {
            headerLabel.text = "CATALOG"
        }else if fromVC == "Contactus" {
            headerLabel.text = "ENQUIRY"

        }else if fromVC == "Facebook" {
            headerLabel.text = "FACEBOOK"

        }else if fromVC == "Insta" {
            headerLabel.text = "INSTAGRAM"

        }else if fromVC == "Twitter" {
            headerLabel.text = "TWITTER"

        }else if fromVC == "Sewingblogs" {
            headerLabel.text = "SEWING BLOGS"

        }else {
            headerLabel.text = "SOCIAL NETWORKING"

        }
        mimeTypes = ["pdf"]
        if let link = URL(string:loadUrl) {
        let request = URLRequest(url: link)
        wkWebView.load(request)
        }else {
            let alert = UIAlertController(title: "", message: "URL NOT AVAILABLE OR WRONG URL PROVIDED", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        self.view.makeToastActivity()
        self.wkWebView.navigationDelegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let mimeType = navigationResponse.response.mimeType {
            if isMimeTypeConfigured(mimeType) {
                if let url = navigationResponse.response.url {
                    let fileName = getFileNameFromResponse(navigationResponse.response) ?? "default"
                    downloadData(fromURL: url, fileName: url.lastPathComponent) { success, destinationURL in
                        if success, let destinationURL = destinationURL {
                            self.pdfLink = destinationURL
                            DispatchQueue.main.async {
                                self.downloadButton.isHidden = false
                            }
                        }
                    }
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.allow)
    }
    private func getFileNameFromResponse(_ response:URLResponse) -> String? {
        if let httpResponse = response as? HTTPURLResponse {
            let headers = httpResponse.allHeaderFields
            if let disposition = headers["Content-Disposition"] as? String {
                let components = disposition.components(separatedBy: " ")
                if components.count > 1 {
                    let innerComponents = components[1].components(separatedBy: "=")
                    if innerComponents.count > 1 {
                        if innerComponents[0].contains("filename") {
                            return innerComponents[1]
                        }
                    }
                }
            }
        }
        return nil
    }
    private func isMimeTypeConfigured(_ mimeType:String) -> Bool {
        for type in self.mimeTypes {
            if mimeType.contains(type) {
                return true
            }
        }
        return false
    }
    
    private func moveDownloadedFile(url:URL, fileName:String) -> URL {
        let tempDir = NSTemporaryDirectory()
        let destinationPath = tempDir + fileName
        let destinationURL = URL(fileURLWithPath: destinationPath)
        try? FileManager.default.removeItem(at: destinationURL)
        try? FileManager.default.moveItem(at: url, to: destinationURL)
        return destinationURL
    }
    @IBAction func downloadBtn(_ sender: UIButton) {
        fileDownloadedAtURL(url: pdfLink)
    }
    func fileDownloadedAtURL(url: URL) {
           DispatchQueue.main.async {
               let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
               activityVC.popoverPresentationController?.sourceView = self.view
               activityVC.popoverPresentationController?.sourceRect = self.view.frame
               activityVC.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
               self.present(activityVC, animated: true, completion: nil)
           }
       }
    private func downloadData(fromURL url:URL,
                                fileName:String,
                                completion:@escaping (Bool, URL?) -> Void) {
          if #available(iOS 11.0, *) {
              wkWebView.configuration.websiteDataStore.httpCookieStore.getAllCookies() { cookies in
               
                  let session = URLSession.shared
              print(session.configuration.httpCookieStorage?.cookies(for: url))
                  session.configuration.httpCookieStorage?.setCookies(cookies, for: url, mainDocumentURL: nil)
               let tempDir = NSTemporaryDirectory()
                         let destinationPath = tempDir + fileName
               if FileManager.default.contents(atPath: destinationPath) != nil {
                   let destinationURL = URL(fileURLWithPath: destinationPath)
                   completion(true, destinationURL)
               } else {
                  let task = session.downloadTask(with: url) { localURL, urlResponse, error in
                      if let localURL = localURL {
                          let destinationURL = self.moveDownloadedFile(url: localURL, fileName: fileName)
                          completion(true, destinationURL)
                      }
                      else {
                          completion(false, nil)
                      }
                  }
                  
                  task.resume()
               }
              }
          } else {
          }
      }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WKWebViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.view.hideToastActivity()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.view.hideToastActivity()
    }
}
