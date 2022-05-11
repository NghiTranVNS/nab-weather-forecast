//
//  CloudCoordinateAqi.swift
//  mvl
//
//  Created by nghitran on 18/02/2022.
//

import Foundation
import ObjectMapper

class CloudCoordinateAqi: NSObject, Mappable {
    var aqi: Int = 0
   
    // MARK: Object Mapper
    required public init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        //TODO: Parse coordinate aqi here
        self.aqi <- map["data.aqi"]
    }
    
    override init() {
        aqi = 0
    }
}
