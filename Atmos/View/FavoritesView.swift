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
            List(favoritesViewModel.favorites, id: \.hashValue) { location in
                NavigationLink(destination: {
                    Text("Sample")
                        .navigationTitle(location.name ?? "Unknown")
                }, label: {
                    VStack(alignment: .leading) {
                        Text(location.name ?? "Unknown")
                            .font(.title3)
                            .fontWeight(.semibold)
                        HStack {
                            Text("Latitude: \(location.latitude)")
                            Text("Longitude: \(location.longitude)")
                        }
                        .font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                })
                .swipeActions(allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        favoritesViewModel.deleteFavorite(location)
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        FavoritesMapView(favoritesViewModel.favorites)
                    } label: {
                        Image(systemName: "map.fill")
                    }

                }
            }
        }
        .task {
            favoritesViewModel.getFavorites()
        }
        .searchable(text: $favoritesViewModel.searchTerm)
    }
}

#Preview {
    FavoritesView()
}
