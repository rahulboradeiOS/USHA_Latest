//
//  AnnouncementDetailsViewController.swift
 
//
//  Created by Gaurav Oka on 05/10/20.
//  Copyright © 2020 Apple.Inc. All rights reserved.
//

import UIKit

class AnnouncementDetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet weak var btnAttachment: UIButton!

    @IBOutlet weak var imgIcon: UIImageView!
    
    var data_array = [String:Any]()
    
    var attachmentPath : String = ""
    var path:String?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupView()
    }
    
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setupView() {
        let item = data_array
        if let title = item["s_Titile"] as? String,let textMsg = item["s_TextMessage"] as? String,let docType = item["s_AttachmentType"] as? String
            
        {
            let attachmentPathLink = item["s_AttachementPath"] as? String
            if attachmentPathLink != nil{
                showPopUPView(title: title, textMsg: textMsg, imagePath: attachmentPathLink ?? "", docType: docType)
                self.attachmentPath = attachmentPathLink ?? ""
            }else{
                showPopUPView(title: title, textMsg: textMsg, imagePath: attachmentPathLink ?? "", docType: docType)
                self.attachmentPath = attachmentPathLink ?? ""
            }
            

//            showPopUPView(title: title, textMsg: textMsg, imagePath: attachmentPathLink, docType: docType)
//            self.attachmentPath = attachmentPathLink
        }
  
    }
    
    func showPopUPView(title : String,textMsg:String , imagePath : String , docType:String){

//        didSelectView.frame  = CGRect(x: 0, y: 0, width: self.view.frame.width - 55 , height: 390 )
//        didSelectView.frame = myPopUpView.frame
////        didSelectView.center = view.center
//        didSelectView.layer.borderWidth = 1
//
//        didSelectView.layer.borderColor = UIColor.red.cgColor
//        self.view.addSubview(didSelectView)
        
   
            
             if docType == "Image"{

                guard let url = URL(string: mainUrlPowerPlus + "/notificationupload/\(imagePath)") else { return }
                
                           UIImage.loadFrom(url: url) { image in
                               self.imgIcon.image = image
                           }
                           
                           self.btnAttachment.setTitle("VIEW IMAGE", for: .normal)
                           //self.btnAttachment.accessibilityValue = viewModel.sAttachementPath
                           self.btnAttachment.isHidden = false
                            attachmentPath = imagePath
                            self.btnAttachment.addTarget(self, action: #selector(viewMode), for: .touchUpInside)


                       }else if docType == "Document"{
                           
                           self.imgIcon.image = UIImage(named: "documentPop")
                           self.btnAttachment.setTitle("VIEW DOCUMENT", for: .normal)
                        self.btnAttachment.isHidden = false
                        attachmentPath = imagePath
                        self.btnAttachment.addTarget(self, action: #selector(viewMode), for: .touchUpInside)
                       //self.btnAttachment.accessibilityValue = viewModel.sAttachementPath
                       }else if docType == "Video"{
                           
                           self.imgIcon.image = UIImage(named: "videoPop")
                           self.btnAttachment.setTitle("VIEW VIDEO", for: .normal)
                            self.btnAttachment.isHidden = false
                            attachmentPath = imagePath
                        self.btnAttachment.addTarget(self, action: #selector(viewMode), for: .touchUpInside)
                          // self.btnAttachment.accessibilityValue = viewModel.sAttachementPath

                       }else  if docType == "Audio"{
                           self.imgIcon.image = UIImage(named: "audioPop")
                           self.btnAttachment.setTitle("LISTEN AUDIO", for: .normal)
                        self.btnAttachment.isHidden = false
                        attachmentPath = imagePath
                        self.btnAttachment.addTarget(self, action: #selector(viewMode), for: .touchUpInside)
                          // self.btnAttachment.accessibilityValue = viewModel.sAttachementPath
                           
                       }else{
                           self.btnAttachment.isHidden = true
                           self.imgIcon.image = UIImage(named: "TextPop")

                       }
            
            self.titleLabel.text = title
            self.subtitleLabel.text = textMsg
       
        
//        self.didSelectView.transform =  CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
//
//        UIView.animate(withDuration: 0.3 / 1.5, animations: {() -> Void in
//
//            self.didSelectView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
//        }, completion: {(finished: Bool) -> Void in
//            UIView.animate(withDuration: 0.3 / 2, animations: {() -> Void in
//
//                self.didSelectView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
//            }, completion: {(finished: Bool) -> Void in
//                UIView.animate(withDuration: 0.3 / 2, animations: {() -> Void in
//
//                    self.didSelectView.transform = CGAffineTransform.identity
//                })
//            })
//        })


    }
    @objc func viewMode() {
        if self.attachmentPath != ""{
            let urlPath = mainUrlPowerPlus + "/notificationupload/\(self.attachmentPath)"
            guard let url = URL(string: urlPath) else { return }
            UIApplication.shared.open(url)
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
