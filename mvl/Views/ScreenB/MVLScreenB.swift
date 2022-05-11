//
//  MVLScreenB.swift
//  mvl
//
//  Created by nghitran on 18/02/2022.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift
import GoogleMaps

class MVLScreenB: BaseView {
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var fakeMakerImangeView: UIImageView!
    @IBOutlet weak var loadingPointActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var localCoordinateView: MVLStoredCoordinatesView!
    
    public private(set) var disposeBag = DisposeBag()
    private var currentMasker: GMSMarker?
    let defaultZoom: Float = 15.0
    var didChangeMapPosition: ((_ newPosition: CLLocationCoordinate2D) -> Void)? = nil
    var mvlCoordinate: MVLCoordinate = MVLRawCoordinate() {
        didSet {
            pinMap()
        }
    }

    override func setupView() {
        super.setupView()
        
        mapView.delegate = self
        fakeMakerImangeView.isHidden = false
    }
    
    private func pinMap() {
        let coordinate = self.mvlCoordinate.coordinate
        self.currentMasker?.map = nil
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: self.defaultZoom)
        self.mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = coordinate
        marker.title = mvlCoordinate.name
        marker.snippet = mvlCoordinate.markerDescription()
        marker.map = mapView
        self.mapView.selectedMarker = marker
        self.currentMasker = marker
    }
}

extension MVLScreenB: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.currentMasker?.opacity = 0.28
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.currentMasker?.position = position.target
        UIView.animate(withDuration: 5.0, animations: { () -> Void in
        }, completion: {(finished) in
            self.currentMasker?.opacity = 1.0
            //if !self.mvlCoordinate.isEqualTo(position.target) {
                self.mvlCoordinate.coordinate = position.target
            //}
        })
        
        self.didChangeMapPosition?(position.target )
      }
}
