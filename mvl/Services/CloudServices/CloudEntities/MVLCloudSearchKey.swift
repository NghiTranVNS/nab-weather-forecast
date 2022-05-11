//
//  MVLCloudWeatherKey.swift
//  mvl
//
//  Created by Mr Nghi Tran Kien Nghi on 5/12/22.
//

import UIKit
import ObjectMapper

class MVLCloudSearchKey: NSObject, Mappable {
    var k_name: String = ""
    var k_date: Date = Date()
    var k_weathers: [MVLCloudWeather] = []
    var k_key: String = ""
    
    // MARK: Object Mapper
    required public init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        self.k_name <- map["city.name"]
        let today = Date()
        self.k_date = today
        
        self.k_weathers <- map["list"]
        var i = 0
        for weather in k_weathers {
            let timeInterval = 86400 * i
            weather.date = today.addingTimeInterval(Double(timeInterval))
            i += 1
        }
    }
    
    override init() {
        k_name = ""
        k_date = Date()
        k_weathers = []
    }
}

extension MVLCloudSearchKey: MVLSearchKey {
    var date: Date {
        get {
            return k_date
        }
        set {
            k_date = newValue
        }
    }
    
    var key: String {
        get {
            return k_key
        }
        set {
            k_key = newValue
        }
    }
    
    var weathers: [MVLWeather] {
        get {
            return k_weathers
        }
        set {
            k_weathers = newValue.compactMap({ $0 as? MVLCloudWeather })
        }
    }
}
