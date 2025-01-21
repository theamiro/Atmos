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
    @Published var favorites: [any AnyLocation] = []

    private var cancellable = Set<AnyCancellable>()

    private let weatherService: WeatherServiceDelegate
    private let favoriteService: FavoriteServiceDelegate
    private let locationService: LocationServiceDelegate

    init(weatherService: WeatherServiceDelegate, favoriteService: FavoriteServiceDelegate, locationService: LocationServiceDelegate) {
        self.weatherService = weatherService
        self.favoriteService = favoriteService
        self.locationService = locationService
    }

    func fetchCurrentWeather() {
        weatherService.getCurrentWeather()
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

    func get5DayForecast() {
        weatherService.get5DayForecast()
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

    func getFavorites() {
        favoriteService.getFavorites()
            .sink(receiveCompletion: { completed in
                switch completed {
                case .finished: break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] favorites in
                self?.favorites = favorites
            })
            .store(in: &cancellable)
    }

    func addFavorite(location: Location) {
        locationService.getGeoCodePlaceName(location: location)
            .sink { completed in
                print(completed)
            } receiveValue: { [weak self] address in
                guard let self else { return }
                var updatedLocation = location
                updatedLocation.name = address.first?.addressComponents.first?.longName ?? "Unknown"
                favoriteService.addFavorite(location: updatedLocation)
                    .sink { [weak self] success in
                        if success {
                            // notify success
                            self?.getFavorites()
                        } else {
                            // notify error
                        }
                    }
                    .store(in: &cancellable)
            }
            .store(in: &cancellable)
    }

    func removeFavorite(_ location: Location) {
        favoriteService.removeFavorite(location)
            .sink { [weak self] success in
                if success {
                    // notify success
                    self?.getFavorites()
                } else {
                    // notify error
                }
            }
            .store(in: &cancellable)
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
