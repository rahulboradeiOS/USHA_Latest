//
//  DashboardParser.swift
 
//
//  Created by Apple.Inc on 30/05/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import Foundation
import SQLite

public class Dashboard
{
    var Pk_AccRedID:Int!
    var d_AccRedDate:String!
    var d_AvgSalePrice:Int!
    var d_Points:Double!
    var d_SalesQty:Int!
    var d_SalesValue:Double!
    var n_Count:Int!
    var n_MasterCarton:Int!
    var s_AreaName:String!
    var s_BranchName:String!
    var s_CityName:String!
    var s_DistrictName:String!
    var s_MobileNo:String!
    var s_PinCode:String!
    var s_RegionName:String!
    var s_SalesOfficeCode:String!
    var s_SalesOfficeName:String!
    var s_SchemePromCode:String!
    var s_SchemePromName:String!
    var s_SourceName:String!
    var s_StateName:String!
    var s_SubTerritoryName:String!
    var s_TransType:String!
    var s_Type:String!
    var s_UserCode:String!
    var s_UserTypeCode:String!
    var s_UserTypeName:String!
    var s_skuCategoryCode:String!
    var s_skuCategoryName:String!
    var s_skuSubCategoryCode:String!
    var s_skuSubCategoryName:String!
    var accRedDateTimeStamp:TimeInterval?
    //var c_accRedDateFormat:String!
    
}

let tblDashboard = Table("DASHBOARD")
let c_Pk_AccRedID = Expression<Int>(DashboardKey.Pk_AccRedID)
let c_d_AccRedDate = Expression<String>(DashboardKey.d_AccRedDate)
let c_d_AvgSalePrice = Expression<Int>(DashboardKey.d_AvgSalePrice)
let c_d_Points = Expression<Double>(DashboardKey.d_Points)
let c_d_SalesQty = Expression<Int>(DashboardKey.d_SalesQty)
let c_d_SalesValue = Expression<Double>(DashboardKey.d_SalesValue)
let c_n_Count = Expression<Int>(DashboardKey.n_Count)
let c_n_MasterCarton = Expression<Int>(DashboardKey.n_MasterCarton)
let c_s_AreaName = Expression<String>(DashboardKey.s_AreaName)
let c_s_BranchName = Expression<String>(DashboardKey.s_BranchName)
let c_s_CityName = Expression<String>(DashboardKey.s_CityName)
let c_s_DistrictName = Expression<String>(DashboardKey.s_DistrictName)
//let c_s_MobileNo = Expression<String>(DashboardKey.s_MobileNo)
let c_s_PinCode = Expression<String>(DashboardKey.s_PinCode)
let c_s_RegionName = Expression<String>(DashboardKey.s_RegionName)
let c_s_SalesOfficeCode = Expression<String>(DashboardKey.s_SalesOfficeCode)
let c_s_SalesOfficeName = Expression<String>(DashboardKey.s_SalesOfficeName)
let c_s_SchemePromCode = Expression<String>(DashboardKey.s_SchemePromCode)
let c_s_SchemePromName = Expression<String>(DashboardKey.s_SchemePromName)
let c_s_SourceName = Expression<String>(DashboardKey.s_SourceName)
let c_s_StateName = Expression<String>(DashboardKey.s_StateName)
let c_s_SubTerritoryName = Expression<String>(DashboardKey.s_SubTerritoryName)
let c_s_TransType = Expression<String>(DashboardKey.s_TransType)
let c_s_Type = Expression<String>(DashboardKey.s_Type)
//let c_s_UserCode = Expression<String>(DashboardKey.s_UserCode)
//let c_s_UserTypeCode = Expression<String>(DashboardKey.s_UserTypeCode)
//let c_s_UserTypeName = Expression<String>(DashboardKey.s_UserTypeName)
let c_s_skuCategoryCode = Expression<String>(DashboardKey.s_skuCategoryCode)
let c_s_skuCategoryName = Expression<String>(DashboardKey.s_skuCategoryName)
let c_s_skuSubCategoryCode = Expression<String>(DashboardKey.s_skuSubCategoryCode)
let c_s_skuSubCategoryName = Expression<String>(DashboardKey.s_skuSubCategoryName)
let c_accRedDateTimeStamp = Expression<TimeInterval>(DashboardKey.accRedDateTimeStamp)
//let c_accRedDateFormat = Expression<String>(DashboardKey.c_accRedDateFormat)

