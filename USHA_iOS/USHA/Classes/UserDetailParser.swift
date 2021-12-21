//
//  UserDetailParser.swift
 
//
//  Created by Apple.Inc on 07/06/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import Foundation
import SQLite

class UserDetails:NSObject
{
    var Pk_UserID:Int?
    var s_UserTypeCode :String?
    var s_UserCode :String?
    var s_FirmCode :String?
    var s_MobileNo :String?
    var s_FullName :String?
    var d_DOB :String?
    var s_EmailID :String?
    var s_Education :String?
    var s_ShopName :String?
    var s_ShopAddress1 :String?
    var s_ShopAddress2 :String?
    var s_ShopGEOID :String?
    var b_IsActive :String?
    var s_CreatedSource :String?
    var s_CreatedBy :String?
    var d_Balance :Double?
    var s_RoleName :String?
    var s_UserTypeName :String?
    var TotalBalance :String?
    var SchemeAllow :String?
}


let tblUser = Table("USER")

let c_Pk_UserID = Expression<Int>(UserDetailKey.Pk_UserID)
let c_s_UserTypeCode = Expression<String>(UserDetailKey.s_UserTypeCode)
let c_s_UserCode = Expression<String>(UserDetailKey.s_UserCode)
let c_s_FirmCode = Expression<String>(UserDetailKey.s_FirmCode)
let c_s_MobileNo = Expression<String>(UserDetailKey.s_MobileNo)
let c_s_FullName = Expression<String>(UserDetailKey.s_FullName)
let c_d_DOB = Expression<String>(UserDetailKey.d_DOB)
let c_s_EmailID = Expression<String>(UserDetailKey.s_EmailID)
let c_s_Education = Expression<String>(UserDetailKey.s_Education)
let c_s_ShopName = Expression<String>(UserDetailKey.s_ShopName)
let c_s_ShopAddress1 = Expression<String>(UserDetailKey.s_ShopAddress1)
let c_s_ShopAddress2 = Expression<String>(UserDetailKey.s_ShopAddress2)
let c_s_ShopGEOID = Expression<String>(UserDetailKey.s_ShopGEOID)
let c_b_IsActive = Expression<String>(UserDetailKey.b_IsActive)
let c_s_CreatedSource = Expression<String>(UserDetailKey.s_CreatedSource)
let c_s_CreatedBy = Expression<String>(UserDetailKey.s_CreatedBy)
let c_d_Balance = Expression<Double>(UserDetailKey.d_Balance)
let c_s_RoleName = Expression<String>(UserDetailKey.s_RoleName)
let c_s_UserTypeName = Expression<String>(UserDetailKey.s_UserTypeName)
let c_TotalBalance = Expression<String>(UserDetailKey.TotalBalance)
let c_SchemeAllow = Expression<String>(UserDetailKey.SchemeAllow)

class UserDetailParser: NSObject
{
    class func parseUserDetail(json:[String:Any], actionType:String)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
//        if let db = DataProvider.sharedInstance.getDBConnection()
//        {
//            db.trace { (error) in
//                print(error)
//            }
//            do {
//                try db.run(tblUser.drop(ifExists: true))
//            } catch  {
//                print("error DB delete")
//                print("Error info: \(error)")
//            }
        
            let userDetail = UserDetails()
            if let Pk_UserID = json[UserDetailKey.Pk_UserID] as? Int
            {
                userDetail.Pk_UserID = Pk_UserID
            }
            else
            {
                userDetail.Pk_UserID = -1
            }
            
            if let s_UserTypeCode = json[UserDetailKey.s_UserTypeCode] as? String
            {
                userDetail.s_UserTypeCode = s_UserTypeCode
            }
            else
            {
                userDetail.s_UserTypeCode = ""
            }
                    
            if let s_UserCode = json[UserDetailKey.s_UserCode] as? String
            {
                userDetail.s_UserCode = s_UserCode
            }
            else
            {
                userDetail.s_UserCode = ""
            }
            
            if let s_FirmCode = json[UserDetailKey.s_FirmCode] as? String
            {
                userDetail.s_FirmCode = s_FirmCode
            }
            else
            {
                userDetail.s_FirmCode = ""
            }
                    
