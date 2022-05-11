//
//  WebAPIServiceImpl.swift
//  mvl
//
//  Created by nghitran on 15/02/2022.
//

import UIKit
import Alamofire
import ObjectMapper

class MVLWebAPIServiceImpl: MVLWebAPIService {
    static let aqiEndPoint = "https://api.waqi.info/feed/"
    static let infoEndPoint = "https://api.bigdatacloud.net/data/reverse-geocode-client"

    func searchForWeatherForcast(city: String, completion: @escaping (WebAPIResponse<MVLSearchKey?>) -> Void) {
        guard city.count > GlobalVariables.minLengthOfKeyString else {
            print("FATAL: Loading weather forcast with ")
            completion(.failure(nil))
            return
        }
        
        let urlString: String = String(format: GlobalVariables.weatherAPIBaseUrl + WeatherAPI.forcast.rawValue, city, GlobalVariables.numberOfForcastDays, GlobalVariables.weatherAppplicationID, GlobalVariables.temperatureUnit)
        print(urlString)
        AF.request(urlString).responseJSON
        { response in
            print("\(#function)\n\(response.result)")
            guard let urlResponse = response.response else {
                if let errorCode = (response.error?.underlyingError as? URLError)?.code {
                    if .notConnectedToInternet == errorCode {
                        completion(.notConnectedToInternet)
                    } else {
                        completion(.failure(NSError(domain:"", code: errorCode.rawValue, userInfo: nil)))
                    }
                }
                else {
                    completion(.failure(NSError(domain:"", code: 0, userInfo: nil)))
                }
                return
            }

            switch urlResponse.statusCode {
            case 200...299:
                if case .success(let json) = response.result,
                    let jsonDictionary = json as? [String : Any] {
                    let key = Mapper<MVLCloudSearchKey>().map(JSON: jsonDictionary)
                    key?.key = city
                    completion(.success(responseData: key as? MVLSearchKey))
                } else {
                    completion(.failure(NSError(domain:"", code: 0, userInfo: nil)))
                }
            case NSURLErrorNotConnectedToInternet:
                completion(.notConnectedToInternet)
            default:
                completion(.failure(NSError(domain:"", code: 0, userInfo: nil)))
            }
        }
    }
}
