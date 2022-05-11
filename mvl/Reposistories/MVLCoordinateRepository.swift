//
//  MVLCoordinateRepository.swift
//  mvl
//
//  Created by nghitran on 18/02/2022.
//

import UIKit
import RxSwift

protocol MVLCoordinateRepository {
    //MARK: - Web API
    var didLoadCoordinateName: ((_ coordinates: MVLCoordinate?, _ error: Error?) -> Void)? { get set }
    var didLoadCoordinateAqi: ((_ coordinates: MVLCoordinate?, _ error: Error?) -> Void)? { get set }
    func loadCoordinateNameAt(lat: Double, long: Double)
    func loadCoordinateAqiAt(lat: Double, long: Double)
    
    //MARK: - Web API - ReactiveX support
    func requestNameOfCoordinate(lat: Double, long: Double) -> Observable<MVLCoordinate?>
    func requestAqiOfCoordinate(lat: Double, long: Double) -> Observable<MVLCoordinate?>
    
    //MARK: - Local store
    var didLoadCoordinates: ((_ coordinates: [MVLCoordinate], _ error: Error?) -> Void)? { get set }
    var didSaveCoordinate: ((_ coordinate: MVLCoordinate?, _ error: Error?) -> Void)? { get set }
    var didClearLocalCoordinates: ((_ success: Bool, _ error: Error?) -> Void)? { get set }
    func coordinateList() -> [MVLCoordinate]
    func numberOfCoordinates() -> Int
    func loadCoordinates()
    func coordinateAtIndex(_ index: Int) -> MVLCoordinate?
    func saveCoordinate(coordinate: MVLCoordinate)
    func clearLocalCoordinates()
    
    //MARK: - Local store - ReactiveX support
    func requestLocalCoordinates() -> Observable<[MVLCoordinate]>
    func requestSavingCoordinate(coordinate: MVLCoordinate) -> Observable<MVLCoordinate?>
    func requestClearingLocalCoordinates() -> Observable<Bool>
}
