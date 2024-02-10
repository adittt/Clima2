//
//  CurrentWeather.swift
//  Clima2
//
//  Created by Adit Salim on 31/01/24.
//

import Foundation

struct CurrentWeather: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable, Hashable {
    let temp: Double
    var roundedTemp: String {
        String(format: "%.0f", self.temp)
    }
}

struct Weather: Codable, Hashable {
    let description: String
    let id: Int
    
    var conditionName: String {
        switch id {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...504:
            return "cloud.sun.rain"
        case 511:
            return "cloud.snow"
        case 520...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
