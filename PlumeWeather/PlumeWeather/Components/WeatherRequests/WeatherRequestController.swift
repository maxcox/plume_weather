//
//  WeatherRequestController.swift
//  PlumeWeather
//
//  Created by Admin on 1/25/19.
//  Copyright © 2019 JosephCox. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import OAuthSwift

protocol WeatherRequestDelegate {
    
    var currentWeatherData:YahooWeatherResponse? { get set }
}

final class WeatherRequestController: PlumeLocationDelegate {
    
    var delegate:WeatherRequestDelegate?
    
    var refreshTimer:Timer?
    
    let defaultLocation = "location=sunnyvale,ca"
    var lastLocation:CLLocation? {
        didSet {
            refreshWeather()
        }
    }
    
    @objc func refreshWeather() {
        
        let location = lastLocation?.coordinatesHTTPString("lat", "long") ?? defaultLocation
        
        weatherRequest(location: location)
    }
    
    private func weatherRequest(location:String) {
        
        let sessionManager = SessionManager.default
        
        sessionManager.request(URL(string: "https://weather-ydn-yql.media.yahoo.com/forecastrss?\(location)&format=json")!, headers: ["Yahoo-App-Id":"woarXb78"])
        .validate()
        .responseJSON { (dataResponse) in
            
            guard dataResponse.result.isSuccess else {
                print("Error while fetching local weather data: \(String(describing: dataResponse.result.error))");
                return
            }
            
            var weatherData:YahooWeatherResponse
            
            do {
                weatherData = try JSONDecoder().decode(YahooWeatherResponse.self, from: dataResponse.data!)
            } catch let parsingError {
                print("Data parsing unsuccessful with error: \(parsingError)")
                return
            }
            
            if (self.delegate != nil) {
                self.delegate?.currentWeatherData = weatherData
            }
        }
    }
    
    //MARK: - Refresh Timer Methods
    
    func startRefresh() {
        if (refreshTimer == nil) {
            refreshTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(refreshWeather), userInfo: nil, repeats: true)
        }
    }
    
    func stopRefresh() {
        if (refreshTimer != nil) {
            refreshTimer?.invalidate()
            refreshTimer = nil
        }
    }
}
