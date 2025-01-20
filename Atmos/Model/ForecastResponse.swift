//
//  ForecastResponse.swift
//  Atmos
//
//  Created by Michael Amiro on 16/01/2025.
//

import Foundation
import DeveloperToolsSupport

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

    var weatherIllustration: WeatherIllustration {
        switch main {
        case "Rainy":
            WeatherIllustration(icon: .rain, background: .seaRainy)
        case "Sunny":
            WeatherIllustration(icon: .partlySunny, background: .seaSunny)
        default:
            WeatherIllustration(icon: .clear, background: .seaCloudy)
        }
    }
}

struct WeatherIllustration {
    var icon: ImageResource
    var background: ImageResource
}
