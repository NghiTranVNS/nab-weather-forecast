//
//  MVLWeatherRepositoryImpl.swift
//  mvl
//
//  Created by Mr Nghi Tran Kien Nghi on 5/9/22.
//

import UIKit
import RxSwift

class MVLWeatherRepositoryImpl: MVLWeatherRepository {
    var webAPIService: MVLWebAPIService = MVLWebAPIServiceImpl()
    
    var localStoreService: MVLLocalStoreService = MVLLocalStoreServiceCoreDataImpl()
}

//MARK: - Web API - ReactiveX support
extension MVLWeatherRepositoryImpl {
    func requestWeathersWithKey(_ key: String)  -> Observable<MVLSearchKey?> {
        Observable<MVLSearchKey?>.create { [weak self] observable in
            
            self?.webAPIService.searchForWeatherForcast(city: key, completion: { result in
                guard let _ = self else {
                    observable.onNext(nil)
                    observable.onCompleted()
                    return
                }
                
                switch result {
                case .failure(_):
                    observable.onNext(nil)
                case .notConnectedToInternet:
                    observable.onNext(nil)
                case .success(responseData: let responseData):
                    observable.onNext(responseData)
                }
                observable.onCompleted()
            })
            
            return Disposables.create()
        }
    }
}

//MARK: - Local - ReactiveX support
extension MVLWeatherRepositoryImpl {
    //MARK: - Weather
    func loadLocalSearchKeys() -> Observable<[MVLSearchKey]> {
        Observable<[MVLSearchKey]>.create { [weak self] observable in
            self?.localStoreService.loadSearchedKeys { result in
                switch result {
                case .failure(_):
                    observable.onNext([])
                    observable.onCompleted()
                case .success(responseData: let keys):
                    observable.onNext(keys)
                    observable.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func storeSearchKeyToLocal(searchKey: MVLSearchKey) -> Observable<MVLSearchKey?> {
        Observable<MVLSearchKey?>.create { [weak self] observable in
            self?.localStoreService.saveSearchedKey(key: searchKey) { result in
                switch result {
                case .failure(_):
                    observable.onNext(nil)
                    observable.onCompleted()
                case .success(responseData: let localKey):
                    observable.onNext(localKey)
                    observable.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func deleteSearchKeyInLocalStore(searchKey: MVLSearchKey) -> Observable<Bool> {
        Observable<Bool>.create { [weak self] observable in
            self?.localStoreService.removeSearchedKey(key: searchKey) { result in
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
    
    func deleteAllSearchKeysInLocalStore() -> Observable<Bool> {
        Observable<Bool>.create { [weak self] observable in
            self?.localStoreService.removeAllSearchKeys() { result in
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
