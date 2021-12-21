//
//  SchemeParser.swift
 
//
//  Created by Apple.Inc on 08/06/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import Foundation
import SQLite

class Scheme: NSObject
{
    var d_Balance : Double?
    var s_SchemePromCode : String?
    var s_SchemePromName : String?
}
class DropdownQ: NSObject
{
    var n_sequence : Int?
    var s_AnswerOption : String?
    var s_Answercode : String?
}

let tblScheme = Table("SCHEME")

let c_Pk_SchemeID = Expression<Int>("Pk_SchemeID")
//let c_d_Balance = Expression<String>(SchemeKey.d_Balance)
//let c_s_SchemePromCode = Expression<String>(SchemeKey.s_SchemePromCode)
//let c_s_SchemePromName = Expression<String>(SchemeKey.s_SchemePromName)

class SchemeParser:NSObject
{
    class func parseScheme(json:[[String:Any]]) -> ([String], [Scheme])
    {
        var s = [Scheme]()
        var schmeName_arr = [String]()
        for item in json
        {
            let scheme = Scheme()

            if let d_Balance = item[SchemeKey.d_Balance] as? Double
            {
                scheme.d_Balance = d_Balance
            }
            else
            {
                scheme.d_Balance = 0.0
            }
            
            if let s_SchemePromCode = item[SchemeKey.s_SchemePromCode] as? String
            {
                scheme.s_SchemePromCode = s_SchemePromCode
            }
            else
            {
                scheme.s_SchemePromCode = ""
            }
            
            if let s_SchemePromName = item[SchemeKey.s_SchemePromName] as? String
            {
                schmeName_arr.append(s_SchemePromName)
                scheme.s_SchemePromName = s_SchemePromName
            }
            else
            {
                scheme.s_SchemePromName = ""
            }
            
            s.append(scheme)
        }
        return (schmeName_arr, s)
    }
    
    class func saveSchemeData(scheme:Scheme)
    {
        guard let db = DataProvider.getDBConnection() else
        {
            print("db connection not found")
            return
        }
        do {
            try db.run(tblScheme.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { t in
                t.column(c_Pk_SchemeID, primaryKey: .autoincrement)
                t.column(c_d_Balance)
                t.column(c_s_SchemePromCode, unique: true)
                t.column(c_s_SchemePromName, unique: true)
            }))
            
            let insert = tblScheme.insert(
                //c_Pk_SchemeID <- user.Pk_UserID ?? 0,
                c_d_Balance <- scheme.d_Balance ?? 0.0,
                c_s_SchemePromCode <- scheme.s_SchemePromCode ?? "",
                c_s_SchemePromName <- scheme.s_SchemePromName ?? ""
            )
            try db.run(insert)
            //print(rowid)
            
        } catch  {
            print("error DB Insert")
            print("Error info: \(error)")
        }
    }
}

struct SchemeKey
{
    static let Pk_SchemeID = "Pk_SchemeID"
    static let s_SchemePromName = "s_SchemePromName"
    static let d_Balance = "d_Balance"
    static let s_SchemePromCode = "s_SchemePromCode"
}
