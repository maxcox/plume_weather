//
//  WeatherRequestController.swift
//  PlumeWeather
//
//  Created by Admin on 1/25/19.
//  Copyright © 2019 JosephCox. All rights reserved.
//

import Foundation
import Alamofire
import OAuthSwift

protocol WeatherRequestDelegate {
    
    var currentWeatherData:YahooWeatherResponse? { get set }
}

final class WeatherRequestController {
    
    var delegate:WeatherRequestDelegate?
    
    init() {
    }
    
    func refreshWeather() {
        
        let testLocation = "sunnyvale,ca"
        
        weatherRequest(location: testLocation)
    }
    
    private func weatherRequest(location:String) {
        
        let sessionManager = SessionManager.default
        
        let dataRequest:DataRequest = sessionManager.request(URL(string: "https://weather-ydn-yql.media.yahoo.com/forecastrss?location=\(location)&format=json")!, headers: ["Yahoo-App-Id":"woarXb78"])
        
        dataRequest.responseJSON { (dataResponse) in
            
            guard dataResponse.result.isSuccess else { print(dataResponse.error); return}
            
            var weatherData:YahooWeatherResponse
            
            do {
                weatherData = try JSONDecoder().decode(YahooWeatherResponse.self, from: dataResponse.data!)
            } catch {
                print("Parsing error.")
                return
            }
            
            if (self.delegate != nil) {
                self.delegate?.currentWeatherData = weatherData
            }
        }
    }
}
