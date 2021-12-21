//
//  RedeemtionParser.swift
 
//
//  Created by Apple.Inc on 09/06/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import Foundation
import SQLite

class BankDetails:NSObject
{
    var s_BankAccountNo : String?
    var s_BankName : String?
    var s_BankAddress : String?
    var s_IFSCCode : String?
    var s_AccountStatus : String?
    var s_FileName : String?
    var s_MobileNo : String?
    var s_UserTypeName : String?
    var s_FirmName : String?
    var d_CreatedDate : String?
    var s_AccountHolderName : String?
}

let tblBank = Table("BANK")

let c_Pk_BankID = Expression<Int>("Pk_BankID")
let c_s_BankAccountNo = Expression<String>(BankDetailsKey.s_BankAccountNo)
let c_s_BankName = Expression<String>(BankDetailsKey.s_BankName)
let c_s_BankAddress = Expression<String>(BankDetailsKey.s_BankAddress)
let c_s_IFSCCode = Expression<String>(BankDetailsKey.s_IFSCCode)
let c_s_AccountStatus = Expression<String>(BankDetailsKey.s_AccountStatus)
let c_s_FileName = Expression<String>(BankDetailsKey.s_FileName)
//let c_s_MobileNo = Expression<String>(BankDetailsKey.s_MobileNo)
//let c_s_UserTypeName = Expression<String>(BankDetailsKey.s_UserTypeName)
let c_s_FirmName = Expression<String>(BankDetailsKey.s_FirmName)
let c_d_CreatedDate = Expression<String>(BankDetailsKey.d_CreatedDate)
let c_s_AccountHolderName = Expression<String>(BankDetailsKey.s_AccountHolderName)

class BankDetailsParser
{
    class func parseBankDetails(json:[[String:Any]]) -> ([String], [BankDetails])
    {
        var bankDetails_arr = [BankDetails]()
        var accountNumber_arr = [String]()
        
        DataProvider.dropTable(table: tblBank)
        
        for item in json
        {
            let bank = BankDetails()
            
            if let s_BankAccountNo = item[BankDetailsKey.s_BankAccountNo] as? String
            {
                accountNumber_arr.append(s_BankAccountNo)
                bank.s_BankAccountNo = s_BankAccountNo
            }
            else
            {
                bank.s_BankAccountNo = ""
            }
            
            if let s_BankName = item[BankDetailsKey.s_BankName] as? String
            {
                bank.s_BankName = s_BankName
            }
            else
            {
                bank.s_BankName = ""
            }
            
            if let s_BankAddress = item[BankDetailsKey.s_BankAddress] as? String
            {
                bank.s_BankAddress = s_BankAddress
            }
            else
            {
                bank.s_BankAddress = ""
            }
            
            if let s_IFSCCode = item[BankDetailsKey.s_IFSCCode] as? String
            {
                bank.s_IFSCCode = s_IFSCCode
            }
            else
            {
                bank.s_IFSCCode = ""
            }
            
            if let s_AccountStatus = item[BankDetailsKey.s_AccountStatus] as? String
            {
                bank.s_AccountStatus = s_AccountStatus
            }
            else
            {
                bank.s_AccountStatus = ""
            }
            
            if let s_FileName = item[BankDetailsKey.s_FileName] as? String
            {
                bank.s_FileName = s_FileName
            }
            else
            {
                bank.s_FileName = ""
            }
            
            if let s_MobileNo = item[BankDetailsKey.s_MobileNo] as? String
            {
                bank.s_MobileNo = s_MobileNo
            }
            else
            {
                bank.s_MobileNo = ""
            }
            
            if let s_UserTypeName = item[BankDetailsKey.s_UserTypeName] as? String
            {
                bank.s_UserTypeName = s_UserTypeName
            }
            else
            {
                bank.s_UserTypeName = ""
            }
            
            if let s_FirmName = item[BankDetailsKey.s_FirmName] as? String
            {
                bank.s_FirmName = s_FirmName
            }
            else
            {
                bank.s_FirmName = ""
            }
            
            if let d_CreatedDate = item[BankDetailsKey.d_CreatedDate] as? String
            {
                bank.d_CreatedDate = d_CreatedDate
            }
            else
            {
                bank.d_CreatedDate = ""
            }
            
            if let s_AccountHolderName = item[BankDetailsKey.s_AccountHolderName] as? String
            {
                bank.s_AccountHolderName = s_AccountHolderName
            }
            else
            {
                bank.s_AccountHolderName = ""
            }
            bankDetails_arr.append(bank)
            
            saveBankDetailsData(bank: bank)
            
        }
        return (accountNumber_arr, bankDetails_arr)
    }
    
    class func saveBankDetailsData(bank:BankDetails)
    {
        guard let db = DataProvider.getDBConnection() else
        {
            print("db connection not found")
            return
        }
        
        do {
            
            DataProvider.dropTable(table: tblBank)
            
            try db.run(tblBank.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { t in
                t.column(c_Pk_BankID, primaryKey: true)
                t.column(c_s_BankAccountNo)
                t.column(c_s_BankName)
                t.column(c_s_BankAddress)
                t.column(c_s_IFSCCode)
                t.column(c_s_AccountStatus)
                t.column(c_s_FileName)
                t.column(c_s_FirmName)
                t.column(c_d_CreatedDate)
                t.column(c_s_AccountHolderName)
            }))
            
            let insert = tblBank.insert(
                //c_Pk_BankID <- user.Pk_UserID ?? 0,
                c_s_BankAccountNo <- bank.s_BankAccountNo ?? "",
                c_s_BankName <- bank.s_BankName ?? "",
                c_s_BankAddress <- bank.s_BankAddress ?? "",
                c_s_IFSCCode <- bank.s_IFSCCode ?? "",
                c_s_AccountStatus <- bank.s_AccountStatus ?? "",
                c_s_FileName <- bank.s_FileName ?? "",
                c_s_FirmName <- bank.s_FirmName ?? "",
                c_d_CreatedDate <- bank.d_CreatedDate ?? "",
                c_s_AccountHolderName <- bank.s_AccountHolderName ?? ""
            )
            try db.run(insert)
            //print(rowid)
            
        } catch  {
            print("error DB Insert")
            print("Error info: \(error)")
        }
    }
}

struct BankDetailsKey
{
    static let s_BankAccountNo = "s_BankAccountNo"
    static let s_BankName = "s_BankName"
    static let s_BankAddress = "s_BankAddress"
    static let s_IFSCCode = "s_IFSCCode"
    static let s_AccountStatus = "s_AccountStatus"
    static let s_FileName = "s_FileName"
    static let s_MobileNo = "s_MobileNo"
    static let s_UserTypeName = "s_UserTypeName"
    static let s_FirmName = "s_FirmName"
    static let d_CreatedDate = "d_CreatedDate"
    static let s_AccountHolderName = "s_AccountHolderName"
}