class DashboardParser: NSObject
{
    var arr_dasboard = [Dashboard]()
    let dateFormatter = DateFormatter()

    func parseDashboard(json:[Any], isSave:Bool) -> [Dashboard]
    {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if json.count == 0
        {
            if isSave
            {
                //let dash = Dashboard()
                //self.saveDashboardData(dashboard: dash)
            }
        }
        else{
            for item in json
            {
                let das = Dashboard()
                let listaccredtempdata_Dic = item as! [String:Any]
                if let Pk_AccRedID = listaccredtempdata_Dic[DashboardKey.Pk_AccRedID] as? Int
                {
                    das.Pk_AccRedID = Pk_AccRedID
                }
                else
                {
                    das.Pk_AccRedID = -1
                }
                
                if let d_AccRedDate = listaccredtempdata_Dic[DashboardKey.d_AccRedDate] as? String
                {
                    das.d_AccRedDate = d_AccRedDate
                }
                else
                {
                    das.d_AccRedDate = ""
                }
                
                if let d_AvgSalePrice = listaccredtempdata_Dic[DashboardKey.d_AvgSalePrice] as? Int
                {
                    das.d_AvgSalePrice = d_AvgSalePrice
                }
                else
                {
                    das.d_AvgSalePrice = 0
                }
                
                if let d_Points = listaccredtempdata_Dic[DashboardKey.d_Points] as? Double
                {
                    das.d_Points = d_Points
                }
                else
                {
                    das.d_Points = 0
                }
                
                if let d_SalesQty = listaccredtempdata_Dic[DashboardKey.d_SalesQty] as? Int
                {
                    das.d_SalesQty = d_SalesQty
                }
                else
                {
                    das.d_SalesQty = 0
                }
                
                if let d_SalesValue = listaccredtempdata_Dic[DashboardKey.d_SalesValue] as? Double
                {
                    das.d_SalesValue = d_SalesValue
                }
                else
                {
                    das.d_SalesValue = 0
                }
                
                if let d_SalesValue = listaccredtempdata_Dic[DashboardKey.d_SalesValue] as? Double
                {
                    das.d_SalesValue = d_SalesValue
                }
                else
                {
                    das.d_SalesValue = 0
                }
                
                if let n_Count = listaccredtempdata_Dic[DashboardKey.n_Count] as? Int
                {
                    das.n_Count = n_Count
                }
                else
                {
                    das.n_Count = 0
                }
                
                if let n_MasterCarton = listaccredtempdata_Dic[DashboardKey.n_MasterCarton] as? Int
                {
                    das.n_MasterCarton = n_MasterCarton
                }
                else
                {
                    das.n_MasterCarton = 0
                }
                
                if let s_AreaName = listaccredtempdata_Dic[DashboardKey.s_AreaName] as? String
                {
                    das.s_AreaName = s_AreaName
                }
                else
                {
                    das.s_AreaName = ""
                }
                
                if let s_BranchName = listaccredtempdata_Dic[DashboardKey.s_BranchName] as? String
                {
                    das.s_BranchName = s_BranchName
                }
                else
                {
                    das.s_BranchName = ""
                }
                
                if let s_CityName = listaccredtempdata_Dic[DashboardKey.s_CityName] as? String
                {
                    das.s_CityName = s_CityName
                }
                else
                {
                    das.s_CityName = ""
                }
                
                if let s_DistrictName = listaccredtempdata_Dic[DashboardKey.s_DistrictName] as? String
                {
                    das.s_DistrictName = s_DistrictName
                }
                else
                {
                    das.s_DistrictName = ""
                }
                
                if let s_MobileNo = listaccredtempdata_Dic[DashboardKey.s_MobileNo] as? String
                {
                    das.s_MobileNo = s_MobileNo
                }
                else
                {
                    das.s_MobileNo = ""
                }
                
                if let s_PinCode = listaccredtempdata_Dic[DashboardKey.s_PinCode] as? String
                {
                    das.s_PinCode = s_PinCode
                }
                else
                {
                    das.s_PinCode = ""
                }
                
                if let s_RegionName = listaccredtempdata_Dic[DashboardKey.s_RegionName] as? String
                {
                    das.s_RegionName = s_RegionName
                }
                else
                {
                    das.s_RegionName = ""
                }
                
                if let s_SalesOfficeCode = listaccredtempdata_Dic[DashboardKey.s_SalesOfficeCode] as? String
                {
                    das.s_SalesOfficeCode = s_SalesOfficeCode
                }
                else
                {
                    das.s_SalesOfficeCode = ""
                }
                
                if let s_SalesOfficeName = listaccredtempdata_Dic[DashboardKey.s_SalesOfficeName] as? String
                {
                    das.s_SalesOfficeName = s_SalesOfficeName
                }
                else
                {
                    das.s_SalesOfficeName = ""
                }
                
                if let s_SchemePromCode = listaccredtempdata_Dic[DashboardKey.s_SchemePromCode] as? String
                {
                    das.s_SchemePromCode = s_SchemePromCode
                }
                else
                {
                    das.s_SchemePromCode = ""
                }
                
                if let s_SchemePromName = listaccredtempdata_Dic[DashboardKey.s_SchemePromName] as? String
                {
                    das.s_SchemePromName = s_SchemePromName
                }
                else
                {
                    das.s_SchemePromName = ""
                }
                
                if let s_SourceName = listaccredtempdata_Dic[DashboardKey.s_SourceName] as? String
                {
                    das.s_SourceName = s_SourceName
                }
                else
                {
                    das.s_SourceName = ""
                }
                
                if let s_StateName = listaccredtempdata_Dic[DashboardKey.s_StateName] as? String
                {
                    das.s_StateName = s_StateName
                }
                else
                {
                    das.s_StateName = ""
                }
                
                if let s_SubTerritoryName = listaccredtempdata_Dic[DashboardKey.s_SubTerritoryName] as? String
                {
                    das.s_SubTerritoryName = s_SubTerritoryName
                }
                else
                {
                    das.s_SubTerritoryName = ""
                }
                
                if let s_TransType = listaccredtempdata_Dic[DashboardKey.s_TransType] as? String
                {
                    das.s_TransType = s_TransType
                }
                else
                {
                    das.s_TransType = ""
                }
                
                if let s_Type = listaccredtempdata_Dic[DashboardKey.s_Type] as? String
                {
                    das.s_Type = s_Type
                }
                else
                {
                    das.s_Type = ""
                }
                
                if let s_UserCode = listaccredtempdata_Dic[DashboardKey.s_UserCode] as? String
                {
                    das.s_UserCode = s_UserCode
                }
                else
                {
                    das.s_UserCode = ""
                }
                
                if let s_UserTypeCode = listaccredtempdata_Dic[DashboardKey.s_UserTypeCode] as? String
                {
                    das.s_UserTypeCode = s_UserTypeCode
                }
                else
                {
                    das.s_UserTypeCode = ""
                }
                
                if let s_UserTypeName = listaccredtempdata_Dic[DashboardKey.s_UserTypeName] as? String
                {
                    das.s_UserTypeName = s_UserTypeName
                }
                else
                {
                    das.s_UserTypeName = ""
                }
                
                if let s_skuCategoryCode = listaccredtempdata_Dic[DashboardKey.s_skuCategoryCode] as? String
                {
                    das.s_skuCategoryCode = s_skuCategoryCode
                }
                else
                {
                    das.s_skuCategoryCode = ""
                }
                
                if let s_skuCategoryName = listaccredtempdata_Dic[DashboardKey.s_skuCategoryName] as? String
                {
                    das.s_skuCategoryName = s_skuCategoryName
                }
                else
                {
                    das.s_skuCategoryName = ""
                }
                
                if let s_skuSubCategoryCode = listaccredtempdata_Dic[DashboardKey.s_skuSubCategoryCode] as? String
                {
                    das.s_skuSubCategoryCode = s_skuSubCategoryCode
                }
                else
                {
                    das.s_skuSubCategoryCode = ""
                }
                
                if let s_skuSubCategoryName = listaccredtempdata_Dic[DashboardKey.s_skuSubCategoryName] as? String
                {
                    das.s_skuSubCategoryName = s_skuSubCategoryName
                }
                else
                {
                    das.s_skuSubCategoryName = ""
                }
                
                if let date = das.d_AccRedDate
                {
                    if let d_AccRedDate = dateFormatter.date(from: date) {
                        
                        let newDate = d_AccRedDate.getGMTDate()
                        das.accRedDateTimeStamp = newDate.timeIntervalSince1970
                        
//                        dateFormatter.dateFormat = "yyyy-MM-dd"
//                        let d_AccRedDate_str = dateFormatter.string(from: d_AccRedDate)
//                        dateFormatter.dateFormat = "yyyy-MM-dd"
//                        if let d_AccRedD = dateFormatter.date(from: d_AccRedDate_str) {
                          //  das.c_accRedDateFormat = d_AccRedDate_str
//                        }
                        
                        
                    }
                }
                
                arr_dasboard.append(das)
                
                if isSave
                {
                    if let db = DataProvider.getDBConnection()
                    {
                        do
                        {
                            let itExists = try db.scalar(tblDashboard.exists)
                            if itExists {
                                //Do stuff
                                insert(dashboard: das, database: db)
                            }
                            else
                            {
                                if(createTable(database: db))
                                {
                                    insert(dashboard: das, database: db)
                                }
                                else
                                {
                                    print("Error to create dashbord table")
                                }
                            }
                        } catch {
                            print("Error in notification doesn't exit dashbord table")
                            print(error)
                            if(createTable(database: db))
                            {
                                insert(dashboard: das, database: db)
                            }
                            else
                            {
                                print("Error to create dashbord table")
                            }
                        }
                    }
                    
                    //            if DataProvider.getDBConnection() != nil
                    //            {
                    //                DataProvider.dropTable(table: tblDashboard)
                    //                for item in arr_dasboard
                    //                {
                    //                    saveDashboardData(dashboard: item)
                    //                }
                    //            }
                    //            else {
                    //                print("error DB connection")
                    //            }
                }
            }
        }
        
      
        
        return arr_dasboard
    }
    
