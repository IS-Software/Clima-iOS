//
//  WeatherData.swift
//  Clima
//
//  Created by Nikita Gavrilov on 06.12.2021.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}
