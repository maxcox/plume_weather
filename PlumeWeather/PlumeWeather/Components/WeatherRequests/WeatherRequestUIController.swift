//
//  WeatherRequestUIController.swift
//  PlumeWeather
//
//  Created by Admin on 1/25/19.
//  Copyright © 2019 JosephCox. All rights reserved.
//

import Foundation
import UIKit

class WeatherRequestUIController: WeatherRequestDelegate {
    
    var currentWeatherData: YahooWeatherResponse? {
        willSet(newValue) {
            if (newValue != nil) {
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }
        }
    }
    
    private var view:UIView!
    private var temperatureLabel:ScrollingValueView!
    private var cityLabel:UILabel!
    
    init(view:UIView, temperatureLabel:ScrollingValueView, cityLabel:UILabel) {
        self.view = view
        self.temperatureLabel = temperatureLabel
        self.cityLabel = cityLabel
    }
    
    private func updateUI() {
        guard let weatherData:YahooWeatherResponse = currentWeatherData else { print("Attempting to update UI with no valid weather data."); return }
        
        let temperature = weatherData.current_observation.condition.temperature
        let city = weatherData.location.city
        
        self.temperatureLabel.value = temperature
        self.cityLabel.text = city
    }
}
