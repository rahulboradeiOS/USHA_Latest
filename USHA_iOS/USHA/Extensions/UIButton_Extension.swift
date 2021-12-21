//
//  UIButton_Extension.swift
//  Wahed
//
//  Created by Amrit Singh on 3/23/17.
//  Copyright © 2017 InfoManav. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    var substituteFontName : String {
        get { return (self.titleLabel?.font.fontName)! }
        set {
            // print(self.font.fontName)
            
            if self.titleLabel?.font.fontName.range(of: "Bold") == nil {
                self.titleLabel?.font = UIFont(name: newValue, size: (self.titleLabel?.font.pointSize)!)
            }
        }
    }
    
    var substituteFontNameBold : String {
        get { return (self.titleLabel?.font.fontName)! }
        set {
            if self.titleLabel?.font.fontName.range(of: "Bold") != nil {
                let f = UIFont(name: newValue, size: (self.titleLabel?.font.pointSize)!)
                self.titleLabel?.font = f!
            }
        }
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