            if let s_MobileNo = json[UserDetailKey.s_MobileNo] as? String
            {
                userDetail.s_MobileNo = s_MobileNo
            }
            else
            {
                userDetail.s_MobileNo = ""
            }
                    
            if let s_FullName = json[UserDetailKey.s_FullName] as? String
            {
                userDetail.s_FullName = s_FullName
            }
            else
            {
                userDetail.s_FullName = ""
            }
                    
            if let d_DOB = json[UserDetailKey.d_DOB] as? String
            {
                userDetail.d_DOB = d_DOB
            }
            else
            {
                userDetail.d_DOB = ""
            }
                    
            if let s_EmailID = json[UserDetailKey.s_EmailID] as? String
            {
                userDetail.s_EmailID = s_EmailID
            }
            else
            {
                userDetail.s_EmailID = ""
            }
                    
            if let s_Education = json[UserDetailKey.s_Education] as? String
            {
                userDetail.s_Education = s_Education
            }
            else
            {
                userDetail.s_Education = ""
            }
                    
            if let s_ShopName = json[UserDetailKey.s_ShopName] as? String
            {
                userDetail.s_ShopName = s_ShopName
            }
            else
            {
                userDetail.s_ShopName = ""
            }
            
            if let s_ShopAddress1 = json[UserDetailKey.s_ShopAddress1] as? String
            {
                userDetail.s_ShopAddress1 = s_ShopAddress1
            }
            else
            {
                userDetail.s_ShopAddress1 = ""
            }
            if let s_ShopAddress2 = json[UserDetailKey.s_ShopAddress2] as? String
            {
                userDetail.s_ShopAddress2 = s_ShopAddress2
            }
            else
            {
                userDetail.s_ShopAddress2 = ""
            }
            
            if let s_ShopGEOID = json[UserDetailKey.s_ShopGEOID] as? String
            {
                userDetail.s_ShopGEOID = s_ShopGEOID
            }
            else
            {
                userDetail.s_ShopGEOID = ""
            }
                    
            if let b_IsActive = json[UserDetailKey.b_IsActive] as? String
            {
                userDetail.b_IsActive = b_IsActive
            }
            else
            {
                userDetail.b_IsActive = ""
            }
            
            
            if let s_CreatedSource = json[UserDetailKey.s_CreatedSource] as? String
            {
                userDetail.s_CreatedSource = s_CreatedSource
            }
            else
            {
                userDetail.s_CreatedSource = ""
            }
            
            if let s_CreatedBy = json[UserDetailKey.s_CreatedBy] as? String
            {
                userDetail.s_CreatedBy = s_CreatedBy
            }
            else
            {
                userDetail.s_CreatedBy = ""
            }
            
            if let d_Balance = json[UserDetailKey.d_Balance] as? Double
            {
                userDetail.d_Balance = d_Balance
            }
            else
            {
                userDetail.d_Balance = 0.0
            }
            
            if let s_RoleName = json[UserDetailKey.s_RoleName] as? String
            {
                userDetail.s_RoleName = s_RoleName
            }
            else
            {
                userDetail.s_RoleName = ""
            }
            
            if let s_UserTypeName = json[UserDetailKey.s_UserTypeName] as? String
            {
                userDetail.s_UserTypeName = s_UserTypeName
            }
            else
            {
                userDetail.s_UserTypeName = ""
            }
            
            if let TotalBalance = json[UserDetailKey.TotalBalance] as? String
            {
                userDetail.TotalBalance = TotalBalance
            }
            else
            {
                userDetail.TotalBalance = ""
            }
            
            if let SchemeAllow = json[UserDetailKey.SchemeAllow] as? String
            {
                userDetail.SchemeAllow = SchemeAllow
            }
            else
            {
                userDetail.SchemeAllow = ""
            }
            
