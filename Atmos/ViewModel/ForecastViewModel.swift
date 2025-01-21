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
    private let placesService: PlacesServiceDelegate

    init(weatherService: WeatherServiceDelegate,
         favoriteService: FavoriteServiceDelegate,
         locationService: LocationServiceDelegate,
         placesService: PlacesServiceDelegate) {
        self.weatherService = weatherService
        self.favoriteService = favoriteService
        self.locationService = locationService
        self.placesService = placesService

        observeForLocationUpdates()
    }

    private func observeForLocationUpdates() {
        locationService
            .currentLocation
            .compactMap { $0 }
            .removeDuplicates(by: { $0.latitude == $1.latitude && $0.longitude == $1.longitude })
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

    func getFavorites() {
        favoriteService
            .getFavorites()
            .receive(on: DispatchQueue.main)
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

    func addFavorite() {
        // Fetch Place Name
        // Store in Coredata
    }

    func removeFavorite(_ location: Location) {
        favoriteService
            .removeFavorite(location)
            .receive(on: DispatchQueue.main)
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
