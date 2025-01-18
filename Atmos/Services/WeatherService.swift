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
        let target = Target(path: "/data/2.5/weather")
        return networkClient.request(target)
            .map { (response: Forecast) in
                response
            }
            .eraseToAnyPublisher()
    }

    func get5DayForecast() -> AnyPublisher<ForecastResponse, Error> {
        let target = Target(path: "/data/2.5/forecast")
        return networkClient.request(target)
            .map { (response: ForecastResponse) in
                response
            }
            .eraseToAnyPublisher()
    }
}
