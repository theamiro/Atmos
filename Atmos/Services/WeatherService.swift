//
//  WeatherService.swift
//  Atmos
//
//  Created by Michael Amiro on 16/01/2025.
//

import Foundation
import CoreLocation
import Combine

protocol WeatherServiceDelegate: AnyObject {
    func getCurrentWeather(latitude: Double, longitude: Double) -> AnyPublisher<Forecast, Error>
    func get5DayForecast(latitude: Double, longitude: Double) -> AnyPublisher<ForecastResponse, Error>
}

final class WeatherService: WeatherServiceDelegate {
    private var networkClient: NetworkClientDelegate
    private var cancellable = Set<AnyCancellable>()

    init(networkClient: NetworkClientDelegate = NetworkClient()) {
        self.networkClient = networkClient
    }

    func getCurrentWeather(latitude: Double, longitude: Double) -> AnyPublisher<Forecast, Error> {
        let parameters: [String: Any] = [
            "lat": latitude,
            "lon": longitude,
            "units": "metric"
        ]
        let target = Target(
            path: "/data/2.5/weather",
            sampleData: generateMockResponse("current"),
            task: .queryParameters(parameters)
        )

        return networkClient.request(target)
            .map { (response: Forecast) in
                response
            }
            .eraseToAnyPublisher()
    }

    func get5DayForecast(latitude: Double, longitude: Double) -> AnyPublisher<ForecastResponse, Error> {
        let parameters: [String: Any] = [
            "lat": latitude,
            "lon": longitude,
            "units": "metric"
        ]
        let target = Target(
            path: "/data/2.5/forecast",
            sampleData: generateMockResponse("forecast"),
            task: .queryParameters(parameters)
        )

        return networkClient.request(target)
            .map { (response: ForecastResponse) in
                response
            }
            .eraseToAnyPublisher()
    }
}
