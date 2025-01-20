//
//  HorizontalGrid.swift
//  Atmos
//
//  Created by Michael Amiro on 20/01/2025.
//

import SwiftUI

struct HorizontalGrid: View {
    var weather: Weather?

    init(_ weather: Weather?) {
        self.weather = weather
    }

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
            VerticalTemperatureView(title: "min",
                                    temperature: String(format: "%.0fº", weather?.minimumTemperature ?? 0.0))
                .frame(maxWidth: .infinity, alignment: .leading)
            VerticalTemperatureView(title: "current",
                                    temperature: String(format: "%.0fº", weather?.temperature ?? 0.0))
                .frame(maxWidth: .infinity)
            VerticalTemperatureView(title: "max",
                                    temperature: String(format: "%.0fº", weather?.maximumTemperature ?? 0.0))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#Preview {
    HorizontalGrid(Weather.init(temperature: 20.0, minimumTemperature: 12.0, maximumTemperature: 28.0))
        .padding(.horizontal)
}
