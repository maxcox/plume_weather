//
//  LocationManager.swift
//  PlumeWeather
//
//  Created by Admin on 1/28/19.
//  Copyright © 2019 JosephCox. All rights reserved.
//

import Foundation
import CoreLocation

protocol PlumeLocationDelegate: class {
    var lastLocation:CLLocation? { get set }
}

class PlumeLocationHandler: NSObject, CLLocationManagerDelegate {
    
    weak var delegate:PlumeLocationDelegate?
    
    let locationManager:CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        
        super.init()
        
        locationManager.delegate = self
    }
    
    private func setupLocationUpdates() {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 50
    }
    
    //MARK: - CLLocationManager Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch (status) {
        case .authorizedWhenInUse, .authorizedAlways:
            setupLocationUpdates()
            manager.startUpdatingLocation()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (delegate != nil) {
            delegate!.lastLocation = locations.last!
        }
    }
}
