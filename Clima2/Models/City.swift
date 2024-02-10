//
//  City.swift
//  Clima2
//
//  Created by Adit Salim on 29/01/24.
//

import Foundation

struct CityResult: Codable {
    let results: [City]
}

struct City: Codable {
    let cityId: Int
    let name: String
    let country: Country
}

struct Country: Codable {
    let name: String
}
