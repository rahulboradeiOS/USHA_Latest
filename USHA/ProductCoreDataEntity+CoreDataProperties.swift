//
//  ProductCoreDataEntity+CoreDataProperties.swift
//  
//
//  Created by Apple on 24/10/19.
//
//

import Foundation
import CoreData


extension ProductCoreDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductCoreDataEntity> {
        return NSFetchRequest<ProductCoreDataEntity>(entityName: "ProductCoreDataEntity")
    }

    @NSManaged public var code: String?
    @NSManaged public var name: String?
    @NSManaged public var discount: String?
    @NSManaged public var unit: String?
    @NSManaged public var categoryCode: String?
    @NSManaged public var qty: Int32
    @NSManaged public var price: Double
    @NSManaged public var amount: Float

}
