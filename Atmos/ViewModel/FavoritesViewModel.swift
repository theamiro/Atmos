//
//  FavoritesViewModel.swift
//  Atmos
//
//  Created by Michael Amiro on 20/01/2025.
//

import SwiftUI
import Combine

class FavoritesViewModel: ObservableObject {
    @Published var searchTerm: String = ""
    @Published var searchResults: [Place] = []
    @Published var favorites: [any AnyLocation] = []

    private let favoriteService: FavoriteServiceDelegate
    private let placesService: PlacesServiceDelegate
    private var cancellable = Set<AnyCancellable>()

    init(favoriteService: FavoriteServiceDelegate = CoreDataFavoriteService(),
         placesService: PlacesServiceDelegate = GooglePlacesService()) {
        self.favoriteService = favoriteService
        self.placesService = placesService

        $searchTerm
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .sink { [weak self] query in
                self?.searchPlacesByText(text: query)
            }
            .store(in: &cancellable)
        getFavorites()
    }

    func getFavorites() {
        favoriteService.getFavorites()
            .receive(on: DispatchQueue.main)
            .sink { completed in
                print(completed)
            } receiveValue: { [weak self] (response: [any AnyLocation]) in
                self?.favorites = response
            }
            .store(in: &cancellable)
    }

    func addFavorite(_ location: Location) {
        favoriteService.addFavorite(location: location)
            .sink { completed in
                print(completed)
            } receiveValue: { [weak self] success in
                print(success)
                self?.resetSearch()
                self?.getFavorites()
            }
            .store(in: &cancellable)
    }

    func deleteFavorite<T>(_ location: T) where T: AnyLocation {
        favoriteService.removeFavorite(location)
            .sink { completed in
                print(completed)
            } receiveValue: { [weak self] completed in
                print(completed)
                self?.getFavorites()
            }
            .store(in: &cancellable)
    }

    func searchPlacesByText(text: String) {
        placesService
            .searchPlacesByText(text: text)
            .sink { completed in
                print(completed)
            } receiveValue: { [weak self] places in
                self?.searchResults = places
            }
            .store(in: &cancellable)
    }

    private func resetSearch() {
        searchTerm = ""
        searchResults = []
    }
}