            if actionType == ActionType.EPLUS
            {
                DataProvider.sharedInstance.ePlusUserDetails = userDetail
            }
            else
            {
                DataProvider.sharedInstance.userDetails = userDetail
                saveUserDetaildData(user: userDetail)
            }
//        }
//        else {
//            print("error DB connection")
//        }
    }
    
    class func saveUserDetaildData(user :UserDetails)
    {
        guard let db = DataProvider.getDBConnection() else
        {
            print("db connection not found")
            return
        }
        
        db.trace { (error) in
            print(error)
        }
        do {

            DataProvider.dropTable(table: tblUser)
            try db.run(tblUser.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { t in
                t.column(c_Pk_UserID, primaryKey: true)
                t.column(c_s_UserTypeCode)
                t.column(c_s_UserCode)
                t.column(c_s_FirmCode)
                t.column(c_s_MobileNo)
                t.column(c_s_FullName)
                t.column(c_d_DOB)
                t.column(c_s_EmailID)
                t.column(c_s_Education)
                t.column(c_s_ShopName)
                t.column(c_s_ShopAddress1)
                t.column(c_s_ShopAddress2)
                t.column(c_s_ShopGEOID)
                t.column(c_b_IsActive)
                t.column(c_s_CreatedSource)
                t.column(c_s_CreatedBy)
                t.column(c_d_Balance)
                t.column(c_s_RoleName)
                t.column(c_s_UserTypeName)
                t.column(c_TotalBalance)
                t.column(c_SchemeAllow)
            }))
            
            let insert = tblUser.insert(
                c_Pk_UserID <- user.Pk_UserID ?? 0,
                c_s_UserTypeCode <- user.s_UserTypeCode ?? "",
                c_s_UserCode <- user.s_UserCode ?? "",
                c_s_FirmCode <- user.s_FirmCode ?? "",
                c_s_MobileNo <- user.s_MobileNo ?? "",
                c_s_FullName <- user.s_FullName ?? "",
                c_d_DOB <- user.d_DOB ?? "",
                c_s_EmailID <- user.s_EmailID ?? "",
                c_s_Education <- user.s_Education ?? "",
                c_s_ShopName <- user.s_ShopName ?? "",
                c_s_ShopAddress1 <- user.s_ShopAddress1 ?? "",
                c_s_ShopAddress2 <- user.s_ShopAddress2 ?? "",
                c_s_ShopGEOID <- user.s_ShopGEOID ?? "",
                c_b_IsActive <- user.b_IsActive ?? "",
                c_s_CreatedSource <- user.s_CreatedSource ?? "",
                c_s_CreatedBy <- user.s_CreatedBy ?? "",
                c_d_Balance <- user.d_Balance ?? 0.0,
                c_s_RoleName <- user.s_RoleName ?? "",
                c_s_UserTypeName <- user.s_UserTypeName ?? "",
                c_TotalBalance <- user.TotalBalance ?? "",
                c_SchemeAllow <- user.SchemeAllow ?? ""
            )
            
            try db.run(insert)
            
            //print(rowid)
            
        } catch  {
            print("error DB Insert")
            print("Error info: \(error)")
        }
    }
    
}


struct UserDetailKey
{
    static let Pk_UserID = "Pk_UserID"
    static let s_UserTypeCode = "s_UserTypeCode"
    static let s_UserCode = "s_UserCode"
    static let s_FirmCode = "s_FirmCode"
    static let s_MobileNo = "s_MobileNo"
    static let s_FullName = "s_FullName"
    static let d_DOB = "d_DOB"
    static let s_EmailID = "s_EmailID"
    static let s_Education = "s_Education"
    static let s_ShopName = "s_ShopName"
    static let s_ShopAddress1 = "s_ShopAddress1"
    static let s_ShopAddress2 = "s_ShopAddress2"
    static let s_ShopGEOID = "s_ShopGEOID"
    static let b_IsActive = "b_IsActive"
    static let s_CreatedSource = "s_CreatedSource"
    static let s_CreatedBy = "s_CreatedBy"
    static let d_Balance = "d_Balance"
    static let s_RoleName = "s_RoleName"
    static let s_UserTypeName = "s_UserTypeName"
    static let TotalBalance = "TotalBalance"
    static let SchemeAllow = "SchemeAllow"
}
