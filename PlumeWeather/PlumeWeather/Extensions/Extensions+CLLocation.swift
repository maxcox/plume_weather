//
//  Extensions+CLLocation.swift
//  PlumeWeather
//
//  Created by Admin on 1/28/19.
//  Copyright © 2019 JosephCox. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    
    func coordinatesHTTPString(_ latKey:String = "lat",_ lonKey:String = "long") -> String {
        return "\(latKey)=\(self.coordinate.latitude)&\(lonKey)=\(self.coordinate.longitude)"
    }
}
