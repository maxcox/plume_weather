//
//  ViewController.swift
//  PlumeWeather
//
//  Created by Admin on 1/24/19.
//  Copyright © 2019 JosephCox. All rights reserved.
//

import UIKit
import Alamofire
import OAuthSwift
import OAuthSwiftAlamofire
import QuartzCore

class TemperatureViewController: UIViewController {

    @IBOutlet var scrollingValueView:ScrollingValueView!
    @IBOutlet var cityLabel:UILabel!
    
    var weatherRequestController:WeatherRequestController!
    var weatherRequestUIController:WeatherRequestUIController!
    
    var locationHandler:PlumeLocationHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollingValueView.labelsFontSize = 160
        scrollingValueView.labelsAlignment = .right
        scrollingValueView.value = 0
        
        locationHandler = PlumeLocationHandler()
        weatherRequestController = WeatherRequestController()
        weatherRequestUIController = WeatherRequestUIController(view: (view)!, temperatureLabel: scrollingValueView, cityLabel: cityLabel)
        
        weatherRequestController.delegate = weatherRequestUIController
        locationHandler.delegate = weatherRequestController
        
        weatherRequestController.refreshWeather()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Refresh weather every 10 seconds
        weatherRequestController.startRefresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        weatherRequestController.stopRefresh()
    }
}

