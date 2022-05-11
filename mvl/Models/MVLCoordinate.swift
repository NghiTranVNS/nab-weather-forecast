//
//  MVLCoordinate.swift
//  mvl
//
//  Created by nghitran on 18/02/2022.
//

import Foundation
import CoreLocation

protocol MVLCoordinate {
    var name: String { get set }
    var aqi: Int { get set }
    var lat: Double { get set }
    var long: Double { get set }
}

extension MVLCoordinate {
    func isEqualTo(_ des: MVLCoordinate) -> Bool {
        return self.lat == des.lat && self.long == des.long
    }
    
    func isEqualTo(_ des: CLLocationCoordinate2D) -> Bool {
        return self.lat == des.latitude && self.long == des.longitude
    }
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        set {
            self.lat = newValue.latitude
            self.long = newValue.longitude
        }
    }
    
    func isInitialized() -> Bool {
        return lat == 0 || long == 0
    }
    
    func shortDescription() -> String {
        let nameString = self.name.count > 0 ? "Name: \(self.name)\n" : "Name: __________\n"
        let aqiString = self.aqi > 0 ? "Aqi: \(self.aqi)\n" : "Aqi: ____________\n"
        let coordinateString = !self.isInitialized() ? String(format:"Lat-Long: %.6f-%.6f", self.lat, self.long) : "Lat-Long: _______"
        let pointInfoStr = nameString + aqiString + coordinateString
        return pointInfoStr
    }
    
    func fullDescription() -> String {
        let nameString = self.name.count > 0 ? "Name: \(self.name)\n" : "Name: N/A\n"
        let aqiString = self.aqi > 0 ? "Air quality: \(self.aqi)\n" : "Air quality: N/A\n"
        let coordinateString = !self.isInitialized() ? String(format:"Latitude: %f\nLongitude: %f", self.lat, self.long) : "Latitude: N/A\nLongitude: N/A"
        let pointInfoStr = nameString + aqiString + coordinateString
        return pointInfoStr
    }
    
    func cellDescription() -> String {
        let nameString = self.name.count > 0 ? "\(self.name)\n" : "__________\n"
        let coordinateString = String(format:"%.6f\n%.6f", self.lat, self.long)
        let pointInfoStr = nameString + coordinateString
        return pointInfoStr
    }
    
    func markerDescription() -> String {
        return String(format: "AQI: %d\n%.6f-%.6f", self.aqi, self.lat, self.long)
    }
}

struct MVLRawCoordinate: MVLCoordinate {
    var name: String = ""
    var aqi: Int = 0
    var lat: Double = 0
    var long: Double = 0
}
