//
//  MVLLocalStoreServiceCoreDataImpl.swift
//  mvl
//
//  Created by nghitran on 21/02/2022.
//

import UIKit
import MagicalRecord

class MVLLocalStoreServiceCoreDataImpl {
    init() {
        configureCoreDataStack()
        
        //The code below is just for demo purpose. We should cho clean up local DB in real product
        //Clean up local DB
        removeAllSearchKeys { result in
            switch result {
            case .failure(_):
                print("Failed to clean local DB")
            case .success(responseData: _):
                print("Cleaned local DB")
            }
        }
        
        
        /* Generate mock data for testing
        let isMockDataGeneratedKey = "isMockDataGenerated"
        let userDefaultd = UserDefaults.standard
        if userDefaultd.bool(forKey: isMockDataGeneratedKey) == false {
            initializeLocalData()
            userDefaultd.set(true, forKey: isMockDataGeneratedKey)
            userDefaultd.synchronize()
        }
        else {
            //Delete mack data for testing
            self.loadSearchedKeys { result in
                switch result {
                case .failure(_):
                    print("Failed to load mock data in CoreData")
                case .success(responseData: let responseData):
                    print("Successfully load mock data in CoreData")
                    for key in responseData {
                        print(key.key)
                        for weather in key.weathers {
                            print(weather.descrpt + ", date: \(weather.dateDescription())")
                        }
                        print("\n")
                    }
                    
                    if let lastKey = responseData.last {
                        self.removeSearchedKeys(keys: [lastKey]) { result in
                            switch result {
                            case .failure(_):
                                print("Failed to delete mock data in CoreData: \(lastKey.key)")
                            case .success(responseData: let responseData):
                                print("Successfully delete mock data in CoreData: \(lastKey.key)")
                            }
                        }
                        
                        print("Number of remaining Weather objects: \(MVLLocalStoreWeather.mr_numberOfEntities())")
                    }
                    else {
                        userDefaultd.set(false, forKey: isMockDataGeneratedKey)
                        userDefaultd.synchronize()
                    }
                }
            }
        }
         */
    }

    //MARK: - Insert mock data for testing
    func initializeLocalData() {
        let keys: [MVLRawSearchKey] = [
            MVLRawSearchKey(weathers: [MVLRawWeather(date: Date(), temp: 30, pressure: 80, humidity: 40, descrpt: "test saigon", icon: "test icon"),
                                       MVLRawWeather(date: Date(), temp: 31, pressure: 81, humidity: 41, descrpt: "test saigon 2", icon: "test icon 2"),
                                       MVLRawWeather(date: Date(), temp: 32, pressure: 82, humidity: 42, descrpt: "test saigon 3", icon: "test icon 3")],
                            date: Date(), key: "saigon"),
            MVLRawSearchKey(weathers: [MVLRawWeather(date: Date(), temp: 30, pressure: 80, humidity: 40, descrpt: "test danang", icon: "test icon"),
                                       MVLRawWeather(date: Date(), temp: 31, pressure: 81, humidity: 41, descrpt: "test danang 2", icon: "test icon 2"),
                                       MVLRawWeather(date: Date(), temp: 32, pressure: 82, humidity: 42, descrpt: "test danang 3", icon: "test icon 3")],
                            date: Date(), key: "danang"),
            MVLRawSearchKey(weathers: [MVLRawWeather(date: Date(), temp: 30, pressure: 80, humidity: 40, descrpt: "test hanoi", icon: "test icon"),
                                       MVLRawWeather(date: Date(), temp: 31, pressure: 81, humidity: 41, descrpt: "test hanoi 2", icon: "test icon 2"),
                                       MVLRawWeather(date: Date(), temp: 32, pressure: 82, humidity: 42, descrpt: "test hanoi 3", icon: "test icon 3")],
                            date: Date(), key: "hanoi")
        ]
        
        saveKeys(keys: keys) { _ in
            
        }
    }
    
    func saveKeys(keys: [MVLRawSearchKey], completion: @escaping (Bool) -> Void) {
        for key in keys {
            self.saveSearchedKey(key: key) { result in
                switch result {
                case .failure(_):
                    print("Failed to create mock data in CoreData for key: \(key.key)")
                case .success(responseData: let responseData):
                    print("Successfully create mock data in CoreData for key: \(responseData?.key ?? "")")
                }
            }
        }
    }
}

//MARK: - MVLLocalStoreService Protocol
extension MVLLocalStoreServiceCoreDataImpl: MVLLocalStoreService {
    //MARK: - Weather
    func saveSearchedKey(key: MVLSearchKey, completion: @escaping (LocalStoreResponse<MVLSearchKey?>) -> Void) {
        var entity: MVLLocalStoreSearchKey?
        MagicalRecord.save({ (ctx) in
            entity = MVLLocalStoreSearchKey.mr_createEntity(in: ctx)
            entity?.k_key = key.key
            entity?.k_date = key.date
            entity?.k_weathers = NSSet(array: key.weathers.compactMap({ mvlWeather in
                let weatherEntity = MVLLocalStoreWeather.mr_createEntity(in: ctx)
                weatherEntity?.w_date = mvlWeather.date
                weatherEntity?.w_icon = mvlWeather.icon
                weatherEntity?.w_temp = mvlWeather.temp
                weatherEntity?.w_pressure = Int32(mvlWeather.pressure)
                weatherEntity?.w_humidity = Int32(mvlWeather.humidity)
                weatherEntity?.w_descrpt = mvlWeather.descrpt
                
                return weatherEntity
            }))
        }) { (succeed, error) in
            if succeed, let ett = entity {
                completion(.success(responseData: ett))
            }
            else {
                completion(.failure(error))
            }
        }
    }
    
    func loadSearchedKeys(completion: @escaping (LocalStoreResponse<[MVLSearchKey]>) -> Void) {
        if let entities = MVLLocalStoreSearchKey.mr_findAllSorted(by: "k_date", ascending: false) as? [MVLLocalStoreSearchKey] {
            completion(.success(responseData: entities))
        }
        else {
            completion(.failure(nil))
        }
    }
    
    func removeSearchedKey(key: MVLSearchKey, completion: @escaping (LocalStoreResponse<Bool>) -> Void) {
        removeSearchedKeys(keys: [key], completion: completion)
    }
    
    func removeSearchedKeys(keys: [MVLSearchKey], completion: @escaping (LocalStoreResponse<Bool>) -> Void) {
        let keyFilter = NSPredicate(format: "k_key IN %@", keys.compactMap({ $0.key }))
        guard let localKeys = MVLLocalStoreSearchKey.mr_findAll(with: keyFilter) else {
            completion(.failure(nil))
            return
        }
        
        MagicalRecord.save(blockAndWait: { ctx in
            for localKey in localKeys {
                localKey.mr_deleteEntity(in: ctx)
            }
        })
        
        completion(.success(responseData: true))
    }
    
    func removeAllSearchKeys(completion: @escaping (LocalStoreResponse<Bool>) -> Void) {
        MagicalRecord.save(blockAndWait: { ctx in
            MVLLocalStoreSearchKey.mr_truncateAll(in: ctx)
            completion(.success(responseData: true))
        })
    }
}

//MARK: - CoreData support
private extension MVLLocalStoreServiceCoreDataImpl {
    func configureCoreDataStack() {
        MagicalRecord.setupCoreDataStack()
    }
}
