//
//  ProductCoreData+CoreDataClass.swift
//  
//
//  Created by Apple on 24/10/19.
//
//

import Foundation
import CoreData

@objc(ProductCoreData)
public class ProductCoreData: NSManagedObject
{
    
    class func insert(dataDict: JSONDictionary, into context: NSManagedObjectContext = DatabaseManager.sharedInstance.context) -> ProductCoreData {
        var productData: ProductCoreData?
        
        
        if let id = dataDict["id"], !"\(id)".isEmpty {
            productData = ProductCoreData.fetch(id: "\(id)")
        }
        
        if productData == nil {
            productData = NSEntityDescription.insertNewObject(forEntityName: "ProductCoreData", into: context) as? ProductCoreData
        }
        
//        var qty = 0
//        var amount = 0.0
        
        if let price = dataDict["price"] as? Double {
            print(price)
            productData!.price = "\(price)"
        }
        
        if let discount = dataDict["discount"] as? String {
            productData!.discount = discount
        }
        
        if let categoryCode = dataDict["categoryCode"] as? String {
            productData!.categoryCode = categoryCode
        }

        if let code = dataDict["code"] as? String {
            productData!.code = code
        }
        
        if let unit = dataDict["unit"] as? String {
            productData!.unit = unit
        }
        
        if let name = dataDict["name"] as? String {
            productData!.name = name
        }
        
        DatabaseManager.sharedInstance.saveContext()
        
        return productData!
    }
    
    // MARK: - Check Whether Value Exist or Not
    
    // MARK: -
    
    class func fetch(id: String?) -> ProductCoreData? {
        var predicateStr = ""
        if let id = id {
            predicateStr = "id == '\(id)'"
        }
        
        if let fetchResult = DatabaseManager.sharedInstance.fetchData("ProductCoreData", predicate: predicateStr, sort: nil) {
            if !fetchResult.isEmpty {
                return fetchResult[0] as? ProductCoreData
            }
            return nil
        }
        return nil
    }
}
