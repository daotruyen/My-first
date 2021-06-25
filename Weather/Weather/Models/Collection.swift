//
//  Collection.swift
//  Weather
//
//  Created by Tuyen on 22/06/2021.
//

import UIKit

struct WeatherInfo {
    let temp: Float
    let description: String
    let icon: String
    let time: String
}
struct numberTemperature {
    let weekDay: String?
    let hourly: [WeatherInfo]?
}
