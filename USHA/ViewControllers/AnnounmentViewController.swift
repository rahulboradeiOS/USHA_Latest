//
//  AnnounmentViewController.swift
 
//
//  Created by Kav Interactive on 10/03/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit
import SwiftyGif


@objc protocol AnnouncementDelegate: AnyObject
{
    @objc optional func didColseFlashMessage()
    @objc optional func didPressedViewMore(file:String)
}

class AnnounmentViewController: UIViewController , SwipeableCardViewDataSource {
   
  
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var tableView_Announcement: UITableView!
    @IBOutlet weak var tableView_Balance_Height: NSLayoutConstraint!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var btn_close: UIButton!
    @IBOutlet weak var lbl_Announcement: UILabel!
    @IBOutlet weak var myPopUpView: SwipeableCardViewContainer!

    @IBOutlet weak var didSelectView: UIView!

    @IBOutlet  weak var titleLabel: UILabel!
    @IBOutlet  weak var subtitleLabel: UILabel!
    @IBOutlet  weak var btnAttachment: UIButton!
    @IBOutlet  weak var imgIcon: UIImageView!

    
    var delegate: AnnouncementDelegate?
    
    var data_array = [[String:Any]]()
    var popUpArray = [[String:Any]]()
    var popModelData : [SampleSwipeableCellViewModel] = []
    var foundItems: [Bool] = []
    var id: Int!
    var attachmentPath : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.didSelectView.layer.cornerRadius = 10
        self.didSelectView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
        tableView_Announcement.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        self.myPopUpView.isHidden = true

        //addTapGesture()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        myPopUpView.addGestureRecognizer(tap)
        

    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                self.didSelectView.removeFromSuperview()
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                self.didSelectView.removeFromSuperview()
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
 

    override func viewDidAppear(_ animated: Bool) {
        
   
//        self.popUpArray = data_array.filter {($0["IsAutoPopup"] as! Bool == true)}
//        print(self.popUpArray)
//
//        let myData = JSON(self.popUpArray)
//        print(myData)
//
//        if myData.count > 0{
//
//             do {
//
//                let jsonData = try JSONSerialization.data(withJSONObject: self.popUpArray, options: [])
//                let jsonDecoder = JSONDecoder()
//
//
//                self.popModelData = try jsonDecoder.decode([SampleSwipeableCellViewModel].self, from: jsonData)
//
//                self.myPopUpView.dataSource = self
//
//                self.myPopUpView.isHidden = false
//
//                }catch let error as NSError {
//                    print(error)
//                }
//        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
                    swipeRight.direction = UISwipeGestureRecognizerDirection.right
                    self.didSelectView.addGestureRecognizer(swipeRight)

                    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
                    swipeDown.direction = UISwipeGestureRecognizerDirection.left
                    self.didSelectView.addGestureRecognizer(swipeDown)
           
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.myPopUpView.isHidden = true
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
      
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 16
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        alertView.alpha = 0;
        //self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            //self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    func addTapGesture()
    {
        //add tapgesture
        let reginTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
        reginTapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(reginTapGesture)
        reginTapGesture.cancelsTouchesInView = false
    }
    
    @objc func tapView(_ sender: UITapGestureRecognizer)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        let height = tableView_Announcement.contentSize.height
        if height > (self.view.frame.height - 100)
        {
            tableView_Balance_Height.constant = self.view.frame.height - 100
        }
        else
        {
            tableView_Balance_Height.constant = height
        }
    }
    
    deinit {
        tableView_Announcement.removeObserver(self, forKeyPath: "contentSize")
    }
    
    @IBAction func btn_close_pressed(_ sender: UIButton)
    {
        delegate?.didColseFlashMessage?()
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_viewMore_pressed(_ sender: UIButton)
    {
        
        let announcementDetailsVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.AnnouncementDetailsViewController) as! AnnouncementDetailsViewController
        announcementDetailsVC.data_array = data_array[sender.tag]
        self.navigationController?.pushViewController(announcementDetailsVC, animated: true)
        
//        let item = data_array[sender.tag]
//        if let title = item["s_Titile"] as? String,let textMsg = item["s_TextMessage"] as? String,let docType = item["s_AttachmentType"] as? String
//            
//        {
//            let attachmentPathLink = item["s_AttachementPath"] as? String
//            if attachmentPathLink != nil{
//                showPopUPView(title: title, textMsg: textMsg, imagePath: attachmentPathLink ?? "", docType: docType)
//                self.attachmentPath = attachmentPathLink ?? ""
//            }else{
//                showPopUPView(title: title, textMsg: textMsg, imagePath: attachmentPathLink ?? "", docType: docType)
//                self.attachmentPath = attachmentPathLink ?? ""
//            }
//            
//
////            showPopUPView(title: title, textMsg: textMsg, imagePath: attachmentPathLink, docType: docType)
////            self.attachmentPath = attachmentPathLink
//        }
        
    }
    
    
    @IBAction func btn_LoadAttachment_pressed(_ sender: UIButton)
    {
        if self.attachmentPath != ""{
            let urlPath = mainUrlPowerPlus + "notificationupload/\(self.attachmentPath)"
            guard let url = URL(string: urlPath) else { return }
            UIApplication.shared.open(url)
        }
        
    }
    
  
    
