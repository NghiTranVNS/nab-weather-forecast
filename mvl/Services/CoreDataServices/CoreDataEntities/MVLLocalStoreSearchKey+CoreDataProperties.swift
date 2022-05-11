//
//  MVLLocalStoreSearchKey+CoreDataProperties.swift
//  
//
//  Created by Mr Nghi Tran Kien Nghi on 5/8/22.
//
//

import Foundation
import CoreData


extension MVLLocalStoreSearchKey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MVLLocalStoreSearchKey> {
        return NSFetchRequest<MVLLocalStoreSearchKey>(entityName: "MVLLocalStoreSearchKey")
    }

    @NSManaged public var k_key: String?
    @NSManaged public var k_date: Date?
    @NSManaged public var k_weathers: NSSet?

}

// MARK: Generated accessors for k_weathers
extension MVLLocalStoreSearchKey {

    @objc(addK_weathersObject:)
    @NSManaged public func addToK_weathers(_ value: MVLLocalStoreWeather)

    @objc(removeK_weathersObject:)
    @NSManaged public func removeFromK_weathers(_ value: MVLLocalStoreWeather)

    @objc(addK_weathers:)
    @NSManaged public func addToK_weathers(_ values: NSSet)

    @objc(removeK_weathers:)
    @NSManaged public func removeFromK_weathers(_ values: NSSet)

}
