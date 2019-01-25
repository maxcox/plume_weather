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
    private var temperatureLabel:UILabel!
    
    init(view:UIView, temperatureLabel:UILabel) {
        self.view = view
        self.temperatureLabel = temperatureLabel
    }
    
    func updateUI() {
        guard let temperature = currentWeatherData?.current_observation.condition.temperature else { return }
        
        self.temperatureLabel.text = String(format: "%d°F", temperature)
    }
}
