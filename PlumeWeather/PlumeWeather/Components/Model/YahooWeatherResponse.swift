//
//  WeatherResponse.swift
//  PlumeWeather
//
//  Created by Admin on 1/25/19.
//  Copyright © 2019 JosephCox. All rights reserved.
//

import Foundation

struct YahooWeatherResponse:Decodable {
    
    let location:YahooLocation
    let current_observation:YahooCurrentObservation
}

struct YahooLocation:Decodable {
    let city:String
    let lat:Double
    let long:Double
    let timezone_id:String
}

struct YahooCurrentObservation:Decodable {
    let condition:YahooCondition
}

struct YahooCondition:Decodable {
    let text:String
    let code:Int
    let temperature:Int
}
