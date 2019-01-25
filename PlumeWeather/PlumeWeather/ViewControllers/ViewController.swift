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

class ViewController: UIViewController {

    var weatherRequestController:WeatherRequestController!
    var weatherRequestUIController:WeatherRequestUIController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let label:UILabel = UILabel.init(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        label.textColor = UIColor.black
        label.textAlignment = .center
        view.addSubview(label)
        
        weatherRequestController = WeatherRequestController()
        weatherRequestUIController = WeatherRequestUIController(view: (view)!, temperatureLabel: label)
        
        weatherRequestController.delegate = weatherRequestUIController
        
        weatherRequestController.refreshWeather()
    }
}

