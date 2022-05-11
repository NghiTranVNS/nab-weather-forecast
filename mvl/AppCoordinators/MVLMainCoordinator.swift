//
//  MainCoordinator.swift
//  mvl
//
//  Created by nghitran on 18/02/2022.
//

import Foundation
import UIKit
import GoogleMaps

class MVLMainCoordinator: MVLAppCoordinator {

    public private(set) var mainViewController: ViewController!
    
    init(withViewController vc: ViewController) {
        self.mainViewController = vc
    }
    
    //MARK: - Utilities
    func showMessage(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        mainViewController.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - MVL
    func showMainView() {
        //TODO: Add animation to improve look and feel
        self.mainViewController.screenA.isHidden = false
        self.mainViewController.screenB.isHidden = true
        self.mainViewController.screenC.isHidden = true
    }
    
    func showMapView(atCoordinate coordinate: MVLCoordinate) {
        self.mainViewController.screenA.isHidden = true
        self.mainViewController.screenB.isHidden = false
        self.mainViewController.screenC.isHidden = true
        
        //Handle showing current coordinate
        self.mainViewController.screenB.mvlCoordinate = coordinate
    }
    
    func showCoordinatePreview(pointA: MVLCoordinate, pointB: MVLCoordinate) {
        self.mainViewController.screenA.isHidden = true
        self.mainViewController.screenB.isHidden = true
        self.mainViewController.screenC.isHidden = false
        
        //Handle showing selected coordinates
        self.mainViewController.screenC.pointA = pointA
        self.mainViewController.screenC.pointB = pointB
    }
}
