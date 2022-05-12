//
//  MockWebAPIService.swift
//  mvlTests
//
//  Created by Mr Nghi Tran Kien Nghi on 5/12/22.
//

import UIKit

class MockWebAPIService: MVLWebAPIService {
    func searchForWeatherForcast(city: String, completion: @escaping (WebAPIResponse<MVLSearchKey?>) -> Void) {
        
        let key = MVLRawSearchKey(weathers: [
            MVLRawWeather(date: Date(), temp: 30, pressure: 80, humidity: 40, descrpt: "test saigon 1", icon: "test icon 1"),
                                   
            MVLRawWeather(date: Date(), temp: 31, pressure: 81, humidity: 41, descrpt: "test saigon 2", icon: "test icon 2"),
                                   
            MVLRawWeather(date: Date(), temp: 32, pressure: 82, humidity: 42, descrpt: "test saigon 3", icon: "test icon 3")],
                                  
                                  date: Date(), key: city)
        
        completion(.success(responseData: key))
        
        //TODO: Simulate failure case
        //completion(.failure(NSError(domain:"", code: 0, userInfo: nil)))
    }
}