    func numberOfCards() -> Int {
        return self.popModelData.count
    }
    
    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard {
     
        let viewModel = self.popModelData[index]
        let cardView = SampleSwipeableCard()
        cardView.viewModel = viewModel
        return cardView
    }
    
    
    func viewForEmptyCards() -> UIView? {
        self.myPopUpView.isHidden = true
        return nil
    }
    

    func showPopUPView(title : String,textMsg:String , imagePath : String , docType:String){

//        didSelectView.frame  = CGRect(x: 0, y: 0, width: self.view.frame.width - 55 , height: 390 )
        didSelectView.frame = myPopUpView.frame
//        didSelectView.center = view.center
        didSelectView.layer.borderWidth = 1

        didSelectView.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(didSelectView)
 
             if docType == "Image"{

                guard let url = URL(string: mainUrlPowerPlus + "notificationupload/\(imagePath)") else { return }

                           UIImage.loadFrom(url: url) { image in
                               self.imgIcon.image = image
                           }
                           
                           self.btnAttachment.setTitle("VIEW IMAGE", for: .normal)
                        //   self.btnAttachment.accessibilityValue = viewModel.sAttachementPath
                           self.btnAttachment.isHidden = false

                       }else if docType == "Document"{
                           
                           self.imgIcon.image = UIImage(named: "documentPop")
                           self.btnAttachment.setTitle("VIEW DOCUMENT", for: .normal)
                        self.btnAttachment.isHidden = false
                       //self.btnAttachment.accessibilityValue = viewModel.sAttachementPath
                       }else if docType == "Video"{
                           
                           self.imgIcon.image = UIImage(named: "videoPop")
                           self.btnAttachment.setTitle("VIEW VIDEO", for: .normal)
                            self.btnAttachment.isHidden = false
                          // self.btnAttachment.accessibilityValue = viewModel.sAttachementPath

                       }else  if docType == "Audio"{
                           self.imgIcon.image = UIImage(named: "audioPop")
                           self.btnAttachment.setTitle("LISTEN AUDIO", for: .normal)

                self.btnAttachment.isHidden = false
                          // self.btnAttachment.accessibilityValue = viewModel.sAttachementPath
                           
                       }else{
                           self.btnAttachment.isHidden = true
                           self.imgIcon.image = UIImage(named: "TextPop")

                       }
            
            self.titleLabel.text = title
            self.subtitleLabel.text = textMsg
       
        
        self.didSelectView.transform =  CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)

        UIView.animate(withDuration: 0.3 / 1.5, animations: {() -> Void in

            self.didSelectView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }, completion: {(finished: Bool) -> Void in
            UIView.animate(withDuration: 0.3 / 2, animations: {() -> Void in

                self.didSelectView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            }, completion: {(finished: Bool) -> Void in
                UIView.animate(withDuration: 0.3 / 2, animations: {() -> Void in

                    self.didSelectView.transform = CGAffineTransform.identity
                })
            })
        })


    }
    
    
    @IBAction func btn_CloseDidSelectView_pressed(_ sender: UIButton)
    {
        removePopUpView()
    }
    
    func removePopUpView() {

        UIView.animate(withDuration: 0.3, animations: {() -> Void in

                self.didSelectView.removeFromSuperview()

        }, completion: nil)
    }


  
}

extension AnnounmentViewController: UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

            return data_array.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AnnouncementTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            print(data_array)
            
            //        if (indexPath.row % 2) == 0
            //        {
            //            cell.lbl_schemeName.textColor = .blue
            //            cell.lbl_balance.textColor = .blue
            //        }
            //        else
            //        {
            //            cell.lbl_schemeName.textColor = .red
            //            cell.lbl_balance.textColor = .red
            //        }
            
            let item = data_array[indexPath.row]
            
            cell.lbl_Title.text = item["s_Titile"] as? String
        
       
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
           
            let getString = item["d_Fromdate"] as! String
            let passString = getString.prefix(19)
            print(passString)
           
           
        if let d = dateFormatter.date(from: "\(passString)")
           {
               dateFormatter.dateFormat = "dd MMM,yyyy | hh:mm a "
               let dstr = dateFormatter.string(from: d)
            cell.lbl_Detail.text = "\(dstr)"

           }

            cell.btn_viewMore.tag = indexPath.row
            
//            if let  s_AttachementPath = item["s_AttachementPath"] as? String,
//                s_AttachementPath != ""
//            {
//                cell.btn_viewMore.isHidden = false
//            }
//            else
//            {
//                cell.btn_viewMore.isHidden = true
//            }
            
            return cell
 
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
     
            return UITableViewAutomaticDimension

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}

class AnnouncementTableViewCell : UITableViewCell
{
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Detail: UILabel!
    @IBOutlet weak var btn_viewMore: UIButton!
}
