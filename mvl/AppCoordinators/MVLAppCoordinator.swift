//
//  AppCoordinator.swift
//  mvl
//
//  Created by nghitran on 18/02/2022.
//

import Foundation
import CoreLocation

protocol MVLAppCoordinator {
    func showMainView()
    func showMapView(atCoordinate coordinate: MVLCoordinate)
    func showCoordinatePreview(pointA: MVLCoordinate, pointB: MVLCoordinate)
}
