//
//  UILable_Extension.swift
//  Wahed
//
//  Created by Amrit Singh on 3/23/17.
//  Copyright © 2017 InfoManav. All rights reserved.
//

import Foundation
import UIKit

extension UILabel
{
    
    var substituteFontName : String {
        get { return self.font.fontName }
        set {
            // print(self.font.fontName)
            
            if self.font.fontName.range(of: "Bold") == nil
            {
                let f = UIFont(name: newValue, size: self.font.pointSize)
                self.font = f//UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
    
    var substituteFontNameBold : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.range(of: "Bold") != nil {
                let f = UIFont(name: newValue, size: self.font.pointSize)
                self.font = f
            }
        }
    }
}
