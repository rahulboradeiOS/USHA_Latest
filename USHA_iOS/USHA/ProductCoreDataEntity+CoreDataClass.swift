//
//  ProductCoreDataEntity+CoreDataClass.swift
//  
//
//  Created by Apple on 24/10/19.
//
//

import Foundation
import CoreData

@objc(ProductCoreDataEntity)
public class ProductCoreDataEntity: NSManagedObject {
    
    class func insert(dataDict: JSONDictionary, into context: NSManagedObjectContext = DatabaseManager.sharedInstance.context) -> ProductCoreDataEntity {
        var productData: ProductCoreDataEntity?
        
        
        if let id = dataDict["id"], !"\(id)".isEmpty {
            productData = ProductCoreDataEntity.fetch(id: "\(id)")
        }
        
        if productData == nil {
            productData = NSEntityDescription.insertNewObject(forEntityName: "ProductCoreDataEntity", into: context) as? ProductCoreDataEntity
        }
        
        
        
        if let amount = dataDict["amount"] as? Double {
            print(amount)
            productData.amount = "\(amount)"
        }
        
        if let price = dataDict["price"] as? Double {
            print(price)
            productData.price = "\(price)"
        }
        
        if let categoryCode = dataDict["categoryCode"] as? String {
            productData.categoryCode = categoryCode
        }
        
        if let code = dataDict["code"] as? String {
            productData!.code = code
        }
        
        if let discount = dataDict["discount"] as? String {
            productData!.discount = discount
        }
        
        if let qty = dataDict["qty"] as? Int32 {
            productData!.qty = qty
        }
        
        if let name = dataDict["name"] as? String {
            productData!.name = name
        }
        
        if let unit = dataDict["unit"] as? String {
            productData!.unit = unit
        }
        
     
        
        DatabaseManager.sharedInstance.saveContext()
        
        return productData!
    }
    
    // MARK: - Check Whether Value Exist or Not
    
    // MARK: -
    
    class func fetch(id: String?) -> ProductCoreDataEntity? {
        var predicateStr = ""
        if let id = id {
            predicateStr = "id == '\(id)'"
        }
        
        if let fetchResult = DatabaseManager.sharedInstance.fetchData("ProductCoreDataEntity", predicate: predicateStr, sort: nil) {
            if !fetchResult.isEmpty {
                return fetchResult[0] as? ProductCoreDataEntity
            }
            return nil
        }
        return nil
    }
}
