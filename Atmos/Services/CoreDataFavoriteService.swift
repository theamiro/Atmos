//
//  FavoriteServiceDelegate.swift
//  Atmos
//
//  Created by Michael Amiro on 18/01/2025.
//

import Foundation
import Combine
import CoreData
import CoreLocation

protocol FavoriteServiceDelegate: AnyObject {
    func getFavorites() -> Just<[any AnyLocation]>
    func addFavorite(location: any AnyLocation) -> Just<Bool>
    func removeFavorite(_ location: any AnyLocation) -> Just<Bool>
}

final class CoreDataFavoriteService: FavoriteServiceDelegate {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func getFavorites() -> Just<[any AnyLocation]> {
        let request = NSFetchRequest<FavoriteLocation>(entityName: "FavoriteLocation")
        do {
            let favorites = try context.fetch(request)
            return Just(favorites)
        } catch {
            print(error.localizedDescription)
            return Just([])
        }
    }

    func addFavorite(location: any AnyLocation) -> Just<Bool> {
        let request = NSFetchRequest<FavoriteLocation>(entityName: "FavoriteLocation")
        do {
            let favorites = try context.fetch(request)
            guard favorites.first(where: { $0.latitude == location.latitude && $0.longitude == location.longitude }) == nil else {
                return Just(false)
            }
            let favorite = FavoriteLocation(context: context)
            favorite.id = UUID()
            favorite.name = location.name
            favorite.latitude = location.latitude
            favorite.longitude = location.longitude
            return Just(save())
        } catch {
            print(error.localizedDescription)
            return Just(false)
        }
    }

    func removeFavorite(_ location: any AnyLocation) -> Just<Bool> {
        let request = NSFetchRequest<FavoriteLocation>(entityName: "FavoriteLocation")
        do {
            let favorites = try context.fetch(request)
            print(favorites)
            guard let favoriteLocation = favorites.first(where: { $0.latitude == location.latitude && $0.longitude == location.longitude }) else {
                print("Location: \(location.latitude), \(location.longitude) not found in storage")
                return Just(false)
            }
            context.delete(favoriteLocation)
            return Just(save())
        } catch {
            print(error.localizedDescription)
            return Just(false)
        }
    }

    private func save() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            print("Unable to save context: \(error.localizedDescription)")
        }
        return false
    }
}
