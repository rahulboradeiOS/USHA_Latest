//
//  LanguageViewController.swift
 
//
//  Created by Naveen on 27/04/19.
//  Copyright © 2019 Apple.Inc. All rights reserved.
//

import UIKit


class LanguageViewController: UIViewController {
    
    @IBOutlet weak var btn_English: UIButton!
    @IBOutlet weak var btn_Hindi: UIButton!


   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpDesign()
    }
    
    
    func setUpDesign(){
        
                  btn_English.layer.masksToBounds = true
                  btn_English.cornerRadius = 30
                  btn_Hindi.layer.masksToBounds = true
                  btn_Hindi.cornerRadius = 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        UserDefaults.standard.removeObject(forKey: "keyLang")
    }
    @IBAction func btn_english_pressed(_ sender: Any) {
        
        UserDefaults.standard.set("en", forKey: "keyLang")  //setObject
        if DataProvider.sharedInstance.userDetails !== nil
        {
            getUserDetail()
            createMenuView()
        }else{
             addNextVC()
        }
       
    }
    @IBAction func btn_Hindi_pressed(_ sender: Any) {
        UserDefaults.standard.set("hi", forKey: "keyLang")  //setObject
        if DataProvider.sharedInstance.userDetails !== nil
        {
            getUserDetail()
            createMenuView()
        }else{
            addNextVC()
        }
    }
    @IBAction func btn_Tamil_pressed(_ sender: Any) {
        UserDefaults.standard.set("ta", forKey: "keyLang")  //setObject
        if DataProvider.sharedInstance.userDetails !== nil
        {
            getUserDetail()
            createMenuView()
        }else{
            addNextVC()
        }
    }
    @IBAction func btn_malayalam_pressed(_ sender: Any) {
        UserDefaults.standard.set("ml", forKey: "keyLang")  //setObject
        if DataProvider.sharedInstance.userDetails !== nil
        {
            getUserDetail()
            createMenuView()
        }else{
            addNextVC()
        }
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
                //                let setpassword = getViewContoller(storyboardName: "Main", identifier: "SetPasswordViewController")
                //                self.present(setpassword, animated: true, completion: nil)
                _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.LoginViewController)
                
            }
        }
        else
        {
            //            let login = getViewContoller(storyboardName: "Main", identifier: "LoginViewController")
            //            self.present(login, animated: true, completion: nil)
            
            _ = setRootViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.LoginViewController)
        }
    }
    func LanguageChanged(strLan:String){
        
    }
}

extension String{
    func localizableString(loc:String) -> String {
        let Path = Bundle.main.path(forResource: loc, ofType: "lproj")!
        let bundle = Bundle(path: Path)!
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
}
}
