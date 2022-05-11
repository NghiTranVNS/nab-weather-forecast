//
//  MVLLocalStoreSearchKey.swift
//  mvl
//
//  Created by Mr Nghi Tran Kien Nghi on 5/8/22.
//

import UIKit
import CoreData

public final class _MVLLocalStoreSearchKey: NSManagedObject {
    @NSManaged public var k_key: String?
    @NSManaged public var k_date: Date?
    @NSManaged public var k_weathers: Set<MVLLocalStoreWeather>?
}


extension MVLLocalStoreSearchKey: MVLSearchKey {
    var date: Date {
        get {
            return k_date ?? Date(timeIntervalSince1970: 0)
        }
        set {
            k_date = newValue
        }
    }
    
    var key: String {
        get {
            return k_key ?? ""
        }
        set {
            k_key = newValue
        }
    }
    
    
    var weathers: [MVLWeather] {
        get {
            return k_weathers?.compactMap({ $0 as? MVLWeather}) ?? []
        }
        set {
            k_weathers = NSSet(array: newValue.compactMap({ $0 as? MVLLocalStoreWeather }))
        }
    }
    
}
