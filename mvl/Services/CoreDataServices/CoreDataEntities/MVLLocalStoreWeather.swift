//
//  MVLLocalStoreWeather.swift
//  mvl
//
//  Created by Mr Nghi Tran Kien Nghi on 5/8/22.
//

import UIKit
import CoreData

public final class  _MVLLocalStoreWeather: NSManagedObject {
    @NSManaged public var w_date: Date?
    @NSManaged public var w_temp: NSNumber?
    @NSManaged public var w_pressure: NSNumber?
    @NSManaged public var w_humidity: NSNumber?
    @NSManaged public var w_descrpt: String?
    @NSManaged public var w_icon: String?
    @NSManaged public var w_key: MVLLocalStoreSearchKey?
}


extension MVLLocalStoreWeather: MVLWeather {
    var date: Date {
        get {
            return w_date ?? Date(timeIntervalSince1970: 0)
        }
        set {
            w_date = newValue
        }
    }
    
    var temp: Double {
        get {
            return w_temp
        }
        set {
            w_temp = newValue
        }
    }
    
    var pressure: Int {
        get {
            return Int(w_pressure)
        }
        set {
            w_pressure = Int32(newValue)
        }
    }
    
    var humidity: Int {
        get {
            return Int(w_humidity)
        }
        set {
            w_humidity = Int32(newValue)
        }
    }
    
    var descrpt: String {
        get {
            return w_descrpt ?? ""
        }
        set {
            w_descrpt = newValue
        }
    }
    
    var icon: String {
        get {
            return w_icon ?? ""
        }
        set {
            w_icon = newValue
        }
    }
}
