//
//  MVLWeather.swift
//  mvl
//
//  Created by Mr Nghi Tran Kien Nghi on 5/8/22.
//

import Foundation

protocol MVLWeather {
    var date: Date { get set }
    var temp: Double { get set }
    var pressure: Int { get set }
    var humidity: Int { get set }
    var descrpt: String { get set }
    var icon: String  { get set }
}

extension MVLWeather {
    func dateDescription() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy"
        let dateStr = dateFormatter.string(from: self.date)
        
        let str = "Date: \(dateStr)\n"
        return str
    }

    func temperatureDescription() -> String {
        let tempStr = "Average Temperature: \(self.temp)°C"
        return tempStr
    }

    func pressureDescription() -> String {
        let str = "Pressure: \(self.pressure)"
        return str
    }

    func humidityDescription() -> String {
        let str = "Humidity: \(self.humidity)%"
        return str
    }
    
    func shortDescription() -> String {
        let str = "Description: \(self.descrpt)"
        return str
    }
}

struct MVLRawWeather: MVLWeather {
    var date: Date = Date()
    
    var temp: Double = 0
    
    var pressure: Int = 0
    
    var humidity: Int = 0
    
    var descrpt: String = ""
    
    var icon: String = ""
}
