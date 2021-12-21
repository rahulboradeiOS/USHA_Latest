//
//  File.swift
//  myWindscreen
//
//  Created by Apple.Inc on 07/04/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import Foundation
import UIKit
extension UITextField
{
    @objc open func validateExp(regx:String) -> Bool
    {
        if (self.text?.count != 0 && !self.validateToString(self.text!, withRegex:regx))
        {
                return false
        }
        return true
    }

    func validateToString(_ stringToSearch:String, withRegex regexString:String) ->Bool {
        let regex = NSPredicate(format: "SELF MATCHES %@", regexString)
        return regex.evaluate(with: stringToSearch)
    }
}
