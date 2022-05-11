//
//  LocalStoreMerchandise.swift
//  mvl
//
//  Created by nghitran on 16/02/2022.
//

import UIKit
import CoreData

public final class MVLLocalStoreCoordinate: NSManagedObject {
    @NSManaged public var c_name: String?
    @NSManaged public var c_aqi: NSNumber?
    @NSManaged public var c_lat: NSNumber?
    @NSManaged public var c_long: NSNumber?
}

extension MVLLocalStoreCoordinate: MVLCoordinate {
    var name: String {
        get {
            return c_name ?? ""
        }
        set {
            c_name = newValue
        }
    }
    
    var aqi: Int {
        get {
            return c_aqi?.intValue ?? 0
        }
        set {
            c_aqi = NSNumber(value: newValue)
        }
    }
    
    var lat: Double {
        get {
            return c_lat?.doubleValue ?? 0
        }
        set {
            c_lat = NSNumber(value: newValue)
        }
    }
    
    var long: Double {
        get {
            return c_long?.doubleValue ?? 0
        }
        set {
            c_long = NSNumber(value: newValue)
        }
    }
}
