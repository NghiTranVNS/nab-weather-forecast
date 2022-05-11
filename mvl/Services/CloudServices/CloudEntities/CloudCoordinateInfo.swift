//
//  CloudCoordinateInfo.swift
//  mvl
//
//  Created by nghitran on 18/02/2022.
//

import UIKit
import ObjectMapper

class CloudCoordinateInfo: NSObject, Mappable {
    var name: String = ""
    var administratives: [CloudAdministrative] = []
    
    // MARK: Object Mapper
    required public init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        self.administratives <- map["localityInfo.administrative"]
        self.name = ""
        let admCount = administratives.count
        if admCount >= 2 {
            self.name = "\(administratives[admCount-2].name), \(administratives[admCount-1].name)"
        }
    }
    
    override init() {
        name = ""
        administratives = []
    }
}

class CloudAdministrative: NSObject, Mappable {
    var name: String = ""
  
    // MARK: Object Mapper
    required public init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        self.name <- map["name"]
    }
    
    override init() {
        name = ""
    }
}

