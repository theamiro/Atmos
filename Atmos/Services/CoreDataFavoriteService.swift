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
        return Just([])
    }

    func addFavorite(location: any AnyLocation) -> Just<Bool> {
        return Just(save())
    }

    func removeFavorite(_ location: any AnyLocation) -> Just<Bool> {
        return Just(save())
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
