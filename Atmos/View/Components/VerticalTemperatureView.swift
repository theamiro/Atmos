//
//  VerticalTemperatureView.swift
//  Atmos
//
//  Created by Michael Amiro on 20/01/2025.
//

import SwiftUI

struct VerticalTemperatureView: View {
    var title: String
    var temperature: String
    var body: some View {
        VStack {
            Text(temperature)
                .font(.title2)
                .fontWeight(.semibold)
            Text(title)
        }
    }
}

#Preview {
    VerticalTemperatureView(title: "min", temperature: "20º")
}
