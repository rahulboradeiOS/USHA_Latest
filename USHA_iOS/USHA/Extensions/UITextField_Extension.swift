//
//  UITextField_Extension.swift
//  Baywood
//
//  Created by Apple.Inc on 13/04/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable extension UITextField{
    @IBInspectable var setImageName: String {
        get{
            return ""
        }
        set{
            let containerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width:self.frame.height, height: self.frame.height))
            let imageView: UIImageView = UIImageView(frame: CGRect(x: 8, y: 8, width: self.frame.height-16, height: self.frame.height-16))
            imageView.image = UIImage(named: newValue)!
            imageView.contentMode = .scaleAspectFit
            containerView.addSubview(imageView)
            imageView.center = containerView.center
            self.rightView = containerView
            self.rightViewMode = UITextFieldViewMode.always
        }
    }
}
