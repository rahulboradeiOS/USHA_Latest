//
//  AnnouncementViewController.swift
//  ELECTRICIAN
//
//  Created by Apple.Inc on 04/02/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit

@objc protocol AnnouncementDelegate: AnyObject
{
    @objc optional func didColseFlashMessage()
    @objc optional func didPressedViewMore(file:String)
}

class AnnouncementViewController: UIViewController 
{
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var tableView_Announcement: UITableView!
    @IBOutlet weak var tableView_Balance_Height: NSLayoutConstraint!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var btn_close: UIButton!
    
    var delegate: AnnouncementDelegate?

    var data_array = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView_Announcement.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)

        //addTapGesture()
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_viewMore_pressed(_ sender: UIButton)
    {
        let item = data_array[sender.tag]
        if let  s_AttachementPath = item["s_AttachementPath"] as? String,
            s_AttachementPath != ""
        {
            delegate?.didPressedViewMore?(file: s_AttachementPath)
            //self.dismiss(animated: true, completion: nil)
        }
    }
}

extension AnnouncementViewController: UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return data_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AnnouncementTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
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
        cell.lbl_Detail.text = item["s_TextMessage"] as? String 
        cell.btn_viewMore.tag = indexPath.row
        
        if let  s_AttachementPath = item["s_AttachementPath"] as? String,
                s_AttachementPath != ""
        {
            cell.btn_viewMore.isHidden = false
        }
        else
        {
            cell.btn_viewMore.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
