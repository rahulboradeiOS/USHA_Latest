//
//  BalanceDetailPopupViewController.swift
 
//
//  Created by Apple.Inc on 23/06/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit

class BalanceDetailPopupViewController: UIViewController {

    @IBOutlet weak var tableView_Balance: UITableView!
    @IBOutlet weak var tableView_Balance_Height: NSLayoutConstraint!
    @IBOutlet weak var alertView: UIView!
    
    var arrKeyValue = [[String:Any]]()
    
    //var arrScheme = [Scheme]()

    @IBOutlet weak var lbl_coloum1: UILabel!
    @IBOutlet weak var lbl_coloum2: UILabel!
    
    @IBOutlet weak var lbl_header: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
       tableView_Balance.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        addTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 2
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    func addTapGesture()
    {
        //add tapgesture
        let reginTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
        reginTapGesture.numberOfTapsRequired = 1
        //reginTapGesture.delegate = self
        view.addGestureRecognizer(reginTapGesture)
        reginTapGesture.cancelsTouchesInView = false
    }
    
    @objc func tapView(_ sender: UITapGestureRecognizer)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        tableView_Balance_Height.constant = tableView_Balance.contentSize.height
    }
    
    deinit {
        tableView_Balance.removeObserver(self, forKeyPath: "contentSize")
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
extension BalanceDetailPopupViewController: UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrKeyValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BalanceTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if (indexPath.row % 2) == 0
        {
            //cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.lbl_schemeName.textColor = .blue
            cell.lbl_balance.textColor = .blue
        }
        else
        {
            //cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            cell.lbl_schemeName.textColor = .red
            cell.lbl_balance.textColor = .red
        }
        
        let item = arrKeyValue[indexPath.row]
        
        cell.lbl_schemeName.text = item["key"] as? String //scheme.s_SchemePromName!
        cell.lbl_balance.text = item["value"] as? String //"\(scheme.d_Balance!)"
       
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

class BalanceTableViewCell : UITableViewCell
{
    @IBOutlet weak var lbl_schemeName: UILabel!
    @IBOutlet weak var lbl_balance: UILabel!
}

