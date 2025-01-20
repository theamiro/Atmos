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

    private var weatherService: WeatherServiceDelegate
    private var favoriteService: FavoriteServiceDelegate

    init(weatherService: WeatherServiceDelegate, favoriteService: FavoriteServiceDelegate) {
        self.weatherService = weatherService
        self.favoriteService = favoriteService
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
        favoriteService.addFavorite(location: location)
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

    func removeFavorite(_ location: Location) {
        favoriteService.removeFavorite(location)
            .sink { success in
                if success {
                    // notify success
                } else {
                    // notify error
                }
            }
            .store(in: &cancellable)
    }

    private func filterForecastByDay(_ forecast: [Forecast]) -> [Forecast] {
        var days = Set<String>()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return forecast.filter { forecast in
            let date = Date(timeIntervalSince1970: forecast.date)
            let dayString = dateFormatter.string(from: date)
            if days.contains(dayString) {
                return false
            } else {
                days.insert(dayString)
                return true
            }
        }
    }
}
