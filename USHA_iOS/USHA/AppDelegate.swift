//
//  AppDelegate.swift
 
//
//  Created by Apple.Inc on 18/05/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import IQKeyboardManagerSwift

import Firebase
import Crashlytics
import Fabric

struct KeychainConfiguration {
    static let serviceName = "TouchMeIn"
    static let accessGroup: String? = nil
}

let appDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var passwordItems: [KeychainPasswordItem] = []
    var deviceUDID:String!
    var arr_UpdatedDelegate_ProductList : [Product] = []
    var orientationLock = UIInterfaceOrientationMask.portrait
    var arr_productProfile = [ProductProfile]()
    var arr_productNameCode = [Division]()
    var arr_updatedDealerList : [Dealer] = []
    var dealerDict = [String:[Dealer]]()



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        
        
        FirebaseApp.configure()
       // Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug = true
        
        
        
        do {
            passwordItems = try KeychainPasswordItem.passwordItems(forService: KeychainConfiguration.serviceName, accessGroup: KeychainConfiguration.accessGroup)
        }
        catch {
            fatalError("Error fetching password items - \(error)")
        }
        
        if(passwordItems.count > 0)
        {
            let passwordItem = passwordItems[0]
            deviceUDID = passwordItem.account
        }
        else
        {
            deviceUDID = deviceID
            // 5
            do {
                // This is a new account, create a new keychain item with the account name.
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                        account: deviceID,
                                                        accessGroup: KeychainConfiguration.accessGroup)
                
                // Save the password for the new item.
                try passwordItem.savePassword(deviceID)
            } catch {
                fatalError("Error updating keychain - \(error)")
            }
        }
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        //UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0.6449330449, green: 0.1435551643, blue: 0.1090322062, alpha: 1)
        IQKeyboardManager.shared.enable = true

        application.applicationIconBadgeNumber = 0
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        removeAppSession()

        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
}

func getViewContoller(storyboardName:String, identifier: String) -> UIViewController
{
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: identifier)
    return vc
}


func setRootViewContoller(storyboardName:String, identifier: String) -> UIViewController?
{
    guard let window = UIApplication.shared.keyWindow else {
        return nil
    }
    
    guard let rootViewController = window.rootViewController else {
        return nil
    }
    
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: identifier)
    vc.view.frame = rootViewController.view.frame
    vc.view.layoutIfNeeded()
    UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
        window.rootViewController = vc
    }, completion: { completed in
        // maybe do something here
    })
    return vc
}

func setInitialRootViewContoller(storyboardName:String) -> UIViewController?
{
    guard let window = UIApplication.shared.keyWindow else {
        return nil
    }
    guard let rootViewController = window.rootViewController else {
        return nil
    }
    
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    let vc = storyboard.instantiateInitialViewController()
    vc?.view.frame = rootViewController.view.frame
    vc?.view.layoutIfNeeded()
    UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
        window.rootViewController = vc
    }, completion: { completed in
        // maybe do something here
    })
    return vc
}

func createMenuView() //viewController:UIViewController)
{
    // create viewController code...
    
    let viewController = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.HomeViewController)
    
    let leftMenuViewController = getViewContoller(storyboardName: Storyboard.Main, identifier: Identifier.LeftMenuViewController) as! LeftMenuViewController
    
    leftMenuViewController.delegate = viewController as? LeftMenuProtocol
    
    let nvc: UINavigationController = UINavigationController(rootViewController: viewController)
    
    let window = UIApplication.shared.keyWindow
    
    let slideMenuController = ExSlideMenuController(mainViewController: nvc, leftMenuViewController: leftMenuViewController)
       // ExSlideMenuController(mainViewController: nvc, rightMenuViewController: leftMenuViewController)
    slideMenuController.automaticallyAdjustsScrollViewInsets = true
    slideMenuController.delegate = viewController as? SlideMenuControllerDelegate
    window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
    window?.rootViewController = slideMenuController
    window?.makeKeyAndVisible()
}

