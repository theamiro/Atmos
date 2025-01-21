//
//  FavoritesMapView.swift
//  Atmos
//
//  Created by Michael Amiro on 21/01/2025.
//

import SwiftUI
import MapKit

struct FavoritesMapView: View {
    var locations: [any AnyLocation]

    init(_ locations: [any AnyLocation]) {
        self.locations = locations
    }

    var body: some View {
        NavigationStack {
            Map {
                ForEach(locations, id: \.hashValue) { location in
                    Marker(coordinate: location.coordinate2D) {
                        Label {
                            Text(location.name)
                        } icon: {
                            Image(systemName: "cloud.fill")
                        }
                    }
                    .tint(Color.accentColor)
                }
            }
            .ignoresSafeArea()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    FavoritesMapView([
        Location(longitude: 36.817223, latitude: -1.286389),
        Location(longitude: 36.617223, latitude: -1.286389),
        Location(longitude: 36.817223, latitude: -1.186389)
    ])
}
