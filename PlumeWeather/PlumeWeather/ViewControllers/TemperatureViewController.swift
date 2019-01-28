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

    @IBOutlet var scrollingLabelView:ScrollingLabelView!
    @IBOutlet var cityLabel:UILabel!
    
    var weatherRequestController:WeatherRequestController!
    var weatherRequestUIController:WeatherRequestUIController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeGradientBackground()
        
        scrollingLabelView.labelsFontSize = 160
        scrollingLabelView.labelsAlignment = .right
        scrollingLabelView.value = 0
        
        weatherRequestController = WeatherRequestController()
        weatherRequestUIController = WeatherRequestUIController(view: (view)!, temperatureLabel: scrollingLabelView, cityLabel: cityLabel)
        
        weatherRequestController.delegate = weatherRequestUIController
        
        weatherRequestController.refreshWeather()
    }
    
    func makeGradientBackground() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 1, green: 0.42, blue: 0, alpha: 1), UIColor(red: 0, green: 0.82, blue: 1, alpha: 1)].map { $0.cgColor }
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        
        view.backgroundColor = UIColor.clear
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

