//
//  SocialNetworkingViewController.swift
 
//
//  Created by Gaurav Oka on 06/10/20.
//  Copyright © 2020 Apple.Inc. All rights reserved.
//

import UIKit



enum SocialNetworkingViewControllerAction: String
{
    case FACEBOOK
    case INSTAGRAM
    case YOUTUBE
    case TWITTER
    case SEWINGBLOGS
    case none


}

class SocialNetworkingViewController: BaseViewController {
    
    
    @IBOutlet weak var collectionView_dashboard: UICollectionView!

    
    
    
    var action:SocialNetworkingViewControllerAction = .none

    
    var dashboard_menus = [
//        ["menu": "dashboard_menu".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "icon_dash.jpg", "action":HomeViewControllerAction.DASHBOARD],
                          ["menu":"FACEBOOK".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "ic_fb.png", "action": SocialNetworkingViewControllerAction.FACEBOOK],
                          ["menu":"TWITTER".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "ic_tweet.png", "action": SocialNetworkingViewControllerAction.TWITTER],
                          ["menu":"INSTAGRAM".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "ic_insta.png", "action": SocialNetworkingViewControllerAction.INSTAGRAM],

                          ["menu":"YOUTUBE".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "ic_youtube.png", "action": SocialNetworkingViewControllerAction.YOUTUBE],
        
                          ["menu":"SEWINGBLOGS".localizableString(loc:UserDefaults.standard.string(forKey: "keyLang")!), "img": "ic_swblog.png", "action": SocialNetworkingViewControllerAction.SEWINGBLOGS],
                   
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuItem()

        collectionView_dashboard.delegate = self
        collectionView_dashboard.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated:true)
    }
    
    func didSelect(menu:SocialNetworkingViewControllerAction)
    {
        switch menu
        {
        case .FACEBOOK:
            //go to facebook link
            let wkVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.WKWebViewController) as! WKWebViewController
            
            wkVC.loadUrl = "https://www.facebook.com/UshaInternational"
            wkVC.fromVC = "Facebook"
            self.navigationController?.pushViewController(wkVC, animated: true)
            break
        case .INSTAGRAM:
            //go to insta link
            let wkVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.WKWebViewController) as! WKWebViewController
            
            wkVC.loadUrl = "https://www.instagram.com/usha_international/?hl=en"
            wkVC.fromVC = "Insta"
            self.navigationController?.pushViewController(wkVC, animated: true)
            break
        case .YOUTUBE:
            //go to youtube link
            let wkVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.WKWebViewController) as! WKWebViewController
            
            wkVC.loadUrl = "https://www.youtube.com/user/UshaEvents"
            wkVC.fromVC = "Youtube"
            self.navigationController?.pushViewController(wkVC, animated: true)
            break
        case .TWITTER:
            //go to twitter link
            let wkVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.WKWebViewController) as! WKWebViewController
            
            wkVC.loadUrl = "https://twitter.com/UshaIntl"
            wkVC.fromVC = "Twitter"
            self.navigationController?.pushViewController(wkVC, animated: true)
            break
        case .SEWINGBLOGS:
            //go to sewingblogs link
            let wkVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.WKWebViewController) as! WKWebViewController
            
            wkVC.loadUrl = "https://www.ushasew.com/blog/#"
            wkVC.fromVC = "Sewingblogs"
            self.navigationController?.pushViewController(wkVC, animated: true)
            break
        case .none:
            break
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

extension SocialNetworkingViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let titleDic = dashboard_menus[indexPath.item]
        if let menu = titleDic["action"] as? SocialNetworkingViewControllerAction
        {
            didSelect(menu: menu)
        }
    }
}

extension SocialNetworkingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        if section == 0
//        {
//            return 2
//        }
        return dashboard_menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2",for: indexPath) as! DashboardCollectionViewCell
        let titleDic = dashboard_menus[indexPath.item]
        let img = UIImage.init(named: (titleDic["img"] as! String))
        
        cell.img_icon.image = img //?.withRenderingMode(.alwaysTemplate)
        let menu = titleDic["menu"] as! String
        cell.lbl_title.text = menu
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (collectionView.frame.size.width - 16) / 3
        
        let height = (collectionView.frame.size.height - 50) / 4.5
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }

}
