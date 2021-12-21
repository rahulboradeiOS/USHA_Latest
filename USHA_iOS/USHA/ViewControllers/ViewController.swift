
//
//  ViewController.swift
 
//
//  Created by Apple.Inc on 13/02/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import SwiftyGif

func isUserExist() -> Bool
{
    return UserDefaults.standard.object(forKey: defaultsKeys.mobile) != nil
}

func isLogin() -> Bool
{
    if let login =  UserDefaults.standard.object(forKey: defaultsKeys.login) as? Bool
    {
        return login
    }
    return false
}

func isPasswordSet() -> Bool
{
    return UserDefaults.standard.object(forKey: defaultsKeys.password) != nil
}

class ViewController: UIViewController {
    
    var window: UIWindow?

    var isFirstTimeLoad : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //        let gif = UIImage(gifName: "Splash-Logo-animated.gif")
        //        let imageview = UIImageView(gifImage: gif, loopCount: 1) // Use -1 for infinite loop
        //        imageview.frame = view.bounds
        //        imageview.delegate = self
        //        view.addSubview(imageview)
        do {
//            let gif = try? UIImage(gifName: "Splash-Logo-animated.gif")
//            let imageview = UIImageView(gifImage: gif!, loopCount: 3) // Use -1 for infinite loop
//            imageview.frame = view.bounds
//            view.addSubview(imageview)
        }
        
        self.perform(#selector(ViewController.addNextVC), with: self, afterDelay: 1.5)

    }

    @objc func addNextVC()
    {
        
        if isUserExist()
        {
            
            if isPasswordSet()
            {
                if(isLogin())
                {
                    //let dash = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.DashboardViewController)
                    //createMenuView()//viewController: dash)
                    removeAppSession()
                    _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PasswordViewController)
                }
                else
                {
//                    let entpassword = getViewContoller(storyboardName: "Main", identifier: "EnterPasswordViewController")
//                    self.present(entpassword, animated: true, completion: nil)
                    _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PasswordViewController)
                }
            }
            else
            {

                let defaults = UserDefaults.standard
                if defaults.object(forKey: "isFirstTime") == nil {
                    defaults.set("No", forKey:"isFirstTime")
                    UserDefaults.standard.set("en", forKey: "keyLang")
                    _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.LoginViewController)
                    //_ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.LoginViewController)
                    
                }
                goBack()
            }
        }
        else
        {

                goBack()
        }
    }
    
    @objc func goBack(){
        
        UserDefaults.standard.set("en", forKey: "keyLang")
             _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.LoginViewController)
        //_ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.LoginViewController)

    }
    
    

    func goToPasswordViewController(isRemoveAppSession:Bool)
    {
        if isRemoveAppSession
        {
            removeAppSession()
        }
        
        let passwordVC = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.PasswordViewController)
     //   let nvc: UINavigationController = UINavigationController(rootViewController: passwordVC)
//        _ = setRootViewContoller(vc: nvc)
    }
}

extension ViewController : SwiftyGifDelegate
{
    
    func gifURLDidFinish(sender: UIImageView) {
        print("gifURLDidFinish")
    }
    
    func gifURLDidFail(sender: UIImageView) {
        print("gifURLDidFail")
    }
    
    func gifDidStart(sender: UIImageView) {
        print("gifDidStart")
    }
    
    func gifDidLoop(sender: UIImageView) {
        print("gifDidLoop")
    }
    
    func gifDidStop(sender: UIImageView) {
        print("gifDidStop")
        
        goBack()
    }
}
