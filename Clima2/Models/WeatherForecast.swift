//
//  WeatherForecast.swift
//  Clima2
//
//  Created by Adit Salim on 02/02/24.
//

import Foundation

struct WeatherForecast: Codable {
    let list: [CityWeather]
    let city: CityData
}

struct CityWeather: Codable, Hashable {
    let dt: Int
    let main: Main
    let weather: [Weather]
}

struct CityData: Codable {
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}
