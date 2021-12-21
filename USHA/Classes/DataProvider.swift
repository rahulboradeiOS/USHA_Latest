//  PostCell.swift
//  XLPagerTabStrip ( https://github.com/xmartlabs/XLPagerTabStrip )
//
//  Copyright (c) 2017 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import UIKit
import SQLite

public class DataProvider
{
    static let sharedInstance = DataProvider()

    var userDetails : UserDetails!
    var ePlusUserDetails: UserDetails!
    var selectedScehme:Scheme!
    var selectedOption:DropdownQ!
    var dbPath : String?
        
    var orientationLock = UIInterfaceOrientationMask.portrait
    var myOrientation: UIInterfaceOrientationMask = .portrait
    
    var otp:String?
    
    var mobile:String?
    
    var filteredArray = [Any]()

    var reportData = [Any]()
    
    var monthName:String!
    var year:String!
    
    var isPendinPopupShow:Bool = false
    var isFlashMessagePopupShow:Bool = false
    
    class func dropTable(table:Table)
    {
        guard let db = self.getDBConnection() else{
            print("db connection not found")
            return
        }
        do {
            try db.run(table.drop(ifExists: true))
        } catch  {
            print("error table drop")
            print("Error info: \(error)")
        }
    }
    
    class func getDBConnection() -> Connection?
    {
        do
        {
            let connection = try Connection(getDBPath()!)
            return connection
        }catch {
            print("DB Error")
            print("Error info: \(error)")
            return nil
        }
    }
    
    class func getDBPath() -> String?
    {
        if let dbPath =  DataProvider.sharedInstance.dbPath
        {
            return dbPath
        }
        else
        {
            if let dbPath = copyDatabaseIfNeeded()
            {
                DataProvider.sharedInstance.dbPath = dbPath
                return dbPath
            }
            else
            {
                print("Fail to get path")
                return ""
            }
        }
    }
    
    class func copyDatabaseIfNeeded() -> String?
    {
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        guard documentsUrl.count != 0 else
        {
            print("Fail to documentsUrl")
            return nil
        }
        
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent(dbName)
        
        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")
            
            let documentsURL = Bundle.main.resourceURL?.appendingPathComponent(dbName)
            
            do {
                try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: finalDatabaseURL.path)
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
        } else {
            print("Database file found at path: \(finalDatabaseURL.path)")
        }
        return finalDatabaseURL.path
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return myOrientation
    }
}



class Accumulation: DataProvider {
    var PK_AccID : Int?
    var MobileNo : String?
    var ProductDivision : String?
    var ProductCategory : String?
    var Pins : Int?
    var AccumulationPoints : Double?
    var SecondarySalesValue : Double?
    var AccDate : String?
    var accDateTimeStamp : TimeInterval?
}

class Redemption: DataProvider {
    var Pk_RedID : Int?
    var MobileNo : String?
    var Product : String?
    var RedemptionPoints : Double?
    var RedDate : String?
    var redDateTimeStamp : TimeInterval?
}

class PendingTransaction: NSObject
{
    var PK_AccID: Int?
    var RET_MobileNo: String?
    var ELEC_MobileNo: String?
    var AccDate: String?
    var Status: String?
    var SMSCode: String?
    var TabNumber: String?
    var PinList:String?
    var Pins_Count: Int?
    var Pin: String?
    var SchemeName: String?
}
