//
//  UIView_Extension.swift
//  Wahed
//
//  Created by Amrit Singh on 3/23/17.
//  Copyright © 2017 InfoManav. All rights reserved.
//

import UIKit

/// set of view inpectables
extension UIView {
    /// border color inspectable prop.
    @IBInspectable public var borderColor: UIColor  {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
    }
    /// modify self.layer.borderWidth
    @IBInspectable public var borderWidth: CGFloat   {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
    /// modify self.cornerRadius and set clipsTobounds to true
    @IBInspectable public var cornerRadius: CGFloat  {
        set {
            self.layer.cornerRadius = newValue
            self.clipsToBounds = true
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
//    @IBInspectable public var shadowColor: UIColor  {
//        set {
//            setShadow()
//        }
//        get {
//            return UIColor(cgColor: self.layer.shadowColor!)
//        }
//    }
//
//    @IBInspectable public var shadowOffset: CGSize {
//        set {
//            setShadow()
//        }
//        get {
//            return CGSize(width: self.layer.shadowOffset.width, height: self.layer.shadowOffset.height)
//        }
//    }
//    
//    @IBInspectable public var shadowRadius: CGFloat  {
//        set {
//            setShadow()
//        }
//        get {
//            return self.layer.shadowRadius
//        }
//    }
//    
//    @IBInspectable public var shadowOpacity: Float  {
//        set {
//            setShadow()
//        }
//        get {
//            return self.layer.shadowOpacity
//        }
//    }

    
    func constraint(withIdentifier: String) -> NSLayoutConstraint? {
        return self.constraints.filter { $0.identifier == withIdentifier }.first
    }
    
//    func setShadow()
//    {
//        self.layer.shadowOpacity = shadowOpacity
//        self.clipsToBounds = false
//        self.layer.shadowOffset = shadowOffset
//        self.layer.shadowRadius = shadowRadius
//        self.layer.shadowColor = shadowColor.cgColor
//    }

    
    func setShadow()
    {
        self.layer.shadowOpacity = 0.5
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor.gray.cgColor
    }
    
    
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
}
