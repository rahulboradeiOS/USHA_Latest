//
//  ExSlideMenuController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/11/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ExSlideMenuController : SlideMenuController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        SlideMenuOptions.hideStatusBar = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
      //UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        setUpStautusBar()
    }
    
    func setUpStautusBar(){
                        
                             if #available(iOS 13.0, *) {
                                 let app = UIApplication.shared
                                 let statusBarHeight: CGFloat = app.statusBarFrame.size.height
                                 
                                 let statusbarView = UIView()
                                 statusbarView.backgroundColor = UIColor.black
                                 view.addSubview(statusbarView)
                               
                                 statusbarView.translatesAutoresizingMaskIntoConstraints = false
                                 statusbarView.heightAnchor
                                     .constraint(equalToConstant: statusBarHeight).isActive = true
                                 statusbarView.widthAnchor
                                     .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
                                 statusbarView.topAnchor
                                     .constraint(equalTo: view.topAnchor).isActive = true
                                 statusbarView.centerXAnchor
                                     .constraint(equalTo: view.centerXAnchor).isActive = true
                               
                             } else {
                                 let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
                                 statusBar?.backgroundColor = UIColor.black
                             }
                        
                    }
       
    
    override func isTagetViewController() -> Bool
    {
        if let vc = UIApplication.topViewController()
        {
            if vc is HomeViewController{
                return true
            }
        }
        return false
    }

    override func track(_ trackAction: TrackAction) {
        switch trackAction {
        case .leftTapOpen:
            print("TrackAction: left tap open.")
        case .leftTapClose:
            print("TrackAction: left tap close.")
        case .leftFlickOpen:
            print("TrackAction: left flick open.")
        case .leftFlickClose:
            print("TrackAction: left flick close.")
        case .rightTapOpen:
            print("TrackAction: right tap open.")
        case .rightTapClose:
            print("TrackAction: right tap close.")
        case .rightFlickOpen:
            print("TrackAction: right flick open.")
        case .rightFlickClose:
            print("TrackAction: right flick close.")
        }   
    }
}
