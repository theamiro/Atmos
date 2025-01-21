//
//  AtmosApp.swift
//  Atmos
//
//  Created by Michael Amiro on 16/01/2025.
//

import SwiftUI

@main
struct AtmosApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            FavoritesView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
