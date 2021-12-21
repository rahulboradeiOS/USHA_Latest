//
//  MonthYearPicker.swift
//
//  Created by Ben Dodson on 15/04/2015.
//  Modified by Jiayang Miao on 24/10/2016 to support Swift 3
//  Modified by David Luque on 24/01/2018 to get default date
//

import UIKit

public enum PickerType: Int
{
    case MonthYear = 0
    case Month = 1
    case Year = 2
}

class MonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var months: [String]!
    var years: [Int]!
    
    var month = Calendar.current.component(.month, from: Date()) {
        didSet {
            selectRow(month-1, inComponent: 0, animated: false)
        }
    }
    
    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            if (pickerType == .MonthYear)
            {
                selectRow(years.index(of: year)!, inComponent: 1, animated: true)
            }
            else if (pickerType == .Year)
            {
                print(year)
                selectRow(years.index(of: year)!, inComponent: 0, animated: true)
            }
            else
            {
                
            }
        }
    }
    
    var pickerType:PickerType = .Month
    
    var onMonthYearSelected: ((_ month: String, _ year: Int) -> Void)?
    var onMonthSelected: ((_ month: String) -> Void)?
    var onYearSelected: ((_ year: Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        // population years
        var years: [Int] = []
        let year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: Date())

        if years.count == 0
        {
            for y in year-40...year+16 {
                years.append(y)
            }
        }
        self.years = years
        //self.year = year

        // population months with localized names
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months
        
        self.delegate = self
        self.dataSource = self
        
        //let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: Date())
        
        //self.selectRow(currentMonth - 1, inComponent: 0, animated: false)
        
        //self.year = year
    }
    
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        switch (pickerType)
        {
        case .MonthYear:
            return 2
        case .Month:
            return 1
        case .Year:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        switch (pickerType)
        {
        case .MonthYear:
            switch component {
            case 0:
                return months[row]
            case 1:
                return "\(years[row])"
            default:
                return nil
            }
        case .Month:
                return months[row]
        case .Year:
                return "\(years[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        switch (pickerType)
        {
        case .MonthYear:
            switch component {
            case 0:
                return months.count
            case 1:
                return years.count
            default:
                return 0
            }
        case .Month:
                return months.count
        case .Year:
                return years.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        switch (pickerType)
        {
        case .MonthYear:
            let month = self.selectedRow(inComponent: 0)+1
            let year = years[self.selectedRow(inComponent: 1)]
            
            if let block = onMonthYearSelected {
                block(self.months[row], year)
            }
            
            self.month = month
            self.year = year
        case .Month:
            let month = self.selectedRow(inComponent: 0)+1
            
            if let block = onMonthSelected {
                block(self.months[row])
            }
            
            self.month = month
        case .Year:
            let year = years[row]
            
            if let block = onYearSelected {
                block(year)
            }
            self.year = year
        }
    }
    
}