    func createTable(database:Connection) -> Bool
    {
        do
        {
            try database.run(tblDashboard.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { t in
                t.column(c_Pk_AccRedID, primaryKey: true)
                t.column(c_d_AccRedDate)
                t.column(c_d_AvgSalePrice)
                t.column(c_d_Points)
                t.column(c_d_SalesQty)
                t.column(c_d_SalesValue)
                t.column(c_n_Count)
                t.column(c_n_MasterCarton)
                t.column(c_s_AreaName)
                t.column(c_s_BranchName)
                t.column(c_s_CityName)
                t.column(c_s_DistrictName)
                t.column(c_s_MobileNo)
                t.column(c_s_PinCode)
                t.column(c_s_RegionName)
                t.column(c_s_SalesOfficeCode)
                t.column(c_s_SalesOfficeName)
                t.column(c_s_SchemePromCode)
                t.column(c_s_SchemePromName)
                t.column(c_s_SourceName)
                t.column(c_s_StateName)
                t.column(c_s_SubTerritoryName)
                t.column(c_s_TransType)
                t.column(c_s_Type)
                t.column(c_s_UserCode)
                t.column(c_s_UserTypeCode)
                t.column(c_s_UserTypeName)
                t.column(c_s_skuCategoryCode)
                t.column(c_s_skuCategoryName)
                t.column(c_s_skuSubCategoryCode)
                t.column(c_s_skuSubCategoryName)
                t.column(c_accRedDateTimeStamp)
               // t.column(c_accRedDateFormat)
            }))
            return true
        } catch {
            print("Error in dashbord table create")
            print(error)
            return false
        }
    }
    
    func insert(dashboard:Dashboard, database:Connection)
    {
        let insert = tblDashboard.insert(
            c_Pk_AccRedID <- dashboard.Pk_AccRedID ?? 0,
            c_d_AccRedDate <- dashboard.d_AccRedDate ?? "",
            c_d_AvgSalePrice <- dashboard.d_AvgSalePrice ?? 0,
            c_d_Points <- dashboard.d_Points ?? 0.0,
            c_d_SalesQty <- dashboard.d_SalesQty ?? 0,
            c_d_SalesValue <- dashboard.d_SalesValue ?? 0.0,
            c_n_Count <- dashboard.n_Count ?? 0,
            c_n_MasterCarton <- dashboard.n_MasterCarton ?? 0,
            c_s_AreaName <- dashboard.s_AreaName ?? "",
            c_s_BranchName <- dashboard.s_BranchName ?? "",
            c_s_CityName <- dashboard.s_CityName ?? "",
            c_s_DistrictName <- dashboard.s_DistrictName ?? "",
            c_s_MobileNo <- dashboard.s_MobileNo ?? "",
            c_s_PinCode <- dashboard.s_PinCode ?? "",
            c_s_RegionName <- dashboard.s_RegionName ?? "",
            c_s_SalesOfficeCode <- dashboard.s_SalesOfficeCode ?? "",
            c_s_SalesOfficeName <- dashboard.s_SalesOfficeName ?? "",
            c_s_SchemePromCode <- dashboard.s_SchemePromCode ?? "",
            c_s_SchemePromName <- dashboard.s_SchemePromName ?? "",
            c_s_SourceName <- dashboard.s_SourceName ?? "",
            c_s_StateName <- dashboard.s_StateName ?? "",
            c_s_SubTerritoryName <- dashboard.s_SubTerritoryName ?? "",
            c_s_TransType <- dashboard.s_TransType ?? "",
            c_s_Type <- dashboard.s_Type ?? "",
            c_s_UserCode <- dashboard.s_UserCode ?? "",
            c_s_UserTypeCode <- dashboard.s_UserTypeCode ?? "",
            c_s_UserTypeName <- dashboard.s_UserTypeName ?? "",
            c_s_skuCategoryCode <- dashboard.s_skuCategoryCode ?? "",
            c_s_skuCategoryName <- dashboard.s_skuCategoryName ?? "",
            c_s_skuSubCategoryCode <- dashboard.s_skuSubCategoryCode ?? "",
            c_s_skuSubCategoryName <- dashboard.s_skuSubCategoryName ?? "",
            c_accRedDateTimeStamp <- dashboard.accRedDateTimeStamp ?? 0
            //c_accRedDateFormat <- dashboard.c_accRedDateFormat ?? ""
        )
        
        do
        {
            let rowid = try database.run(insert)
            print(rowid)
        } catch {
            print("Error in insert to notification item")
            print(error)
        }
    }
    
