//
//  String_Extension.swift
//  Wahed
//
//  Created by Amrit Singh on 3/23/17.
//  Copyright © 2017 InfoManav. All rights reserved.
//

import Foundation
import UIKit

extension String
{
    
        func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
            let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
            
            return ceil(boundingBox.height)
        }
        
        func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat
        {
            let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
            let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
            
            return ceil(boundingBox.width)
        }
    
//    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat
//    {
//        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
//        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
//        return boundingBox.height
//    }
    
    var html2AttributedString: NSAttributedString? {
        guard
            let data = data(using: String.Encoding.utf8)
            else { return nil }
        do {
            let attrs: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.documentType.rawValue) : NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue): String.Encoding.utf8.rawValue
            ]
            return try NSAttributedString(data: data, options: attrs, documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    
//    var detectDates: [Date]? {
//        do {
//            return try NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
//                .matches(in: self, options: [], range: NSRange(location: 0, length: (self as NSString).length))
//                .compactMap{$0.date}
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//        return nil
//    }
    
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
    
    
    //Check phone number valid.
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    
    func removeCharacters(from forbiddenChars: CharacterSet) -> String
    {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
    
    func removeCharacters(from: String) -> String
    {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }
    
    func trim() -> String
    {
        return self.removeCharacters(from: CharacterSet(charactersIn: " "))
    }
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String
    {
        return self.substring(from: self.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.count
    }
    
    var parseJSONString: Any?
    {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            if let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
            {
                return json
            }
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
        return nil
    }
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
}

extension Character
{
    var integerValue:Int
    {
        return Int(String(self)) ?? 0
    }
}

extension Collection where Iterator.Element == String
{
//    var dates: [Date]
//    {
//        return compactMap{$0.detectDates}.flatMap{$0}
//    }
}

extension StringProtocol where Self: RangeReplaceableCollection
{
    mutating func insert(separator: String, every n: Int) {
        indices.reversed().forEach {
            if $0 != startIndex { if distance(from: startIndex, to: $0) % n == 0 { insert(contentsOf: separator, at: $0) } }
        }
    }
    
    func inserting(separator: String, every n: Int) -> Self {
        var string = self
        string.insert(separator: separator, every: n)
        return string
    }
}
