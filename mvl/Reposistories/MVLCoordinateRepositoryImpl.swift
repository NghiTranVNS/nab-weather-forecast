//
//  MVLCoordinateRepositoryImpl.swift
//  mvl
//
//  Created by nghitran on 18/02/2022.
//

import UIKit
import RxSwift

class MVLCoordinateRepositoryImpl: MVLCoordinateRepository {
    
    //MARK: - Web API
    private let webAPIService: MVLWebAPIServiceImpl = MVLWebAPIServiceImpl()
    public private(set) var loadedMVLCoordinate: MVLCoordinate = MVLRawCoordinate()
    
    var didLoadCoordinateName: ((MVLCoordinate?, Error?) -> Void)?
    var didLoadCoordinateAqi: ((MVLCoordinate?, Error?) -> Void)?
    
    func loadCoordinateNameAt(lat: Double, long: Double) {
//        webAPIService.loadCoordinateName(lat: lat, long: long, completion: { [weak self] result in
//            guard let strongSelf = self else { return }
//            switch result {
//            case .failure:
//                strongSelf.didLoadCoordinateName?(nil, NSError(domain: "Unknown", code: 0, userInfo: nil))
//            case .notConnectedToInternet:
//                strongSelf.didLoadCoordinateName?(nil, NSError(domain: "No internet", code: 0, userInfo: nil))
//            case .success(responseData: let mvlCoordinate):
//                strongSelf.loadedMVLCoordinate.name = mvlCoordinate.name
//                strongSelf.loadedMVLCoordinate.lat = mvlCoordinate.lat
//                strongSelf.loadedMVLCoordinate.long = mvlCoordinate.long
//                strongSelf.didLoadCoordinateName?(strongSelf.loadedMVLCoordinate, nil)
//            }
//        })
    }
    
    func loadCoordinateAqiAt(lat: Double, long: Double) {
//        webAPIService.loadCoordinateAqi(lat: lat, long: long, completion: { [weak self] result in
//            guard let strongSelf = self else { return }
//            switch result {
//            case .failure:
//                strongSelf.didLoadCoordinateAqi?(nil, NSError(domain: "Unknown", code: 0, userInfo: nil))
//            case .notConnectedToInternet:
//                strongSelf.didLoadCoordinateAqi?(nil, NSError(domain: "No internet", code: 0, userInfo: nil))
//            case .success(responseData: let mvlCoordinate):
//                strongSelf.loadedMVLCoordinate.aqi = mvlCoordinate.aqi
//                strongSelf.loadedMVLCoordinate.lat = mvlCoordinate.lat
//                strongSelf.loadedMVLCoordinate.long = mvlCoordinate.long
//                strongSelf.didLoadCoordinateAqi?(strongSelf.loadedMVLCoordinate, nil)
//            }
//        })
    }

    //MARK: - Local store
    private let localStoreService: MVLLocalStoreService = MVLLocalStoreServiceCoreDataImpl()
    private var coordinates: [MVLCoordinate] = []
    
    var didLoadCoordinates: (([MVLCoordinate], Error?) -> Void)?
    var didSaveCoordinate: ((MVLCoordinate?, Error?) -> Void)?
    var didClearLocalCoordinates: ((Bool, Error?) -> Void)?
    
    func coordinateList() -> [MVLCoordinate] {
        return coordinates
    }
    
    func numberOfCoordinates() -> Int {
        return coordinates.count
    }
    
    func loadCoordinates() {
        localStoreService.loadCoordinates { [weak self] result in
            switch result {
            case .failure(let error):
                self?.didLoadCoordinates?([], error)
            case .success(responseData: let coordinates):
                self?.coordinates = coordinates
                self?.didLoadCoordinates?(coordinates, nil)
            }
        }
    }
    
    func coordinateAtIndex(_ index: Int) -> MVLCoordinate? {
        guard index >= 0 && index < coordinates.count else {
            return nil
        }
        
        return coordinates[index]
    }
    
    func saveCoordinate(coordinate: MVLCoordinate) {
        localStoreService.saveCoordinate(coordinate: coordinate) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.didSaveCoordinate?(nil, error)
            case .success(responseData: let coordinate):
                self?.didSaveCoordinate?(coordinate, nil)
            }
        }
    }
    
    func clearLocalCoordinates() {
        localStoreService.removeAllSavedCoordinates { [weak self] result in
            switch result {
            case .failure(let error):
                self?.didClearLocalCoordinates?(false, error)
            case .success(responseData: let success):
                self?.didClearLocalCoordinates?(success, nil)
            }
        }
    }
}

//MARK: - ReactiveX support
extension MVLCoordinateRepositoryImpl {
    func requestNameOfCoordinate(lat: Double, long: Double) -> Observable<MVLCoordinate?> {
        Observable<MVLCoordinate?>.create { [weak self] observable in
            self?.loadCoordinateNameAt(lat: lat, long: long)
            self?.didLoadCoordinateName = { [weak self] (mvlCoordinate, error) in
                guard let _ = self else {
                    observable.onCompleted()
                    return
                }
                observable.onNext(mvlCoordinate)
                observable.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func requestAqiOfCoordinate(lat: Double, long: Double) -> Observable<MVLCoordinate?> {
        Observable<MVLCoordinate?>.create { [weak self] observable in
            self?.loadCoordinateAqiAt(lat: lat, long: long)
            self?.didLoadCoordinateAqi = { [weak self] (mvlCoordinate, error) in
                guard let _ = self else {
                    observable.onCompleted()
                    return
                }
                observable.onNext(mvlCoordinate)
                observable.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func requestLocalCoordinates() -> Observable<[MVLCoordinate]> {
        Observable<[MVLCoordinate]>.create { [weak self] observable in
            self?.localStoreService.loadCoordinates { result in
                switch result {
                case .failure(_):
                    observable.onNext([])
                    observable.onCompleted()
                case .success(responseData: let coordinates):
                    observable.onNext(coordinates)
                    observable.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func requestSavingCoordinate(coordinate: MVLCoordinate) -> Observable<MVLCoordinate?> {
        Observable<MVLCoordinate?>.create { [weak self] observable in
            self?.localStoreService.saveCoordinate(coordinate: coordinate) { result in
                switch result {
                case .failure(_):
                    observable.onNext(nil)
                    observable.onCompleted()
                case .success(responseData: let coordinate):
                    observable.onNext(coordinate)
                    observable.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func requestClearingLocalCoordinates() -> Observable<Bool> {
        Observable<Bool>.create { [weak self] observable in
            self?.localStoreService.removeAllSavedCoordinates { result in
                switch result {
                case .failure(_):
                    observable.onNext(false)
                    observable.onCompleted()
                case .success(responseData: let success):
                    observable.onNext(success)
                    observable.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
