//
//  ForecastResponse.swift
//  Atmos
//
//  Created by Michael Amiro on 16/01/2025.
//

import Foundation
import DeveloperToolsSupport
import SwiftUI

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
    let main: WeatherPhenomena
    let description: String
}

enum WeatherPhenomena: String, Decodable {
    case rainy = "Rain"
    case cloudy = "Clouds"
    case sunny = "Sun"
    case clear = "Clear"

    var title: String {
        switch self {
        case .rainy:
            return "Rainy"
        case .cloudy:
            return "Cloudy"
        case .sunny:
            return "Sunny"
        case .clear:
            return "Clear"
        }
    }

    var icon: ImageResource {
        switch self {
        case .rainy:
            return .rain
        case .sunny:
            return .partlySunny
        case .clear, .cloudy:
            return .clear
        }
    }

    var background: ImageResource {
        switch self {
        case .rainy:
            return .seaRainy
        case .cloudy:
            return .seaCloudy
        case .sunny, .clear:
            return .seaSunny
        }
    }

    var backgroundColor: Color {
        switch self {
        case .rainy: return Color.rainy
        case .cloudy: return Color.cloudy
        case .sunny, .clear: return Color.sunnyAlt
        }
    }
}
