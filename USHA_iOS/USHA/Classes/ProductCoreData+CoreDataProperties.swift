//
//  ProductCoreData+CoreDataProperties.swift
//  
//
//  Created by Apple on 24/10/19.
//
//

import Foundation
import CoreData


extension ProductCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductCoreData> {
        return NSFetchRequest<ProductCoreData>(entityName: "ProductCoreData")
    }

    @NSManaged public var name: String?
    @NSManaged public var discount: String?
    @NSManaged public var unit: String?
    @NSManaged public var price: Double
    @NSManaged public var code: String?
    @NSManaged public var categoryCode: String?
    @NSManaged public var qty: Int16
    @NSManaged public var amount: Double

}
