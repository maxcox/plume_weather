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
    private var temperatureLabel:ScrollingLabelView!
    private var cityLabel:UILabel!
    
    init(view:UIView, temperatureLabel:ScrollingLabelView, cityLabel:UILabel) {
        self.view = view
        self.temperatureLabel = temperatureLabel
        self.cityLabel = cityLabel
    }
    
    func updateUI() {
        guard let temperature = currentWeatherData?.current_observation.condition.temperature else { /*handle error*/ return }
        guard let city = currentWeatherData?.location.city else { /*handle error*/ return }
        
        self.temperatureLabel.value = temperature //String(format: "%d", temperature)
        self.cityLabel.text = city
    }
}
