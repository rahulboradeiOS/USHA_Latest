//
//  POSMViewController.swift
//  SAMPARK
//
//  Created by Naveen on 05/07/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class POSMViewController: ViewController {

    var arrayJson = JSON()
    
    @IBOutlet weak var posmServiceRequest: UITableView!
    @IBOutlet weak var Seg_posmServiceRequest: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegmentCtrl()

    }
    override func onBackButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        posmServiceRequest.delegate = self
        posmServiceRequest.dataSource = self
        
    }
    @IBAction func Seg_posmServiceRequest_Pressed(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            sender.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
            print("index 0. pressed")
        }else{
            sender.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
            print("index 1. pressed")
        }
        self.posmServiceRequest.reloadData()
    }
    func setUpSegmentCtrl(){
        let font = UIFont.systemFont(ofSize: 18)
        self.navigationController?.navigationBar.isHidden = false
        Seg_posmServiceRequest.selectedSegmentIndex = 0
        Seg_posmServiceRequest.backgroundColor = UIColor.init(red: 237/255, green: 27/255, blue: 35/255, alpha: 1.0)
        Seg_posmServiceRequest.tintColor = UIColor.init(red: 237/255, green: 27/255, blue: 35/255, alpha: 1.0)
        Seg_posmServiceRequest.setTitleTextAttributes([
            NSAttributedStringKey.font : font,
            NSAttributedStringKey.foregroundColor: UIColor.white
            ], for: .normal)
        Seg_posmServiceRequest.setTitleTextAttributes([
            NSAttributedStringKey.font : font,
            NSAttributedStringKey.foregroundColor: UIColor.white
            ], for: .selected)
    }
}
extension POSMViewController :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Seg_posmServiceRequest.selectedSegmentIndex == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "posmServiceRequestTableViewCell", for: indexPath) as! posmServiceRequestTableViewCell
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PosmServiceStatusTableViewCell", for: indexPath) as! PosmServiceStatusTableViewCell
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Seg_posmServiceRequest.selectedSegmentIndex == 0{
            return 1000
        }else{
            return 600
        }
    }
}
