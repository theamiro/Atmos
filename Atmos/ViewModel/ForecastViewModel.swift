//
//  ForecastViewModel.swift
//  Atmos
//
//  Created by Michael Amiro on 16/01/2025.
//

import Foundation
import Combine
import CoreLocation

final class ForecastViewModel: ObservableObject {
    @Published var currentWeather: Forecast?
    @Published var forecast: [Forecast] = []

    private var cancellable = Set<AnyCancellable>()

    private let weatherService: WeatherServiceDelegate
    private let locationService: LocationServiceDelegate
    private let placesService: PlacesServiceDelegate

    init(weatherService: WeatherServiceDelegate,
         locationService: LocationServiceDelegate,
         placesService: PlacesServiceDelegate) {
        self.weatherService = weatherService
        self.locationService = locationService
        self.placesService = placesService

        observeForLocationUpdates()
    }

    private func observeForLocationUpdates() {
        locationService
            .currentLocation
            .compactMap { $0 }
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .removeDuplicates(by: {
                $0.isSignificantlyDifferent(from: $1)
            })
            .sink(receiveCompletion: { completed in
                print(completed)
            }, receiveValue: { [weak self] location in
                self?.fetchCurrentWeather(location: location)
                self?.get5DayForecast(location: location)
            })
            .store(in: &cancellable)
    }

    func fetchCurrentWeather(location: CLLocationCoordinate2D) {
        weatherService
            .getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
            .receive(on: DispatchQueue.main)
            .sink { completed in
                switch completed {
                case .finished: break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                self?.currentWeather = response
            }
            .store(in: &cancellable)
    }

    func get5DayForecast(location: CLLocationCoordinate2D) {
        weatherService
            .get5DayForecast(latitude: location.latitude, longitude: location.longitude)
            .receive(on: DispatchQueue.main)
            .sink { completed in
                switch completed {
                case .finished: break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.forecast = self.filterForecastByDay(response.forecast)
            }
            .store(in: &cancellable)
    }

    func requestForInUseAuthorization() {
        locationService.requestForInUseAuthorization()
    }

    private func filterForecastByDay(_ forecast: [Forecast]) -> [Forecast] {
        // Rewrite
        var days = Set<String>()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return forecast.filter { forecast in
            let date = Date(timeIntervalSince1970: forecast.date)
            let day = dateFormatter.string(from: date)
            if days.contains(day) {
                return false
            } else {
                days.insert(day)
                return true
            }
        }
    }
}
