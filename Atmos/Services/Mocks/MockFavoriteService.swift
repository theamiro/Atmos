//
//  MockFavoriteService.swift
//  Atmos
//
//  Created by Michael Amiro on 18/01/2025.
//

import Combine

final class MockFavoriteService: FavoriteServiceDelegate {
    private var storage: [Location]

    init(with favorites: [Location] = [Location]()) {
        self.storage = favorites
    }

    func getFavorites() -> Just<[any AnyLocation]> {
        return Just(storage)
    }

    func addFavorite(location: any AnyLocation) -> Just<Bool> {
        guard storage.first(where: { $0.latitude == location.latitude && $0.longitude == location.longitude }) == nil else {
            return Just(false)
        }
        storage.append(Location(name: location.name, longitude: location.longitude, latitude: location.latitude))
        return Just(true)
    }

    func removeFavorite(_ location: any AnyLocation) -> Just<Bool> {
        guard storage.count > 0 else {
            return Just(false)
        }
        guard let favorite = storage.first(where: { $0.latitude == location.latitude && $0.longitude == location.longitude }) else {
            return Just(false)
        }
        storage.removeAll(where: { $0.id == favorite.id })
        return Just(true)
    }
}
