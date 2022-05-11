//
//  MVLCloudWeather.swift
//  mvl
//
//  Created by Mr Nghi Tran Kien Nghi on 5/12/22.
//

import UIKit
import ObjectMapper

class MVLCloudWeather: NSObject, Mappable {
    var w_date: Date = Date()
    var w_temp: Double = 0
    var w_pressure: Int = 0
    var w_humidity: Int = 0
    var w_descrpt: String = ""
    var w_icon: String = ""
    private var weatherDatas: [MVLWeatherForcastCloudData] = []
   
    // MARK: Object Mapper
    required public init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        self.w_date = Date()
        self.w_pressure <- map["pressure"]
        self.w_humidity <- map["humidity"]
        self.weatherDatas <- map["weather"]
        
        if let weatherData = weatherDatas.first {
            self.w_descrpt = weatherData.w_description
            self.w_icon = weatherData.w_icon
        }
        
        if let tempDict = map.JSON["temp"] as? [String:Any], let minTemp = tempDict["min"] as? Double, let maxTemp = tempDict["max"] as? Double {
            self.w_temp = (minTemp + maxTemp) / 2
        }
    }
    
    override init() {
        w_date = Date()
        w_temp = 0
        w_pressure = 0
        w_humidity = 0
        w_descrpt = ""
        w_icon = ""
    }
}

fileprivate class MVLWeatherForcastCloudData: NSObject, Mappable {
    var w_description = ""
    var w_icon = ""
    
    // MARK: Object Mapper
    required public init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        self.w_description <- map["description"]
        self.w_icon <- map["icon"]
    }
    
    override init() {
        w_description = ""
        w_icon = ""
    }
}

extension MVLCloudWeather: MVLWeather {
    var date: Date {
        get {
            return w_date
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
            return w_pressure
        }
        set {
            w_pressure = newValue
        }
    }
    
    var humidity: Int {
        get {
            return w_humidity
        }
        set {
            w_humidity = newValue
        }
    }
    
    var descrpt: String {
        get {
            return w_descrpt
        }
        set {
            w_descrpt = newValue
        }
    }
    
    var icon: String {
        get {
            return w_icon
        }
        set {
            w_icon = newValue
        }
    }
}