//    func saveDashboardData(dashboard :Dashboard)
//    {
//        guard let db = DataProvider.getDBConnection() else {
//            print("db connection not fouind")
//            return}
//
//        db.trace { (error) in
//            print(error)
//        }
//        do {
//            try db.run(tblDashboard.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { t in
//                t.column(c_Pk_AccRedID, primaryKey: true)
//                t.column(c_d_AccRedDate)
//                t.column(c_d_AvgSalePrice)
//                t.column(c_d_Points)
//                t.column(c_d_SalesQty)
//                t.column(c_d_SalesValue)
//                t.column(c_n_Count)
//                t.column(c_n_MasterCarton)
//                t.column(c_s_AreaName)
//                t.column(c_s_BranchName)
//                t.column(c_s_CityName)
//                t.column(c_s_DistrictName)
//                t.column(c_s_MobileNo)
//                t.column(c_s_PinCode)
//                t.column(c_s_RegionName)
//                t.column(c_s_SalesOfficeCode)
//                t.column(c_s_SalesOfficeName)
//                t.column(c_s_SchemePromCode)
//                t.column(c_s_SchemePromName)
//                t.column(c_s_SourceName)
//                t.column(c_s_StateName)
//                t.column(c_s_SubTerritoryName)
//                t.column(c_s_TransType)
//                t.column(c_s_Type)
//                t.column(c_s_UserCode)
//                t.column(c_s_UserTypeCode)
//                t.column(c_s_UserTypeName)
//                t.column(c_s_skuCategoryCode)
//                t.column(c_s_skuCategoryName)
//                t.column(c_s_skuSubCategoryCode)
//                t.column(c_s_skuSubCategoryName)
//                t.column(c_accRedDateTimeStamp)
//            }))
//
//
//
//            let insert = tblDashboard.insert(
//                c_Pk_AccRedID <- dashboard.Pk_AccRedID ?? 0,
//                c_d_AccRedDate <- dashboard.d_AccRedDate ?? "",
//                c_d_AvgSalePrice <- dashboard.d_AvgSalePrice ?? 0,
//                c_d_Points <- dashboard.d_Points ?? 0.0,
//                c_d_SalesQty <- dashboard.d_SalesQty ?? 0,
//                c_d_SalesValue <- dashboard.d_SalesValue ?? 0.0,
//                c_n_Count <- dashboard.n_Count ?? 0,
//                c_n_MasterCarton <- dashboard.n_MasterCarton ?? 0,
//                c_s_AreaName <- dashboard.s_AreaName ?? "",
//                c_s_BranchName <- dashboard.s_BranchName ?? "",
//                c_s_CityName <- dashboard.s_CityName ?? "",
//                c_s_DistrictName <- dashboard.s_DistrictName ?? "",
//                c_s_MobileNo <- dashboard.s_MobileNo ?? "",
//                c_s_PinCode <- dashboard.s_PinCode ?? "",
//                c_s_RegionName <- dashboard.s_RegionName ?? "",
//                c_s_SalesOfficeCode <- dashboard.s_SalesOfficeCode ?? "",
//                c_s_SalesOfficeName <- dashboard.s_SalesOfficeName ?? "",
//                c_s_SchemePromCode <- dashboard.s_SchemePromCode ?? "",
//                c_s_SchemePromName <- dashboard.s_SchemePromName ?? "",
//                c_s_SourceName <- dashboard.s_SourceName ?? "",
//                c_s_StateName <- dashboard.s_StateName ?? "",
//                c_s_SubTerritoryName <- dashboard.s_SubTerritoryName ?? "",
//                c_s_TransType <- dashboard.s_TransType ?? "",
//                c_s_Type <- dashboard.s_Type ?? "",
//                c_s_UserCode <- dashboard.s_UserCode ?? "",
//                c_s_UserTypeCode <- dashboard.s_UserTypeCode ?? "",
//                c_s_UserTypeName <- dashboard.s_UserTypeName ?? "",
//                c_s_skuCategoryCode <- dashboard.s_skuCategoryCode ?? "",
//                c_s_skuCategoryName <- dashboard.s_skuCategoryName ?? "",
//                c_s_skuSubCategoryCode <- dashboard.s_skuSubCategoryCode ?? "",
//                c_s_skuSubCategoryName <- dashboard.s_skuSubCategoryName ?? "",
//                c_accRedDateTimeStamp <- dashboard.accRedDateTimeStamp ?? 0
//            )
//
//            try db.run(insert)
//
//            //print(rowid)
//
//        } catch  {
//            print("error DB Insert")
//            print("Error info: \(error)")
//        }
//    }
//
}

