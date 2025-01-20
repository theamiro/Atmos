//
//  WeatherService.swift
//  Atmos
//
//  Created by Michael Amiro on 16/01/2025.
//

import Foundation
import Combine

protocol WeatherServiceDelegate: AnyObject {
    func getCurrentWeather() -> AnyPublisher<Forecast, Error>
    func get5DayForecast() -> AnyPublisher<ForecastResponse, Error>
}

final class WeatherService: WeatherServiceDelegate {
    private var networkClient: NetworkClientDelegate
    private var cancellable = Set<AnyCancellable>()

    init(networkClient: NetworkClientDelegate = NetworkClient()) {
        self.networkClient = networkClient
    }

    func getCurrentWeather() -> AnyPublisher<Forecast, Error> {
        let parameters: [String: Any] = [
            "lat": -1.286389,
            "lon": 36.817223,
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

    func get5DayForecast() -> AnyPublisher<ForecastResponse, Error> {
        let parameters: [String: Any] = [
            "lat": -1.286389,
            "lon": 36.817223,
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
