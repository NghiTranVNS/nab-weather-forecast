//
//  MVLLocalStoreService.swift
//  mvl
//
//  Created by nghitran on 21/02/2022.
//

import Foundation

enum LocalStoreResponse<T> {
    case failure(Error?)
    case success(responseData: T)
}

protocol MVLLocalStoreService {
    func saveSearchedKey(key: MVLSearchKey, completion: @escaping (LocalStoreResponse<MVLSearchKey?>) -> Void)
    func loadSearchedKeys(completion: @escaping (LocalStoreResponse<[MVLSearchKey]>) -> Void)
    func removeSearchedKey(key: MVLSearchKey, completion: @escaping (LocalStoreResponse<Bool>) -> Void)
    func removeSearchedKeys(keys: [MVLSearchKey], completion: @escaping (LocalStoreResponse<Bool>) -> Void)
    func removeAllSearchKeys(completion: @escaping (LocalStoreResponse<Bool>) -> Void)
}
