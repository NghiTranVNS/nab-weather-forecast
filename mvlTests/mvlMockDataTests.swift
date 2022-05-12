//
//  mvlMockDataTests.swift
//  mvlTests
//
//  Created by Mr Nghi Tran Kien Nghi on 5/12/22.
//

import XCTest
import RxSwift

class mvlMockDataTests: XCTestCase {
    
    var repository: MockWeatherReposistory!
    var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        repository = MockWeatherReposistory()
    }

    override func tearDownWithError() throws {
        repository = nil
    }

    func testSearchByCityName() throws {
        let mockString = "saigon"
        repository.requestWeathersWithKey(mockString).map({ $0 }).bind { key in
            XCTAssertNotNil(key, "Mock key must be loaded")
            XCTAssertEqual(mockString, key?.key, "Loaded key must match input key")
        }.disposed(by: disposeBag)
    }
    
    func testStoreToLocal() throws {
        let mockString = "saigon"
        repository.requestWeathersWithKey(mockString).map({ $0 }).bind { key in
            guard let _key = key else {
                XCTAssertNotNil(key, "Mock key must be loaded")
                return
            }
            
            self.repository.localStoreService.saveSearchedKey(key: _key) { result in
                switch result {
                case .failure(_):
                    XCTFail("Cannot save data to local DB")
                case .success(responseData: let responseData):
                    XCTAssertEqual(mockString, responseData?.key, "Stored key must match input key")
                    XCTAssertEqual(3, responseData?.weathers.count, "Must store the related objects")
                }
            }
        }.disposed(by: disposeBag)
    }
    
    func testReadFromLocal() throws {
        let mockString = "saigon"
        repository.loadLocalSearchKeys().map({ $0 }).bind { keys in
            guard keys.count > 0 else {
                XCTFail("Cannot load local data")
                return
            }
            
            if let key = keys.first(where: { $0.key.lowercased() == mockString.lowercased() }) {
                XCTAssertEqual(3, key.weathers.count, "Must store the related objects")
            }
            else {
                XCTFail("Cannot find stored local data in local DB")
            }
        }.disposed(by: disposeBag)
    }
    
    func testDeleteFromLocal() throws {
        repository.deleteAllSearchKeysInLocalStore().map({ $0 }).bind { success in
            XCTAssertEqual(success, true, "Cannot clean local DB")
            
            self.repository.loadLocalSearchKeys().map({ $0 }).bind { keys in
                if keys.count > 0  {
                    XCTFail("Cannot clean local DB")
                }
            }.disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
    }
}
