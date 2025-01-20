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
    @Published var favorites: [any AnyLocation] = []

    private let favoriteService: FavoriteServiceDelegate
    private var cancellable = Set<AnyCancellable>()

    init(favoriteService: FavoriteServiceDelegate = CoreDataFavoriteService()) {
        self.favoriteService = favoriteService
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
}
