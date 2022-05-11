//
//  MVLLocalStoreWeather+CoreDataProperties.swift
//  
//
//  Created by Mr Nghi Tran Kien Nghi on 5/8/22.
//
//

import Foundation
import CoreData


extension MVLLocalStoreWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MVLLocalStoreWeather> {
        return NSFetchRequest<MVLLocalStoreWeather>(entityName: "MVLLocalStoreWeather")
    }

    @NSManaged public var w_date: Date?
    @NSManaged public var w_temp: Double
    @NSManaged public var w_pressure: Int32
    @NSManaged public var w_humidity: Int32
    @NSManaged public var w_descrpt: String?
    @NSManaged public var w_icon: String?
    @NSManaged public var w_name: String?
    @NSManaged public var w_key: MVLLocalStoreSearchKey?

}
