//
//  Date_Extension.swift
 
//
//  Created by Apple.Inc on 30/05/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import Foundation
extension Date
{
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
    
    func startOfMonth() -> Date? {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month, .hour], from: Calendar.current.startOfDay(for: self))
        return Calendar.current.date(from: comp)!
    }
    
    func lastDayOfMonth() -> Date {
        let calendar = NSCalendar.current
        let dayRange = calendar.range(of: .day, in: .month, for: self)
        let dayCount = dayRange?.count
        var comp = calendar.dateComponents([.year, .month, .day], from: self)
        comp.day = dayCount! + 1
        return calendar.date(from: comp)!
    }
}
