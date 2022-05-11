//
//  GlobalVariables.swift
//  mvl
//
//  Created by nghitran on 18/02/2022.
//

import UIKit

struct GlobalVariables {
    static let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    static let googleMapAPIKey = "AIzaSyCRzXSoVwkrGDyl_2LDOyWPsVNlraXxBo4"
    static let aqiToken = "d3539514ef7cbcb591832dcd265e7d15fae3d91c"
    static let bigDataCloudAPIKey = "efdfd5d92ace4e90b8a2e51f4a33fee7"
    
    //Weather UI Validation
    static let minLengthOfKeyString = 3
    
    //Weather API
    static let numberOfForcastDays = 7
    static let weatherAppplicationID = "60c6fbeb4b93ac653c492ba806fc346d"
    static let temperatureUnit = "metric"
    static let weatherAPIBaseUrl = "https://api.openweathermap.org/data/2.5/"
}

//MARK: - MVL Components
public enum AppScreen {
    case screenA
    case screenB
    case screenC
}

//Weathers
public enum WeatherAPI: String {
    case forcast = "forecast/daily?q=%@&cnt=%d&appid=%@&units=%@"
}
