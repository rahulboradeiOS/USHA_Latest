//
//  VoucherParser.swift
//  ELECTRICIAN
//
//  Created by Apple.Inc on 01/12/18.
//  Copyright © 2018 Apple.Inc. All rights reserved.
//

import UIKit
import SQLite

class Voucher: NSObject
{
    var Image:String?
    var RedProductName:String?
    var ProductImage:String?
    var RedProductCode:String?
    var RedProductDescription:String?
    var qty:Int?
    var total:Double?
    var id:Int?
}

let tblVoucher = Table("VOUCHER")

let c_Pk_VoucherID = Expression<Int>(VoucherKey.Pk_VoucherID)
let c_Image = Expression<String>(VoucherKey.Image)
let c_RedProductName = Expression<String>(VoucherKey.RedProductName)
let c_ProductImage = Expression<String>(VoucherKey.ProductImage)
let c_RedProductCode = Expression<String>(VoucherKey.RedProductCode)
let c_RedProductDescription = Expression<String>(VoucherKey.RedProductDescription)
let c_Qty = Expression<Int>(VoucherKey.Qty)
let c_Total = Expression<Double>(VoucherKey.Total)

class VoucherParser: NSObject
{
    class func parseVoucher(json:[[String:Any]]) -> [Voucher]
    {
        var s = [Voucher]()
        for item in json
        {
            let voucher = Voucher()
            
            if let Image = item[VoucherKey.Image] as? String
            {
                voucher.Image = Image
            }
            else
            {
                voucher.Image = ""
            }
            
            if let RedProductName = item[VoucherKey.RedProductName] as? String
            {
                voucher.RedProductName = RedProductName
            }
            else
            {
                voucher.RedProductName = ""
            }
            
            if let ProductImage = item[VoucherKey.ProductImage] as? String
            {
                voucher.ProductImage = ProductImage
            }
            else
            {
                voucher.ProductImage = ""
            }
            
            if let RedProductCode = item[VoucherKey.RedProductCode] as? String
            {
                voucher.RedProductCode = RedProductCode
            }
            else
            {
                voucher.RedProductCode = ""
            }
            
            if let RedProductDescription = item[VoucherKey.RedProductDescription] as? String
            {
                voucher.RedProductDescription = RedProductDescription
            }
            else
            {
                voucher.RedProductDescription = ""
            }
            
            s.append(voucher)
        }
        return s
    }

    class func saveVoucherData(voucher:Voucher) -> Bool
    {
        guard let db = DataProvider.getDBConnection() else
        {
            print("db connection not found")
            return false
        }
        
        do {
            let itExists = try db.scalar(tblVoucher.exists)
            if itExists
            {
                return VoucherParser.insert(voucher: voucher, db: db)
            }
            else
            {
                if(VoucherParser.createTable(db: db))
                {
                    return VoucherParser.insert(voucher: voucher, db: db)
                }
                else
                {
                    print("Error to create tblVoucher")
                    return false
                }
            }
        }
        catch let error
        {
            print("Error in VoucherParser doesn't exit tblVoucher")
            print("insertion failed: \(error)")
            if(createTable(db: db))
            {
                return VoucherParser.insert(voucher: voucher, db: db)
            }
            else
            {
                print("Error to create tblVoucher")
                return false
            }
        }
    }
    
    class func createTable(db:Connection) -> Bool
    {
        do
        {
            try db.run(tblVoucher.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { t in
                t.column(c_Pk_VoucherID, primaryKey: .autoincrement)
                t.column(c_Image)
                t.column(c_ProductImage)
                t.column(c_RedProductName)
                t.column(c_Qty)
                t.column(c_Total)
                t.column(c_RedProductCode)
                t.column(c_RedProductDescription)
            }))
            return true

        }catch {
            print("error DB create tblVoucher")
            print("Error info: \(error)")
            return false
        }
    }
    
    class func insert(voucher:Voucher, db:Connection) -> Bool
    {
        do {
            let insert = tblVoucher.insert(
                c_Image <- voucher.Image ?? "",
                c_RedProductName <- voucher.RedProductName ?? "",
                c_ProductImage <- voucher.ProductImage ?? "",
                c_Qty <- voucher.qty ?? 0,
                c_Total <- Double(voucher.total ?? 0),
                c_RedProductCode <- voucher.RedProductCode ?? "",
                c_RedProductDescription <- voucher.RedProductDescription ?? ""
            )
            try db.run(insert)
            return true
        }
        catch let error
        {
            print("insertion failed tblVoucher: \(error)")
            return true
        }
    }
}

struct VoucherKey
{
    static let Pk_VoucherID = "Pk_VoucherID"
    static let Image = "Image"
    static let RedProductName = "RedProductName"
    static let ProductImage = "ProductImage"
    static let RedProductCode = "RedProductCode"
    static let RedProductDescription = "RedProductDescription"
    static let Qty = "Qty"
    static let Total = "Total"
}
