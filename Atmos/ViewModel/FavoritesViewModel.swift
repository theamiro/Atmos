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
    @Published private(set) var searchResults: [Place] = []
    @Published private(set) var favorites: [any AnyLocation] = []

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
            .receive(on: DispatchQueue.main)
            .handleOutput { [weak self] query in
                self?.searchPlacesByText(text: query)
            }
            .store(in: &cancellable)
        getFavorites()
    }

    func getFavorites() {
        favoriteService.getFavorites()
            .receive(on: DispatchQueue.main)
            .handleOutput(completion: { [weak self] favorites in
                self?.favorites = favorites
            })
            .store(in: &cancellable)
    }

    func addFavorite(_ location: Location) {
        favoriteService.addFavorite(location: location)
            .receive(on: DispatchQueue.main)
            .handleOutput { [weak self] _ in
                self?.resetSearch()
                self?.getFavorites()
            }
            .store(in: &cancellable)
    }

    func deleteFavorite<T>(_ location: T) where T: AnyLocation {
        favoriteService.removeFavorite(location)
            .receive(on: DispatchQueue.main)
            .toVoid()
            .store(in: &cancellable)
    }

    func searchPlacesByText(text: String) {
        placesService
            .searchPlacesByText(text: text)
            .receive(on: DispatchQueue.main)
            .handleOutput { [weak self] places in
                self?.searchResults = places
            }
            .store(in: &cancellable)
    }

    private func resetSearch() {
        searchTerm = ""
        searchResults = []
    }
}
