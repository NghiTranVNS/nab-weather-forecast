//
//  MVLWeatherRepository.swift
//  mvl
//
//  Created by Mr Nghi Tran Kien Nghi on 5/9/22.
//

import UIKit
import RxSwift

protocol MVLWeatherRepository {
    //MARK: - Web API - ReactiveX support
    func requestWeathersWithKey(_ key: String)  -> Observable<MVLSearchKey?>
    
    //MARK: - Local store - ReactiveX support - Weather
    func loadLocalSearchKeys() -> Observable<[MVLSearchKey]>
    func storeSearchKeyToLocal(searchKey: MVLSearchKey) -> Observable<MVLSearchKey?>
    func deleteSearchKeyInLocalStore(searchKey: MVLSearchKey) -> Observable<Bool>
    func deleteAllSearchKeysInLocalStore() -> Observable<Bool>
}