struct DashboardKey
{
    static let Pk_AccRedID = "Pk_AccRedID"
    static let d_AccRedDate = "d_AccRedDate"
    static let d_AvgSalePrice = "d_AvgSalePrice"
    static let d_Points = "d_Points"
    static let d_SalesQty = "d_SalesQty"
    static let d_SalesValue = "d_SalesValue"
    static let n_Count = "n_Count"
    static let n_MasterCarton = "n_MasterCarton"
    static let s_AreaName = "s_AreaName"
    static let s_BranchName = "s_BranchName"
    static let s_CityName = "s_CityName"
    static let s_DistrictName = "s_DistrictName"
    static let s_MobileNo = "s_MobileNo"
    static let s_PinCode = "s_PinCode"
    static let s_RegionName = "s_RegionName"
    static let s_SalesOfficeCode = "s_SalesOfficeCode"
    static let s_SalesOfficeName = "s_SalesOfficeName"
    static let s_SchemePromCode = "s_SchemePromCode"
    static let s_SchemePromName = "s_SchemePromName"
    static let s_SourceName = "s_SourceName"
    static let s_StateName = "s_StateName"
    static let s_SubTerritoryName = "s_SubTerritoryName"
    static let s_TransType = "s_TransType"
    static let s_Type = "s_Type"
    static let s_UserCode = "s_UserCode"
    static let s_UserTypeCode = "s_UserTypeCode"
    static let s_UserTypeName = "s_UserTypeName"
    static let s_skuCategoryCode = "s_skuCategoryCode"
    static let s_skuCategoryName = "s_skuCategoryName"
    static let s_skuSubCategoryCode = "s_skuSubCategoryCode"
    static let s_skuSubCategoryName = "s_skuSubCategoryName"
    
    static let accRedDateTimeStamp = "accRedDateTimeStamp"
    
    static let c_accRedDateFormat = "c_accRedDateFormat"
}
