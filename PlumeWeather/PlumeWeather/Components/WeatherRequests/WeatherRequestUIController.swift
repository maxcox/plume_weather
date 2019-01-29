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
    
    func updateUI() {
        guard let weatherData:YahooWeatherResponse = currentWeatherData else { /*handle error*/ return }
        
        let temperature = weatherData.current_observation.condition.temperature
        let city = weatherData.location.city
        
        //FIXME: Some test code below
        self.temperatureLabel.value = temperature + Int(arc4random_uniform(11)) - 5
        self.cityLabel.text = city
    }
}
