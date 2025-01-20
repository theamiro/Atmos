//
//  DayWeatherView.swift
//  Atmos
//
//  Created by Michael Amiro on 18/01/2025.
//

import SwiftUI

struct DayWeatherView: View {
    var forecast: Forecast
    init(_ forecast: Forecast) {
        self.forecast = forecast
    }
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), content: {
            Text(Date(timeIntervalSince1970: forecast.date).formatted(.dateTime.weekday(.wide)))
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(forecast.weather.first?.weatherIllustration.icon ?? .clear)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32)
            Text(String(format: "%.0fº", forecast.main.temperature))
                .font(.headline)
                .multilineTextAlignment(.trailing)
                .monospacedDigit()
                .frame(maxWidth: .infinity, alignment: .trailing)
        })
    }
}

#Preview {
    DayWeatherView(Forecast(date: 1234567890,
                            main: Weather(temperature: 20.0,
                                          minimumTemperature: 16.0,
                                          maximumTemperature: 34.0),
                            weather: [WeatherType(id: 1, main: "Rainy", description: "Light showers")]))
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.cloudy)
}
