//
//  FavoritesView.swift
//  Atmos
//
//  Created by Michael Amiro on 20/01/2025.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesViewModel = FavoritesViewModel(favoriteService: MockFavoriteService())
    var body: some View {
        NavigationStack {
            List(favoritesViewModel.favorites, id: \.hashValue) { location in
                VStack(alignment: .leading) {
                    Text("Amsterdam")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Group {
                        Text("Latitude: \(location.latitude)")
                        Text("Longitude: \(location.longitude)")
                    }
                    .font(.subheadline)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationTitle("Favorites")
        }
        .task {
            favoritesViewModel.getFavorites()
        }
    }
}

#Preview {
    FavoritesView()
}
