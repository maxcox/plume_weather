//
//  Result.swift
//  PlumeWeather
//
//  Created by Admin on 1/25/19.
//  Copyright © 2019 JosephCox. All rights reserved.
//

enum DataResult<T: Decodable> {
    case Success(T)
    case Failure(Error)
}
