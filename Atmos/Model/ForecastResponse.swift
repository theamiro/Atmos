//
//  ForecastResponse.swift
//  Atmos
//
//  Created by Michael Amiro on 16/01/2025.
//

import Foundation

struct ForecastResponse: Decodable {
    var forecast: [Forecast]

    enum CodingKeys: String, CodingKey {
        case forecast = "list"
    }
}

struct Forecast: Decodable {
    let date: TimeInterval
    let main: Weather
    let weather: [WeatherType]

    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case main
        case weather
    }
}

struct Weather: Decodable {
    let temperature: Double
    let minimumTemperature: Double
    let maximumTemperature: Double

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
    }
}

struct WeatherType: Decodable {
    let id: Int
    let main: String
    let description: String
}
