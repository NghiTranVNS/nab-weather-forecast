//
//  WebAPIService.swift
//  mvl
//
//  Created by nghitran on 18/02/2022.
//

import UIKit

enum WebAPIResponse<T> {
    case failure(Error?)
    case notConnectedToInternet
    case success(responseData: T)
}

protocol MVLWebAPIService {
    func searchForWeatherForcast(city: String, completion: @escaping (WebAPIResponse<MVLSearchKey?>) -> Void)
}
