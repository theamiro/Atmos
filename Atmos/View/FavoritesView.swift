//
//  FavoritesView.swift
//  Atmos
//
//  Created by Michael Amiro on 20/01/2025.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    var body: some View {
        NavigationStack {
            if favoritesViewModel.searchTerm.isEmpty {
                List(favoritesViewModel.favorites, id: \.hashValue) { location in
                    FavoriteView(location)
                        .swipeActions(allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                favoritesViewModel.deleteFavorite(location)
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                }
                .navigationTitle("Favorites")
            } else {
                List(favoritesViewModel.searchResults, id: \.id) { result in
                    let location = Location(name: result.name,
                                            longitude: result.geometry.location.longitude,
                                            latitude: result.geometry.location.latitude)
                    FavoriteView(location)
                        .onTapGesture {
                            favoritesViewModel.addFavorite(location)
                        }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    FavoritesMapView(favoritesViewModel.favorites)
                } label: {
                    Image(systemName: "map.fill")
                }
            }
        }
        .searchable(text: $favoritesViewModel.searchTerm, prompt: Text("Search a new place"))
    }
}

#Preview {
    FavoritesView()
}
