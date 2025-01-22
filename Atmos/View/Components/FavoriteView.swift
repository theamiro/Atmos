//
//  FavoriteView.swift
//  Atmos
//
//  Created by Michael Amiro on 21/01/2025.
//

import SwiftUI

struct FavoriteView: View {
    var location: any AnyLocation

    init(_ location: any AnyLocation) {
        self.location = location
    }

    var body: some View {
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
    }
}

#Preview {
    FavoriteView(Location(name: "Kisumu, Kenya", longitude: 34.0393, latitude: 1.3033))
}
