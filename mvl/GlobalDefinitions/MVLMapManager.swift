//
//  MVLMapManager.swift
//  mvl
//
//  Created by nghitran on 18/02/2022.
//

import GoogleMaps

class MVLMapManager {
    static let shared = MVLMapManager()
    
    private init() {
        GMSServices.provideAPIKey(GlobalVariables.googleMapAPIKey)
    }
}
