//
//  MVLLocationsManager.swift
//  mvl
//
//  Created by nghitran on 18/02/2022.
//

import Foundation
import CoreLocation
import MapKit
import RxSwift

class MVLLocationsManager: NSObject {
    static let shared = MVLLocationsManager()
    
    private let locationManager = CLLocationManager()
    private var getCurrentLocationCompleted: ((CLLocation?) -> Void)?
    
    var latestLocation: CLLocation?
    var locationAuthorizationStatus : PublishSubject<CLAuthorizationStatus?> = PublishSubject()
    var newestCurrentLocation : PublishSubject<CLLocation?> = PublishSubject()
    var isGrantLocationPermission: Bool {
        var grantLocationPermission = false
        if CLLocationManager.locationServicesEnabled() {
            let locationServiceStatus = CLLocationManager.authorizationStatus()
            switch locationServiceStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                grantLocationPermission = true
            default:
                break
            }
        }
        
        return grantLocationPermission
    }
    
    override init() {
        super.init()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 10
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.delegate = self
    }
    
    @discardableResult
    func checkAndRequestAuthorizationLocation() -> PublishSubject<CLAuthorizationStatus?>  {
        if CLLocationManager.locationServicesEnabled() {
            let locationServiceStatus = CLLocationManager.authorizationStatus()
            switch locationServiceStatus {
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            default:
                self.locationAuthorizationStatus.onNext(locationServiceStatus)
            }
        }
        else {
            self.locationAuthorizationStatus.onNext(nil)
        }
        
        return self.locationAuthorizationStatus
    }
    
    func getCurrentLocationManual(currentLocationCompleted: @escaping ((CLLocation?) -> Void)) {
        self.locationManager.showsBackgroundLocationIndicator = false
        self.getCurrentLocationCompleted = currentLocationCompleted
        self.startUpdatingLocation()
    }
    
    func requestLocationObservable() -> Observable<CLLocation?> {
        Observable<CLLocation?>.create { observable in
            self.getCurrentLocationManual { location in
                observable.onNext(location)
                observable.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func startTrackingCurrentLocation() {
        self.locationManager.showsBackgroundLocationIndicator = true
        self.startUpdatingLocation()
    }
    
    fileprivate func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
        self.latestLocation = nil
    }
}


extension MVLLocationsManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationAuthorizationStatus.onNext(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("[UPDATE-LOCATION] \(locations.last.debugDescription)")
        self.latestLocation = locations.last
        self.getCurrentLocationCompleted?(self.latestLocation)
        self.getCurrentLocationCompleted = nil
        self.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error.localizedDescription)")
    }
}
