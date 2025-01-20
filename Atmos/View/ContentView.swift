//
//  ContentView.swift
//  Atmos
//
//  Created by Michael Amiro on 16/01/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var forecastViewModel = ForecastViewModel(weatherService: WeatherService(),
                                                                   favoriteService: CoreDataFavoriteService())
    var body: some View {
        ScrollView {
            VStack {
                Text(String(format: "%.0fº", forecastViewModel.currentWeather?.main.temperature ?? 0.0))
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                Text("Cloudy".uppercased())
                    .font(.headline)
                    .fontWeight(.bold)
            }
            HStack {
                VerticalTempView(title: "min", temperature: String(format: "%.0fº", forecastViewModel.currentWeather?.main.minimumTemperature ?? 0.0))
                Spacer()
                VerticalTempView(title: "current", temperature: String(format: "%.0fº", forecastViewModel.currentWeather?.main.temperature ?? 0.0))
                Spacer()
                VerticalTempView(title: "max", temperature: String(format: "%.0fº", forecastViewModel.currentWeather?.main.maximumTemperature ?? 0.0))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            Divider()
            VStack(spacing: 0) {
                ForEach(forecastViewModel.forecast, id: \.date) { forecast in
                    DayWeatherView(forecast)
                }
            }
        }
        .task {
            forecastViewModel.fetchCurrentWeather()
            forecastViewModel.get5DayForecast()
        }
    }
}

#Preview {
    ContentView()
}

struct VerticalTempView: View {
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
